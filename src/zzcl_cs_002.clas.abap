CLASS zzcl_cs_002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZCL_CS_002 IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA:BEGIN OF ls_data,
           value TYPE TABLE OF zzs_warranty_report,
         END OF ls_data.

    DATA lt_original_data TYPE STANDARD TABLE OF zc_scs017 WITH DEFAULT KEY.
    DATA lv_billingdocumentdate TYPE datum.

    lt_original_data = CORRESPONDING #( it_original_data ).
    IF lt_original_data IS INITIAL.
      EXIT.
    ENDIF.

    " Find CA by Scenario ID
    cl_com_arrangement_factory=>create_instance( )->query_ca(
      EXPORTING
        is_query           = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'YY1_API' ) ) )
      IMPORTING
        et_com_arrangement = DATA(lt_ca) ).
    IF lt_ca IS INITIAL.
      EXIT.
    ENDIF.

    " take the first one
    READ TABLE lt_ca INTO DATA(lo_ca) INDEX 1.

    " get destination based on Communication Arrangement and the service ID
    TRY.
        DATA(lo_dest_v4) = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = 'YY1_API'
            service_id     = 'YY1_ODATAV4_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).
      CATCH cx_http_dest_provider_error INTO DATA(lx_http_dest_provider_error).
        EXIT.
    ENDTRY.

**********************************************************************
* Labor  Hour
* Travel Hour
**********************************************************************
    SELECT serviceconfirmation,
           serviceconfirmationitem,
           referenceserviceorder,
           referenceserviceorderitem,
           yy1_efforttype_sri,
           actualserviceduration,
           actualservicedurationunit
      FROM i_serviceconfirmationitemtp
       FOR ALL ENTRIES IN @lt_original_data
     WHERE referenceserviceorder = @lt_original_data-servicedocument
       AND referenceserviceorderitem = @lt_original_data-servicedocumentitem
       AND serviceconfitemcategory = 'SCP1'
      INTO TABLE @DATA(lt_serviceconfirmation).

    IF lt_serviceconfirmation IS NOT INITIAL.
      SELECT _item~serviceconfirmation,
             _item~serviceconfirmationitem,
             _item~referenceserviceorder,
             _item~referenceserviceorderitem,
             _partner~custmgmtpartnerfunction,
             _partner~custmgmtbusinesspartner,
             _person~fullname
        FROM i_serviceconfirmationitemtp AS _item
       INNER JOIN i_srvcconfitempartnertp AS _partner ON _partner~serviceconfirmation = _item~serviceconfirmation
                                                     AND _partner~serviceconfirmationitem = _item~serviceconfirmationitem
        LEFT JOIN i_workforceperson_1 AS _person ON _person~businesspartner = _partner~custmgmtbusinesspartner
         FOR ALL ENTRIES IN @lt_serviceconfirmation
       WHERE _item~serviceconfirmation = @lt_serviceconfirmation-serviceconfirmation
         AND _item~serviceconfirmationitem = @lt_serviceconfirmation-serviceconfirmationitem
         AND _partner~custmgmtpartnerfunction = '00000052'
        INTO TABLE @DATA(lt_srvcconfitempartner).

      SORT lt_srvcconfitempartner BY referenceserviceorder referenceserviceorderitem custmgmtbusinesspartner.
      DELETE ADJACENT DUPLICATES FROM lt_srvcconfitempartner
                            COMPARING referenceserviceorder referenceserviceorderitem custmgmtbusinesspartner.

      SELECT a~referenceserviceorder,
             a~referenceserviceorderitem,
             a~yy1_efforttype_sri AS efforttype,
             a~actualservicedurationunit,
             SUM( a~actualserviceduration ) AS actualserviceduration
        FROM @lt_serviceconfirmation AS a
       GROUP BY a~referenceserviceorder,
                a~referenceserviceorderitem,
                a~yy1_efforttype_sri,
                a~actualservicedurationunit
        INTO TABLE @DATA(lt_time_summary).

      SORT lt_time_summary BY referenceserviceorder referenceserviceorderitem efforttype.
    ENDIF.
**********************************************************************

    LOOP AT lt_original_data INTO DATA(ls_original_data)
                                  GROUP BY ( referenceproduct = ls_original_data-referenceproduct
                                             serialnumber     = ls_original_data-serialnumber )
                                 ASSIGNING FIELD-SYMBOL(<fs_group>).

      " Call API for get product description
      IF <fs_group>-referenceproduct IS NOT INITIAL AND <fs_group>-serialnumber IS NOT INITIAL.
        TRY.
*            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest_v4 ).
*            DATA(lo_request) = lo_http_client->get_http_request(   ).
*            lo_http_client->enable_path_prefix( ).
*
*            DATA(lv_path)   = |/zui_warrantyreport/srvd/sap/zui_warrantyreport/0001/ZZR_WARRANTY_REPORT|.
*            DATA(lv_filter) = |?$filter=material1 eq '{ <fs_group>-referenceproduct }' and serialnumber1 eq '{ <fs_group>-serialnumber }'|.
*
*            lv_path = lv_path && lv_filter.
*
*            lo_request->set_uri_path( EXPORTING i_uri_path = lv_path ).
*            lo_request->set_header_field( i_name = 'Accept' i_value = 'application/json' ).
*
*            lo_http_client->set_csrf_token(  ).
*
*            DATA(lo_response) = lo_http_client->execute( if_web_http_client=>get ).
*            DATA(lv_response) = lo_response->get_text(  ).
*            DATA(lv_status)   = lo_response->get_status( ).
*
*            /ui2/cl_json=>deserialize(
*                EXPORTING
*                    json = lv_response
*                CHANGING
*                    data = ls_data
*            ).

            DATA(lt_warrantyreport) = ls_data-value.
            SORT lt_warrantyreport BY legacy.
          CATCH cx_root INTO DATA(lx_root).

        ENDTRY.
      ENDIF.

      LOOP AT GROUP <fs_group> ASSIGNING FIELD-SYMBOL(<fs_original_data>).

        CLEAR lv_billingdocumentdate.

        " Technician id and name
        READ TABLE lt_srvcconfitempartner INTO DATA(ls_partner) WITH KEY referenceserviceorder     = <fs_original_data>-servicedocument
                                                                         referenceserviceorderitem = <fs_original_data>-servicedocumentitem
                                                                         BINARY SEARCH.
        IF sy-subrc = 0.
          <fs_original_data>-technicianid   = ls_partner-custmgmtbusinesspartner.
          <fs_original_data>-technicianname = ls_partner-fullname.
        ENDIF.

        IF lt_warrantyreport IS NOT INITIAL.
          " there's only one line and Legacy = X
          IF lines( lt_warrantyreport ) = 1 AND line_exists( lt_warrantyreport[ legacy = abap_true ] ).
            lv_billingdocumentdate = lt_warrantyreport[ 1 ]-postingdate.

            " multiple lines
          ELSEIF lines( lt_warrantyreport ) > 1.
            SELECT MAX( a~creationdate )
              FROM @lt_warrantyreport AS a
             WHERE a~legacy = @abap_false
               AND a~salesdocumenttype IN ( 'OR','SD2' )
              INTO @DATA(lv_date1).

            SELECT MAX( a~creationdate )
              FROM @lt_warrantyreport AS a
             WHERE a~legacy = @abap_true
              INTO @DATA(lv_date2).

            " multiple lines, exists Legacy = "" and Legacy = X
            IF line_exists( lt_warrantyreport[ legacy = abap_false ] ) AND
               line_exists( lt_warrantyreport[ legacy = abap_true ] ).

              lv_billingdocumentdate = COND #( WHEN lv_date1 >= lv_date2 THEN lv_date1 ELSE lv_date2 ).

              " multiple lines, exists Legacy = ""
            ELSEIF NOT line_exists( lt_warrantyreport[ legacy = abap_true ] ).
              lv_billingdocumentdate = lv_date1.
            ENDIF.
          ENDIF.

          " Usage Duration(Day)
          IF lv_billingdocumentdate IS NOT INITIAL.
            <fs_original_data>-usagedurationbydate = <fs_original_data>-servicedocumentcreationdate - lv_billingdocumentdate.
          ENDIF.

          " Usage Duration(Month)
          " Get result as Usage Duration(Day)/30, Mapping with following options:
          " 0-6 month
          " 7-12 month
          " 13-18 month
          " 19-24 month
          " 25-30 month
          " 31-36 month
          " 37-42 month
          " 43-48 month
          " 49-54 month
          " 55-60 month
          " 60 month plus
          DATA(lv_quotient) = ceil( <fs_original_data>-usagedurationbydate / 30 ).
          IF lv_quotient BETWEEN 0 AND 6.
            <fs_original_data>-usagedurationbymonth = '0-6 month'.
          ELSEIF lv_quotient BETWEEN 7 AND 12.
            <fs_original_data>-usagedurationbymonth = '7-12 month'.
          ELSEIF lv_quotient BETWEEN 13 AND 18.
            <fs_original_data>-usagedurationbymonth = '13-18 month'.
          ELSEIF lv_quotient BETWEEN 19 AND 24.
            <fs_original_data>-usagedurationbymonth = '19-24 month'.
          ELSEIF lv_quotient BETWEEN 25 AND 30.
            <fs_original_data>-usagedurationbymonth = '25-30 month'.
          ELSEIF lv_quotient BETWEEN 31 AND 36.
            <fs_original_data>-usagedurationbymonth = '31-36 month'.
          ELSEIF lv_quotient BETWEEN 37 AND 42.
            <fs_original_data>-usagedurationbymonth = '37-42 month'.
          ELSEIF lv_quotient BETWEEN 43 AND 48.
            <fs_original_data>-usagedurationbymonth = '43-48 month'.
          ELSEIF lv_quotient BETWEEN 49 AND 54.
            <fs_original_data>-usagedurationbymonth = '49-54 month'.
          ELSEIF lv_quotient BETWEEN 55 AND 60.
            <fs_original_data>-usagedurationbymonth = '55-60 month'.
          ELSE.
            <fs_original_data>-usagedurationbymonth = '60 month plus'.
          ENDIF.
        ENDIF.

        " In/Out of Warranty
        CASE <fs_original_data>-yy1_inoroutofwarranty_srh.
          WHEN 'InExtWarr'.
            <fs_original_data>-yy1_inoroutofwarranty_desc = 'In Extended Warranty'.
          WHEN 'InStdWarrC'.
            <fs_original_data>-yy1_inoroutofwarranty_desc = 'In Standard Warranty-Compressor'.
          WHEN 'InStdWarrL'.
            <fs_original_data>-yy1_inoroutofwarranty_desc = 'In Standard Warranty-Labor'.
          WHEN 'NotFound'.
            <fs_original_data>-yy1_inoroutofwarranty_desc = 'Not Found'.
          WHEN 'OutOfWarr'.
            <fs_original_data>-yy1_inoroutofwarranty_desc = 'Out of Warranty'.
          WHEN OTHERS.
        ENDCASE.

        " Replace Reason
        CASE <fs_original_data>-yy1_replacereason_srh.
          WHEN 'Attempts'.
            <fs_original_data>-yy1_replacereason_desc = 'TOO MANY ATTEMPTS TO REPAIR'.
          WHEN 'CauseTBD'.
            <fs_original_data>-yy1_replacereason_desc = 'CANNOT DETERMINE ISSUE/NEED INTERNAL INSPECTION'.
          WHEN 'CostlyFix'.
            <fs_original_data>-yy1_replacereason_desc = 'TOO COSTLY TO FIX ISSUE'.
          WHEN 'Management'.
            <fs_original_data>-yy1_replacereason_desc = 'PER MANAGEMENT REPLACE THE UNIT'.
          WHEN 'NewUnitDOA'.
            <fs_original_data>-yy1_replacereason_desc = 'NEW UNIT DOA'.
          WHEN 'NonFixable'.
            <fs_original_data>-yy1_replacereason_desc = 'NON-REPAIRABLE ISSUE'.
          WHEN 'Refusal'.
            <fs_original_data>-yy1_replacereason_desc = 'CUSTOMER/DEALER REFUSES TO REPAIR'.
          WHEN 'Unavail'.
            <fs_original_data>-yy1_replacereason_desc = 'REQUIRED PARTS UNAVAILABLE'.
          WHEN OTHERS.
        ENDCASE.

        " Labor  Hour
        READ TABLE lt_time_summary INTO DATA(ls_time_summary) WITH KEY referenceserviceorder     = <fs_original_data>-servicedocument
                                                                       referenceserviceorderitem = <fs_original_data>-servicedocumentitem
                                                                       efforttype = 'Labor Hour'
                                                                       BINARY SEARCH.
        IF sy-subrc = 0.
          <fs_original_data>-laborhour     = ls_time_summary-actualserviceduration.
          <fs_original_data>-laborhourunit = ls_time_summary-actualservicedurationunit.
        ENDIF.

        " Travel Hour
        READ TABLE lt_time_summary INTO ls_time_summary WITH KEY referenceserviceorder     = <fs_original_data>-servicedocument
                                                                 referenceserviceorderitem = <fs_original_data>-servicedocumentitem
                                                                 efforttype = 'Travel Hour'
                                                                 BINARY SEARCH.
        IF sy-subrc = 0.
          <fs_original_data>-travelhour     = ls_time_summary-actualserviceduration.
          <fs_original_data>-travelhourunit = ls_time_summary-actualservicedurationunit.
        ENDIF.
      ENDLOOP.

*      CLEAR: lv_path,lv_filter,lv_response,ls_data,lt_warrantyreport.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.

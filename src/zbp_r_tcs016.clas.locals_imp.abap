CLASS lhc_zr_tcs016 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS determinInitFields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_tcs016~determinInitFields.
    METHODS checkMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_tcs016~checkMandatoryFields.

ENDCLASS.

CLASS lhc_zr_tcs016 IMPLEMENTATION.

  METHOD determinInitFields.
    " Read itself
    READ ENTITIES OF zr_tcs015 IN LOCAL MODE
        ENTITY zr_tcs016 FIELDS ( uuid ParentUUID ShipToCustomerOrTech  )
        WITH CORRESPONDING #( keys ) RESULT DATA(LT_record).

    " Read Service Order Infomation
    IF lt_record IS NOT INITIAL.
      SELECT ServiceObjectType,
             ServiceOrder,
             SoldtoParty,
             YY1_ContactName1_SRH,
             YY1_ContactPhone1_SRH,
             YY1_Street_SRH,
             YY1_Address2_SRH,
             YY1_City_SRH,
             YY1_State_SRH,
             YY1_Zip_SRH,
             YY1_ServiceParts_SRH
             FROM zr_scs011
           FOR ALL ENTRIES IN @lt_record
           WHERE YY1_ServiceParts_SRH = @lt_record-ParentUUID
           INTO TABLE @DATA(lt_serviceorders).
      SORT lt_serviceorders BY YY1_ServiceParts_SRH.
    ENDIF.

    LOOP AT lt_record ASSIGNING FIELD-SYMBOL(<record>).
      READ TABLE lt_serviceorders ASSIGNING FIELD-SYMBOL(<service_order>) WITH KEY YY1_ServiceParts_SRH = <record>-ParentUUID
                                                                                   BINARY SEARCH.
      IF sy-subrc = 0.
        "Fill Contact and Address Info
        IF <record>-ShipToCustomerOrTech = 'CUSTOMER'.
          <record>-ContactName = <service_order>-YY1_ContactName1_SRH.
          <record>-ContactPhone = <service_order>-YY1_ContactPhone1_SRH.
          <record>-Address = <service_order>-YY1_Street_SRH.
          <record>-Address2 = <service_order>-YY1_Address2_SRH.
          <record>-City = <service_order>-YY1_City_SRH.
          <record>-State = <service_order>-YY1_State_SRH.
          <record>-Zip = <service_order>-YY1_Zip_SRH.
        ENDIF.
        " Fill Dealer
        <record>-Dealer = <service_order>-SoldToParty.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zr_tcs015 IN LOCAL MODE
          ENTITY zr_tcs016 UPDATE FIELDS ( Dealer ContactName ContactPhone  Address Address2 City State Zip )
              WITH VALUE #( FOR record IN lt_record ( CORRESPONDING #( record ) ) ).

  ENDMETHOD.

  METHOD checkMandatoryFields.

    DATA permission_request TYPE STRUCTURE FOR PERMISSIONS REQUEST zr_tcs016.
    DATA(description_permission_request) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data_ref( REF #( permission_request-%field ) ) ).
    DATA(components_permission_request) = description_permission_request->get_components(  ).

    DATA reported_field LIKE LINE OF reported-zr_tcs016.
*    DATA reported_field1 LIKE LINE OF reported-zr_tcs017.


    LOOP AT components_permission_request INTO DATA(component_permission_request).
      permission_request-%field-(component_permission_request-name) = if_abap_behv=>mk-on.
    ENDLOOP.

    READ ENTITIES OF zr_tcs015 IN LOCAL MODE
        ENTITY zr_Tcs016
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    GET PERMISSIONS ONLY GLOBAL FEATURES ENTITY zr_tcs016 REQUEST permission_request
        RESULT DATA(permission_result).


    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<data>).
      LOOP AT components_permission_request INTO component_permission_request.
        IF permission_result-global-%field-(component_permission_request-name) = if_abap_behv=>fc-f-mandatory
          AND <data>-(component_permission_request-name) IS INITIAL.
          APPEND VALUE #( %tky = <data>-%tky  ) TO failed-zr_tcs016.
*          failed-zr_tcs016[ 1 ]-%fail-cause-unspecific

          CLEAR reported_field.
          reported_field-%tky = <data>-%tky.
          reported_field-%element-(component_permission_request-name) = if_abap_behv=>mk-on.
          reported_field-%path = VALUE #( zr_tcs015-%is_draft = <data>-%is_draft
                                          zr_tcs015-%key-uuid = <data>-ParentUUID
                                          ).

          reported_field-%msg = new_message( id       = '00'
                                                         number   = 000
                                                         severity = if_abap_behv_message=>severity-error
                                                         v1       = |{ component_permission_request-name }|
                                                         v2       = | is required | ).

          APPEND reported_field TO reported-zr_tcs016 .
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*CLASS LHC_ZR_TCS016 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
*  PRIVATE SECTION.
**    METHODS:
**      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
**        IMPORTING
**           REQUEST requested_authorizations FOR ZR_TCS016
**        RESULT result.
*ENDCLASS.
*
*CLASS LHC_ZR_TCS016 IMPLEMENTATION.
**  METHOD GET_GLOBAL_AUTHORIZATIONS.
**  ENDMETHOD.
*ENDCLASS.

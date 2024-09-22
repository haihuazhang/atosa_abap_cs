CLASS zzcl_zr_scs006 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
*    METHODS get_function_modules IMPORTING io_request  TYPE REF TO if_rap_query_request
*                                           io_response TYPE REF TO if_rap_query_response
*                                 RAISING   cx_rap_query_prov_not_impl
*                                           cx_rap_query_provider.

    METHODS get_NonAtosaProductModel IMPORTING io_request  TYPE REF TO if_rap_query_request
                                               io_response TYPE REF TO if_rap_query_response
                                     RAISING   cx_rap_query_prov_not_impl
                                               cx_rap_query_provider.
ENDCLASS.



CLASS ZZCL_ZR_SCS006 IMPLEMENTATION.


  METHOD get_NonAtosaProductModel.

    DATA: lt_entity    TYPE TABLE OF zr_scs002,
          lr_BrandName TYPE RANGE OF zr_scs002-BrandName.
    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_filters) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.

    LOOP AT lt_filters INTO DATA(ls_filter).
      TRANSLATE ls_filter-name TO UPPER CASE.
      CASE ls_filter-name.
        WHEN 'BRANDNAME'.
          MOVE-CORRESPONDING ls_filter-range TO lr_BrandName.


      ENDCASE.

    ENDLOOP.


*
*    TRY.
*        DATA(lv_curr_lang) = cl_abap_context_info=>get_user_language_abap_format(  ).
*      CATCH cx_abap_context_info_error.
*        "handle exception
*    ENDTRY.
    SELECT * FROM zr_tcs014                             "#EC CI_NOWHERE
        WHERE BrandName IN @lr_brandname
    INTO TABLE @DATA(lt_result).

    SORT lt_result BY BrandName Z3rdProductModels.

    DELETE ADJACENT DUPLICATES FROM lt_result COMPARING BrandName Z3rdProductModels.

    lt_entity = VALUE #( FOR result IN lt_result (
        BrandName = result-BrandName
        Code = result-Z3rdProductModels
        IssueCategory = result-IssueCategory
     ) ).

    zzcl_odata_utils=>filtering( EXPORTING io_filter = io_request->get_filter(  ) CHANGING ct_data = lt_entity ).

    IF io_request->is_total_numb_of_rec_requested(  ) .
      io_response->set_total_number_of_records( lines( lt_entity ) ).
    ENDIF.

    zzcl_odata_utils=>orderby( EXPORTING it_order = io_request->get_sort_elements( )  CHANGING ct_data = lt_entity ).

    zzcl_odata_utils=>paging( EXPORTING io_paging = io_request->get_paging(  ) CHANGING ct_data = lt_entity ).

    io_response->set_data( lt_entity ).



*    DATA(sort_elements) = io_request->get_sort_elements( ).
*    /iwbep/cl_mgw_data_util=>orderby( it_order = sort_elements CHANGING ct_data = lt_funcs ).


  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    TRY.
        CASE io_request->get_entity_id( ).

          WHEN 'ZR_SCS002'.
            get_NonAtosaProductModel( io_request = io_request io_response = io_response ).

        ENDCASE.

      CATCH cx_rap_query_provider.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

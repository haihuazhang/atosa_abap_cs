CLASS zzcl_zr_scs005 DEFINITION
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

    METHODS get_addresstype IMPORTING io_request  TYPE REF TO if_rap_query_request
                                    io_response TYPE REF TO if_rap_query_response
                          RAISING   cx_rap_query_prov_not_impl
                                    cx_rap_query_provider.
ENDCLASS.



CLASS ZZCL_ZR_SCS005 IMPLEMENTATION.


  METHOD get_addresstype.

    DATA: lt_entity TYPE TABLE OF zr_scs005.
*
    TRY.
        DATA(lv_curr_lang) = cl_abap_context_info=>get_user_language_abap_format(  ).
      CATCH cx_abap_context_info_error.
        "handle exception
    ENDTRY.
    SELECT * FROM zr_scs006
    WHERE language = @lv_curr_lang
    INTO TABLE @DATA(lt_result).

    lt_entity = VALUE #( FOR result IN lt_result ( addresstype = result-value_low addresstypetext = result-text ) ).

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

          WHEN 'ZR_SCS005'.
            get_addresstype( io_request = io_request io_response = io_response ).

        ENDCASE.

      CATCH cx_rap_query_provider.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

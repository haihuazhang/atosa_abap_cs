CLASS lhc_zr_tcs012 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zr_tcs012
        RESULT result,
      check FOR VALIDATE ON SAVE
        IMPORTING keys FOR zr_tcs012~check,
      createcontactid FOR DETERMINE ON SAVE
        IMPORTING keys FOR zr_tcs012~createcontactid.
*      createcontactid FOR DETERMINE ON SAVE
*        IMPORTING keys FOR zr_tcs012~createcontactid.
ENDCLASS.

CLASS lhc_zr_tcs012 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD check.
    READ ENTITIES OF zr_tcs012
    ENTITY zr_tcs012
    FIELDS ( zmaterial zserialnumber )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    IF lt_data IS NOT INITIAL.
      SELECT material1,
             serialnumber1
      FROM zi_warranty_report
      FOR ALL ENTRIES IN @lt_data
      WHERE material1 = @lt_data-zmaterial
      AND   serialnumber1 = @lt_data-zserialnumber
      INTO TABLE @DATA(lt_warranty).
      SORT lt_warranty BY material1 serialnumber1.
    ENDIF.

    LOOP AT lt_data INTO DATA(ls_data).
      READ TABLE lt_warranty INTO DATA(ls_warranty) WITH KEY material1 = ls_data-zmaterial
                                                             serialnumber1 = ls_data-zserialnumber BINARY SEARCH.
      IF sy-subrc <> 0.
        INSERT VALUE #( zmaterial                         = ls_data-zmaterial
                          zserialnumber = ls_data-zserialnumber
                          %msg                       = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                              text     = 'This Unit is invalid, please check the warranty information!' )
                        ) INTO TABLE reported-zr_tcs012.
        INSERT VALUE #( zmaterial = ls_data-zmaterial zserialnumber = ls_data-zserialnumber ) INTO TABLE failed-zr_tcs012.
      ENDIF.
      IF ls_data-zaddresstype IS INITIAL.
        INSERT VALUE #( zmaterial                         = ls_data-zmaterial
                            zserialnumber = ls_data-zserialnumber
                            %msg                       = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                                text     = 'Please choose an Address Type!' )
                          ) INTO TABLE reported-zr_tcs012.
        INSERT VALUE #( zmaterial = ls_data-zmaterial zserialnumber = ls_data-zserialnumber ) INTO TABLE failed-zr_tcs012.
      ELSEIF ls_data-zaddresstype <> 'Residence' AND ls_data-zaddresstype <> 'Business' AND ls_data-zaddresstype <> 'FoodTruck'.
        INSERT VALUE #( zmaterial                         = ls_data-zmaterial
                        zserialnumber = ls_data-zserialnumber
                        %msg                       = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                            text     = 'Please choose a correct Address Type!' )
                      ) INTO TABLE reported-zr_tcs012.
        INSERT VALUE #( zmaterial = ls_data-zmaterial zserialnumber = ls_data-zserialnumber ) INTO TABLE failed-zr_tcs012.
      ENDIF.
    ENDLOOP.



  ENDMETHOD.

  METHOD createcontactid.
    READ ENTITIES OF zr_tcs012 IN LOCAL MODE
    ENTITY zr_tcs012 ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(results).
    SELECT z_material,
           z_serial_number,
           z_contact_name,
           z_street,
           z_zip,
           z_contact_id
        FROM ztcs012
        WHERE z_material IS NOT INITIAL
        INTO TABLE @DATA(gt_ztcs012).
    SORT gt_ztcs012 BY z_contact_name z_street.
    DATA(gt_ztcs012_01) = gt_ztcs012.
    SORT gt_ztcs012_01 BY z_contact_id DESCENDING.

    LOOP AT results ASSIGNING FIELD-SYMBOL(<result>).
      IF <result>-zcontactid IS INITIAL.
        READ TABLE gt_ztcs012 INTO DATA(gs_ztcs012) WITH KEY z_contact_name = <result>-zcontactname
                                                             z_street = <result>-zstreet BINARY SEARCH.
        IF sy-subrc = 0.
          <result>-zcontactid = gs_ztcs012-z_contact_id.
        ELSE.
          READ TABLE gt_ztcs012 INTO DATA(gs_ztcs012_001) WITH KEY z_zip = <result>-zzip
                                                                   z_contact_name = <result>-zcontactname.
          IF sy-subrc = 0.
            <result>-zcontactid = gs_ztcs012_001-z_contact_id.
          ELSE.
            READ TABLE gt_ztcs012_01 INTO DATA(gs_ztcs012_01) INDEX 1.
            IF sy-subrc = 0.
              <result>-zcontactid = gs_ztcs012_01-z_contact_id + 1.
            ELSE.
              <result>-zcontactid = 1.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zr_tcs012 IN LOCAL MODE
        ENTITY zr_tcs012 UPDATE FIELDS (  zcontactid )
            WITH VALUE #( FOR file IN results ( %tky = file-%tky zcontactid = file-zcontactid ) ).
  ENDMETHOD.

ENDCLASS.

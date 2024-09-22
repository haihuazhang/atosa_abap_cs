CLASS lhc_zr_tcs017 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS determineItemNo FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_tcs017~determineItemNo.
    METHODS checkItemFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_tcs017~checkItemFields.
    METHODS determineStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR zr_tcs017~determineStatus.
    METHODS determineStatusInDraft FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_tcs017~determineStatusInDraft.
    METHODS determineQuantityBySN FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_tcs017~determineQuantityBySN.

ENDCLASS.

CLASS lhc_zr_tcs017 IMPLEMENTATION.

  METHOD determineItemNo.
    DATA : lv_itemno TYPE n LENGTH 6.
    " Get Max Item Number
    READ ENTITIES OF zr_tcs015 IN LOCAL MODE
     ENTITY zr_tcs017 FIELDS ( uuid ParentUUID ItemNo )
         WITH CORRESPONDING #( keys ) RESULT DATA(lt_data).


    READ ENTITIES OF zr_tcs015 IN LOCAL MODE
      ENTITY zr_tcs016 BY \_Parts FIELDS ( ItemNo ) WITH VALUE #( FOR data IN lt_data ( %tky-uuid = data-ParentUUID
                                                                                        %tky-%is_draft = data-%is_draft ) )
         RESULT DATA(lt_assigned_data).
    SORT lt_assigned_data BY ItemNo DESCENDING.

    IF lines( lt_assigned_data ) = 0.
      lv_itemno = 10.
    ELSE.
      lv_itemno = lt_assigned_data[ 1 ]-ItemNo + 10.
    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<data>).
      <data>-ItemNo = lv_itemno.
      lv_itemno += 10.
    ENDLOOP.

    MODIFY ENTITIES OF zr_tcs015 IN LOCAL MODE
        ENTITY zr_tcs017 UPDATE FIELDS ( ItemNo )
            WITH CORRESPONDING #( lt_data  ).

  ENDMETHOD.

  METHOD checkItemFields.

    DATA permission_request TYPE STRUCTURE FOR PERMISSIONS REQUEST zr_tcs017.
    DATA(description_permission_request) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data_ref( REF #( permission_request-%field ) ) ).
    DATA(components_permission_request) = description_permission_request->get_components(  ).

    DATA reported_field LIKE LINE OF reported-zr_tcs017.
*    DATA reported_field1 LIKE LINE OF reported-zr_tcs017.


    LOOP AT components_permission_request INTO DATA(component_permission_request).
      permission_request-%field-(component_permission_request-name) = if_abap_behv=>mk-on.
    ENDLOOP.

    READ ENTITIES OF zr_tcs015 IN LOCAL MODE
        ENTITY zr_Tcs017
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    GET PERMISSIONS ONLY GLOBAL FEATURES ENTITY zr_tcs017 REQUEST permission_request
        RESULT DATA(permission_result).


    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<data>).
      LOOP AT components_permission_request INTO component_permission_request.
        IF permission_result-global-%field-(component_permission_request-name) = if_abap_behv=>fc-f-mandatory
          AND <data>-(component_permission_request-name) IS INITIAL.
          APPEND VALUE #( %tky = <data>-%tky  ) TO failed-zr_tcs017.
*          failed-zr_tcs016[ 1 ]-%fail-cause-unspecific

          CLEAR reported_field.
          reported_field-%tky = <data>-%tky.
          reported_field-%element-(component_permission_request-name) = if_abap_behv=>mk-on.
          reported_field-%path = VALUE #( zr_tcs015-%is_draft = <data>-%is_draft
                                          zr_tcs015-%key-uuid = <data>-RootUUID
                                          zr_tcs016-%is_draft = <data>-%is_draft
                                          zr_tcs016-%key-uuid = <data>-ParentUUID
                                          ).
          reported_field-%state_area = component_permission_request-name.

          reported_field-%msg = new_message( id       = '00'
                                                         number   = 000
                                                         severity = if_abap_behv_message=>severity-error
                                                         v1       = |{ component_permission_request-name }|
*                                                         v2       = | with key: { <data>-uuid } is required | ).
                                                         v2       = | is required | ).

          APPEND reported_field TO reported-zr_tcs017 .
        ENDIF.





      ENDLOOP.

      " Check other fields
      " Validate Serial Number API_MATERIALSERIALNUMBER_0001
      " Validate Stock - Serial Number
      " ② API_MATERIAL_STOCK_SRV
      IF <data>-Product IS NOT INITIAL
          AND <data>-Plant IS NOT INITIAL
          AND <data>-StorageLocation IS NOT INITIAL
          AND <data>-SerialNumber IS NOT INITIAL.
        IF ( zzcl_mm_utils=>checkserialnumberbymaterial( material = <data>-Product
                                                         plant = <data>-Plant
                                                         storagelocation = <data>-StorageLocation
                                                         serialnumber = <data>-SerialNumber
                                                       ) = abap_false ).
          APPEND VALUE #( %tky = <data>-%tky  ) TO failed-zr_tcs017.
          CLEAR reported_field.
          reported_field-%tky = <data>-%tky.
          reported_field-%element-serialnumber = if_abap_behv=>mk-on.
          reported_field-%path = VALUE #( zr_tcs015-%is_draft = <data>-%is_draft
                                          zr_tcs015-%key-uuid = <data>-RootUUID
                                          zr_tcs016-%is_draft = <data>-%is_draft
                                          zr_tcs016-%key-uuid = <data>-ParentUUID
                                          ).
          reported_field-%state_area = component_permission_request-name.

          reported_field-%msg = new_message( id       = 'ZZCS'
                                                         number   = 000
                                                         severity = if_abap_behv_message=>severity-error
                                                         v1       = <data>-SerialNumber
                                                         v2       = <data>-Plant
                                                         v3       = <data>-StorageLocation ).

          APPEND reported_field TO reported-zr_tcs017 .
        ENDIF.
      ENDIF.

      IF <data>-Product IS NOT INITIAL
          AND <data>-Plant IS NOT INITIAL
          AND <data>-StorageLocation IS NOT INITIAL.
        " Check Product & StorageLocation
        " ① I_ProductStorageLocationBasic
        SELECT SINGLE Product,
                      Plant,
                      StorageLocation
            FROM I_ProductStorageLocationBasic WITH PRIVILEGED ACCESS
            WHERE Product = @<data>-Product
              AND Plant = @<data>-Plant
              AND StorageLocation = @<data>-StorageLocation
            INTO @DATA(ls_productstoragelocation).
        IF sy-subrc NE 0.

          APPEND VALUE #( %tky = <data>-%tky  ) TO failed-zr_tcs017.
          CLEAR reported_field.
          reported_field-%tky = <data>-%tky.
          reported_field-%element-storagelocation = if_abap_behv=>mk-on.
          reported_field-%path = VALUE #( zr_tcs015-%is_draft = <data>-%is_draft
                                          zr_tcs015-%key-uuid = <data>-RootUUID
                                          zr_tcs016-%is_draft = <data>-%is_draft
                                          zr_tcs016-%key-uuid = <data>-ParentUUID
                                          ).
          reported_field-%state_area = component_permission_request-name.

          reported_field-%msg = new_message( id       = 'ZZCS'
                                                         number   = 001
                                                         severity = if_abap_behv_message=>severity-error
                                                         v1       = <data>-Plant
                                                         v2       = <data>-StorageLocation ).

          APPEND reported_field TO reported-zr_tcs017 .
        ENDIF.

        " Validate Stock - Non Serial Number
        " API_MATERIAL_STOCK_SRV
        IF <data>-SerialNumber IS INITIAL.
          IF ( zzcl_mm_utils=>checkstockwithoutsn( material = <data>-Product
                                                 plant = <data>-Plant
                                                 storagelocation = <data>-StorageLocation
*                                                 serialnumber = <data>-SerialNumber
                                                 quantity = <data>-Quantity
                                                 unit = <data>-Unit
                                               ) = abap_false ).
            APPEND VALUE #( %tky = <data>-%tky  ) TO failed-zr_tcs017.
            CLEAR reported_field.
            reported_field-%tky = <data>-%tky.
            reported_field-%element-quantity = if_abap_behv=>mk-on.
            reported_field-%path = VALUE #( zr_tcs015-%is_draft = <data>-%is_draft
                                            zr_tcs015-%key-uuid = <data>-RootUUID
                                            zr_tcs016-%is_draft = <data>-%is_draft
                                            zr_tcs016-%key-uuid = <data>-ParentUUID
                                            ).
            reported_field-%state_area = component_permission_request-name.

            reported_field-%msg = new_message( id       = 'ZZCS'
                                                           number   = 002
                                                           severity = if_abap_behv_message=>severity-error
                                                           v1       = <data>-Plant
                                                           v2       = <data>-StorageLocation ).

            APPEND reported_field TO reported-zr_tcs017 .
          ENDIF.
        ENDIF.
      ENDIF.






      " Validate Sales Document & Sales Document Item
      IF <data>-SoNumber IS NOT INITIAL.
        SELECT SINGLE salesdocument
            FROM i_saLESDOCUMENT
            WHERE salesdocument = @<data>-SoNumber
            INTO @DATA(ls_so).
        IF sy-subrc NE 0.
          APPEND VALUE #( %tky = <data>-%tky  ) TO failed-zr_tcs017.
          CLEAR reported_field.
          reported_field-%tky = <data>-%tky.
          reported_field-%element-sonumber = if_abap_behv=>mk-on.
          reported_field-%path = VALUE #( zr_tcs015-%is_draft = <data>-%is_draft
                                          zr_tcs015-%key-uuid = <data>-RootUUID
                                          zr_tcs016-%is_draft = <data>-%is_draft
                                          zr_tcs016-%key-uuid = <data>-ParentUUID
                                          ).
          reported_field-%state_area = component_permission_request-name.

          reported_field-%msg = new_message( id       = 'ZZCS'
                                                         number   = 003
                                                         severity = if_abap_behv_message=>severity-error
                                                          ).

          APPEND reported_field TO reported-zr_tcs017 .
        ENDIF.


      ENDIF.

      IF <data>-SoNumber IS NOT INITIAL AND <data>-SoItem IS NOT INITIAL.
        SELECT SINGLE salesdocument
            FROM i_saLESDOCUMENTITEM
            WHERE salesdocument = @<data>-SoNumber
              AND salesdocumentitem = @<data>-SoItem
            INTO @DATA(ls_soITEM).
        IF sy-subrc NE 0.
          APPEND VALUE #( %tky = <data>-%tky  ) TO failed-zr_tcs017.
          CLEAR reported_field.
          reported_field-%tky = <data>-%tky.
          reported_field-%element-soitem = if_abap_behv=>mk-on.
          reported_field-%path = VALUE #( zr_tcs015-%is_draft = <data>-%is_draft
                                          zr_tcs015-%key-uuid = <data>-RootUUID
                                          zr_tcs016-%is_draft = <data>-%is_draft
                                          zr_tcs016-%key-uuid = <data>-ParentUUID
                                          ).
          reported_field-%state_area = component_permission_request-name.

          reported_field-%msg = new_message( id       = 'ZZCS'
                                                         number   = 004
                                                         severity = if_abap_behv_message=>severity-error
                                                          ).

          APPEND reported_field TO reported-zr_tcs017 .
        ENDIF.
      ENDIF.


    ENDLOOP.


  ENDMETHOD.

  METHOD determineStatus.
    READ ENTITIES OF zr_tcs015 IN LOCAL MODE
        ENTITY zr_tcs017 FIELDS ( uuid SoNumber SoItem )
            WITH CORRESPONDING #( keys ) RESULT DATA(lt_data).


    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<data>).
      IF <data>-SoNumber IS NOT INITIAL AND <data>-SoItem IS NOT INITIAL.
        <data>-PartsApplicationStatus = 'Created SO'.
      ELSE.
        <data>-PartsApplicationStatus = 'Submitted'.
      ENDIF.
      <data>-SubmitDate = cl_abap_context_info=>get_system_date( ).
    ENDLOOP.

    MODIFY ENTITIES OF zr_tcs015 IN LOCAL MODE
        ENTITY zr_tcs017 UPDATE FIELDS ( PartsApplicationStatus SubmitDate )
            WITH CORRESPONDING #( lt_data  ).

  ENDMETHOD.

  METHOD determineStatusInDraft.
    " Change Quantity if serial number is not initial.


  ENDMETHOD.

  METHOD determineQuantityBySN.
    READ ENTITIES OF zr_tcs015 IN LOCAL MODE
    ENTITY zr_tcs017 FIELDS ( uuid SerialNumber Quantity )
        WITH CORRESPONDING #( keys ) RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<data>).
      IF <data>-SerialNumber IS NOT INITIAL.
        <data>-Quantity = 1.
*      ELSE.
**        <data>-PartsApplicationStatus = 'Submitted'.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zr_tcs015 IN LOCAL MODE
        ENTITY zr_tcs017 UPDATE FIELDS ( Quantity )
            WITH CORRESPONDING #( lt_data  ).
  ENDMETHOD.

ENDCLASS.

*CLASS LHC_ZR_TCS017 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
*  PRIVATE SECTION.
*    METHODS:
*      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
*        IMPORTING
*           REQUEST requested_authorizations FOR ZR_TCS017
*        RESULT result.
*ENDCLASS.
*
*CLASS LHC_ZR_TCS017 IMPLEMENTATION.
*  METHOD GET_GLOBAL_AUTHORIZATIONS.
*  ENDMETHOD.
*ENDCLASS.

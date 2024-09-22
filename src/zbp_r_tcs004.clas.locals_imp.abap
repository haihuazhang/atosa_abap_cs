CLASS lhc_serviceorderissuegroup DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ServiceOrderIssueGroup
        RESULT result,
      updateServiceDocument FOR MODIFY
        IMPORTING keys FOR ACTION ServiceOrderIssueGroup~updateServiceDocument RESULT result.
ENDCLASS.

CLASS lhc_serviceorderissuegroup IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD updateServiceDocument.

    DATA: lt_serviceorder_change    TYPE TABLE FOR UPDATE I_ServiceOrderTP\\ServiceOrder,
          lt_longtext_to_create_cba TYPE TABLE FOR CREATE I_ServiceOrderTP\_SrvcOrdLongTextTP,
          ls_longtext_to_create_cba LIKE LINE OF lt_longtext_to_create_cba.
    DATA : lv_longText TYPE string.


    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>) INDEX 1.
    IF sy-subrc = 0.

      " Update Customizing Field
      lt_serviceorder_change =
      VALUE #( (

                   YY1_InorOutofWarranty_SRH = <key>-%param-YY1_InorOutofWarranty_SRH
                   YY1_ChangeReason_SRH = <key>-%param-YY1_ChangeReason_SRH
                   YY1_MissingSNReason_SRH = <key>-%param-YY1_MissingSNReason_SRH
                   YY1_AcceptReject_SRH = <key>-%param-YY1_AcceptReject_SRH
                   YY1_BusinessName1_SRH = <key>-%param-YY1_BusinessName1_SRH
                   YY1_ContactName1_SRH = <key>-%param-YY1_ContactName1_SRH
                   YY1_ContactPhone1_SRH = <key>-%param-YY1_ContactPhone1_SRH
                   YY1_City_SRH = <key>-%param-YY1_City_SRH
                   YY1_State_SRH = <key>-%param-YY1_State_SRH
                   YY1_Street_SRH = <key>-%param-YY1_Street_SRH
                   YY1_Zip_SRH = <key>-%param-YY1_Zip_SRH
                   YY1_Address2_SRH = <key>-%param-YY1_Address2_SRH
                   YY1_Email_SRH = <key>-%param-YY1_Email_SRH
                   YY1_BusinessHour_SRH = <key>-%param-YY1_BusinessHour_SRH
                   YY1_OldSerialNumber_SRH = <key>-%param-YY1_OldSerialNumber_SRH
                   YY1_AddressType_SRH = <key>-%param-YY1_AddressType_SRH
                   YY1_WhichManText_SRH = <key>-%param-YY1_WhichManText_SRH
                   YY1_IssueCategory_SRH = <key>-%param-YY1_IssueCategory_SRH
                   YY1_BrandName1_SRH = <key>-%param-YY1_BrandName1_SRH
                   YY1_NonAtosaMatModel_SRH = <key>-%param-YY1_NonAtosaMatModel_SRH
                   YY1_RealSerialNumber_SRH = <key>-%param-YY1_RealSerialNumber_SRH
                   %key-ServiceOrder = <key>-%param-ServiceOrder
                   %tky-ServiceOrder = <key>-%param-ServiceOrder
                  ) ).

      " Update Issue Category in Long Text(Internal Note).
      " With Create by Association (Create is OK for both Insert and Update in LongText scenario).

      " Get Service Order Issue Group and Issue Content.
      SELECT a~ServiceOrderUUID,
             a~IssueCategory,
             a~IssueGroup,
             c~IssueContent,
             c~IssueContentS
        FROM zr_tcs004 AS a JOIN I_ServiceDocument AS b ON a~ServiceOrderUUID = b~ServiceDocumentUUID
                            JOIN zr_tcs005 AS c ON a~uuid = c~ServiceOrderIssueGroupUUID
            WHERE b~ServiceDocument = @<key>-%param-ServiceOrder
              AND a~IssueCategory = @<key>-%param-YY1_IssueCategory_SRH
              INTO TABLE @DATA(lt_issue_content).
      DELETE lt_issue_content WHERE IssueContentS = space.

      " String: Issue Category
      lv_longText = |------------------------------------------\r\nIssue Category:\r\n{ <key>-%param-YY1_IssueCategory_SRH }|.


      LOOP AT lt_issue_content ASSIGNING FIELD-SYMBOL(<fs_issue_group>) GROUP BY <fs_issue_group>-IssueGroup.
        " String: Issue Group
        lv_longText = |{ lv_longText }\r\n\r\n------------------------------\r\nIssue Group:\r\n{ <fs_issue_group>-IssueGroup }|.
        LOOP AT GROUP <fs_issue_group> ASSIGNING FIELD-SYMBOL(<fs_issue>).
          " String: Issue
          lv_longText = |{ lv_longText }\r\n\r\n------------------\r\nIssue:\r\n{ <fs_issue>-IssueContent }\r\n\r\n{ <fs_issue>-IssueContentS }|.
        ENDLOOP.
      ENDLOOP.


      "Parameters for BOI(Long Text)
      ls_longtext_to_create_cba-%key-ServiceOrder = <key>-%param-ServiceOrder.
      ls_longtext_to_create_cba-ServiceOrder = <key>-%param-ServiceOrder.

      INSERT VALUE #(
            %cid = 'CID_DUMMY'
            TextObjectType                 = 'S002'
            Language                       = 'E'
            ServiceOrderLongText = lv_longText
            %control-TextObjectType = if_abap_behv=>mk-on
            %control-Language = if_abap_behv=>mk-on
            %control-ServiceOrderLongText = if_abap_behv=>mk-on
        ) INTO TABLE ls_longtext_to_create_cba-%target.
      APPEND ls_longtext_to_create_cba TO lt_longtext_to_create_cba.






      " BOI: Service Order
      " Update Customizing Fields in Service Order Header
      " Create Long Text of Service Order Header(Internal Note)
      MODIFY ENTITIES OF i_serviceordertp
      ENTITY serviceorder
      UPDATE FIELDS ( YY1_InorOutofWarranty_SRH  YY1_ChangeReason_SRH YY1_MissingSNReason_SRH
                      YY1_AcceptReject_SRH YY1_BusinessName1_SRH YY1_ContactName1_SRH
                      YY1_ContactPhone1_SRH YY1_City_SRH YY1_State_SRH
                      YY1_Street_SRH YY1_Zip_SRH YY1_Address2_SRH
                      YY1_Email_SRH YY1_BusinessHour_SRH YY1_OldSerialNumber_SRH YY1_AddressType_SRH YY1_WhichManText_SRH YY1_IssueCategory_SRH
                      YY1_BrandName1_SRH YY1_NonAtosaMatModel_SRH YY1_RealSerialNumber_SRH )
      WITH lt_serviceorder_change
      CREATE BY \_SrvcOrdLongTextTP FROM lt_longtext_to_create_cba

          FAILED DATA(lt_failed_modify)
          REPORTED DATA(lt_reported_modify).

      IF lines( lt_failed_modify-serviceorder ) > 0.
        failed-serviceorderissuegroup = VALUE #( ( %cid = <key>-%cid ) ).
        reported-serviceorderissuegroup = VALUE #( FOR rpdserviceorder IN lt_reported_modify-serviceorder ( %cid = <key>-%cid %msg = rpdserviceorder-%msg ) ).
      ENDIF.


    ENDIF.



  ENDMETHOD.

ENDCLASS.

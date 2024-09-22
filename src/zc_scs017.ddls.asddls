@EndUserText.label: 'Quality Report'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SCS017
  provider contract transactional_query
  as projection on ZR_SCS017
{
  key     ServiceDocument,
  key     ServiceDocumentItem,
          _ServiceDocumentSuccessor.ServiceDocSuccessor,
          YY1_Activity_SRI,
          _ServiceDocumentEnhcd.ServiceDocumentCreationDate,
          @ObjectModel.text.element: [ 'PersonFullName' ]
          ServiceDocumentCreatedByUser,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual TechnicianID               : abap.char( 10 ),
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual TechnicianName             : abap.char( 80 ),

          ReferenceProduct,
          @ObjectModel.text.element: [ 'ProductGroupName' ]
          ProductGroup,
          SerialNumber,
          _ZTMM001.zoldserialnumber as OldSerialNumber,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual UsageDurationByDate        : abap.int4,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual UsageDurationByMonth       : abap.char( 20 ),

          YY1_Replacement_SRH,

          @ObjectModel.text.element: [ 'YY1_InorOutofWarranty_Desc' ]
          YY1_InorOutofWarranty_SRH,
          @UI.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual YY1_InorOutofWarranty_Desc : abap.char( 100 ),

          @ObjectModel.text.element: [ 'YY1_ReplaceReason_Desc' ]
          YY1_ReplaceReason_SRH,
          @UI.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual YY1_ReplaceReason_Desc     : abap.char( 100 ),

          YY1_ResolutionCode1_SRI,
          YY1_ResolutionCode2_SRI,

          // PartsAmount

          _ServiceDocumentHeaderText.ServiceDocumentLongText,

          @Semantics.quantity.unitOfMeasure : 'LaborHourUnit'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual LaborHour                  : abap.quan( 7, 2 ),

          @Semantics.quantity.unitOfMeasure : 'TravelHourUnit'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual TravelHour                 : abap.quan( 7, 2 ),

          @UI.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual LaborHourUnit              : abap.unit( 3 ),

          @UI.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZZCL_CS_002'
  virtual TravelHourUnit             : abap.unit( 3 ),

          @UI.hidden: true
          ServiceObjectType,
          @UI.hidden: true
          ServiceDocumentType,
          @UI.hidden: true
          ServiceDocumentUUID,
          @UI.hidden: true
          ProductID,
          @UI.hidden: true
          DeliveryDocument,
          @UI.hidden: true
          DeliveryDocumentItem,
          @UI.hidden: true
          _User.PersonFullName,
          @UI.hidden: true
          _ProductGroupText.ProductGroupName,

          /* Associations */
          _Product,
          _ProductGroupText,
          _SerialNumberDelivery,
          _ServiceDocumentEnhcd,
          _ServiceDocumentHeaderText,
          _ServiceDocumentRefObject,
          _ServiceDocumentSuccessor,
          _User,
          _ZTMM001
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quality Report'
define root view entity ZR_SCS016
  as select from I_ServiceDocument     as _ServiceDocument
    inner join   I_ServiceDocumentItem as _ServiceDocumentItem on _ServiceDocumentItem.ServiceDocument = _ServiceDocument.ServiceDocument

  association [0..1] to I_BusinessUserVH           as _User                      on  _User.UserID = $projection.ServiceDocumentCreatedByUser
  association [0..1] to I_ServiceDocumentSuccessor as _ServiceDocumentSuccessor  on  _ServiceDocumentSuccessor.ServiceDocumentUUID           = $projection.ServiceDocumentUUID
                                                                                 and _ServiceDocumentSuccessor.ServiceDocSuccessorBusObjType = 'FSMCALL'
  association [0..1] to I_ServiceDocumentEnhcd     as _ServiceDocumentEnhcd      on  _ServiceDocumentEnhcd.ServiceObjectType = $projection.ServiceObjectType
                                                                                 and _ServiceDocumentEnhcd.ServiceDocument   = $projection.ServiceDocument
  association [0..1] to I_ServiceDocumentRefObject as _ServiceDocumentRefObject  on  _ServiceDocumentRefObject.ServiceObjectType   = $projection.ServiceObjectType
                                                                                 and _ServiceDocumentRefObject.ServiceDocument     = $projection.ServiceDocument
                                                                                 and _ServiceDocumentRefObject.ServiceDocumentItem = $projection.ServiceDocumentItem
  association [0..1] to I_SrvcDocHeaderLongText    as _ServiceDocumentHeaderText on  _ServiceDocumentHeaderText.ServiceObjectType = $projection.ServiceObjectType
                                                                                 and _ServiceDocumentHeaderText.ServiceDocument   = $projection.ServiceDocument
                                                                                 and _ServiceDocumentHeaderText.TextObjectType    = 'S009'
                                                                                 and _ServiceDocumentHeaderText.Language          = $session.system_language
{
  key _ServiceDocument.ServiceDocument,
  key _ServiceDocumentItem.ServiceDocumentItem,

      _ServiceDocument.ServiceObjectType,
      _ServiceDocument.ServiceDocumentType,
      _ServiceDocument.ServiceDocumentUUID,
      _ServiceDocument.ServiceDocumentCreatedByUser,
      _ServiceDocument.YY1_Replacement_SRH,
      _ServiceDocument.YY1_ReplaceReason_SRH,
      _ServiceDocument.YY1_InorOutofWarranty_SRH,

      _ServiceDocumentItem.YY1_Activity_SRI,
      _ServiceDocumentItem.YY1_ResolutionCode1_SRI,
      _ServiceDocumentItem.YY1_ResolutionCode2_SRI,

      _ServiceDocumentRefObject.ProductID,
      _ServiceDocumentRefObject.ReferenceProduct,
      _ServiceDocumentRefObject.SerialNumber,

      _User,
      _ServiceDocumentSuccessor,
      _ServiceDocumentEnhcd,
      _ServiceDocumentRefObject,
      _ServiceDocumentHeaderText
}
where
      _ServiceDocument.ServiceObjectType          = 'BUS2000116'
  and _ServiceDocument.ServiceDocumentType        = 'SVO1'
  and _ServiceDocumentItem.ServiceDocItemCategory = 'SVP1'

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quality Report'
define root view entity ZR_SCS017
  as select from ZR_SCS016

  association [0..1] to I_Product                      as _Product              on  _Product.Product = $projection.ReferenceProduct

  association [0..1] to I_ProductGroupText_2           as _ProductGroupText     on  _ProductGroupText.ProductGroup = $projection.productgroup
                                                                                and _ProductGroupText.Language     = $session.system_language
  association [0..1] to ztmm001                        as _ZTMM001              on  _ZTMM001.product       = $projection.ProductID
                                                                                and _ZTMM001.zserialnumber = $projection.SerialNumber
  association [0..1] to I_SerialNumberDeliveryDocument as _SerialNumberDelivery on  _SerialNumberDelivery.Material     = $projection.ReferenceProduct
                                                                                and _SerialNumberDelivery.SerialNumber = $projection.SerialNumber

{
  key ServiceDocument,
  key ServiceDocumentItem,
      ServiceObjectType,
      ServiceDocumentType,
      ServiceDocumentUUID,
      ServiceDocumentCreatedByUser,
      YY1_Replacement_SRH,
      YY1_ReplaceReason_SRH,
      YY1_InorOutofWarranty_SRH,
      YY1_Activity_SRI,
      YY1_ResolutionCode1_SRI,
      YY1_ResolutionCode2_SRI,
      ProductID,
      ReferenceProduct,
      _Product.ProductGroup,
      SerialNumber,

      _SerialNumberDelivery.DeliveryDocument,
      _SerialNumberDelivery.DeliveryDocumentItem,

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

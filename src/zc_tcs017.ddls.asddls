@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS017'
define view entity ZC_TCS017
  //  provider contract transactional_query
  as projection on ZR_TCS017
{
  key UUID,
      ParentUUID,
      RootUUID,
      ItemNo,
      Product,
      Quantity,
      Unit,
      SerialNumber,
      Plant,
      StorageLocation,
      SoNumber,
      SoItem,
      PartsApplicationStatus,
      SubmitDate,
      LocalLastChangedAt,
      /* Associations */
      _Shipping : redirected to parent ZC_TCS016,
      _Header   : redirected to ZC_TCS015

}

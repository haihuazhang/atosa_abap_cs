@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS016'
define view entity ZC_TCS016
  //  provider contract transactional_query
  as projection on ZR_TCS016
{
  key UUID,
      ParentUUID,
      ShipToCustomerOrTech,
      ShippingMethod,
      Dealer,
      SalesOrganization,
      ContactName,
      ContactPhone,
      Address,
      Address2,
      City,
      State,
      Zip,
      LocalLastChangedAt,
      CreatedAt,
      /* Associations */
      _Parts  : redirected to composition child ZC_TCS017,
      _Header : redirected to parent ZC_TCS015,
      _Previous

}

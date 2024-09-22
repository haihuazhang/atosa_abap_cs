@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS015'
@ObjectModel.semanticKey: ['UUID']
define root view entity ZC_TCS015
  provider contract transactional_query
  as projection on ZR_TCS015
{
  key UUID,
  LocalLastChangedAt,
  _Shipping : redirected to composition child ZC_TCS016
  
}

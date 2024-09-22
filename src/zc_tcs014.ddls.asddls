@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS014'
define root view entity ZC_TCS014
  provider contract transactional_query
  as projection on ZR_TCS014
{
  key UUID,
  IssueCategory,
  BrandName,
  Z3rdProductModels,
  LocalLastChangedAt
  
}

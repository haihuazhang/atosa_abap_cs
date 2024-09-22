@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS013'
@ObjectModel.semanticKey: [ 'MaterialModel' ]
define root view entity ZC_TCS013
  provider contract transactional_query
  as projection on ZR_TCS013
{
  key UUID,
  IssueCategory,
  MaterialModel,
  LocalLastChangedAt
  
}

@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS001'
@ObjectModel.semanticKey: [ 'IssueCategory','IssueGroup' ]
define root view entity ZC_TCS001
  provider contract transactional_query
  as projection on ZR_TCS001
{
  key UUID,
  IssueCategory,
  IssueGroup,
  VideoRequired,
  PictureRequired,
  LocalLastChangedAt,
  _Issue : redirected to composition child ZC_TCS002
  
}

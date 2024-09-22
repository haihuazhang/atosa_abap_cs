@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS004'
define root view entity ZC_TCS004
  provider contract transactional_query
  as projection on ZR_TCS004
{
  key UUID,
  IssueCategory,
  IssueGroupUUID,
  ServiceOrderUUID,
  IssueGroup,
  Picture,
  PictureFileName,
  PictureMimeType,
  Video,
  VideoFileName,
  VideoMimeType,
  LocalLastChangedAt,
  _Item : redirected to ZC_TCS005
  
}

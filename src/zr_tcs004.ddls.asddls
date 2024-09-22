@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Issue Category of Service Orde'
define root view entity ZR_TCS004
  as select from ztcs004 as ServiceOrderIssueGroup
  association [0..*] to ZR_TCS005 as _Item on _Item.ServiceOrderIssueGroupUUID = $projection.UUID
{
  key uuid                  as UUID,
      issue_category        as IssueCategory,
      issue_group_uuid      as IssueGroupUUID,
      service_order_uuid    as ServiceOrderUUID,
      issue_group           as IssueGroup,
      @Semantics.largeObject:
      { mimeType: 'PictureMimeType',
      fileName: 'PictureFileName',
      contentDispositionPreference: #ATTACHMENT }
      picture               as Picture,
      picture_file_name     as PictureFileName,
      @Semantics.mimeType: true
      picture_mime_type     as PictureMimeType,
      @Semantics.largeObject:
      { mimeType: 'VideoMimeType',
      fileName: 'VideoFileName',
      contentDispositionPreference: #ATTACHMENT }
      video                 as Video,
      video_file_name       as VideoFileName,
      @Semantics.mimeType: true
      video_mime_type       as VideoMimeType,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Item
}

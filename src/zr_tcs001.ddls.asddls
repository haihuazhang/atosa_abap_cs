@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Issue Category Management'
@ObjectModel.semanticKey: [ 'IssueCategory','IssueGroup' ]
define root view entity ZR_TCS001
  as select from ztcs001 as IssueGroup
  composition [0..*] of ZR_TCS002 as _Issue
{
  key uuid                  as UUID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZR_TCS007', element: 'value_low' }, useForValidation: true}]
//      @Consumption.valueHelpDefinition.useForValidation: true
      issue_category        as IssueCategory,
      issue_group           as IssueGroup,
      video_required        as VideoRequired,
      picture_required      as PictureRequired,
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
      _Issue

}

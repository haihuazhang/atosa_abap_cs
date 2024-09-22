@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Issue of Service Order'
define root view entity ZR_TCS005
  as select from ztcs005 as ServiceOrderIssue
  //composition of target_data_source_name as _association_name
{
  key uuid                  as UUID,
      parent_uuid           as ServiceOrderIssueGroupUUID,
      issue_uuid            as IssueUUID,
      issue_content         as IssueContent,
      issue_content_s       as IssueContentS,
       issue_group as IssueGroup,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
      //    _association_name // Make association public
}

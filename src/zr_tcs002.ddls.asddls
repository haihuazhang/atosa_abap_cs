@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Issue Category Management - Issue'
define view entity ZR_TCS002
  as select from ztcs002 as _Issue
  association to parent ZR_TCS001 as _IssueGroup on $projection.IssueGroupUUID = _IssueGroup.UUID
  composition [0..*] of ZR_TCS003 as _DropDownContent
{
  key _Issue.uuid           as UUID,
      _Issue.parent_uuid    as IssueGroupUUID,
      _Issue.issue_content  as IssueContent,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZR_TCS010', element: 'value_low' }}]
      _Issue.issue_type     as IssueCType,
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

      _IssueGroup, // Make association public
      _DropDownContent
}

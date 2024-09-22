@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Issue Category Management - DropDown Content'
define view entity ZR_TCS003
  as select from ztcs003 as _DropDownContent
  association to parent ZR_TCS002 as _Issue on $projection.IssueUUID = _Issue.UUID
  association [1..1] to ZR_TCS001 as _IssueGroup on $projection.IssueGroupUUID = _IssueGroup.UUID
{
  key uuid                  as UUID,
      root_uuid             as IssueGroupUUID,
      parent_uuid           as IssueUUID,
      dropdown_content      as DropdownContent,
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
      _Issue, // Make association public
      _IssueGroup
}

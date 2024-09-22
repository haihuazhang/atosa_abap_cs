@EndUserText.label: 'Issue Category Management - DropDown Content'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_TCS003 as projection on ZR_TCS003
{
    key UUID,
    IssueGroupUUID,
    IssueUUID,
    DropdownContent,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _Issue : redirected to parent ZC_TCS002,
    _IssueGroup : redirected to ZC_TCS001
}

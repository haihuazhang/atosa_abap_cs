@EndUserText.label: 'Issue Category Management - Issue'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
define view entity ZC_TCS002 as projection on ZR_TCS002
{
    key UUID,
    IssueGroupUUID,
    IssueContent,
    IssueCType,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _DropDownContent : redirected to composition child ZC_TCS003,
    _IssueGroup : redirected to parent ZC_TCS001
}

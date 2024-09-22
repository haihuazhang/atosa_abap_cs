@EndUserText.label: 'Issue of Service Order'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_TCS005
  provider contract transactional_query
  as projection on ZR_TCS005
{
  key UUID,
      ServiceOrderIssueGroupUUID,
      IssueUUID,
      IssueContent,
      IssueContentS,
      IssueGroup,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}

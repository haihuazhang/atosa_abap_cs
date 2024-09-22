@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZTCS014'
define root view entity ZR_TCS014
  as select from ztcs014
{
  key uuid as UUID,
  issue_category as IssueCategory,
  brand_name as BrandName,
  z3rd_product_models as Z3rdProductModels,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
  
}

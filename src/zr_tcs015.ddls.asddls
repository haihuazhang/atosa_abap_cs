@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Service Parts UDF'
define root view entity ZR_TCS015
  as select from ztcs015 as Header
  composition [0..*] of ZR_TCS016 as _Shipping
{
  key uuid as UUID,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  _Shipping
  
}

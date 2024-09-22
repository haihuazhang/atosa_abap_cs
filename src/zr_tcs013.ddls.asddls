@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Issue Category and Material'
define root view entity ZR_TCS013
  as select from ztcs013
{
  key uuid as UUID,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZR_TCS007', element: 'value_low' }, useForValidation: true}]
  issue_category as IssueCategory,
  material_model as MaterialModel,
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

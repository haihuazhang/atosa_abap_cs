@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product and Material Model'
define view entity ZR_SCS010
  as select from I_ProductSalesDelivery         as _Sales
    inner join   I_AdditionalMaterialGroup1Text as _MaterialGroupText on  _MaterialGroupText.AdditionalMaterialGroup1 = _Sales.FirstSalesSpecProductGroup
                                                                      and _MaterialGroupText.Language                 = $session.system_language
{
  key _Sales.Product                                  as Product,
  key _Sales.ProductSalesOrg,
  key _Sales.ProductDistributionChnl,
      //    key _Sales.ProductSalesOrg,
      //    key _Sales.ProductDistributionChnl,
      //    max( _Sales.FirstSalesSpecProductGroup ) as ,
      _MaterialGroupText.AdditionalMaterialGroup1Name as ProductModel
}
where
  _MaterialGroupText.AdditionalMaterialGroup1Name <> ''
//group by
//  _Sales.Product

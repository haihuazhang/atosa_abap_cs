@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Value Help of Shipping Method'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SCS020 as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZZDCS026')
{
 
    @Semantics.language: true
    key language,
    key value_low,
        domain_name,
        value_position,
    @Semantics.text: true
    text
}

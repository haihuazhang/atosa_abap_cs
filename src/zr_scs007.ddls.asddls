@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Value Help of Brand Name'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [ #CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE ]
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZR_SCS007
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZZDCS022')
  association [0..*] to ZR_SCS004 as _Text on  $projection.domain_name    = _Text.domain_name
                                           and $projection.value_position = _Text.value_position
{
       //    key ,

       @ObjectModel.text.association: '_Text'
  key  value_low,
       domain_name,
       value_position,
       //    value_high,
       _Text
}

@EndUserText.label: 'Service Value Help of Issue Category'
@ObjectModel.query.implementedBy:'ABAP:ZZCL_ZR_TCS008'
define custom entity ZR_TCS008
// with parameters parameter_name : parameter_type
{
  key IssueCategoryCode : zzecs001;
  IssueCategoryText : abap.sstring( 100 );
  
}

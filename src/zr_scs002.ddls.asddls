@EndUserText.label: 'Service Value Help of Non-Atosa Product Model'
@ObjectModel.query.implementedBy:'ABAP:ZZCL_ZR_SCS006'
define custom entity ZR_SCS002
  // with parameters parameter_name : parameter_type
{
      //      @ObjectModel.text.element:['Description']
  key Code          : zzecs023;
      BrandName     : zzecs022;
      Description   : abap.sstring( 100 );
      IssueCategory : zzecs001;

}

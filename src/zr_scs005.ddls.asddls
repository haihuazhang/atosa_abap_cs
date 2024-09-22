@EndUserText.label: 'Service Value Help of Address Type'
@ObjectModel.query.implementedBy:'ABAP:ZZCL_ZR_SCS005'
define custom entity ZR_SCS005
{
  key AddressType : zzecs024;
  @Semantics.text: true
  AddressTypeText : abap.sstring( 100 );
  
}

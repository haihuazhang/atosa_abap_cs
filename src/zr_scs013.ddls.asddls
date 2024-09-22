@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Serial - Product - Old Serial Number'
define root view entity ZR_SCS013 as select from ZR_TMM001
//composition of target_data_source_name as _association_name
{
//    key UUID,
    key Product,
    key Zserialnumber as SerialNumber,
    max( Zoldserialnumber  ) as OldSerialNumber
//    CreatedBy,
//    CreatedAt,
//    LastChangedBy,
//    LastChangedAt,
//    LocalLastChangedAt,
//    _association_name // Make association public
}
 group by Product, Zserialnumber

@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TCS012'
@ObjectModel.semanticKey: [ 'ZMaterial', 'ZSerialNumber' ]
define root view entity ZC_TCS012
  provider contract transactional_query
  as projection on ZR_TCS012
{
  key ZMaterial,
  key ZSerialNumber,
  ZOldSerial,
  ZBusinessName,
  ZContactId,
  ZContactName,
  ZContactPhone,
  ZCity,
  ZState,
  ZZip,
  ZStreet,
  ZAddress2,
  ZAddressType,
  ZEmail,
  ZBusinessHour,
  LocalLastChangedAt
  
}

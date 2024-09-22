@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZTCS012'
define root view entity ZR_TCS012
  as select from ztcs012
{
  key z_material as ZMaterial,
  key z_serial_number as ZSerialNumber,
  z_old_serial as ZOldSerial,
  z_business_name as ZBusinessName,
  z_contact_id as ZContactId,
  z_contact_name as ZContactName,
  z_contact_phone as ZContactPhone,
  z_city as ZCity,
  z_state as ZState,
  z_zip as ZZip,
  z_street as ZStreet,
  z_address2 as ZAddress2,
  z_address_type as ZAddressType,
  z_email as ZEmail,
  z_business_hour as ZBusinessHour,
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

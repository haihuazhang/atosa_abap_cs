@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Service Parts Shipping Info'
define view entity ZR_TCS016
  as select from ztcs016 as _Shipping
  association to parent ZR_TCS015 as _Header on $projection.ParentUUID = _Header.UUID
  composition [0..*] of ZR_TCS017 as _Parts
  association [0..*] to ZR_sCS022 as _Previous on $projection.UUID <> _Previous.ParentUUID
                                               and $projection.CreatedAt >= _Previous.CreatedAt
                                               and $projection.ParentUUID = _Previous.RootUUID
{
  key uuid                     as UUID,
      parent_uuid              as ParentUUID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZR_SCS019', element: 'value_low' }, useForValidation: true}]
      ship_to_customer_or_tech as ShipToCustomerOrTech,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZR_SCS021', element: 'value_low' }, useForValidation: true}]
      shipping_method          as ShippingMethod,
      dealer                   as Dealer,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesOrganization', element: 'SalesOrganization' }, useForValidation: true}]
      sales_organization       as SalesOrganization,
      contact_name             as ContactName,
      contact_phone            as ContactPhone,
      address                  as Address,
      address_2                as Address2,
      city                     as City,
      state                    as State,
      zip                      as Zip,
      @Semantics.user.createdBy: true
      created_by               as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at               as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by          as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at          as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at    as LocalLastChangedAt,
      _Header,
      _Parts,
      _Previous
}

@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Service Parts - Parts Info'
define view entity ZR_TCS017
  as select from ztcs017 as Parts
  association        to parent ZR_TCS016 as _Shipping    on $projection.ParentUUID = _Shipping.UUID
  association [1..1] to ZR_TCS015        as _Header      on $projection.RootUUID = _Header.UUID
  association [0..*] to I_ProductText    as _ProductText on $projection.Product = _ProductText.Product

{
  key uuid                     as UUID,
      parent_uuid              as ParentUUID,
      root_uuid                as RootUUID,
      item_no                  as ItemNo,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' }, useForValidation: true}]
      //      @ObjectModel.foreignKey.association: '_Product'
      @ObjectModel.text.association: '_ProductText'
      product                  as Product,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity                 as Quantity,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductUnitsOfMeasure', element: 'AlternativeUnit' }, useForValidation: true, 
                                           additionalBinding: [{
                                                element: 'Product',
                                                localElement: 'Product',
                                                usage: #FILTER
                                                 }]
                                        }]

      unit                     as Unit,
      serial_number            as SerialNumber,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' }, useForValidation: true}]
      plant                    as Plant,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_StorageLocation', element: 'StorageLocation' }, useForValidation: true,
                                        additionalBinding: [{
                                                element: 'Plant',
                                                localElement: 'Plant',
                                                usage: #FILTER
                                                 }]
                                        
                                        }]
      storage_location         as StorageLocation,
      so_number                as SoNumber,
      so_item                  as SoItem,
      parts_application_status as PartsApplicationStatus,
      submit_date              as SubmitDate,
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
      _Shipping,
      _ProductText

}

@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Service Parts - Parts Info'
@Metadata.allowExtensions: true
define view entity ZR_sCS022
  as select from ZR_TCS017
  //  association        to parent ZR_TCS016 as _Shipping    on $projection.ParentUUID = _Shipping.UUID
  //  association [1..1] to ZR_TCS015        as _Header      on $projection.RootUUID = _Header.UUID
  association [0..*] to I_ProductText as _ProductText on $projection.Product = _ProductText.Product
  association [0..1] to I_SalesDocument as _salesdocument on $projection.SoNumber = _salesdocument.SalesDocument

{
  key UUID                   as UUID,
      ParentUUID             as ParentUUID,
      RootUUID               as RootUUID,
      ItemNo                 as ItemNo,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' }, useForValidation: true}]
      //      @ObjectModel.foreignKey.association: '_Product'
      @ObjectModel.text.association: '_ProductText'
      Product                as Product,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Quantity               as Quantity,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductUnitsOfMeasure', element: 'AlternativeUnit' }, useForValidation: true,
                                           additionalBinding: [{
                                                element: 'Product',
                                                localElement: 'Product',
                                                usage: #FILTER
                                                 }]
                                        }]

      Unit                   as Unit,
      SerialNumber           as SerialNumber,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' }, useForValidation: true}]
      Plant                  as Plant,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_StorageLocation', element: 'StorageLocation' }, useForValidation: true,
                                        additionalBinding: [{
                                                element: 'Plant',
                                                localElement: 'Plant',
                                                usage: #FILTER
                                                 }]

                                        }]
      StorageLocation        as StorageLocation,
      SoNumber               as SoNumber,
      SoItem                 as SoItem,
      PartsApplicationStatus as PartsApplicationStatus,
      SubmitDate             as SubmitDate,
      @Semantics.user.createdBy: true
      CreatedBy              as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt              as CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy          as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt          as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt     as LocalLastChangedAt,
      _salesdocument.CreationDate,
      //      _Header,
      //      _Shipping,
      _ProductText

}

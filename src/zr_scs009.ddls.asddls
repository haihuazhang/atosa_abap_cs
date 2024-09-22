@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material & Serial Number of Service Order'
define root view entity ZR_SCS009
  as select from    I_ServiceOrderCube_2 as _ServiceOrderCube
    left outer join I_Equipment          as _Equipment on _Equipment.Equipment = _ServiceOrderCube.Equipment
{
  key _ServiceOrderCube.ServiceObjectType,
  key _ServiceOrderCube.ServiceOrder,

      //      _ServiceOrderCubeProductID,
      //      SerialNumber,
      _ServiceOrderCube.Equipment,


      case _ServiceOrderCube.ProductID
           when '' then _Equipment.Material
           else _ServiceOrderCube.ProductID
      end as ProductID,

      case _ServiceOrderCube.SerialNumber
           when '' then _Equipment.SerialNumber
           else _ServiceOrderCube.SerialNumber
      end as SerialNumber

}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Document with Serial Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SCS011
  as select from    I_ServiceOrderCube_2 as _ServiceOrderCube
    inner join      ZR_SCS009            as _ServiceOrderRef on  _ServiceOrderRef.ServiceObjectType = _ServiceOrderCube.ServiceObjectType
                                                             and _ServiceOrderRef.ServiceOrder      = _ServiceOrderCube.ServiceOrder
    left outer join ZR_TCS012                                on  _ServiceOrderRef.ProductID    = ZR_TCS012.ZMaterial
                                                             and _ServiceOrderRef.SerialNumber = ZR_TCS012.ZSerialNumber
    left outer join ZR_TMM001                                on  _ServiceOrderRef.ProductID    = ZR_TMM001.Product
                                                             and _ServiceOrderRef.SerialNumber = ZR_TMM001.Zserialnumber

    left outer join ZR_SCS010                                on _ServiceOrderRef.ProductID = ZR_SCS010.Product
                                                             and _ServiceOrderCube.SalesOrganization = ZR_SCS010.ProductSalesOrg
                                                             and _ServiceOrderCube.DistributionChannel = ZR_SCS010.ProductDistributionChnl
    
    

{
  key _ServiceOrderCube.ServiceObjectType,
  key _ServiceOrderCube.ServiceOrder,
      _ServiceOrderCube.ServiceOrderDescription,
      _ServiceOrderCube.ServiceOrderStatus,
      _ServiceOrderCube.ServiceOrderStatusName,
      _ServiceOrderCube.ServiceDocumentType,
      _ServiceOrderCube.RefBusinessSolutionOrder,
      _ServiceOrderCube.SoldToParty,
      _ServiceOrderCube.ResponsibleEmployee,
      _ServiceOrderCube.ContactPersonBusinessPartnerId,
      _ServiceOrderCube.RequestedServiceEndDate,
      _ServiceOrderCube.ServiceDocumentCreationDate,
      _ServiceOrderCube.SrvcOrdCreationQuarter,
      _ServiceOrderCube.SrvcOrdCreationMonth,
      _ServiceOrderCube.SrvcOrdCreationYear,
      _ServiceOrderCube.ServiceDocumentPriority,
      _ServiceOrderCube.ServiceDocumentHasError,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      _ServiceOrderCube.ServiceDocNetAmount,
      _ServiceOrderCube.NumberOfIncomingServiceOrders,
      _ServiceOrderCube.NumberOfOpenServiceOrders,
      _ServiceOrderCube.TransactionCurrency,
      _ServiceOrderCube.PurchaseOrderByCustomer,
      _ServiceOrderCube.SalesOrganizationOrgUnitID,
      _ServiceOrderCube.SalesOfficeOrgUnitID,
      _ServiceOrderCube.SalesGroupOrgUnitID,
      _ServiceOrderCube.ServiceOrganization,
      _ServiceOrderCube.SalesOrganization,
      _ServiceOrderCube.DistributionChannel,
      _ServiceOrderCube.Division,
      _ServiceOrderCube.SalesOffice,
      _ServiceOrderCube.SalesGroup,
      _ServiceOrderCube.NmbrOfIncompleteServiceOrders,
      _ServiceOrderCube.NumberOfOverdueServiceOrders,
      _ServiceOrderCube.SrvcOrdHasConfdItem,
      _ServiceOrderCube.ServiceDocumentIsOpen,
      _ServiceOrderCube.ServiceReferenceObjectType,
      _ServiceOrderCube.SrvcRefObjIsMainObject,
      _ServiceOrderRef.ProductID,
      _ServiceOrderRef.SerialNumber,
      _ServiceOrderCube.Equipment,
      //    FunctionalLocation,
      _ServiceOrderCube.RespyMgmtServiceTeam,
      _ServiceOrderCube.RespyMgmtServiceTeamDesc,
      _ServiceOrderCube.TeamName,
      _ServiceOrderCube.YY1_OldSerialNumber_SRH,
      _ServiceOrderCube.YY1_IssueCategory_SRH,
      _ServiceOrderCube.YY1_IssueCategoryUrl_SRH,
      _ServiceOrderCube.YY1_AcceptReject_SRH,
      _ServiceOrderCube.YY1_Address2_SRH,
      _ServiceOrderCube.YY1_BillingDatefor3rd_SRH,
      _ServiceOrderCube.YY1_BillingDocfor3rd_SRH,
      
      _ServiceOrderCube.YY1_BusinessHour_SRH,
      _ServiceOrderCube.YY1_BusinessName1_SRH,
      _ServiceOrderCube.YY1_ChangeReason_SRH,
      _ServiceOrderCube.YY1_City_SRH,
      _ServiceOrderCube.YY1_ContactName1_SRH,
      _ServiceOrderCube.YY1_ContactPhone1_SRH,
      _ServiceOrderCube.YY1_Email_SRH,
      _ServiceOrderCube.YY1_InorOutofWarranty_SRH,
      _ServiceOrderCube.YY1_MissingSNReason_SRH,
      _ServiceOrderCube.YY1_RealSerialNumber_SRH,
      _ServiceOrderCube.YY1_State_SRH,
      _ServiceOrderCube.YY1_Street_SRH,
      _ServiceOrderCube.YY1_Zip_SRH,
      _ServiceOrderCube.YY1_WhichManText_SRH,
      _ServiceOrderCube.YY1_AddressType_SRH,
    
      // 
      _ServiceOrderCube.YY1_BrandName1_SRH,
      _ServiceOrderCube.YY1_NonAtosaMatModel_SRH,
      _ServiceOrderCube.YY1_ServiceParts_SRH,
//      _ServiceOrderCube.YY1_RealSerialNumber_SRH,
      ZR_SCS010.ProductModel,
      //    substring( _ServiceOrderRef.ProductID , 1 , 3 ) as  ZZProduct_C3,
      //    substring( _ServiceOrderRef.ProductID , 1 , 4 ) as  ZZProduct_C4,
      //    substring( _ServiceOrderRef.ProductID , 1 , 5 ) as  ZZProduct_C5,
      //    substring( _ServiceOrderRef.ProductID , 1 , 7 ) as  ZZProduct_C7,
      





      ZR_TCS012.ZBusinessName,
      ZR_TCS012.ZContactName,
      ZR_TCS012.ZContactPhone,
      ZR_TCS012.ZCity,
      ZR_TCS012.ZState,
      ZR_TCS012.ZZip,
      ZR_TCS012.ZStreet,
      ZR_TCS012.ZAddress2,
      ZR_TCS012.ZEmail,
      ZR_TCS012.ZBusinessHour,

      ZR_TMM001.Zoldserialnumber,
      ZR_TCS012.ZAddressType,


      /* Associations */
      _ServiceOrderCube._ContactPerson,
      _ServiceOrderCube._DistributionChannel,
      _ServiceOrderCube._Division,
      _ServiceOrderCube._Period,
      _ServiceOrderCube._RespEmployee,
      _ServiceOrderCube._SalesGroup,
      //    _SalesGroupOrgUnit,
      _ServiceOrderCube._SalesGroupOrgUnit_2,
      _ServiceOrderCube._SalesOffice,
      //    _SalesOfficeOrgUnit,
      _ServiceOrderCube._SalesOfficeOrgUnit_2,
      _ServiceOrderCube._SalesOrganization,
      //    _SalesOrganizationOrgUnit,
      _ServiceOrderCube._SalesOrganizationOrgUnit_2,
      _ServiceOrderCube._ServiceDocHasError,
      _ServiceOrderCube._ServiceDocRefObj,
      _ServiceOrderCube._ServiceDocumentIsOpen,
      _ServiceOrderCube._ServiceDocumentPriority,
      //    _ServiceDocumentStatus,
      _ServiceOrderCube._ServiceDocumentType,
      _ServiceOrderCube._ServiceObjType,
      _ServiceOrderCube._ServiceTeamHeader,
      _ServiceOrderCube._SoldToParty,
      _ServiceOrderCube._SrvcDocLifecycleStatus,
      _ServiceOrderCube._SrvcOrdConfStatus,
      _ServiceOrderCube._TransactionCurrency,
      _ServiceOrderCube._YY1_InorOutofWarranty_SRH,
      _ServiceOrderCube._YY1_AcceptReject_SRH,
      _ServiceOrderCube._YY1_ChangeReason_SRH,
      _ServiceOrderCube._YY1_MissingSNReason_SRH
}

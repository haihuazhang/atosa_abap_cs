@EndUserText.label: 'Parameter of Update Service Order'
define abstract entity ZR_SCS001
{
  ServiceOrder              : zzecs020;
  YY1_InorOutofWarranty_SRH : abap.char( 10 );
  YY1_ChangeReason_SRH      : abap.char( 10 );
  YY1_MissingSNReason_SRH   : abap.char( 10 );
  YY1_AcceptReject_SRH      : abap.sstring( 6 );
  YY1_BusinessName1_SRH     : abap.sstring( 80 );
  YY1_ContactName1_SRH      : abap.sstring( 60 );
  YY1_ContactPhone1_SRH     : abap.sstring( 30 );
  YY1_City_SRH              : abap.sstring( 35 );
  YY1_State_SRH             : abap.sstring( 30 );
  YY1_Street_SRH            : abap.sstring( 35 );
  YY1_Zip_SRH               : abap.sstring( 30 );
  YY1_Address2_SRH          : abap.sstring( 80 );
  YY1_Email_SRH             : abap.sstring( 30 );
  YY1_BusinessHour_SRH      : abap.sstring( 20 );
  YY1_OldSerialNumber_SRH   : abap.sstring( 40 );
  YY1_AddressType_SRH       : abap.sstring(10);
  YY1_WhichManText_SRH      : abap.sstring(100);
  YY1_IssueCategory_SRH     : abap.sstring(40);
  YY1_BrandName1_SRH        : abap.sstring(10);
  YY1_NonAtosaMatModel_SRH  : abap.sstring(20);
  YY1_RealSerialNumber_SRH  : abap.sstring(40);

  //    OutboundDeliveryItem : abap.numc( 6 );
}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity YI_SWAS_TRAVEL_BEHAV_D
  as select from yswas_travel_d
  {
  key traveluuid           as TravelUuid,
      travelid             as TravelId,
      agencyid             as AgencyId,
      customerid           as CustomerId,
      begindate            as BeginDate,
      enddate              as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      bookingfee           as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      totalprice           as TotalPrice,
      currencycode         as CurrencyCode,
      description           as Description,
      overallstatus        as OverallStatus,
      createdby            as CreatedBy,
      createdat            as CreatedAt,
      lastchangedby       as LastChangedBy,
      lastchangedat       as LastChangedAt,
      locallastchangedat as LocalLastChangedAt,
      draftentitycreationdatetime as Draftentitycreationdatetime,
      draftentitylastchangedatetime as Draftentitylastchangedatetime,
      draftadministrativedatauuid as Draftadministrativedatauuid,
      draftentityoperationcode as Draftentityoperationcode,
      hasactiveentity as Hasactiveentity,
      draftfieldchanges as Draftfieldchanges
}
//where travel_id = '00000050'

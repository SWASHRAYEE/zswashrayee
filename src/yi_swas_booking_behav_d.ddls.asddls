@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Interface View with association'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YI_SWAS_BOOKING_BEHAV_D 
  as select from yswas_booking_d
  
{
  key bookinguuid          as BookingUuid,
      traveluuid           as TravelUuid,
      bookingid            as BookingId,
      bookingdate         as BookingDate,
      customerid           as CustomerId,
      carrierid            as CarrierId,
      connectionid         as ConnectionId,
      flightdate           as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flightprice         as FlightPrice,
      currencycode         as CurrencyCode,
      createdby            as CreatedBy,
      lastchangedby       as LastChangedBy,
      locallastchangedat as LocalLastChangedAt,
    draftentitycreationdatetime as Draftentitycreationdatetime,
    draftentitylastchangedatetime as Draftentitylastchangedatetime,
    draftadministrativedatauuid as Draftadministrativedatauuid,
    draftentityoperationcode as Draftentityoperationcode,
    hasactiveentity as Hasactiveentity,
    draftfieldchanges as Draftfieldchanges
}



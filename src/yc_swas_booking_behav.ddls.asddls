@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking consumption/projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YC_SWAS_BOOKING_behav
// as select from yi_swas_booking
   as projection on YI_SWAS_BOOKING_behav
 // association [1..1] to yc_swas_travel as _Travel 
 // on $projection.TravelUuid = _Travel.TravelUuid
{
  key YI_SWAS_BOOKING_behav.BookingUuid,
      YI_SWAS_BOOKING_behav.TravelUuid,
      YI_SWAS_BOOKING_behav.BookingId,
      YI_SWAS_BOOKING_behav.BookingDate,
      YI_SWAS_BOOKING_behav.CustomerId,
      YI_SWAS_BOOKING_behav.CarrierId,
      YI_SWAS_BOOKING_behav.ConnectionId,
      YI_SWAS_BOOKING_behav.FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      YI_SWAS_BOOKING_behav.FlightPrice,
      YI_SWAS_BOOKING_behav.CurrencyCode,
      YI_SWAS_BOOKING_behav.CreatedBy,
      YI_SWAS_BOOKING_behav.LastChangedBy,
      YI_SWAS_BOOKING_behav.LocalLastChangedAt,
      /* Associations */
      _Travel : redirected to parent YC_SWAS_TRAVEL_behav  // projection view
}


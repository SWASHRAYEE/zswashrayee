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
      yi_swas_booking_behav.TravelUuid,
      yi_swas_booking_behav.BookingId,
      yi_swas_booking_behav.BookingDate,
      yi_swas_booking_behav.CustomerId,
      yi_swas_booking_behav.CarrierId,
      yi_swas_booking_behav.ConnectionId,
      yi_swas_booking_behav.FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      yi_swas_booking_behav.FlightPrice,
      yi_swas_booking_behav.CurrencyCode,
      yi_swas_booking_behav.CreatedBy,
      yi_swas_booking_behav.LastChangedBy,
      yi_swas_booking_behav.LocalLastChangedAt,
      /* Associations */
      _Travel : redirected to parent yc_swas_travel_behav  // projection view
}


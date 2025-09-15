@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking consumption/projection view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity yc_swas_booking as select from yi_swas_booking
  association [1..1] to yc_swas_travel as _Travel 
  on $projection.TravelUuid = _Travel.TravelUuid
{
  key yi_swas_booking.BookingUuid,
      yi_swas_booking.TravelUuid,
      yi_swas_booking.BookingId,
      yi_swas_booking.BookingDate,
      yi_swas_booking.CustomerId,
      yi_swas_booking.CarrierId,
      yi_swas_booking.ConnectionId,
      yi_swas_booking.FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      yi_swas_booking.FlightPrice,
      yi_swas_booking.CurrencyCode,
      yi_swas_booking.CreatedBy,
      yi_swas_booking.LastChangedBy,
      yi_swas_booking.LocalLastChangedAt,
      /* Associations */
      _Travel
}


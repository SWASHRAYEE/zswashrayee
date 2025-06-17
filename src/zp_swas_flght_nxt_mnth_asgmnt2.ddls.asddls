@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Upcoming flights in next couple of months'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZP_SWAS_FLGHT_NXT_MNTH_ASGMNT2 as 
   select distinct from yi_swas_travel as travel
   inner join yi_swas_booking as booking on booking.TravelUuid = travel.TravelUuid
              and booking.FlightDate between $session.system_date and
                  dats_add_months( $session.system_date , 7 , 'FAIL')
{key booking.BookingUuid,
 key travel.TravelUuid,
 // booking.TravelUuid, // not unique, present in BOOKING table also gives error
 booking.BookingId,
 booking.BookingDate,
 booking.CustomerId,
 booking.CarrierId,
 booking.ConnectionId,
 booking.FlightDate,
 //booking.FlightPrice,
 booking.CurrencyCode,
 booking.CreatedBy,
 booking.LastChangedBy,
 booking.LocalLastChangedAt,
 travel.TravelId,
 travel.AgencyId,
// travel.CustomerId,
 travel.BeginDate,
 travel.EndDate,
 @Semantics.amount.currencyCode: 'CurrencyCode' 
travel.BookingFee as BookingFee,
// travel.TotalPrice,
// travel.CurrencyCode,
 travel.Description,
 travel.OverallStatus,
 travel.CreatedBy as trvel_crt_by,
 travel.CreatedAt,
 travel.LastChangedBy as trvel_chng_by,
 travel.LastChangedAt,
 travel.LocalLastChangedAt as trvel_lst_chng_by,// to make unique element
 /* Associations */
 travel._booking
    
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight detail with many bookings'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZP_SWAS_FLGHT_MNY_BOOK_ASNMNT3 
      as select distinct from yi_swas_travel as trvl
      inner join yi_swas_booking as book
      on trvl.TravelUuid = book.TravelUuid
//      and book.BookingId > '0003'

{
    
    trvl.TravelUuid,
    count( distinct book.BookingId ) as book_count,
    trvl.TravelId,
    trvl.AgencyId,
    trvl.CustomerId,
    trvl.BeginDate,
    trvl.EndDate,
//@Semantics.amount.currencyCode: 'CurrencyCode'     
//    trvl.BookingFee,
//@Semantics.amount.currencyCode: 'CurrencyCode'     
//    trvl.TotalPrice,
//    trvl.CurrencyCode,

    trvl._booking
}  group by trvl.TravelUuid,
           trvl.TravelId,
           trvl.AgencyId,
           trvl.CustomerId,
           trvl.BeginDate,
           trvl.EndDate
           

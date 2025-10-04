@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity yi_swas_travel 
  as select from yswas_travel
  association[1..*] to yi_swas_booking as _booking on $projection.TravelUuid = _booking.TravelUuid
  association [0..1] to /DMO/I_Agency  as _Agency  on $projection.AgencyId = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer  as _Customer on $projection.CustomerId = _Customer.CustomerID
  
{   key travel_uuid as TravelUuid,
    travel_id as TravelId,
    agency_id as AgencyId,
    customer_id as CustomerId,
    begin_date as BeginDate,
    end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price as TotalPrice,
    currency_code as CurrencyCode,
    description as Description,
    overall_status as OverallStatus,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt,
    _booking , // exposed association
    _Agency , // exposed association
    _Customer // exposed association
  // _booking.BookingId // Adhoc Associationpath expression & it will change the cardinality stated above
 //   _booking[*:inner].BookingId // convert the association into inner join 
                                // & it will change the cardinality stated above
    
}

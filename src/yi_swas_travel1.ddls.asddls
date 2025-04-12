@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '${ddl_source_description}'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YI_SWAS_Travel1 as select from zswas_travel
{
    key travel_uuid as TravelUuid,
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
    last_changed_at as LastChangedAt
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel consumption/ Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity YC_SWAS_TRAVEL_behav 
   provider contract transactional_query
//as select from yi_swas_travel
  //  association [1..*] to yc_swas_booking as _Booking 
    //on $projection.TravelUuid = _Booking.TravelUuid
    //as projection on YI_SWAS_TRAVEL_behav
    as projection on YI_swas_Travel_behav
{
  key TravelUuid,
      TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _Agency.Name as AgencyName,
        @ObjectModel.text.element: [ 'CustomerName' ]
        @Consumption.valueHelpDefinition: [{ entity:{name: '/DMO/i_customer' , element: 'CustomerID' },
                                             useForValidation: true }]  
      CustomerId,
      _Customer.FirstName as CustomerName,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Booking : redirected to composition child YC_SWAS_BOOKING_behav
}


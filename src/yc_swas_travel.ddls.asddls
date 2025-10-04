@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel consumption/ Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity yc_swas_travel as select from yi_swas_travel
    association [1..*] to yc_swas_booking as _Booking 
    on $projection.TravelUuid = _Booking.TravelUuid
{
  key TravelUuid,
@UI: { lineItem: [{ position: 10 }] ,
                 selectionField: [{ position: 10 }]} // for FIORI exposure annotation  
      TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Consumption.valueHelpDefinition: 
                 [{ entity: {name: '/DMO/I_Agency',
                   element: 'AgencyID'} }] // to concatenate agency ID +Agency name
      AgencyId,
      _Agency.Name as AgencyName,
        @ObjectModel.text.element: [ 'CustomerName' ]
      @Consumption.valueHelpDefinition: 
                 [{ entity: {name: '/DMO/I_Customer',
                   element: 'CustomerID'} }] // to concatenate customer ID + Customer name
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
      _Booking
}


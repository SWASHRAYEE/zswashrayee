@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testing system variable , string function & association'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity yi_swas_connction_view 
   as select from /DMO/I_Connection_R
{  AirlineID,
   ConnectionID,
 // _Flight.OccupiedSeats,
  // _Airline._Currency._Text.CurrencyName
  // _Airline._Currency._Text[ Language = 'E' ].CurrencyName
  _Airline._Currency._Text[ Language = $session.system_language ].CurrencyName as currencynam2, // filter association
  _Flight._Airline._Currency._Text[ Language = $session.system_language ].CurrencyShortName as currencynam1,// filter association
  cast( 'Swashrayee' as char20 ) as firstname,
  lpad( $projection.firstname,15 ,'Mrs ' ) as fullname,
  concat_with_space( $projection.fullname , 'Banerjee' , 1 ) as fullname1,
  length( $projection.firstname ) as len,
  right( $projection.firstname, 4 ) as right1,
  case $projection.currencynam1
    when 'Euro' then 'Approved'
    else 'Rejected'
    end as currencystatus
  
  }  

  

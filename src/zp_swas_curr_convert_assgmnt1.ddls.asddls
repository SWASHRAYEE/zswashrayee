@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Amount conversion of total price - Assignment 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zp_swas_curr_convert_assgmnt1 
 with parameters
//  p_SourceAmnt     : abap.curr( 13, 2 ),
//  p_SourceCurr     : abap.cuky( 5 ),
  p_TargetCurr     : abap.cuky( 5 )
as select from yi_swas_travel as Travel
{ 
     AgencyId,
     case OverallStatus
       when 'A' then 'Accepted'
       when 'O' then 'Open'
       else 'Can not be determined'
       end as description_status,
     OverallStatus,
   @Semantics.amount.currencyCode: 'CurrencyCode'   
//      AgencyId, WRONG position of element
      TotalPrice,    
     CurrencyCode,
     @Semantics.amount.currencyCode: 'TargetCurrency'
 //  currency_conversion(amount => $parameters.p_SourceAmnt,                 // Input price
     currency_conversion(amount => $projection.totalprice,                 // Input price
//                          source_currency => $parameters.p_SourceCurr ,     // country code
                          source_currency => $projection.currencycode ,     // country currency code
                          target_currency => $parameters.p_TargetCurr ,   // target currency
                          exchange_rate_date => $session.system_date,
                          error_handling => 'SET_TO_NULL' 
 //                         client => $session.client   // optional
                           ) as ConvertedPrice,
       $parameters.p_TargetCurr as TargetCurrency                
    
}

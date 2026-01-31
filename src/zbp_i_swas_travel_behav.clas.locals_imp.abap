*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lhc_YI_swas_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR YI_swas_travel_behav RESULT result.

    METHODS determineTravelID FOR DETERMINE ON SAVE
      IMPORTING keys FOR travel~determineTravelID.

    METHODS checkCustomerID FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~checkCustomerID.
ENDCLASS.

CLASS lhc_YI_swas_travel IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD determinetravelid .
    DATA : Travel_update    TYPE TABLE FOR UPDATE YI_swas_Travel_behav\\Travel,
           ls_travel_update LIKE LINE OF travel_update.

*1.  read all the travel instances
    READ ENTITIES OF YI_swas_Travel_behav IN LOCAL MODE " bypassing auth check via this LOCAL MODE
    ENTITY travel
    FIELDS ( travelID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(Travel_Read_Result).
* 2. Check if travel ID is filled or not
    DELETE Travel_Read_Result WHERE TravelId IS NOT INITIAL.
    IF Travel_Read_Result IS INITIAL.
      RETURN.
    ENDIF..
* 3. Generate new travel ID-Max of travel ID  + 1
    SELECT FROM YI_swas_Travel_behav
    FIELDS MAX( TravelID )
    INTO @DATA(Max_Travel_ID).
* 4. Update travel instance derived from step 3
    LOOP AT travel_read_result ASSIGNING FIELD-SYMBOL(<fs_read_result>).
      ls_travel_update-%tky = <fs_read_result>-%tky." transactional key
      ls_travel_update-%data-TravelId = max_travel_id + 1.
      ls_travel_update-%control-travelid = if_abap_behv=>mk-on.
      APPEND ls_travel_update TO travel_update.
    ENDLOOP.

    MODIFY ENTITIES OF YI_swas_Travel_behav IN LOCAL MODE
      ENTITY travel
      UPDATE
      FROM  travel_update
      FAILED FINAL(lt_fail_update)
      REPORTED FINAL(lt_report_update).

    IF  lt_report_update IS NOT INITIAL.
      reported  = CORRESPONDING  #( DEEP  lt_report_update  ).
    ENDIF.



  ENDMETHOD.
  METHOD checkCustomerID.
* 1. Read customer ID from instance
* 2. Validate customer ID by checking against /DMO/I_Customer
*3. If not vAlid , make instance failed and report error

  ENDMETHOD..













































ENDCLASS.

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
  TYPES : BEGIN OF ty_customer_id,
            cust_id TYPE YI_swas_Travel_behav-CustomerId,
          END OF TY_CUSTOMER_ID.

   TYPES : tt_ty_cust_id TYPE SORTED TABLE OF  TY_CUSTOMER_ID WITH UNIQUE KEY cust_id.
   DATA: lt_cust_id TYPE tt_ty_cust_id.
   CONSTANTS state_area TYPE string VALUE 'CHECK_STATUS'.
* 1. Read customer ID from instance
   READ ENTITIES OF YI_swas_Travel_behav IN LOCAL MODE " bypassing auth check via this LOCAL MODE
    ENTITY travel
    FIELDS ( CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(Travel_Read_val).

    lt_cust_id = CORRESPONDING #( travel_read_val discarding duplicates mapping cust_id = CustomerId except * ).
    DELETE lt_cust_id WHERE cust_id is INITIAL.
    if lt_cust_id is INITIAL.
      RETURN.
    ENDIF.
* 2. Check if travel ID is filled or not
      SELECT FROM /DMO/I_Customer
      FIELDS CustomerID
      FOR ALL ENTRIES IN @lt_cust_id
      WHERE CustomerID = @lt_cust_id-cust_id
      into TABLE @DATA(lt_cust_id_valid).

      LOOP AT travel_read_val ASSIGNING FIELD-SYMBOL(<lfs_travel>).
*        2.1 Invalidate state areas
*        2.2 Check Customer ID
            if  <lfs_travel>-CustomerId is INITIAL
              or NOT line_exists( lt_cust_id_valid[ CustomerID = <lfs_travel>-CustomerId ] ).
*        2.3 Make instance failed
                APPEND VALUE #( %tky = <lfs_travel>-%tky ) TO failed-travel.
*        2.4 Report an error message
                 APPEND VALUE #( %tky   = <lfs_travel>-%tky
                                 %state_area = state_area
                                 %msg = me->new_message( id = 'YI_SWAS_MSG_CLS'
                                                         number = '100'
                                                         severity = if_abap_behv_message=>severity-error
                                                         v1 = <lfs_travel>-CustomerID )
                                 %element-customerid = if_abap_behv=>mk-on    )
                  TO  reported-travel.
            ENDIF.

       ENDLOOP.

* 2. Validate customer ID by checking against /DMO/I_Customer
*3. If not vAlid , make instance failed and report error

  ENDMETHOD..













































ENDCLASS.

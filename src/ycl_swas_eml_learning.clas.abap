CLASS ycl_swas_eml_learning DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS ycl_swas_eml_learning IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "  *********************************************************************
    " EML practice which is used to invoke behavior definition from driver program
    "   *********************************************************************

    DATA : ls_travel_input     TYPE TABLE FOR READ IMPORT YI_swas_Travel_behav,
           lt_travel_result    TYPE TABLE FOR READ RESULT YI_swas_Travel_behav,
           Travel_Read_Import  TYPE TABLE FOR READ IMPORT YI_swas_Travel_behav,
           Booking_Read_Import TYPE TABLE FOR READ IMPORT YI_SWAS_BOOKING_behav.

    DATA : travel_create_import TYPE TABLE FOR CREATE YI_swas_Travel_behav\\travel. " Press F2 will give u element list

        travel_create_import = VALUE #( %cid = 'swashrayee_1' " forming internal structure ie derived structure
                                        %is_draft = if_abap_behv=>mk-on  " indicator of draft enabling
                                     (  %data = VALUE #(
                                          TravelId = '6945'
                                          AgencyId = '1214'
                                          CustomerId = '34566'
                                          Description = TEXT-001 ) ) ).
* Create entity based on internal derived structure
        MODIFY ENTITIES OF YI_swas_Travel_behav
        ENTITY travel
        CREATE FIELDS  ( TravelId AgencyId CustomerId Description )
        WITH travel_create_import.


* Fetch key UUID from TRAVEL entity
    SELECT FROM YC_SWAS_TRAVEL_behav
      FIELDS  DISTINCT TravelId ,TravelUuid , BeginDate , TotalPrice
     WHERE TravelId IN ( '00000025' , '00000034' )
*       WHERE TravelUuid = 'FF65BB3252506C9519007CEE18EE2C04'
      INTO TABLE @DATA(lt_key_truuid).

    IF lt_key_truuid IS INITIAL.
      RETURN.
    ELSE.
      Travel_Read_Import = CORRESPONDING #( lt_key_truuid ).
      out->write( 'below is TRAVEL entity records : -' ).
      out->write( lt_key_truuid ).
    ENDIF.

* Fetch key UUID from BOOKING entity
    SELECT FROM YC_SWAS_booking_behav
      FIELDS DISTINCT traveluuid , BookingId , BookingUuid
      WHERE BookingId IN ( '0002' , '0001' )
      INTO TABLE @DATA(lt_key_truuid_bk).
    IF sy-subrc IS INITIAL.
      out->write( 'below is BOOKING entity records  : -' ).
      out->write( lt_key_truuid_bk )  .
    ENDIF.

*  "Test 1 - Read  fields of Travel Entity, we are nt passing control MARKED entry
* Assignment 1 (read travel entries only)
    READ ENTITIES OF YI_swas_Travel_behav
    ENTITY Travel
    FIELDS ( TravelId  AgencyId CustomerId ) "to show all flds use ALL FIELDS
     WITH  Travel_Read_Import  "VALUE #( ( TravelUuid = '0075BB3252506C9519007CEE18EE2C04' ) )
    RESULT lt_travel_result.

    IF  sy-subrc = 0.
      out->write( 'below is TRAVEL entity records after READ: -' ).
      out->write( lt_key_truuid_bk )  .
    ENDIF.
*
*
* Assignment 2 (read booking entries only)
*   Read fields of Booking entity with association-
    READ ENTITIES OF YI_swas_Travel_behav
    ENTITY Travel BY \_Booking
    FIELDS ( BookingId CarrierId ) "to show all flds use ALL FIELDS
     WITH CORRESPONDING #( travel_read_import )  "VALUE #( ( TravelUuid = '0075BB3252506C9519007CEE18EE2C04' ) )
    RESULT DATA(lt_booking_result).
    IF  sy-subrc = 0.
      out->write( 'below is BOOKING entity records after READ: -' ).
      out->write( lt_key_truuid_bk )  .
    ENDIF.
*
** Assignment 3 (read travel and booking both entries together only )
    READ ENTITIES OF YI_swas_Travel_behav
     ENTITY travel
     ALL FIELDS WITH travel_read_import
     RESULT DATA(lt_travel_result_combine)

     ENTITY Travel BY \_Booking
     ALL FIELDS WITH CORRESPONDING #( travel_read_import )
     RESULT DATA(lt_booking_result_combine)
      FAILED DATA(lt_travel_book_fail)   " FAILED table is just like BAPI_RETURN
    REPORTED DATA(lt_travel_book_report).
    IF  sy-subrc = 0.
      out->write( 'below is both TRAVEL & BOOKING entity records after READ: -' ).
      out->write( lt_travel_result_combine ).
      out->write( lt_booking_result_combine ). " will be empty as no matched entry between
    ENDIF.


** Modifying entity Update fields of Travel Entity
    LOOP AT lt_key_truuid INTO DATA(ls_key_traveluuid).
      READ TABLE lt_key_truuid_bk INTO DATA(ls_key_traveluuid_bk)
                                  WITH KEY TravelUuid = ls_key_traveluuid-TravelUuid.
      IF sy-subrc IS INITIAL.
*        DATA(lv_updated_flight_price) =
*             ls_key_traveluuid-TotalPrice + ls_key_traveluuid-TotalPrice * 1." updated price
        DATA(lv_updated_end_date) = syst-datum + 10.  " 10 days after current date
************************************************************************************************************
** Update the fields with new values :- did nt work as there is no matched records between BOOKING & TRAVEL
************************************************************************************************************
*        MODIFY ENTITIES OF YI_swas_Travel_behav
*          ENTITY travel
*          UPDATE FIELDS ( Description
*          BeginDate EndDate TotalPrice )
*          WITH VALUE #( ( TravelUuid = ls_key_traveluuid-TravelUuid " FB3940B148F078A61900384E39E14232
**               WITH VALUE #( ( TravelUuid = lt_key_truuid[  1 ]-TravelUuid
*                          Description = 'Swashrayee experiment'  " change description
*                          BeginDate = syst-datum" begin date is changed as current date
*                          EndDate = lv_updated_end_date" end date is changed as curr_date + 10 days
*                          TotalPrice = lv_updated_flight_price ) )"Increase price by 10 %
*          REPORTED DATA(lt_travel_mod_rep)
*          FAILED DATA(lt_travel_mod_fail).
*
      ENDIF.
    ENDLOOP.

*    out->write( 'Display after COMMIT with updated description' ).
*    out->write( lt_travel_mod ). " Display after COMMIT
*    out->write( lt_travel_mod_rep ).
*
***Class work reading BOOKING entity fields directly without association
    READ ENTITIES OF YI_swas_Travel_behav
    ENTITY booking
    ALL FIELDS WITH VALUE #( (  BookingUuid = '0D4A40B148F078A61900384E39E14232 ' ) ) " key element is mandatory
    RESULT FINAL(lt_booking) " this internal table will not be overwritten after using FINAL
    FAILED FINAL(lt_booking_fail). "." Press F2 on the internal table to get the detail deep structure
    IF  sy-subrc = 0.
      out->write( 'below is both BOOKING entity records after READ without ASSOCIATION: -' ).
      out->write( lt_booking ).
    ENDIF.
*************************************************************************************************
***** CREATE new travel entity record - *********************************************************
*************************************************************************************************
    MODIFY ENTITIES OF YI_swas_Travel_behav
    ENTITY travel
    CREATE FIELDS ( TravelId AgencyId CustomerId Description )
    WITH VALUE #(  (  %cid = 'swashrayee_1'  "CID - component ID
                      %data = VALUE #(
                                  TravelId = '6945'
                                  AgencyId = '1214'
                                  CustomerId = '34566'
                                  Description = TEXT-001 ) ) ) "CNTRL+1 will help u to create/edit new text elements
          CREATE BY  \_booking
          FIELDS ( BookingId CustomerId CarrierId ConnectionId )
          WITH VALUE #( (  %cid_ref =  'swashrayee_1'
                        %target = VALUE #( ( %cid = 'swashrayee_booking_1'
                        %data = VALUE #( BookingId = '121'
                                          CustomerId = '004'
                                          CarrierId = '006'
                                          ConnectionId = '009' )  )  ) ) )
                                    MAPPED FINAL(lt_travel_new_cr)
                                    FAILED FINAL(lt_travel_create_fail).

              if sy-subrc is INITIAL AND lt_travel_new_cr is NOT INITIAL.
*                    COMMIT ENTITIES.
                    out->write( 'Newly created records in TRAVEL entiies :-' ).
                    out->write( lt_travel_new_cr ).
              ENDIF.
*************************************************************************************
****DELETE TRAVAL entity ----------
*************************************************************************************
     MODIFY ENTITIES OF YI_swas_Travel_behav
     ENTITY travel
      DELETE FROM VALUE #( (  TravelUuid = 'EE18078AFF881FE0B7AF55C0C0985AE9' )    )
       FAILED FINAL(lt_travel_del)   .

* Checking RETURN or FAILED table , based on which commit will be done
    IF lt_travel_del IS  NOT INITIAL .
*      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.
** After deleion and COMMIT read the entities to display-
    READ ENTITIES OF YI_swas_Travel_behav
      ENTITY travel
       FIELDS ( TravelId TravelUuid AgencyId Description )
       WITH VALUE #( ( TravelUuid = 'EE18078AFF881FE0B7AF55C0C0985AE9' )  )
      RESULT DATA(lt_travel_mod)
      FAILED DATA(lt_travel_del_fail).

      if lt_travel_del_fail is NOT INITIAL.
         out->write( 'Below entry is already deleted' ).
         out->write( lt_travel_del_fail ).
      ENDIF..
**********************************************************************
****************Update Entities***************************
**********************************************************************
     MODIFY ENTITIES OF YI_swas_Travel_behav
        ENTITY travel
        UPDATE FIELDS ( Description BeginDate )
        WITH VALUE #( ( TravelUuid = 'FB3940B148F078A61900384E39E14232'
                        BeginDate = syst-datum
                        Description = 'Demo Swashrayee' ) )
        REPORTED DATA(lt_travel_updt)
        FAILED DATA(lt_travel_updt_fail).

        if  lt_travel_updt is NOT INITIAL AND lt_travel_updt_fail is INITIAL.
           COMMIT ENTITIES.
        ENDIF..

        READ ENTITIES OF YI_swas_Travel_behav
           ENTITY travel
           ALL FIELDS WITH VALUE #( ( TravelUuid = 'FB3940B148F078A61900384E39E14232' ) )
           RESULT DATA(lt_travel_updt_com).
           if  sy-subrc is INITIAL.
            out->write( 'After COMMIT description has been changed below' ).
            out->write( lt_travel_updt_com ).
           ENDIF.


*
*    "Test 2 - Read Travel Entity using From variant
*    " ls_travel_input = VALUE #( ( %is_draft = if_abap_behv=>mk-on " similar to BAPI X structure
*    "                          TravelUuid = '0075BB3252506C9519007CEE18EE2C04'
*    "                         %control = VALUE #( TravelId = if_abap_behv=>mk-on " similar to BAPI X structure
*    "                                           AgencyId = if_abap_behv=>mk-on
*    "                                          TotalPrice = if_abap_behv=>mk-on
*    "                                         CustomerId = if_abap_behv=>mk-on ) ) ) .
*
*    "READ ENTITIES OF YI_swas_Travel_behav
*    "   ENTITY travel
*    "   FROM ls_travel_input
*    "  RESULT lt_travel_result.

  ENDMETHOD .
ENDCLASS .

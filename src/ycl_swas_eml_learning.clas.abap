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

* Fetch key UUID from TRAVEL entity
    SELECT FROM YC_SWAS_TRAVEL_behav
      FIELDS traveluuid , TotalPrice
      WHERE TravelId IN ( '00000025' , '00000034' )
      INTO TABLE @DATA(lt_key_truuid).

    IF lt_key_truuid IS INITIAL.
      RETURN.
    ELSE.
      Travel_Read_Import = CORRESPONDING #( lt_key_truuid ).
    ENDIF.

* Fetch key UUID from BOOKING entity
    SELECT FROM YC_SWAS_booking_behav
      FIELDS traveluuid
      WHERE BookingId IN ( '00000002' , '00000001' )
      INTO TABLE @DATA(lt_key_truuid_bk).

*  "Test 1 - Read  fields of Travel Entity, we are nt passing control MARKED entry
* Assignment 1 (read travel entries only)
    READ ENTITIES OF YI_swas_Travel_behav
    ENTITY Travel
    FIELDS ( TravelId  AgencyId CustomerId ) "to show all flds use ALL FIELDS
     WITH  Travel_Read_Import  "VALUE #( ( TravelUuid = '0075BB3252506C9519007CEE18EE2C04' ) )
    RESULT lt_travel_result.


* Assignment 2 (read booking entries only)
* Read fields of Booking entity-
    READ ENTITIES OF YI_swas_Travel_behav
    ENTITY Travel BY \_Booking
    FIELDS ( BookingId CarrierId ) "to show all flds use ALL FIELDS
     WITH CORRESPONDING #( travel_read_import )  "VALUE #( ( TravelUuid = '0075BB3252506C9519007CEE18EE2C04' ) )
    RESULT DATA(lt_booking_result).

* Assignment 3 (read travel and booking both entries together only )
    READ ENTITIES OF YI_swas_Travel_behav
     ENTITY travel
     ALL FIELDS WITH travel_read_import
     RESULT DATA(lt_travel_result_combine)

     ENTITY Travel BY \_Booking
     ALL FIELDS WITH CORRESPONDING #( travel_read_import )
     RESULT DATA(lt_booking_result_combine)
      FAILED DATA(lt_travel_book_fail)   " FAILED table is just like BAPI_RETURN
    REPORTED DATA(lt_travel_book_report).

* Modifying entity Update fields of Travel Entity
LOOP AT lt_key_truuid INTO DATA(ls_key_traveluuid).
    READ TABLE lt_key_truuid_bk INTO DATA(ls_key_traveluuid_bk)
                                WITH KEY TravelUuid = ls_key_traveluuid-TravelUuid.
      IF sy-subrc is INITIAL.
         DATA(lv_updated_flight_price) =
              ls_key_traveluuid-TotalPrice + ls_key_traveluuid-TotalPrice * 1." updated price
          DATA(lv_updated_end_date) = syst-datum + 10.  " 10 days after current date

* Update the fields with new values :-
            MODIFY ENTITIES OF YI_swas_Travel_behav
              ENTITY travel
              UPDATE FIELDS ( Description
              BeginDate EndDate TotalPrice )
              WITH VALUE #( ( TravelUuid = ls_key_traveluuid-TravelUuid " FB3940B148F078A61900384E39E14232
*               WITH VALUE #( ( TravelUuid = lt_key_truuid[  1 ]-TravelUuid
                              Description = 'Swashrayee experiment'  " change description
                              BeginDate = syst-datum" begin date is changed as current date
                              EndDate = lv_updated_end_date" end date is changed as curr_date + 10 days
                              TotalPrice = lv_updated_flight_price ) )"Increase price by 10 %
              REPORTED DATA(lt_travel_mod_rep)
              FAILED DATA(lt_travel_mod_fail).
      ENDIF.
ENDLOOP.

*Modify booking entities where BOOKINID = 1 or 2
*    MODIFY ENTITIES OF YI_Mainak_Booking
*       ENTITY travel by \_booking
*       update fields (  )

* After modification when COMMIT yet nt done, read the entities to display-
    READ ENTITIES OF YI_swas_Travel_behav
      ENTITY travel
      FIELDS ( TravelId TravelUuid AgencyId Description )
      WITH travel_read_import
      RESULT DATA(lt_travel_mod).

    out->write( lt_travel_result ).
    out->write( lt_booking_result ).
    out->write( lt_booking_result_combine ).
    out->write( lt_travel_book_fail )." Press F2 on the internal table to get the detail deep structure
    out->write( lt_travel_book_report )." Press F2 on the internal table to get the detail deep structure
    out->write( 'Display before commit' ).
    out->write( lt_travel_mod ). " Display belore COMMIT

* Checking RETURN or FAILED table , based on which commit will be done
    IF    lt_travel_mod_fail IS INITIAL.
      COMMIT ENTITIES.
    ELSE.
      ROLLBACK ENTITIES.
    ENDIF.
* After modification and COMMIT read the entities to display-
    READ ENTITIES OF YI_swas_Travel_behav
      ENTITY travel
       FIELDS ( TravelId TravelUuid AgencyId Description )
       WITH travel_read_import
      RESULT lt_travel_mod.

    out->write( 'Display after COMMIT with updated description' ).
    out->write( lt_travel_mod ). " Display after COMMIT

     "Test 2 - Read Travel Entity using From variant
    " ls_travel_input = VALUE #( ( %is_draft = if_abap_behv=>mk-on " similar to BAPI X structure
    "                          TravelUuid = '0075BB3252506C9519007CEE18EE2C04'
    "                         %control = VALUE #( TravelId = if_abap_behv=>mk-on " similar to BAPI X structure
    "                                           AgencyId = if_abap_behv=>mk-on
    "                                          TotalPrice = if_abap_behv=>mk-on
    "                                         CustomerId = if_abap_behv=>mk-on ) ) ) .

    "READ ENTITIES OF YI_swas_Travel_behav
    "   ENTITY travel
    "   FROM ls_travel_input
    "  RESULT lt_travel_result.

  ENDMETHOD.
ENDCLASS.

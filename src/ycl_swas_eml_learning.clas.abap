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

    DATA : ls_travel_input    TYPE TABLE FOR READ IMPORT YI_swas_Travel_behav,
           lt_travel_result   TYPE TABLE FOR READ RESULT YI_swas_Travel_behav,
           Travel_Read_Import TYPE TABLE FOR READ IMPORT YI_swas_Travel_behav,
           Booking_Read_Import TYPE TABLE FOR READ IMPORT YI_SWAS_BOOKING_behav.

* Fetch key UUID from TRAVE
    SELECT FROM YC_SWAS_TRAVEL_behav
      FIELDS traveluuid
      WHERE TravelId IN ( '00000025' , '00000034' )
      INTO TABLE @DATA(lt_key_truuid).

    IF lt_key_truuid IS INITIAL.
      RETURN.
    ELSE.
      Travel_Read_Import = CORRESPONDING #( lt_key_truuid ).
    ENDIF.

*  "Test 1 - Read  fields of Travel Entity, we are nt passing control MARKED entry
* Assignment 1 (read travel entries only)
    READ ENTITIES OF YI_swas_Travel_behav
    ENTITY Travel
    FIELDS ( TravelId  AgencyId ) "to show all flds use ALL FIELDS
     WITH  Travel_Read_Import  "VALUE #( ( TravelUuid = '0075BB3252506C9519007CEE18EE2C04' ) )
    RESULT lt_travel_result
    FAILED DATA(lt_travel_fail)
    REPORTED DATA(lt_travel_report).

* Assignment 2 (read booking entries only)
* Read fields of Booking entity-
    READ ENTITIES OF YI_swas_Travel_behav
    ENTITY Travel BY \_Booking
    FIELDS ( BookingId CarrierId ) "to show all flds use ALL FIELDS
     WITH CORRESPONDING #( travel_read_import )  "VALUE #( ( TravelUuid = '0075BB3252506C9519007CEE18EE2C04' ) )
    RESULT data(lt_booking_result).

* Assignment 3 (read travel and booking both entries only)
    READ ENTITIES OF YI_swas_Travel_behav
     ENTITY travel
     ALL FIELDS WITH travel_read_import
     RESULT DATA(lt_travel_result_combine)

     ENTITY Travel BY \_Booking
     ALL FIELDS WITH CORRESPONDING #( travel_read_import )
     RESULT DATA(lt_booking_result_combine).

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

    out->write( lt_travel_result ).
    out->write( lt_booking_result ).
    out->write( lt_booking_result_combine ).
    out->write( lt_travel_fail ).
    out->write( lt_travel_report ).
  ENDMETHOD.
ENDCLASS.

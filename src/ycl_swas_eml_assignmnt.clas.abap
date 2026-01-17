CLASS ycl_swas_eml_assignmnt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : ty_travel__read_result_tt TYPE TABLE FOR READ RESULT YI_swas_Travel_behav\\travel,
            ty_booking_read_result_tt TYPE TABLE FOR READ RESULT YI_swas_Travel_behav\\booking.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS copy_travel_draft IMPORTING travel_id      TYPE YI_swas_Travel_behav-TravelId
                              EXPORTING travel_result  TYPE ty_travel__read_result_tt
                                        booking_result TYPE ty_travel__read_result_tt.


ENDCLASS.

CLASS ycl_swas_eml_assignmnt IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    copy_travel_draft( " Cntrl +Space  after that Shift + ENTER auto syntax will come
      EXPORTING
        travel_id     =  '0000025'
      IMPORTING
        travel_result = DATA(travel_read)
        booking_result = DATA(booking_read)
    ).
  ENDMETHOD.

  METHOD copy_travel_draft.
    DATA : lt_travel_create_target  TYPE TABLE FOR CREATE YI_swas_Travel_behav\\travel, " Press F2 will give u element list
           ls_travel_src_create     LIKE LINE OF lt_travel_create_target,
           lt_booking_create_target TYPE TABLE FOR CREATE YI_swas_Travel_behav\\Travel\_Booking,
           ls_booking_create        LIKE LINE OF lt_booking_create_target,
           ls_booking_create_target LIKE LINE OF ls_booking_create-%target.

* 1. Fetch key maximum travel ID from TRAVEL entity where travel ID = 25
    SELECT SINGLE FROM Yi_SWAS_TRAVEL_behav "equivalent to  SELECT * FROM YC_SWAS_TRAVEL_behav
       FIELDS *
     WHERE TravelId IN ( '00000025' )
      INTO  @DATA(ls_src_travel).

    IF ls_src_travel IS NOT INITIAL.
      RETURN.
    ENDIF.
    SELECT FROM YI_SWAS_BOOKING_behav
     FIELDS *
     WHERE TravelUuid = @ls_src_travel-TravelUuid
     INTO TABLE @DATA(lt_src_booking).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.
    SELECT SINGLE FROM YI_swas_Travel_behav
      FIELDS MAX( TravelId )
      INTO @DATA(lv_max_travelid).


* 2A. Changing travel ID to the next number and prepare travel entity
    ls_travel_src_create-%data = CORRESPONDING #( ls_src_travel
                                 EXCEPT TravelUuid CreatedAt CreatedBy LastChangedBy LastChangedAt )  .
    ls_travel_src_create-%cid = 'Swas_travel'.
    ls_travel_src_create-TravelId =  lv_max_travelid + 1.
    ls_travel_src_create-%is_draft = if_abap_behv=>mk-on.
*      ls_travel_src_create-%control= if_abap_behv=>mk-on.
    APPEND ls_travel_src_create TO lt_travel_create_target.

* 2B. Changing travel ID to the next number and prepare travel entity
    ls_booking_create-%cid_ref = ls_travel_src_create-%cid.
    ls_booking_create-%is_draft = ls_travel_src_create-%is_draft.

    LOOP AT lt_src_booking ASSIGNING FIELD-SYMBOL(<lfs_src_booking>).
      ls_booking_create_target-%cid = |{  ls_booking_create-%cid_ref }-booking{ sy-tabix } |.
      ls_booking_create_target-%is_draft  = ls_booking_create-%is_draft.
      ls_booking_create_target-%data = CORRESPONDING #( ls_booking_create EXCEPT TravelUuid BookingUuid CreatedBy LastChangedBy ).
      APPEND ls_booking_create_target TO ls_booking_create-%target.
    ENDLOOP.
    APPEND ls_booking_create TO lt_booking_create_target.

*3. create new entity-
    MODIFY ENTITIES OF YI_SWAS_travel_behav
     ENTITY  travel
     CREATE
     FIELDS ( AgencyId BeginDate BookingFee CurrencyCode CustomerId Description EndDate OverallStatus TotalPrice )
     WITH lt_travel_create_target

     CREATE BY \_booking
     FIELDS ( BookingDate BookingId CarrierId ConnectionId CurrencyCode CustomerId )
     WITH lt_booking_create_target

     MAPPED FINAL(travel_mapped)
     FAILED FINAL(travel_fail).

    IF travel_fail IS INITIAL .
      COMMIT ENTITIES.
    ENDIF.

* 4. Reading and displaying newly created entities-

    DATA : lt_travel_read TYPE TABLE FOR READ IMPORT YI_swas_Travel_behav\\Travel,
           ls_travel_read LIKE LINE OF lt_travel_read.

    LOOP AT travel_mapped-travel ASSIGNING FIELD-SYMBOL(<lfs_trvl_read>).
      ls_travel_read-%tky = <lfs_trvl_read>-%tky.
      APPEND ls_travel_read TO lt_travel_read.
    ENDLOOP..

    READ ENTITIES OF YI_swas_Travel_behav
      ENTITY travel
      ALL FIELDS WITH CORRESPONDING #( lt_travel_read )
      RESULT DATA(result_travel)

      ENTITY travel BY \_booking
      ALL FIELDS WITH CORRESPONDING #( lt_travel_read )
      RESULT DATA(result_booking).

  ENDMETHOD .
ENDCLASS .

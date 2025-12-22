*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lhc_YI_swas_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR YI_swas_travel_behav RESULT result.
ENDCLASS.







CLASS lhc_YI_swas_travel IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
  ENDMETHOD.
ENDCLASS.

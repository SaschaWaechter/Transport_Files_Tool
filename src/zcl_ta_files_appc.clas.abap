class ZCL_TA_FILES_APPC definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GAF_CONF_EXIT .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS variante_setzen
      IMPORTING
        io_gaf TYPE REF TO if_fpm_gaf
      RAISING
        cx_fpm_floorplan.
    METHODS system_und_mandant_setzen.
ENDCLASS.



CLASS ZCL_TA_FILES_APPC IMPLEMENTATION.


  METHOD IF_FPM_GAF_CONF_EXIT~OVERRIDE_EVENT_GAF.


    "Variante setzen
    TRY.
        variante_setzen( io_gaf ).
      CATCH cx_fpm_floorplan.
    ENDTRY.


    system_und_mandant_setzen( ).



  ENDMETHOD.


  METHOD SYSTEM_UND_MANDANT_SETZEN.

    "System und Mandant setzen
    DATA(lo_fpm) = cl_fpm_factory=>get_instance( ).
    DATA(lo_idr) = CAST if_fpm_idr( lo_fpm->get_service( cl_fpm_service_manager=>gc_key_idr ) ).
    lo_idr->get_application_title(
          IMPORTING
        ev_title         = DATA(l_title)
    ).
    IF NOT l_title CS sy-sysid AND NOT l_title CS sy-mandt.
      lo_idr->set_application_title( EXPORTING iv_title = |{ l_title } [{ sy-sysid }/{ sy-mandt }]| ).
    ENDIF.

  ENDMETHOD.


  METHOD VARIANTE_SETZEN.

    "Variante setzen
    CASE io_gaf->mo_event->mv_event_id.
      WHEN 'START_EXP'.
        io_gaf->set_variant( iv_variant_id = 'EXP' ).
        cl_fpm_factory=>get_instance( )->raise_event_by_id(
          EXPORTING
            iv_event_id   = if_fpm_constants=>gc_event-leave_initial_screen
        ).
      WHEN 'START_IMP'.
        io_gaf->set_variant( iv_variant_id = 'IMP' ).
        cl_fpm_factory=>get_instance( )->raise_event_by_id(
          EXPORTING
            iv_event_id   = if_fpm_constants=>gc_event-leave_initial_screen
        ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

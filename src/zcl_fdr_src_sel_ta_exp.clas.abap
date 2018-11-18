class ZCL_FDR_SRC_SEL_TA_EXP definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GUIBB .
  interfaces IF_FPM_GUIBB_SEARCH .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FDR_SRC_SEL_TA_EXP IMPLEMENTATION.


  METHOD IF_FPM_GUIBB_SEARCH~CHECK_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_SEARCH~FLUSH.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_SEARCH~GET_DATA.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_SEARCH~GET_DEFAULT_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_SEARCH~GET_DEFINITION.
    DATA ls_data TYPE e070.
    DATA: ls_descr_attr TYPE fpmgb_s_searchfield_descr.
    DATA lt_operators TYPE fpmgb_s_search_operator.

    eo_field_catalog_attr = CAST #( cl_abap_structdescr=>describe_by_data( ls_data ) ).

    et_field_description_attr = VALUE #( ( name = 'TRKORR' max_1_value = 'X' ddic_shlp_name = 'ZH_TRKORR' value_suggest = 'X'
    mandatory = 'X'   ) ).


  ENDMETHOD.


  METHOD IF_FPM_GUIBB_SEARCH~PROCESS_EVENT.

    IF io_event->mv_event_id = 'FPM_NEXT_STEP'.

      IF it_fpm_search_criteria IS INITIAL.
        et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '001' severity = 'E') ).
        ev_result = if_fpm_constants=>gc_event_result-failed.
      ELSE.
        DATA(lt_sc) = it_fpm_search_criteria.
        DATA(l_trkorr) = lt_sc[ 1 ]-low.

        SELECT SINGLE * FROM e070 INTO @DATA(ls_e071) WHERE trkorr = @l_trkorr.
        IF ls_e071-trstatus NE 'R'.
          et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '000' severity = 'E' parameter_1 = l_trkorr ) ).
          ev_result = if_fpm_constants=>gc_event_result-failed.
        else.
           ev_result = if_fpm_constants=>gc_event_result-ok.
           zcl_ta_files_singleton=>singleton( )->set_ta( i_ta = CONV #( l_trkorr ) ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~GET_PARAMETER_LIST.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~INITIALIZE.

  ENDMETHOD.
ENDCLASS.

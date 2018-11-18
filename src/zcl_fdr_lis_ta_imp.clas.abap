class ZCL_FDR_LIS_TA_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GUIBB .
  interfaces IF_FPM_GUIBB_LIST .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FDR_LIS_TA_IMP IMPLEMENTATION.


  METHOD IF_FPM_GUIBB_LIST~CHECK_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~FLUSH.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~GET_DATA.

    IF iv_eventid->mv_event_id EQ 'FPM_NEXT_STEP'.

      DATA ls_tmscsys TYPE tmscsys.
      DATA lt_req_inf TYPE stms_wbo_requests.

      DATA(l_ta) = zcl_ta_files_singleton=>singleton( )->get_ta( ).

      SELECT SINGLE * FROM tmscsys INTO @ls_tmscsys WHERE sysnam = @sy-sysid.

      CALL FUNCTION 'TMS_MGR_READ_TRANSPORT_REQUEST'
        EXPORTING
          iv_request       = l_ta    " Transportauftrag
          is_queue         = ls_tmscsys   " TMS CI: Systeme
        IMPORTING
          et_request_infos = lt_req_inf.

      IF line_exists( lt_req_inf[ 1 ] ).
        DATA(lt_data) = lt_req_inf[ 1 ]-e071.
      ENDIF.


      ct_data = lt_data.
      ev_data_changed = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~GET_DEFAULT_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~GET_DEFINITION.
    DATA lt_eo71 TYPE STANDARD TABLE OF e071.

    eo_field_catalog ?= cl_abap_tabledescr=>describe_by_data( lt_eo71 ).

    eo_field_catalog->get_table_line_type( ).
    DATA(lo_log_line_descr) = CAST cl_abap_structdescr( eo_field_catalog->get_table_line_type( ) ).

    LOOP AT lo_log_line_descr->components ASSIGNING FIELD-SYMBOL(<ls_log_line_descr>).

      et_field_description = VALUE #( BASE et_field_description (  name = <ls_log_line_descr>-name allow_aggregation = abap_true
      allow_filter = abap_true allow_sort = abap_true ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~PROCESS_EVENT.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~GET_PARAMETER_LIST.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~INITIALIZE.

  ENDMETHOD.
ENDCLASS.

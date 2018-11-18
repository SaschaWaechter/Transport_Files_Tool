class ZCL_FDR_LIS_TA_EXP definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GUIBB .
  interfaces IF_FPM_GUIBB_LIST .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FDR_LIS_TA_EXP IMPLEMENTATION.


    METHOD IF_FPM_GUIBB_LIST~CHECK_CONFIG.

    ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~FLUSH.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~GET_DATA.

    if iv_eventid->mv_event_id EQ 'FPM_NEXT_STEP'.
       DATA(l_ta) = zcl_ta_files_singleton=>singleton( )->get_ta( ).
       select * from e071 into TABLE @DATA(lt_data) WHERE trkorr = @l_ta.

       ct_data = lt_data.
       ev_data_changed = abap_true.
    endif.

  ENDMETHOD.


    METHOD IF_FPM_GUIBB_LIST~GET_DEFAULT_CONFIG.

    ENDMETHOD.


  METHOD IF_FPM_GUIBB_LIST~GET_DEFINITION.
    DATA lt_eo71 TYPe STANDARD TABLE of e071.

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

class ZCL_FDR_FORM_FILE_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GUIBB .
  interfaces IF_FPM_GUIBB_FORM .

  data:
    BEGIN OF ms_data,
            text1 TYPE string,
            text2 TYPE string,
            text3 TYPE string,
          END OF ms_data .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FDR_FORM_FILE_IMP IMPLEMENTATION.


  METHOD IF_FPM_GUIBB_FORM~CHECK_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~FLUSH.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DATA.

    clear ms_data.
    DATA(l_ta) = zcl_ta_files_singleton=>singleton( )->get_ta( ).
    ms_data-text2 = l_ta.
    ms_data-text1 = COND #( WHEN l_ta IS INITIAL THEN '@02@' ELSE '@01@' ).
    ms_data-text3 = COND #( WHEN l_ta IS INITIAL THEN 'Fehler' ELSE 'An Importqueue angehängt' ).

    cs_data = ms_data.
    ev_data_changed = abap_true.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFAULT_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFINITION.

    eo_field_catalog = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( p_data = ms_data ) ).

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~PROCESS_EVENT.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~GET_PARAMETER_LIST.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~INITIALIZE.

  ENDMETHOD.
ENDCLASS.

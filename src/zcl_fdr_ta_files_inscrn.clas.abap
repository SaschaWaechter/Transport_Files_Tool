class ZCL_FDR_TA_FILES_INSCRN definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GUIBB .
  interfaces IF_FPM_GUIBB_FORM .

  data:
    BEGIN OF ms_inscrn,
            text1 TYPE string,
            text2 TYPE string,
            text3 TYPE string,
          END OF ms_inscrn .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FDR_TA_FILES_INSCRN IMPLEMENTATION.


  METHOD IF_FPM_GUIBB_FORM~CHECK_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~FLUSH.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DATA.

    MS_INSCRN-TEXT1 = 'Mit diesem Tool können Sie Co-/Datafiles zu Transportaufträgen importieren/exportieren'.
    MS_INSCRN-text2 = 'Transportfiles exportieren'.
    MS_INSCRN-TEXT3 = 'Transportfiles importieren'.

    CS_DATA = MS_INSCRN.
    EV_DATA_CHANGED = abap_true.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFAULT_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFINITION.

    eo_field_catalog = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( p_data = ms_inscrn ) ).

    et_action_definition = VALUE #(
                                    (
                                     id         = 'START_EXP'
                                     text       = 'Transportauftrag exportieren'
                                     enabled    = abap_true
                                    )
                                    (
                                     id         = 'START_IMP'
                                     text       = 'Transportauftrag importieren'
                                     enabled    = abap_true
                                    )
                                   ).

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~PROCESS_EVENT.


  ENDMETHOD.


  METHOD IF_FPM_GUIBB~GET_PARAMETER_LIST.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~INITIALIZE.

  ENDMETHOD.
ENDCLASS.

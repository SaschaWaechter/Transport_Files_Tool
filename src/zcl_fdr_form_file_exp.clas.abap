class ZCL_FDR_FORM_FILE_EXP definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GUIBB .
  interfaces IF_FPM_GUIBB_FORM .

  types:
    BEGIN OF ty_data,
             file_download TYPE xstring,
           END OF ty_data .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS download_file IMPORTING i_file     TYPE string
                                    i_filename TYPE string.
ENDCLASS.



CLASS ZCL_FDR_FORM_FILE_EXP IMPLEMENTATION.


  METHOD DOWNLOAD_FILE.
    DATA ls_text TYPE fpm_s_text.
    DATA lt_text TYPE STANDARD TABLE OF fpm_s_text.
    DATA l_xstring TYPE xstring.
    DATA lt_binary TYPE solix_tab.
    DATA ls_binary TYPE solix.
    DATA l_lenght TYPE i.

*    OPEN DATASET i_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
*    DO.
*      READ DATASET i_file INTO ls_text.
*      IF sy-subrc <> 0.
*        EXIT.
*      ELSE.
*        lt_text = VALUE #( BASE lt_text ( ls_text ) ).
*      ENDIF.
*    ENDDO.
*    CLOSE DATASET i_file.
*
*    CALL FUNCTION 'SCMS_TEXT_TO_BINARY'
*      EXPORTING
*        mimetype      = space
*      IMPORTING
*        output_length = l_lenght
*      TABLES
*        text_tab      = lt_text
*        binary_tab    = lt_binary.
*    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*      EXPORTING
*        input_length = l_lenght
*      IMPORTING
*        buffer       = l_xstring
*      TABLES
*        binary_tab   = lt_binary.

    DATA: lv_xstring TYPE xstring.

    OPEN DATASET i_file FOR INPUT IN BINARY MODE.
        READ DATASET i_file INTO l_xstring.
    CLOSE DATASET i_file.


    cl_wd_runtime_services=>attach_file_to_response(
     EXPORTING
     i_filename = i_filename
     i_content = l_xstring
     i_mime_type = 'text/plain'
     i_in_new_window = abap_true ).
  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~CHECK_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~FLUSH.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DATA.



  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFAULT_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFINITION.

    DATA ls_action_definition TYPE fpmgb_s_actiondef.
    DATA ls_field_description TYPE fpmgb_s_formfield_descr.
    DATA ls_data TYPE ty_data.

    eo_field_catalog = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( ls_data ) ).
    ls_field_description-name = 'FILE_DOWNLOAD'.
    APPEND ls_field_description TO et_field_description.
    ls_action_definition-id = 'DOWNLOAD'.
    LS_ACTION_DEFINITION-TEXT = 'Download'.
    ls_action_definition-enabled = abap_true.
    APPEND ls_action_definition TO et_action_definition.


  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~PROCESS_EVENT.

    IF io_event->mv_event_id EQ 'DOWNLOAD'.

      DATA l_tr TYPE char255.
      CALL 'C_SAPGPARAM' ID 'NAME' FIELD 'DIR_TRANS' ID 'VALUE' FIELD l_tr.

      "Cofile
      DATA(l_r_ta) = zcl_ta_files_singleton=>singleton( )->get_ta( ).
      DATA(l_cf_l) = strlen( l_r_ta ).
      l_cf_l = l_cf_l - 4.
      DATA(l_cf) = 'K' && l_r_ta+4(l_cf_l) && '.' && l_r_ta(3).

      DATA(l_file) = l_tr && '/cofiles/' && l_cf.

      download_file(
        EXPORTING
          i_file     = l_file
          i_filename = l_cf
      ).

      "Datafile
      l_r_ta = zcl_ta_files_singleton=>singleton( )->get_ta( ).
      DATA(l_df_l) = strlen( l_r_ta ).
      l_df_l = l_df_l - 4.
      DATA(l_df) = 'R' && l_r_ta+4(l_df_l) && '.' && l_r_ta(3).

      l_file = l_tr && '/data/' && l_df.

      download_file(
        EXPORTING
          i_file     = l_file
          i_filename = l_df
      ).


    ENDIF.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~GET_PARAMETER_LIST.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~INITIALIZE.

  ENDMETHOD.
ENDCLASS.

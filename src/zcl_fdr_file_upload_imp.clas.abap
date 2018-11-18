class ZCL_FDR_FILE_UPLOAD_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_FPM_GUIBB .
  interfaces IF_FPM_GUIBB_FORM .

  types:
    BEGIN OF ty_file_upl_dialog,
             file_data_c          TYPE xstring,
             file_name_ref_c      TYPE string,
             file_mime_type_ref_c TYPE string,
             file_data_d          TYPE xstring,
             file_name_ref_d      TYPE string,
             file_mime_type_ref_d TYPE string,
           END OF ty_file_upl_dialog .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_file_metadata
      IMPORTING i_fullpath       TYPE string
      EXPORTING
                e_root           TYPE string
                e_path           TYPE string
                e_file_name      TYPE string
                e_file_extension TYPE string.

    DATA ms_file_upl_dialog TYPE ty_file_upl_dialog.

    METHODS files_exists_already RETURNING VALUE(r_bool) TYPE boolean.
    METHODS get_tr_dir RETURNING VALUE(r_tr) TYPE char255.
    .
ENDCLASS.



CLASS ZCL_FDR_FILE_UPLOAD_IMP IMPLEMENTATION.


  METHOD FILES_EXISTS_ALREADY.
    DATA l_exists TYPE boolean VALUE abap_false.
    DATA(lt_path) = VALUE stringtab( ( get_tr_dir( ) && '/cofiles/' && ms_file_upl_dialog-file_name_ref_c )
                                     ( get_tr_dir( ) && '/data/' && ms_file_upl_dialog-file_name_ref_d )    ).

    LOOP AT lt_path ASSIGNING FIELD-SYMBOL(<ls_path>).
      OPEN DATASET <ls_path> FOR INPUT IN BINARY MODE.
      IF sy-subrc = 0.
        l_exists = abap_true.
      ENDIF.
      CLOSE DATASET <ls_path>.
    ENDLOOP.
    r_bool = l_exists.
  ENDMETHOD.


  METHOD GET_FILE_METADATA.

    FIND '$' IN i_fullpath MATCH OFFSET DATA(l_moff).
    IF sy-subrc = 0.
* lokaler Pfad innerhalb der Cloud --> Sonderlogik

      SPLIT i_fullpath AT '$' INTO e_root e_path.
      IF l_moff > 0.
        DATA(l_len) = l_moff + 2.
        e_root = i_fullpath(l_len).
        e_path = i_fullpath+l_len.

        FIND REGEX '^(.+\\|.+\/)*(.+)\.(.+)' IN e_path SUBMATCHES e_path e_file_name e_file_extension.
      ENDIF.

    ELSE.
      " Should match both windows frontend and application server paths
      FIND REGEX '^(.:\\|\/\/)(.+\\|.+\/)*(.+)\.(.+)' IN i_fullpath SUBMATCHES e_root e_path e_file_name e_file_extension.

    ENDIF.
  ENDMETHOD.


  METHOD GET_TR_DIR.
    CALL 'C_SAPGPARAM' ID 'NAME' FIELD 'DIR_TRANS' ID 'VALUE' FIELD r_tr.
  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~CHECK_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~FLUSH.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DATA.



    CASE io_event->mv_event_id.

      WHEN 'FILE_UPLOAD'.

        ms_file_upl_dialog = cs_data.


        get_file_metadata(
          EXPORTING
            i_fullpath       = ms_file_upl_dialog-file_name_ref_c
          IMPORTING
*            e_root           =
*            e_path           =
            e_file_name      = ms_file_upl_dialog-file_name_ref_c
            e_file_extension = DATA(l_file_extension)
        ).

        ms_file_upl_dialog-file_name_ref_c = ms_file_upl_dialog-file_name_ref_c && '.' && l_file_extension.

        get_file_metadata(
          EXPORTING
            i_fullpath       = ms_file_upl_dialog-file_name_ref_d
          IMPORTING
*            e_root           =
*            e_path           =
            e_file_name      = ms_file_upl_dialog-file_name_ref_d
            e_file_extension = l_file_extension
        ).

        ms_file_upl_dialog-file_name_ref_d = ms_file_upl_dialog-file_name_ref_d && '.' && l_file_extension.

        zcl_ta_files_singleton=>singleton( )->set_files( is_files = ms_file_upl_dialog ).

        IF ms_file_upl_dialog-file_name_ref_c EQ '.' OR ms_file_upl_dialog-file_name_ref_d EQ '.'.
          et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '006' severity = 'E') ).
        ELSE.
          et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '005' severity = 'S') ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFAULT_CONFIG.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~GET_DEFINITION.

    DATA ls_file_upl_dialog TYPE ty_file_upl_dialog.

    eo_field_catalog = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( p_data = ls_file_upl_dialog ) ).

    et_field_description = VALUE #(
                                    ( name = 'FILE_DATA_C'  file_name_ref = 'FILE_NAME_REF_C' mime_type_ref = 'FILE_MIME_TYPE_REF_C' )
                                    ( name = 'FILE_DATA_D'  file_name_ref = 'FILE_NAME_REF_D' mime_type_ref = 'FILE_MIME_TYPE_REF_D' )
                                   ).

    et_action_definition = VALUE #(
                                    (
                                     id         = 'FILE_UPLOAD'
                                     text       = 'FILE_UPLOAD'
                                     enabled    = abap_true
                                    )
                                   ).

  ENDMETHOD.


  METHOD IF_FPM_GUIBB_FORM~PROCESS_EVENT.

    IF io_event->mv_event_id = 'FPM_NEXT_STEP'.

      IF ms_file_upl_dialog-file_name_ref_c EQ '.' OR ms_file_upl_dialog-file_name_ref_d EQ '.'.
        et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '002' severity = 'E') ).
        ev_result = if_fpm_constants=>gc_event_result-failed.
      ELSEIF NOT ms_file_upl_dialog-file_name_ref_c CP 'K*'.
        et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '003' severity = 'E') ).
        ev_result = if_fpm_constants=>gc_event_result-failed.
      ELSEIF NOT ms_file_upl_dialog-file_name_ref_d CP 'R*'.
        et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '004' severity = 'E') ).
        ev_result = if_fpm_constants=>gc_event_result-failed.
      ELSEIF ms_file_upl_dialog-file_name_ref_d+1 NE ms_file_upl_dialog-file_name_ref_c+1.
        et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '008' severity = 'E') ).
        ev_result = if_fpm_constants=>gc_event_result-failed.
      ELSEIF files_exists_already( ) = abap_true.
        et_messages = VALUE #( ( msgid = 'ZN_TA_FILES' msgno = '007' severity = 'E') ).
        ev_result = if_fpm_constants=>gc_event_result-failed.
      ELSE.
        "Transportauftrag hochladen
        DATA(l_datafile_path) = get_tr_dir( ) && '/data/' && ms_file_upl_dialog-file_name_ref_d.
        DATA(l_cofiles_path) = get_tr_dir( ) && '/cofiles/' && ms_file_upl_dialog-file_name_ref_c.

        OPEN DATASET l_datafile_path FOR OUTPUT IN BINARY MODE.
        TRANSFER ms_file_upl_dialog-file_data_d TO l_datafile_path.
        CLOSE DATASET l_datafile_path.

        OPEN DATASET l_cofiles_path FOR OUTPUT IN BINARY MODE.
        TRANSFER ms_file_upl_dialog-file_data_c TO l_cofiles_path.
        CLOSE DATASET l_cofiles_path.

        SPLIT ms_file_upl_dialog-file_name_ref_c AT '.' INTO DATA(l_after) DATA(l_before).
        DATA(l_ta) = l_before && l_after.
        zcl_ta_files_singleton=>singleton( )->set_ta( i_ta = CONV #( l_ta ) ).

        "Transportauftrag aufnehmen
        DATA l_domain TYPE tmsdomnam.
        CALL FUNCTION 'TMS_CFG_GET_DOMAIN_NAME'
          EXPORTING
            iv_system      = CONV tmssysnam( sy-sysid )
          IMPORTING
            ev_domain_name = l_domain.
        CALL FUNCTION 'TMS_MGR_FORWARD_TR_REQUEST'
          EXPORTING
            iv_target  = CONV tmssysnam( sy-sysid )
            iv_tardom  = l_domain
            iv_request = CONV trkorr( l_ta ).


      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~GET_PARAMETER_LIST.

  ENDMETHOD.


  METHOD IF_FPM_GUIBB~INITIALIZE.

  ENDMETHOD.
ENDCLASS.

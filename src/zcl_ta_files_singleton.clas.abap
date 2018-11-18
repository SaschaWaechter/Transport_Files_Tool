class ZCL_TA_FILES_SINGLETON definition
  public
  final
  create public .

public section.

  class-methods SINGLETON
    returning
      value(RO_SINGLETON) type ref to zCL_TA_FILES_SINGLETON .
  methods SET_TA
    importing
      !I_TA type TRKORR .
  methods GET_TA
    returning
      value(R_TA) type TRKORR .
  methods SET_FILES
    importing
      !IS_FILES type zCL_FDR_FILE_UPLOAD_IMP=>TY_FILE_UPL_DIALOG .
  methods GET_FILES
    returning
      value(RS_FILES) type zCL_FDR_FILE_UPLOAD_IMP=>TY_FILE_UPL_DIALOG .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA m_ta TYPE trkorr.
    DATA ms_files TYPE zcl_fdr_file_upload_imp=>ty_file_upl_dialog.
    CLASS-DATA mo_singleton TYPE REF TO zcl_ta_files_singleton.
ENDCLASS.



CLASS ZCL_TA_FILES_SINGLETON IMPLEMENTATION.


  METHOD GET_FILES.
    rs_files = ms_files.
  ENDMETHOD.


  METHOD GET_TA.
    r_ta = m_ta.
  ENDMETHOD.


  METHOD SET_FILES.
    ms_files = is_files.
  ENDMETHOD.


  METHOD SET_TA.
    m_ta = i_ta.
  ENDMETHOD.


  METHOD SINGLETON.

    IF mo_singleton IS NOT BOUND.
      ro_singleton = NEW zcl_ta_files_singleton( ).
      mo_singleton = ro_singleton.
    ELSE.
      ro_singleton = mo_singleton.
    ENDIF.

  ENDMETHOD.
ENDCLASS.

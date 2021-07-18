CLASS lhc_SOHead_1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS blockOrder FOR MODIFY
      IMPORTING keys FOR ACTION SOHead_1~blockOrder RESULT result.

    METHODS unblockOrder FOR MODIFY
      IMPORTING keys FOR ACTION SOHead_1~unblockOrder RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR SOHead_1 RESULT result.

ENDCLASS.

CLASS lhc_SOHead_1 IMPLEMENTATION.

  METHOD blockOrder.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_head>).
      MODIFY ENTITY IN LOCAL MODE z_c_ch_sohead1
        UPDATE FIELDS ( block_status )
          WITH VALUE #( (
            sales_doc_num = <fs_head>-sales_doc_num
            block_status = '99' "That means we are blocking for admin approval
          ) )
          REPORTED reported
          FAILED failed.

      READ ENTITY IN LOCAL MODE z_c_ch_sohead1
        ALL FIELDS WITH
          VALUE #( (
            sales_doc_num = <fs_head>-sales_doc_num
          ) )
          RESULT DATA(lt_sales_head).

      result = VALUE #( FOR ls_sales_head IN lt_sales_head (
        sales_doc_num = ls_sales_head-sales_doc_num
        %param-sales_doc_num = ls_sales_head-sales_doc_num
        "%param-block_status = ls_sales_head-block_status
      ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD unblockOrder.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_head>).
      MODIFY ENTITY IN LOCAL MODE z_c_ch_sohead1
        UPDATE FIELDS ( block_status )
          WITH VALUE #( (
            sales_doc_num = <fs_head>-sales_doc_num
            block_status = '' "That means we are unblocking
          ) )
          REPORTED reported
          FAILED failed.

      READ ENTITY IN LOCAL MODE z_c_ch_sohead1
        ALL FIELDS WITH
          VALUE #( (
            sales_doc_num = <fs_head>-sales_doc_num
          ) )
          RESULT DATA(lt_sales_head).

      result = VALUE #( FOR ls_sales_head IN lt_sales_head (
        sales_doc_num = ls_sales_head-sales_doc_num
        %param-sales_doc_num = ls_sales_head-sales_doc_num
        "%param-block_status = ls_sales_head-block_status
      ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE z_c_ch_sohead1
      ALL FIELDS WITH VALUE #( FOR ls_key IN keys ( sales_doc_num = ls_key-sales_doc_num ) )
      RESULT DATA(lt_sales_head).

    result = VALUE #( FOR ls_sales_head IN lt_sales_head (
        %tky-sales_doc_num = ls_sales_head-sales_doc_num
        %features-%update = COND #( WHEN ls_sales_head-block_status = ''
                            THEN if_abap_behv=>fc-f-unrestricted
                            ELSE if_abap_behv=>fc-f-read_only )
        %features-%delete = COND #( WHEN ls_sales_head-block_status = ''
                            THEN if_abap_behv=>fc-o-enabled
                            ELSE if_abap_behv=>fc-o-disabled )
        %features-%assoc-_SOItem1 = COND #( WHEN ls_sales_head-block_status = ''
                                    THEN if_abap_behv=>fc-o-enabled
                                    ELSE if_abap_behv=>fc-o-disabled )
    ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_save DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lcl_save IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_chglog    TYPE STANDARD TABLE OF zch_chglog,
          lv_timestamp TYPE timestamp.
    GET TIME STAMP FIELD lv_timestamp.
    IF delete-sohead_1 IS NOT INITIAL.
      lt_chglog = VALUE #( FOR ls_sohead IN delete-sohead_1 (
        tstamp = lv_timestamp
        objname = 'ZCH_VBAK1'
        chgtype = 'D'
        objkey = ls_sohead-sales_doc_num
        uname = sy-uname
      ) ).
    ENDIF.

    INSERT zch_chglog FROM TABLE @lt_chglog.

  ENDMETHOD.

ENDCLASS.

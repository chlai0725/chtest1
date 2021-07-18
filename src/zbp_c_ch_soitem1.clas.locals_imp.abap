CLASS lhc_SOItem_1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS newSalesTotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SOItem_1~newSalesTotal.

    METHODS checkUnitPriceQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR SOItem_1~checkUnitPriceQuantity.

ENDCLASS.

CLASS lhc_SOItem_1 IMPLEMENTATION.

  METHOD newSalesTotal.

    READ ENTITIES OF z_c_ch_sohead1 IN LOCAL MODE
      ENTITY SOHead_1 BY \_SOItem1
      ALL FIELDS WITH VALUE #( FOR ls_key IN keys ( sales_doc_num = ls_key-sales_doc_num ) )
      RESULT DATA(lt_sales_item).

    DATA: lv_total_doc TYPE zch_vbak1-netwr,
          lv_doc_num   TYPE zch_vbak1-vbeln.
    LOOP AT lt_sales_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      lv_total_doc += <fs_item>-quantity * <fs_item>-unit_cost.
      IF sy-tabix = 1.
        lv_doc_num = <fs_item>-sales_doc_num.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITY IN LOCAL MODE z_c_ch_sohead1
      UPDATE FIELDS ( total_cost )
      WITH VALUE #( (
        sales_doc_num = lv_doc_num
        total_cost = lv_total_doc
      ) )
      REPORTED DATA(lt_reported)
      FAILED DATA(lt_failed).

    if lt_failed is not initial.
      "through error message
    endif.


  ENDMETHOD.

  METHOD checkUnitPriceQuantity.

    READ ENTITIES OF z_c_ch_sohead1 IN LOCAL MODE
      ENTITY SOHead_1 BY \_SOItem1
      FROM VALUE #( FOR ls_key IN keys ( sales_doc_num = ls_key-sales_doc_num ) )
      RESULT DATA(lt_sales_item).

    LOOP AT lt_sales_item INTO DATA(ls_item).
      LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
        CHECK <fs_key>-item_position = ls_item-item_position AND
              ( ls_item-unit_cost LT 0 OR ls_item-quantity LT 0 ).

        APPEND VALUE #(
          sales_doc_num = ls_item-sales_doc_num
          item_position = ls_item-item_position
          ) TO failed-soitem_1.

        APPEND VALUE #(
          sales_doc_num = ls_item-sales_doc_num
          item_position = ls_item-item_position
          %msg = new_message(
            id = 'Z_CH_SALES1'
            number = '001'
            v1 = ls_item-item_position
            severity = if_abap_behv_message=>severity-error )
          ) TO reported-soitem_1.

      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

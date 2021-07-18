CLASS zch_insert_sodata1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      create_sample_so_data,
      reset_sample_so_data.

ENDCLASS.



CLASS zch_insert_sodata1 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    reset_sample_so_data(  ).
    create_sample_so_data(  ).
    out->write( EXPORTING data = 'Done' ).
  ENDMETHOD.

  METHOD create_sample_so_data.
    DATA:
      lt_so_header TYPE STANDARD TABLE OF zch_vbak1,
      lt_so_item   TYPE STANDARD TABLE OF zch_vbap1,
      lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    lt_so_header = VALUE #(
                     (
                      vbeln          = '1001'
                      erdat          = sy-datum
                      ernam          = 'Alex'
                      vkorg          = '1000'
                      vtweg          = '10'
                      spart          = '10'
                      netwr          = '2000.00'
                      waerk          = 'EUR'
                      faksk          = ''
                      last_changed_timestamp = lv_timestamp
                     )
                     (
                     vbeln           = '1002'
                      erdat          = sy-datum
                      ernam          = 'Alex'
                      vkorg          = '1000'
                      vtweg          = '10'
                      spart          = '10'
                      netwr          = '2000.00'
                      waerk          = 'EUR'
                      faksk          = ''
                      last_changed_timestamp = lv_timestamp
                     )
     ).

     lt_so_item = VALUE #(
                    (

                         vbeln          = '1001'
                         posnr          = '10'
                         matnr          = 'M-10'
                         arktx          = 'Laptop'
                         netpr          = '1000'
                         netwr          = '1000'
                         waerk          = 'EUR'
                         kpein          = '1'
                         kmein          = 'PC'
                         last_changed_timestamp = lv_timestamp
                     )
                     (

                         vbeln          = '1001'
                         posnr          = '20'
                         matnr          = 'M-20'
                         arktx          = 'Office Phone'
                         netpr          = '1000'
                         netwr          = '1000'
                         waerk          = 'EUR'
                         kpein          = '1'
                         kmein          = 'PC'
                         last_changed_timestamp = lv_timestamp
                     )
                     (

                         vbeln          = '1002'
                         posnr          = '10'
                         matnr          = 'A-20'
                         arktx          = 'Big Office Desk'
                         netpr          = '1000'
                         netwr          = '2000'
                         waerk          = 'EUR'
                         kpein          = '2'
                         kmein          = 'PC'
                         last_changed_timestamp = lv_timestamp
                     )
                   ).

    INSERT zch_vbak1 FROM TABLE @lt_so_header.
    INSERT zch_vbap1 FROM TABLE @lt_so_item.
  ENDMETHOD.

  METHOD reset_sample_so_data.
    DELETE FROM zch_vbak1.
    DELETE FROM zch_vbap1.
  ENDMETHOD.

ENDCLASS.

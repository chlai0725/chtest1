CLASS zch_insert_data_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS add_user_data.
    METHODS reset_admin_all_user.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zch_insert_data_01 IMPLEMENTATION.
  METHOD add_user_data.
    DATA: lt_type_user TYPE STANDARD TABLE OF zch_userinfo.

    lt_type_user = VALUE #( ( user_email = 'user1@test.com' first_name = 'Ajy' last_name = 'L1' )
                            ( user_email = 'user2@test.com' first_name = 'Bjy' last_name = 'L2' )
                            ( user_email = 'user3@test.com' first_name = 'Cjy' last_name = 'L3' ) ).
    SELECT * FROM zch_userinfo INTO TABLE @DATA(lt_data).
    IF sy-subrc = 0.
      DELETE zch_userinfo FROM TABLE @lt_data.
    ENDIF.
    INSERT zch_userinfo FROM TABLE @lt_type_user.

  ENDMETHOD.

  METHOD reset_admin_all_user.
    UPDATE zch_userinfo SET is_admin = 'NO'.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
*    add_user_data(  ).
    reset_admin_all_user(  ).
  ENDMETHOD.

ENDCLASS.

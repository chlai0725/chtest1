*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_user DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS set_user_admin FOR MODIFY IMPORTING keys FOR ACTION User_01~makeUserAdmin RESULT result.
    METHODS remove_user_admin FOR MODIFY IMPORTING keys FOR ACTION User_01~removeUserAdmin RESULT result.
    METHODS check_valid_email FOR VALIDATE ON SAVE IMPORTING keys FOR User_01~validEmail.
    METHODS assign_is_admin FOR DETERMINE ON MODIFY IMPORTING keys FOR User_01~assignAdmin.
*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK User_01.
ENDCLASS.

CLASS lhc_user IMPLEMENTATION.

  METHOD set_user_admin.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_user>).
*      MODIFY ENTITY IN LOCAL MODE z_c_ch_userinfo_m_01
*          UPDATE FIELDS ( is_admin )
*            WITH VALUE #( ( Email = <fs_user>-Email is_admin = 'YES' ) ).

      UPDATE zch_userinfo SET is_admin = 'YES' WHERE user_email = @<fs_user>-Email.
      IF sy-subrc = 0.
        APPEND VALUE #(
          Email = <fs_user>-Email
          %param-Email = <fs_user>-Email
          %param-is_admin = 'YES'
        ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD remove_user_admin.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_user>).
      UPDATE zch_userinfo SET is_admin = 'NO' WHERE user_email = @<fs_user>-Email.
      IF sy-subrc = 0.
        APPEND VALUE #(
          Email = <fs_user>-Email
          %param-Email = <fs_user>-Email
          %param-is_admin = 'NO'
        ) TO result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD check_valid_email.
    DATA:
      lr_regex          TYPE REF TO cl_abap_regex,
      lr_matcher        TYPE REF TO cl_abap_matcher,
      lv_email_to_check TYPE string.

    CREATE OBJECT lr_regex
      EXPORTING
        pattern     = '[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}'
        ignore_case = abap_true.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_user>).
      lr_matcher = lr_regex->create_matcher( text = <fs_user>-Email ).
      IF lr_matcher->match(  ) IS INITIAL.
        "if email is not proper
        APPEND VALUE #( Email = <fs_user>-Email ) TO failed-user_01.
        APPEND VALUE #( Email = <fs_user>-Email
                        %msg = new_message( id = 'Z_CH_USER_01' number = '001' v1 = <fs_user>-Email
                                            severity = if_abap_behv_message=>severity-error )
                      ) TO reported-user_01.
      ELSE.
        "if email is proper
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD assign_is_admin.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_user>).
      IF <fs_user>-Email CS 'admin'.
        MODIFY ENTITY IN LOCAL MODE z_c_ch_userinfo_m_01
          UPDATE FIELDS ( is_admin )
            WITH VALUE #( ( Email = <fs_user>-Email is_admin = 'YES' ) ).
      ELSE.
        MODIFY ENTITY IN LOCAL MODE z_c_ch_userinfo_m_01
          UPDATE FIELDS ( is_admin )
            WITH VALUE #( ( Email = <fs_user>-Email is_admin = 'NO' ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

*  METHOD lock.
*    TRY.
*        "Instantiate lock object
*        DATA(lock) = cl_abap_lock_object_factory=>get_instance( iv_name = 'EZCH_USERINFO' ).
*      CATCH cx_abap_lock_failure INTO DATA(exception).
*        RAISE SHORTDUMP exception.
*    ENDTRY.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<user>).
*      TRY.
*          "enqueue travel instance
*          lock->enqueue(
*              it_parameter  = VALUE #( (  name = 'USER_EMAIL' value = REF #( <user>-email ) ) )
*          ).
*          "if foreign lock exists
*        CATCH cx_abap_foreign_lock INTO DATA(foreign_lock).
*          APPEND VALUE #( Email = <user>-Email ) TO failed-user_01.
*          APPEND VALUE #( Email = <user>-Email
*                        %msg = new_message( id = 'Z_CH_USER_01' number = '005' "v1 = <fs_user>-Email
*                                            severity = if_abap_behv_message=>severity-error )
*                      ) TO reported-user_01.
**          map_messages(
**           EXPORTING
**                user_email = <user>-email
**                messages  =  VALUE #( (
**                                           msgid = '/DMO/CM_FLIGHT_LEGAC'
**                                           msgty = 'E'
**                                           msgno = '032'
**                                           msgv1 = <user>-email
**                                           msgv2 = foreign_lock->user_name )
**                          )
**              CHANGING
**                failed    = failed-user_01
**                reported  = reported-user_01
**            ).
*
*        CATCH cx_abap_lock_failure INTO exception.
*          RAISE SHORTDUMP exception.
*      ENDTRY.
*    ENDLOOP.
*
*  ENDMETHOD.

ENDCLASS.

@AbapCatalog.sqlViewName: 'ZVCHUSERINFO01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS view for  userinfo'
define view z_i_ch_userinfo_m_01 as select from zch_userinfo {
    key user_email,
    first_name,
    last_name,
    is_admin,
    
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at
}

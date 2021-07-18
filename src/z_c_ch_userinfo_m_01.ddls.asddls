@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Root CDS view for userinfo'
define root view entity z_c_ch_userinfo_m_01 as select from z_i_ch_userinfo_m_01
{
  key user_email as Email,
  first_name,
  last_name,
  is_admin,
  concat_with_space(first_name, last_name, 1) as full_name,
  
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at
}

@AbapCatalog.sqlViewName: 'ZCCHSOHEAD1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Sales Header Root View'
define root view z_c_ch_sohead1
  as select from z_i_ch_sohead1
  composition [0..*] of z_c_ch_soitem1 as _SOItem1
{
  key sales_doc_num,
      date_created,
      person_created,
      sales_org,
      sales_dist,
      sales_div,
      total_cost,
      cost_currency,
      block_status,
      case block_status
        when '' then 'OK'
        when '99' then 'Approval Needed'
        else 'Blocked'
      end as block_status_msg,
      last_changed,
      /* Associations */
      //_SO_Item1
      _SOItem1
}

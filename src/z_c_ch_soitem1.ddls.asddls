@AbapCatalog.sqlViewName: 'ZCCHSOITEM1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Sales Item composite View'
define view z_c_ch_soitem1
  as select from z_i_ch_soitem1
  association to parent z_c_ch_sohead1 as _SOHead1
    on $projection.sales_doc_num = _SOHead1.sales_doc_num
{
  key sales_doc_num,
  key item_position,
      mat_num,
      mat_desc,
      unit_cost,
      total_item_cost,
      cost_currency,
      quantity,
      unit,
      last_changed,
      /* Associations */
      //_SO_Head1
      _SOHead1
}

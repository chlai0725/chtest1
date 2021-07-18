@AbapCatalog.sqlViewName: 'ZICHSOHEAD1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Doc Basic View'
@ObjectModel.representativeKey: 'sales_doc_num'
@ObjectModel.semanticKey: ['sales_doc_num']

define view z_i_ch_sohead1
  as select from zch_vbak1
  association [0..*] to z_i_ch_soitem1 as _SO_Item1
    on $projection.sales_doc_num = _SO_Item1.sales_doc_num
{
  key vbeln                  as sales_doc_num,
      erdat                  as date_created,
      @Semantics.user.createdBy: true
      ernam                  as person_created,
      vkorg                  as sales_org,
      vtweg                  as sales_dist,
      spart                  as sales_div,
      @Semantics.amount.currencyCode: 'cost_currency'
      netwr                  as total_cost,
      waerk                  as cost_currency,
      faksk                  as block_status,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_timestamp as last_changed,
      
      _SO_Item1
}

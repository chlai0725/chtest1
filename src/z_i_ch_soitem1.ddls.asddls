@AbapCatalog.sqlViewName: 'ZICHSOITEM1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Item Basic View'
@ObjectModel.representativeKey: 'item_position'
@ObjectModel.semanticKey: ['sales_doc_num', 'item_position']

define view z_i_ch_soitem1
  as select from zch_vbap1
  association [1..1] to z_i_ch_sohead1 as _SO_Head1
    on $projection.sales_doc_num = _SO_Head1.sales_doc_num
{
  key vbeln                  as sales_doc_num,
  key posnr                  as item_position,
      matnr                  as mat_num,
      @Semantics.text: true
      arktx                  as mat_desc,
      @Semantics.amount.currencyCode: 'cost_currency'
      netpr                  as unit_cost,
      @Semantics.amount.currencyCode: 'cost_currency'
      netwr                  as total_item_cost,
      waerk                  as cost_currency,
      @Semantics.quantity.unitOfMeasure: 'unit'
      kpein                  as quantity,
      kmein                  as unit,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_timestamp as last_changed,
      
      _SO_Head1

}

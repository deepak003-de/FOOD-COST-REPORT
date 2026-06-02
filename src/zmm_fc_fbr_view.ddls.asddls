@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ' F&B Revenue'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_FC_FBR_View 
  as select from I_GLAccountLineItem

{
  key CompanyCode,
  key Plant,
  key GLAccount,
  key Ledger,
  key PostingDate,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  AmountInCompanyCodeCurrency,
  CompanyCodeCurrency
}
where
  (GLAccount = '0030010200' or GLAccount = '0030010100' or GLAccount = '0030031600') and
  (Ledger = '0L' or Ledger = '0B') and
  PostingDate between '20240101' and '20240930'


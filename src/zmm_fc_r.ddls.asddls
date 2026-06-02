@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - Food Cost Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_FC_R with parameters
 p_actual_from : zmm_fr_date,
    p_actual_to   : zmm_to_date,
    p_budget_from : zmm_bfr_date,
    p_budget_to   : zmm_bto_date

  as select from I_GLAccountLineItem as Gl
  left outer join ZSD_GSTR1_001 as Gst on Gl.GLAccount = Gst.revenuegl
  
//  left outer join I_Plant as Plant on Gl.Plant = Plant.Plant

  //left outer join I_GLAccountLineItem as GlLineItem
//    on Gl.GLAccount = GlLineItem.GLAccount
//    left outer join I_Plant as Plant on GlLineItem.Plant = Plant.Plant

   
{ key Gl.ProfitCenter,
//  key Gl.Plant,
     Gl.CompanyCode,
//   Plant.PlantName,
  Gl.CompanyCodeCurrency,
 sum(
    case 
      when (Gl.GLAccount = '0030010200' or Gl.GLAccount = '0030010400')
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then -1 * cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as Beverage_FGR,
    
  sum(
    case 
      when (Gl.GLAccount = '0030010100' or Gl.GLAccount = '0030010200' or Gl.GLAccount = '0030011500' or Gl.GLAccount = '0030031700' or Gl.GLAccount = '0030031720'  or Gl.GLAccount = '0030032500' ) // Food
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then -1 * cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as Food_FGR,
  
  abap.string' ' as Tabaco,

  sum(
    case 
      when Gl.GLAccount = '0030031600' // Backend Scrap Sale
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as Scrap_FGR,

  // Total Actual for Plant
//sum(
//    case
//      when (Gl.GLAccount = '0030010200' or  Gl.GLAccount = '0030010100' or Gl.GLAccount =  '0030031600' or Gl.GLAccount = '0030010400')
//           and Gl.Ledger = '0L'
//           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
//      then -1* cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
//      else 0
//    end
//  ) as Total_FGR_Sept,
sum(
    case
      when (
        (Gl.GLAccount = '0030010200' or Gl.GLAccount = '0030010400') or
        (Gl.GLAccount = '0030010100' or Gl.GLAccount = '0030010200' or Gl.GLAccount = '0030011500' or Gl.GLAccount = '0030031700' or Gl.GLAccount = '0030031720' or Gl.GLAccount = '0030032500') or
        (Gl.GLAccount = '0030031600')
      )
      and Gl.Ledger = '0L'
      and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then 
        case 
          when Gl.GLAccount = '0030031600' 
          then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
          else -1 * cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
        end
      else 0
    end
  ) as Total_FGR_Sept,

  // Budget June 2024
//  sum(
//    case 
//      when (Gl.GLAccount = '0030010200'or Gl.GLAccount =  '0030010100'or Gl.GLAccount = '0030031600')
//           and Gl.Ledger = '0L'
//           and Gl.PostingDate between $parameters.p_budget_from and $parameters.p_budget_to
//      then -1 * cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
//      else 0
//    end
//  ) as Budget__FGR_June_2024,
  abap.string'' as Budget__FGR_June_2024,
  sum(
    case 
      when (Gl.GLAccount = '0040030120' or Gl.GLAccount = '0040030121'or Gl.GLAccount = '0040030100' or Gl.GLAccount = '0040033000' or Gl.GLAccount = '0040035000')
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as Beverage_cogs,
  sum(
    case 
      when (Gl.GLAccount = '0040030110' or Gl.GLAccount = '0040030111')
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as Liquor_cogs,
 
  sum(
    case 
      when (Gl.GLAccount = '0040020100' or Gl.GLAccount = '0040020300' or Gl.GLAccount = '0040020400' or Gl.GLAccount = '0040020600' 
      or Gl.GLAccount = '0040030100' or Gl.GLAccount = '0040030101' or Gl.GLAccount = '0040030200' or Gl.GLAccount = '0040030210'
      or Gl.GLAccount = '0040030300' 
      or Gl.GLAccount = '0040030400' or Gl.GLAccount = '0040030600'or Gl.GLAccount = '0040030700' 
      or Gl.GLAccount = '0040030800' or Gl.GLAccount = '0040030900' or Gl.GLAccount = '0040031000' or Gl.GLAccount = '0040034000'
      or Gl.GLAccount = '0040041300' or Gl.GLAccount = '0040020120' or Gl.GLAccount = '0040020110' or Gl.GLAccount = '0040020119')
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as food_cogs,
  
   sum(
    case 
      when (Gl.GLAccount = '0040020200' or Gl.GLAccount = '40040500')
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as Packaging_cogs,
  
   sum(
    case 
      when (Gl.GLAccount = '0040040200' or Gl.GLAccount = '0040040210' or Gl.GLAccount = '0040040250' or Gl.GLAccount = '0360000001' or Gl.GLAccount = '0360000000' or Gl.GLAccount = '0360000002')
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then  cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as LP_cogs,
  
//   sum(
//    case 
//      when (Gl.GLAccount = '0040040200' or Gl.GLAccount = '0040040210' or Gl.GLAccount = '0040040250' or Gl.GLAccount = '0360000004' or Gl.GLAccount = '0360000005')
//           and Gl.Ledger = '0L'
//           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
//      then  cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
//      else 0
//    end
//  ) as  Charcoal_COGS
//, 

   sum(
    case 
      when ( Gl.GLAccount = '0040040210' )
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then  cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as  Charcoal_COGS
, 
  
   sum(
    case 
      when Gl.GLAccount = '0040020000'
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as Consumable_COGS,
  
   sum(
    case 
      when Gl.GLAccount = '0040051200'
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as HKEEPING_COGS,
  
   sum(
    case 
      when Gl.GLAccount = '0040030140' 
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as STATIONERY_COGS,
   sum(
    case 
      when Gl.GLAccount = '0040030160' 
           and Gl.Ledger = '0L'
           and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
      then cast(Gl.AmountInCompanyCodeCurrency as abap.dec(15,2))
      else 0
    end
  ) as  Uniforms_COGS,

 sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0040030110' and Gl.AccountingDocumentType = 'KA' or Gl.AccountingDocumentType = 'KR' or Gl.AccountingDocumentType = 'RE' )
         or ( Gl.GLAccount = '0040030111' and ( Gl.AccountingDocumentType = 'RE' ) )
         or ( Gl.GLAccount = '0040030120' and ( Gl.AccountingDocumentType = 'RE' ) ))
      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
      else 0
    end
)  as FIGLBev_COGS,//FIGLBev_COGS 

sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0040030000' and Gl.AccountingDocumentType = 'KR' )
         or ( Gl.GLAccount = '0040030100' and ( Gl.AccountingDocumentType = 'KA' or Gl.AccountingDocumentType = 'KR' or Gl.AccountingDocumentType = 'RE' ) )
         or ( Gl.GLAccount = '0040031000' and ( Gl.AccountingDocumentType = 'PR' or Gl.AccountingDocumentType = 'RP' ) )
         or ( Gl.GLAccount = '0040041300' and ( Gl.AccountingDocumentType = 'KA' or Gl.AccountingDocumentType = 'RE' ) )
          )
      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
      else 0
    end
) as FIGLFood_COGS,

   sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0040040210' and Gl.AccountingDocumentType = 'KR' )
          )
      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
      else 0
    end
)  as  FI_GL_Charcoal  ,
//  sum(
//    case 
//      when Gl.Ledger = '0L'
//       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
//       and (
//            ( Gl.GLAccount = '0020080600' and Gl.AccountingDocumentType = 'KR' )
//          )
//      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
//      else 0
//    end
//)  as   FI_GL_Packing ,
//  cast( 0 as abap.dec(15,2) ) as  FI_GL_Consumable ,
    sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0020080600' and (
             Gst.product like '00000000010%'
             or Gst.product like  '00000000020%'
             or Gst.product like  '00000000040%'
             or Gst.product like  '00000000041%'
           ) )
          )
      then cast( Gst.igstamt as abap.dec(15,2) )
      else 0
    end
) as   FBGST ,
 
  sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0020080600' and (            
               Gst.product like  '00000000031%'
           ) )
          )
      then cast(Gst.igstamt as abap.dec(15,2) )
      else 0
    end
)  as   Non_Food_GST ,
      sum(
      case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0040030100' and Gl.AccountingDocumentType = 'KG' )
          )
      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
      else 0
    end
)  as    Food_Amt_CN,
        sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0040030120' and Gl.AccountingDocumentType = 'KG' )
          )
      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
      else 0
    end
)  as   Beverage_Amt_CN ,
//  cast( 0 as abap.dec(15,2) ) as   Liquor_Amt_CN ,
//  cast( 0 as abap.dec(15,2) ) as   Packaging_Amt_CN ,
  cast( 0 as abap.dec(15,2) ) as    IUTIn_STCOGS,
  cast( 0 as abap.dec(15,2) ) as   IUTOut_STCOGS,
    sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0040032000'  )
          )
      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
      else 0
    end
)   as   Spoilage_STCOGS,

  cast( 0 as abap.dec(15,2) ) as    FoodTrailRND_STCOGS,
  cast( 0 as abap.dec(15,2) ) as   Bar_STCOGS,
  cast( 0 as abap.dec(15,2) ) as   Kitchen_STCOGS,
      sum(
    case 
      when Gl.Ledger = '0L'
       and Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to
       and (
            ( Gl.GLAccount = '0040013100'  )
          )
      then cast( Gl.AmountInCompanyCodeCurrency as abap.dec(15,2) )
      else 0
    end
) as    StaffMeal_STCOGS,

//  cast( 0 as abap.dec(15,2) ) as    Discount_STCOGS,
//  cast( 0 as abap.dec(15,2) ) as    NCK_STCOGS,
  cast( 0 as abap.dec(15,2) ) as     Beverage_STCOGS,
  cast( 0 as abap.dec(15,2) ) as    Food_STCOGS,
  cast( 0 as abap.dec(15,2) ) as     GrossCOGS_STCOGS,
  cast( 0 as abap.dec(15,2) ) as    BevCost_STCOGS,
  cast( 0 as abap.dec(15,2) ) as    FoodCost_STCOGS,
  cast( 0 as abap.dec(15,2) ) as    FBGross_COGSPercentage,
  cast( 0 as abap.dec(15,2) ) as    PACKAGINGGross_COGSPercentage,
  cast( 0 as abap.dec(15,2) ) as    LPGGAS_COGSPercentage,
  cast( 0 as abap.dec(15,2) ) as    CharcoalGross_COGSPercentage,
  cast( 0 as abap.dec(15,2) ) as    ConsumableGross_COGSPercentage,
  cast( 0 as abap.dec(15,2) ) as    HKEEPINGGross_COGSPercentage,  
  cast( 0 as abap.dec(15,2) ) as    GrossnetcostBev_Percentage,
  cast( 0 as abap.dec(15,2) ) as    Grossnetfood_Percentage,
  cast( 0 as abap.dec(15,2) ) as    BevCost_totalPercentage,
  cast( 0 as abap.dec(15,2) ) as    FoodCost_totalPercentage,
  cast( 0 as abap.dec(15,2) ) as    foodBevcostPercentage,
  cast( 0 as abap.dec(15,2) ) as    FBPKLPChar,
//  cast( 0 as abap.dec(15,2) ) as    FBPKLPPercentage,
  cast( 0 as abap.dec(15,2) ) as    SpoilageCOGS,
  cast( 0 as abap.dec(15,2) ) as    CostpAug24_FB,
  cast( 0 as abap.dec(15,2) ) as    CostpAug24_COGS,
 cast( 0 as abap.dec(15,2) ) as    Cogs_FGPercentage,
  cast( 0 as abap.dec(15,2) ) as    Cogs_COGSPercentage,
  cast( 0 as abap.dec(15,2) ) as    Bugsvssales,
  cast( 0 as abap.dec(15,2) ) as    Remark    
   
 
  
  
  
  

}
where 
  (
    Gl.GLAccount = '0030010200' or Gl.GLAccount = '0030010100' or Gl.GLAccount = '0030010400' or Gl.GLAccount = '0030031600'
    or Gl.GLAccount = '0040030120' or Gl.GLAccount = '0040030121' or Gl.GLAccount = '0040033000' or Gl.GLAccount = '0040035000'
    or Gl.GLAccount = '0040030110' or Gl.GLAccount = '0040030111'
    or Gl.GLAccount = '0040020100' or Gl.GLAccount = '0040020300' or Gl.GLAccount = '0040020400' or Gl.GLAccount = '0040020600'
    or Gl.GLAccount = '0040030100' or Gl.GLAccount = '0040030101' or Gl.GLAccount = '0040030200' or Gl.GLAccount = '0040030210'
    or Gl.GLAccount = '0040030300' or Gl.GLAccount = '0040030400' or Gl.GLAccount = '0040030600' or Gl.GLAccount = '0040030700'
    or Gl.GLAccount = '0040030800' or Gl.GLAccount = '0040030900' or Gl.GLAccount = '0040031000' or Gl.GLAccount = '0040034000'
    or Gl.GLAccount = '0040041300' or Gl.GLAccount = '0040020120' or Gl.GLAccount = '0040020110' or Gl.GLAccount = '0040020119'
    or Gl.GLAccount = '0040020200' or Gl.GLAccount = '0040040500'
    or Gl.GLAccount = '0040040200' or Gl.GLAccount = '0040040210' or Gl.GLAccount = '0040040250'
    or Gl.GLAccount = '0040020000' or Gl.GLAccount = '0020080600'
    or Gl.GLAccount = '0040051200' or Gl.GLAccount = '0040030140' or Gl.GLAccount = '0040030160'
    or Gl.GLAccount = '0040030000' or Gl.GLAccount = '002008060' or Gl.GLAccount = '0040013100' or Gl.GLAccount = '0040032000' or Gl.GLAccount = '0040030100'
  )
  and (
    (Gl.PostingDate between $parameters.p_actual_from and $parameters.p_actual_to and Gl.Ledger = '0L') or
    (Gl.PostingDate between $parameters.p_budget_from and $parameters.p_budget_to and Gl.Ledger = '0L')
  )

group by 
//  Gl.Plant,
  Gl.CompanyCodeCurrency,
//    Gl.CompanyCode,
    Gl.ProfitCenter,
    Gl.CompanyCode


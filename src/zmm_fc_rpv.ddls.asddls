@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calculation cds view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_FC_RPV
  with parameters
    p_actual_from : zmm_fr_date,
    p_actual_to   : zmm_to_date,
    p_budget_from : zmm_bfr_date,
    p_budget_to   : zmm_bto_date
  as select from ZMM_FC_R( p_actual_from: $parameters.p_actual_from  , p_actual_to: $parameters.p_actual_to , p_budget_from: $parameters.p_budget_from , p_budget_to: $parameters.p_budget_to )
{
  key ProfitCenter,
      //    key Plant,
        CompanyCode,
      CompanyCodeCurrency,
      // F&B Revenue ********************
      Beverage_FGR,
      Food_FGR,
      Tabaco,
      Scrap_FGR,
      cast(
    coalesce(Beverage_FGR, 0) +
    coalesce(Food_FGR, 0) +
    coalesce(Scrap_FGR, 0)
as abap.dec(15,2)) as
      Total_FGR_Sept1,
      Total_FGR_Sept,
      Budget__FGR_June_2024,
      //Consumption COGS Value
      Beverage_cogs,
      Liquor_cogs,
      food_cogs,
      Packaging_cogs,
      LP_cogs,
      Charcoal_COGS,
      Consumable_COGS,
      HKEEPING_COGS,
      STATIONERY_COGS,
      //************************
      Uniforms_COGS,
      FIGLBev_COGS,
      FIGLFood_COGS,
      //Balnk fields for future use
      FI_GL_Charcoal,
//      FI_GL_Packing,
//      FI_GL_Consumable,
      FBGST,
      Non_Food_GST,

      // Credit Note

      Food_Amt_CN,
      Beverage_Amt_CN,
//      Liquor_Amt_CN,
//      Packaging_Amt_CN,

      // Stock Transfer In Out & Spoilage & Discount COGS Value

      IUTIn_STCOGS,
      IUTOut_STCOGS,
       Spoilage_STCOGS,
      FoodTrailRND_STCOGS,
      Bar_STCOGS,
      Kitchen_STCOGS,
      StaffMeal_STCOGS,
//      Discount_STCOGS,
      //NCK_STCOGS,
      cast(
         coalesce(Beverage_cogs, 0) +
         coalesce(Liquor_cogs, 0) +
         coalesce(Bar_STCOGS, 0) +
       coalesce(FIGLBev_COGS , 0) -

         coalesce(Beverage_Amt_CN , 0) 
         as abap.dec(15,2)
      ) as Beverage_STCOGS

  ,
//As intsructed by rohit removed negaitive sign from food cogs calculation on 06th 11 2025
      cast( 
          coalesce(food_cogs, 0) +
          coalesce(IUTIn_STCOGS, 0) +
          coalesce(FIGLFood_COGS, 0) +
          coalesce(FBGST, 0) -
          (
            coalesce(IUTOut_STCOGS, 0) +
            coalesce(Kitchen_STCOGS , 0) +
            coalesce(Food_Amt_CN, 0)
          )
          as abap.dec(15,2)
      ) as Food_STCOGS,

//As intsructed by rohit removed negaitive sign from food cogs calculation on 06th 11 2025
cast(
         coalesce(Beverage_cogs, 0) +
         coalesce(Liquor_cogs, 0) +
         coalesce(Bar_STCOGS, 0) +
       coalesce(FIGLBev_COGS , 0) -

         coalesce(Beverage_Amt_CN , 0) +
          (
          coalesce(food_cogs, 0) +
          coalesce(IUTIn_STCOGS, 0) +
          coalesce(FIGLFood_COGS, 0) +
          coalesce(FBGST, 0) -
          (
            coalesce(IUTOut_STCOGS, 0) +
            coalesce(Kitchen_STCOGS , 0) +
            coalesce(Food_Amt_CN, 0)))
    
    as abap.dec(15,2)
) as GrossCOGS_STCOGS,
  BevCost_STCOGS,

      

      // Food Cost % = Food_STCOGS / Food_FGR
     FoodCost_STCOGS,
    FBGross_COGSPercentage,

      // Packaging %
    PACKAGINGGross_COGSPercentage,

      // LPG GAS %
      cast(
          case when (Beverage_FGR + Food_FGR + Scrap_FGR) <> 0 then
              coalesce(LP_cogs, 0) / (Beverage_FGR + Food_FGR + Scrap_FGR)
//          else 0 
          end
          as abap.dec(15,2)
      ) as LPGGAS_COGSPercentage,

      // Charcoal %
    cast(
    case 
        when ( coalesce(Beverage_FGR,0)
             + coalesce(Food_FGR,0)
             + coalesce(Scrap_FGR,0) ) <> 0
        then
            coalesce(Charcoal_COGS,0)
            /
            ( coalesce(Beverage_FGR,0)
            + coalesce(Food_FGR,0)
            + coalesce(Scrap_FGR,0) )
        else 0
    end
as abap.dec(15,2)
) as CharcoalGross_COGSPercentage,

      // Consumables %
    ConsumableGross_COGSPercentage,

      // HKEEPING %
      cast(
          case when (Beverage_FGR + Food_FGR + Scrap_FGR) <> 0 then
              coalesce(HKEEPING_COGS, 0) / (Beverage_FGR + Food_FGR + Scrap_FGR)
          else 0 end
          as abap.dec(15,2)
      ) as HKEEPINGGross_COGSPercentage,

      // Net Beverage Cost
     GrossnetcostBev_Percentage,

      // Net Food Cost
      Grossnetfood_Percentage,

      // Beverage Cost % of Total
    BevCost_totalPercentage,

      // Food Cost % of Total
     FoodCost_totalPercentage,

   // Combined Food & Bev cost %
     foodBevcostPercentage,
      
      
//      FBPKLPPercentage,
      SpoilageCOGS,
      CostpAug24_FB,
      CostpAug24_COGS,
      Cogs_FGPercentage,
      Cogs_COGSPercentage,
      Bugsvssales,
      Remark





}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMM_FC_RP with parameters
@EndUserText.label: 'From Actual Date'
   p_actual_from : zmm_fr_date,
@EndUserText.label: 'To Actual Date'
    p_actual_to   : zmm_to_date,
@EndUserText.label: 'Budget From'
    p_budget_from : zmm_bfr_date,
    @EndUserText.label: 'Budget To'
    p_budget_to   : zmm_bto_date
    as select from ZMM_FC_FINAL( p_actual_from: $parameters.p_actual_from  , p_actual_to: $parameters.p_actual_to , p_budget_from: $parameters.p_budget_from , p_budget_to: $parameters.p_budget_to )
{
//    @EndUserText.label: 'Profit Center'
//    key Plant,
    @EndUserText.label: 'Profit Center'
key ProfitCenter,
    @EndUserText.label: 'Company Code'
    CompanyCode,
//    @EndUserText.label: 'Plant Name'
//    PlantName,
    CompanyCodeCurrency,
    @EndUserText.label: '  F&B Revenue(Beverage)'
    Beverage_FGR,
    @EndUserText.label: 'F&B Revenue(Food)'
    Food_FGR,
    @EndUserText.label: '  Backend & Tobaco '
    Tabaco,
    @EndUserText.label: ' Backend Scrap Sale '
    Scrap_FGR,
    @EndUserText.label: '  F&B Revenue (Total)'
    Total_FGR_Sept1,
    @UI.hidden: true
    Total_FGR_Sept,
    @EndUserText.label: '  F&B Revenue( Budgeted)'
    Budget__FGR_June_2024,
    @EndUserText.label: 'Consumption COGS Value( Beverage)'
    Beverage_cogs,
    @EndUserText.label: 'Consumption COGS Value( Liquor)'
    Liquor_cogs,
    @EndUserText.label: 'Consumption COGS Value( Food)'
    food_cogs,
    @EndUserText.label: 'Consumption COGS Value( Packaging)'
    Packaging_cogs,
    @EndUserText.label: 'Consumption COGS Value( LPG Gas)'
    LP_cogs,
    @EndUserText.label: 'Consumption COGS Value( Charcoal)'
    Charcoal_COGS,
    @EndUserText.label: 'Consumption COGS Value( Consumable)'
    Consumable_COGS,
    @EndUserText.label: 'Consumption COGS Value( Housekeeping)'
    HKEEPING_COGS,
    @EndUserText.label: 'Consumption COGS Value( Stationery)'
    STATIONERY_COGS,
    @EndUserText.label: 'Consumption COGS Value( Uniforms)'
    Uniforms_COGS,
    @EndUserText.label: 'Consumption COGS Value(FI GLBev.COGS)'
    FIGLBev_COGS,
    @EndUserText.label: 'Consumption COGS Value(FI GLFood COGS)'
    FIGLFood_COGS,
    @EndUserText.label: 'Consumption COGS Value(FI GL Charcoal)'
    FI_GL_Charcoal,
//    @EndUserText.label: 'Consumption COGS Value(FI GL Packing)'
//    FI_GL_Packing,
//    @EndUserText.label: 'Consumption COGS Value(FI GL Consumable)'
//    FI_GL_Consumable,
    @EndUserText.label: 'Consumption COGS Value( F&B GST)'
    FBGST,
    @EndUserText.label: 'Consumption COGS Value( Non Food GST)'
    Non_Food_GST,
    @EndUserText.label: ' Credit Note( F&B COGS)'
    Food_Amt_CN,
    @EndUserText.label: 'Credit Note( Beverage COGS)'
    Beverage_Amt_CN,
//    @EndUserText.label: 'Credit Note( Liquor COGS)'
//    Liquor_Amt_CN,
//    @EndUserText.label: 'Credit Note( Packaging COGS)'
//    Packaging_Amt_CN,
    @EndUserText.quickInfo: 'Stock Transfer In Out & Spoilage & Discount COGS Value'
    @EndUserText.label: ' IUT In'
    IUTIn_STCOGS,
    @EndUserText.label: ' IUT Out'
    IUTOut_STCOGS,
    @EndUserText.label: 'Spoilage'
    Spoilage_STCOGS,
    @EndUserText.label: 'Food Trail'
    FoodTrailRND_STCOGS,
    @EndUserText.label: 'Bar'
    Bar_STCOGS,
    @EndUserText.label: 'Kitchen'
    Kitchen_STCOGS,
    @EndUserText.label: 'Staff Meal'
    StaffMeal_STCOGS,
//    @EndUserText.label: 'Discount'
//    Discount_STCOGS,
//    @EndUserText.label: 'NCK'
//    NCK_STCOGS,
    @EndUserText.label: 'Beverage'
    
    Beverage_STCOGS,
       @EndUserText.label: 'food'
    Food_STCOGS,
    @EndUserText.label: 'FB Gross COGS'
    GrossCOGS_STCOGS,
    @EndUserText.label: 'Beverage Cost'
   cast(
    concat(
        cast( coalesce( BevCost_STCOGS, 0 ) as abap.char(20) ),
        ' %'
    ) 
as abap.char(40)) as BevCost_STCOGS,
    @EndUserText.label: 'Food Cost'
    FoodCost_STCOGS,
    @EndUserText.label: 'Food Beverage '
    FBGross_COGSPercentage,
    @EndUserText.label: 'Beverage Gross COGS '
    PACKAGINGGross_COGSPercentage,
    @EndUserText.label: 'LPG Gas COGS '
    LPGGAS_COGSPercentage,
    @EndUserText.label: 'Charcoal COGS '
    CharcoalGross_COGSPercentage,
    @EndUserText.label: 'Consumable COGS '
    ConsumableGross_COGSPercentage,
    @EndUserText.label: 'Housekeeping COGS '
    HKEEPINGGross_COGSPercentage,
    @EndUserText.label: 'Gross Net Cost Bev'
    GrossnetcostBev_Percentage,
    @EndUserText.label: 'Gross Net Cost Food'
    Grossnetfood_Percentage,
    @EndUserText.label: 'Gross Net Cost Beverage Total %'
    BevCost_totalPercentage,
    @EndUserText.label: 'Gross Net Cost Food Total %'
    FoodCost_totalPercentage,
    @EndUserText.label: 'Food Beverage Cost In%'
    foodBevcostPercentage,
    @EndUserText.label: 'F&B+PK+LP+Char)COGS Total%'
    FBPKLPCHAR,
//    @EndUserText.label: 'Beverage Packaging LPG Charcoal Total'
//    FBPKLPPercentage,
    @EndUserText.label: 'Spoilage COGS In% '
    SpoilageCOGS,
    @EndUserText.label: 'Cost Aug 24 FB %'
    CostpAug24_FB,
    @EndUserText.label: 'Cost Aug 24 COGS % '    
    CostpAug24_COGS,
    @EndUserText.label: 'COGS FB % '
    Cogs_FGPercentage,
    @EndUserText.label: 'COGS  COGS %'
    Cogs_COGSPercentage,
    @EndUserText.label: 'Bug Vs Sales % '
    Bugsvssales,
    @EndUserText.label: 'Remarks'
    Remark
}

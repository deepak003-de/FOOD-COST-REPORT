@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calculation Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_FC_FINAL with parameters p_actual_from : zmm_fr_date,
    p_actual_to   : zmm_to_date,
    p_budget_from : zmm_bfr_date,
    p_budget_to   : zmm_bto_date as  select from ZMM_FC_RPV( p_actual_from: $parameters.p_actual_from  , p_actual_to: $parameters.p_actual_to , p_budget_from: $parameters.p_budget_from , p_budget_to: $parameters.p_budget_to )
{
key ProfitCenter,
CompanyCode,
CompanyCodeCurrency,
Beverage_FGR,
Food_FGR,
Tabaco,
Scrap_FGR,
Total_FGR_Sept1,
Total_FGR_Sept,
Budget__FGR_June_2024,
Beverage_cogs,
Liquor_cogs,
food_cogs,
Packaging_cogs,
LP_cogs,
Charcoal_COGS,
Consumable_COGS,
HKEEPING_COGS,
STATIONERY_COGS,
Uniforms_COGS,
FIGLBev_COGS,
FIGLFood_COGS,
FI_GL_Charcoal,
FBGST,
Non_Food_GST,
Food_Amt_CN,
Beverage_Amt_CN,
IUTIn_STCOGS,
IUTOut_STCOGS,
Spoilage_STCOGS,
FoodTrailRND_STCOGS,
Bar_STCOGS,
Kitchen_STCOGS,
StaffMeal_STCOGS,
Beverage_STCOGS,
Food_STCOGS,
GrossCOGS_STCOGS,
//cast(concat(
//    cast(
//        cast(coalesce(
//BevCost_STCOGS,0) * 100 as abap.dec(15,2))
//        as abap.char(20)
//    ),
//    ' %'
//) as  abap.char( 40 )) as
 cast(
    case 
        when coalesce(Beverage_FGR, 0) <> 0 then
            coalesce(Beverage_STCOGS, 0) / coalesce(Beverage_FGR, 0) * 100
//        else 0
    end
    as abap.dec(15,2)
) as BevCost_STCOGS,


//cast(concat(
//    cast(
//        cast(coalesce(
//FoodCost_STCOGS,0) * 100 as abap.dec(15,2))
//        as abap.char(20)
//    ),
//    ' %'
//) as  abap.char( 40 )) as
// cast(
//    case 
//        when coalesce(Food_FGR, 0) <> 0 then
//            coalesce(Food_STCOGS, 0) / coalesce(Food_FGR, 0)
//        else 0
//    end 
//as abap.dec(15,2)) as FoodCost_STCOGS,
cast(
    concat(
        cast(
            round(
                case 
                    when coalesce(Food_FGR, 0) <> 0 then
                        ( coalesce(Food_STCOGS, 0) / coalesce(Food_FGR, 0) ) * 100
//                    else 0
                end, 
            2) 
        as abap.char(20)),
        ' %'
    ) 
as abap.char(40)) as FoodCost_STCOGS ,
      
cast(
    concat(
        cast(
            round(
                case 
                    when coalesce(Beverage_FGR, 0) + coalesce(Food_FGR, 0) + coalesce(Scrap_FGR, 0) <> 0 then
                        ( coalesce(Beverage_STCOGS, 0) + coalesce(Food_STCOGS, 0) )
                        / ( coalesce(Beverage_FGR, 0) + coalesce(Food_FGR, 0) + coalesce(Scrap_FGR, 0) ) * 100
                        
//                    else 0
                end,
            2)
        as abap.char(20)),
        ' %'
    )
as abap.char(40)) as FBGross_COGSPercentage,

 cast(
    concat(
        cast(
            round(
                case 
                    when coalesce(Beverage_FGR, 0) + coalesce(Food_FGR, 0) + coalesce(Scrap_FGR, 0) <> 0 then
                        ( coalesce(Packaging_cogs, 0) )
                        / ( coalesce(Beverage_FGR, 0) + coalesce(Food_FGR, 0) + coalesce(Scrap_FGR, 0) )
                        
//                    else 0
                end,
            2)
        as abap.char(20)),
        ' %'
    )
as abap.char(40)) as PACKAGINGGross_COGSPercentage,
cast(concat(
    cast(
        cast(coalesce(
LPGGAS_COGSPercentage,0) as abap.dec(15,2))
        as abap.char(20)
    ),
    ' %'
) as  abap.char( 40 )) as LPGGAS_COGSPercentage,
cast(concat(
    cast(
        cast(coalesce(
CharcoalGross_COGSPercentage,0)  as abap.dec(15,2))
        as abap.char(20)
    ),
    ' %'
) as  abap.char( 40 )) as CharcoalGross_COGSPercentage,

  cast(
          case when (Beverage_FGR + Food_FGR + Scrap_FGR) <> 0 then
              (coalesce(Consumable_COGS, 0) ) /
              (Beverage_FGR + Food_FGR + Scrap_FGR)
//          else 0
           end
          as abap.dec(15,2)
      ) as ConsumableGross_COGSPercentage,

////cast(concat(
////    cast(
////        cast(coalesce(
////ConsumableGross_COGSPercentage,0)  as abap.dec(15,2))
////        as abap.char(20)
////    ),
////    ' %'
////) as  abap.char( 40 )) as ConsumableGross_COGSPercentage,
cast(concat(
    cast(
        cast(coalesce(
HKEEPINGGross_COGSPercentage,0)  as abap.dec(15,2))
        as abap.char(20)
    ),
    ' %'
) as  abap.char( 40 )) as HKEEPINGGross_COGSPercentage,
Beverage_STCOGS as
 GrossnetcostBev_Percentage,
 Food_STCOGS as Grossnetfood_Percentage,
 cast(
    concat(
        cast(
            round(
                case 
                    when coalesce(Beverage_FGR, 0) <> 0 then
                        ( coalesce(Beverage_STCOGS, 0) / coalesce(Beverage_FGR, 0) ) * 100
//                    else 0
                end,
            2)
        as abap.char(20)),
        ' %'
    )
as abap.char(40)) as BevCost_totalPercentage,
cast(
    concat(
        cast(
            round(
                case 
                    when coalesce(Food_FGR, 0) <> 0 then
                        ( coalesce(Food_STCOGS, 0) / coalesce(Food_FGR, 0) ) * 100
//                    else 0
                end,
            2)
        as abap.char(20)),
        ' %'
    )
as abap.char(40)) as FoodCost_totalPercentage,
//cast(concat(
//    cast(
//        cast(coalesce(FoodCost_totalPercentage,0)  as abap.dec(15,2))
//        as abap.char(20)
//    ),
//    ' %'
//) as  abap.char( 40 )) as FoodCost_totalPercentage,

//cast(concat(
//    cast(
//        cast(coalesce(
//foodBevcostPercentage,0) as abap.dec(15,2))
//        as abap.char(20)
//    ),
//    ' %'
//) as  abap.char( 40 )) as foodBevcostPercentage,

cast(
    concat(
        cast(
            round(
                case 
                    when coalesce(Beverage_FGR, 0) + coalesce(Food_FGR, 0) + coalesce(Scrap_FGR, 0) <> 0 then
                        ( ( coalesce(Beverage_STCOGS, 0) + coalesce(Food_STCOGS, 0) )
                          / coalesce(Total_FGR_Sept1, 0) * 100
                        ) 
//                    else 0
                end,
            2)
        as abap.char(20)),
        ' %'
    )
as abap.char(40)) as foodBevcostPercentage,
--TOTAL FIXED COGS GROUP
concat(
  cast(
    cast(
      case 
        when Total_FGR_Sept1 <> 0 then
          ( coalesce(GrossCOGS_STCOGS, 0) +
            coalesce(Packaging_cogs, 0) +
            coalesce(LP_cogs, 0) +
            coalesce(Charcoal_COGS, 0) +
            coalesce(Non_Food_GST, 0) +
            coalesce(FI_GL_Charcoal, 0)
          ) / coalesce(Total_FGR_Sept1, 0) * 100
//        else 0
      end
    as abap.dec(15,2))  -- First cast to DEC
  as abap.char(20)),     -- Then cast to CHAR for CONCAT
  '%'
) as FBPKLPCHAR,
--FBPKLPPercentage,
cast(
case 
  when Total_FGR_Sept1 <> 0 then  
  coalesce(Spoilage_STCOGS,0) / (Total_FGR_Sept1) else 0 end
         as abap.dec(15,2) )as SpoilageCOGS,
 cast(concat(
    cast(
        cast(coalesce(
         
 CostpAug24_FB,0) as abap.dec(15,2))
        as abap.char(20)
    ),
    ' %' ) as  abap.char( 40 )) as CostpAug24_FB,
cast(concat(
    cast(
        cast(coalesce(

CostpAug24_COGS,0)  as abap.dec(15,2))
        as abap.char(20)
    ),
    ' %' ) as  abap.char( 40 )) as CostpAug24_COGS,
    
 cast(concat(
    cast(
        cast(
            ( coalesce(foodBevcostPercentage, 0) - coalesce(CostpAug24_COGS, 0) ) 
            as abap.dec(15,2)
        ) 
        as abap.char(20)
    ),
    ' %' ) as  abap.char( 40 )
) as Cogs_FGPercentage
,
//concat(
//    cast(
//        cast(
//            (
//                (
//                 ( coalesce(GrossCOGS_STCOGS, 0) +
//            coalesce(Packaging_cogs, 0) +
//            coalesce(LP_cogs, 0) +
//            coalesce(Charcoal_COGS, 0) +
//            coalesce(Non_Food_GST, 0) +
//            coalesce(FI_GL_Charcoal, 0)
//          ) / coalesce(Total_FGR_Sept1, 0) 
//                ) 
//            ) 
//            as abap.dec(15,2)
//        )
//        as abap.char(20)
//    ),
//    ' %'
//) as Cogs_COGSPercentage
concat(
    cast(
        cast(
            case 
                when coalesce(Total_FGR_Sept1,0) <> 0
                then
                    (
                      coalesce(GrossCOGS_STCOGS, 0) +
                      coalesce(Packaging_cogs, 0) +
                      coalesce(LP_cogs, 0) +
                      coalesce(Charcoal_COGS, 0) +
                      coalesce(Non_Food_GST, 0) +
                      coalesce(FI_GL_Charcoal, 0)
                    )
                    / coalesce(Total_FGR_Sept1,0)
                else 0
            end
        as abap.dec(15,2))
    as abap.char(20)),
    ' %'
) as Cogs_COGSPercentage

,
 Bugsvssales,
 Remark    
   
   
}

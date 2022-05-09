select 					 SUM(AdjustedSales)	YTDSales,
					 SUM(AdjustedGP)   	YTDGP,
					 SUM(AdjustedQTYSold)	YTDQTYSold
				  FROM tblSnapAdjustedMonthlySKUSales
			                  WHERE iYearMonth  >= '01/01/2010'
				        and iYearMonth  < '08/01/2010'
				        
/*
YTDSales		YTDGP			YTDQTYSold
41,868,173.688	18,741,396.191	1,244,751
*/				        

select 					 SUM(AdjustedSales)	YTDSales,
					 SUM(AdjustedGP)   	YTDGP,
					 SUM(AdjustedQTYSold)	YTDQTYSold
				  FROM vwAdjustedDailySKUSales
			                  WHERE dtDate  >= '01/01/2010'
				        and dtDate  < '08/01/2010'
				        
/*
YTDSales	YTDGP	YTDQTYSold
41,870,368.558	18,742,459.651	1,244,764
*/			    








/******** daily view vs monthly snapshot CHECKs ***********/
select 			    tblSnapAdjustedMonthlySKUSales.ixSKU, 
					SUM(AdjustedSales)	YTDSales,
					 SUM(AdjustedGP)   	YTDGP,
					 SUM(AdjustedQTYSold)	YTDQTYSold
				  FROM tblSnapAdjustedMonthlySKUSales
					left join tblVendorSKU VS on VS.ixSKU = tblSnapAdjustedMonthlySKUSales.ixSKU
			                  WHERE iYearMonth  >= '07/01/2010'
				        and iYearMonth  < '08/01/2010'
				        and VS.ixVendor = '1713'
				        and VS.iOrdinality = '1'
group by tblSnapAdjustedMonthlySKUSales.ixSKU
--YTDSales	 YTDGP		YTDQTYSold
-- 	619.69	402.69		31			JAN'10
-- 	419.79	272.79		21			FEB'10
-- 	519.74	337.74		26			MAR'10
-- 	459.77	298.77		23			APR'10
-- 	579.71	376.71		29			MAY'10
-- 	479.76	311.76		24			JUN'10
-- 	499.75	324.75		25			JUL'10
-- 830,894 	 266,621 	17,366		01/01/2010-07/31/2010



select 				vwAdjustedDailySKUSales.ixSKU,	 SUM(AdjustedSales)	YTDSales,
					 SUM(AdjustedGP)   	YTDGP,
					 SUM(AdjustedQTYSold)	YTDQTYSold
				  FROM vwAdjustedDailySKUSales
					left join tblVendorSKU VS on VS.ixSKU = vwAdjustedDailySKUSales.ixSKU				  
			                  WHERE dtDate  >= '01/01/2010'
				        and dtDate  < '08/01/2010'
				        and VS.ixVendor = '1713'	
				        and VS.iOrdinality = '1'			        
group by vwAdjustedDailySKUSales.ixSKU				        
--YTDSales	 YTDGP		 YTDQTYSold
-- 	JAN'10
-- 	FEB'10
-- 	MAR'10
-- 	APR'10
-- 	MAY'10
-- 	JUN'10
-- 	JUL'10
-- 91085117	3578.21	2325.21	179     01/01/2010-07/31/2010

select DATEADD(mm, DATEDIFF(mm,0,'08/10/2010')-1, 0)-- 07/01/2010 first of the month for @Date	    
select DATEADD(mm, DATEDIFF(mm,0,'08/10/2010'), 0)  -- 08/01/2010

SELECT                           
                                                                   iYearMonth                                           Month01,
				  tblSnapAdjustedMonthlySKUSales.ixSKU,
					 SUM(AdjustedSales)	MonthSales,
					 SUM(AdjustedGP)   	MonthGP,
					 SUM(AdjustedQTYSold)	MonthQTYSold
				  FROM tblSnapAdjustedMonthlySKUSales
				  left join tblVendorSKU VS on VS.ixSKU = tblSnapAdjustedMonthlySKUSales.ixSKU
                  WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,'08/10/2010')-1, 0)    -- first of the month for @Date
				           and iYearMonth < DATEADD(mm, DATEDIFF(mm,0,'08/10/2010'), 0) -- first of the month for @Date
                                                                        and VS.ixVendor = '0106'   
				  GROUP BY iYearMonth,tblSnapAdjustedMonthlySKUSales.ixSKU
				  
				  
				  
--YTDSales	 YTDGP		 YTDQTYSold
-- 126,341 	 40,039 	 2,450 



SELECT                           
                                                                   iYearMonth                                           Month01,
				   ixSKU,
					 SUM(AdjustedSales)	MonthSales,
					 SUM(AdjustedGP)   	MonthGP,
					 SUM(AdjustedQTYSold)	MonthQTYSold
				  FROM tblSnapAdjustedMonthlySKUSales
			                  WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-1, 0)    -- first of the month for @Date
				           and iYearMonth < DATEADD(mm, DATEDIFF(mm,0,@Date), 0) -- first of the month for @Date
				           
				  GROUP BY iYearMonth, ixSKU
				  
				  
				  
select distinct ixSKU,iYearMonth 
from tblSnapAdjustedMonthlySKUSales
 			                  WHERE iYearMonth  >= '07/01/2010' -- 13865 rows
				        and iYearMonth  < '08/01/2010'				  
-- B bin inventory for JEF

SELECT PickBinNumber, COUNT(distinct SKU)
FROM
(
/*
DECLARE @BinLocation VARCHAR(10), @MinQty int, @MaxQty int

SELECT @BinLocation = '0', @MinQty = 1    , @MaxQty = 999999
*/
				
SELECT DISTINCT (CASE WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z01' AND 'Z24' THEN 'Z'
					  WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z26' AND 'Z75' THEN 'Z2'
					  ELSE SUBSTRING(BS.sPickingBin, 1, 1)							  
			     END) AS BinGroup
	 , BS.sPickingBin AS PickBinNumber
     , BS.ixSKU AS SKU
     , S.sDescription AS SKUDescription
     , ISNULL(BS.iSKUQuantity,0) AS PickBinQAV
     , ISNULL(SL.iQAV,0) AS SKUQAV
     , ISNULL(SL.iQOS,0) AS SKUQOS 
     , S.mPriceLevel1 
     , S.mLatestCost 'LatestUnitCost'
     , CAST(S.mLatestCost AS Money) CONVERTEDLatstCost
     , (ISNULL(SL.iQOS,0)* CAST(S.mLatestCost AS Money)) as 'ExtQOSCost'     
     , (S.mPriceLevel1-CAST(S.mLatestCost AS Money)) 'UnitGrossProfit'
     , ((S.mPriceLevel1-CAST(S.mLatestCost AS Money))/NULLIF(CAST(S.mPriceLevel1 AS Money),0)) 'UnitGPpercent'     
     , ISNULL(YTD.YTDQtySold,0) AS 'TwelveMonthSales'
     , ISNULL(BOM.YTDBOMQty,0) AS 'TwelveMonthBOM'
     , ISNULL(YTD.YTDQtySold,0) + ISNULL(BOM.YTDBOMQty,0) AS '12MoUsage' -- 12Mo Sales + 12Mo BOM
  --   , (ISNULL(SL.iQOS,0.0) / (ISNULL(YTD.YTDQtySold,0.00001) + ISNULL(BOM.YTDBOMQty,0.000001))) 'EstYrsStock'     
--, (ISNULL(SL.iQOS,0.0)*12 / (ISNULL(YTD.YTDQtySold,0.0)+ISNULL(BOM.YTDBOMQty,0.0)))  'EstMoOfStock'
     , S.dtCreateDate
     , VS.ixVendor
   , (CASE WHEN flgBackorderAccepted = 1 then 'Y'
 else 'N'
 END
 ) BOAccpeted
FROM tblBinSku BS --14,614 rows
LEFT JOIN tblSKU S ON S.ixSKU = BS.ixSKU
LEFT JOIN tblSKULocation SL ON SL.ixSKU = BS.ixSKU 
   AND SL.ixLocation = '99'
LEFT JOIN tblBin B ON B.ixBin = BS.ixBin
LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
-- 12 Month Sales (with Returns backed out) 
LEFT JOIN (SELECT ADS.ixSKU AS SKU
                , ISNULL(SUM(ADS.AdjustedQTYSold),0) AS YTDQtySold
		   FROM vwAdjustedDailySKUSales ADS
		   WHERE ADS.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		   GROUP BY ADS.ixSKU
          ) YTD on YTD.SKU = BS.ixSKU 
-- 12 Month BOM Qty            
LEFT JOIN (SELECT ST.ixSKU AS SKU
                , ISNULL(SUM(ST.iQty),0) * -1 AS YTDBOMQty 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		     and ST.sTransactionType = 'BOM' 
			 and ST.iQty < 0
		   GROUP BY ST.ixSKU
		  ) BOM ON BOM.SKU = BS.ixSKU   
WHERE BS.ixLocation = '99'  
  and BS.sPickingBin LIKE 'B%' --BS.sPickingBin LIKE '%' + @BinLocation + '%'
  and BS.sPickingBin <> 'BOM' 
  --where sku like '%' + @Sku + '%'    
 -- and ISNULL(YTD.YTDQtySold,0) BETWEEN @MinQty AND @MaxQty
  and S.flgIntangible = 0
  and S.flgDeletedFromSOP = '0'		
  and SUBSTRING(BS.sPickingBin, 1, 1) NOT IN ('!', '~') -- to exclude more essentially "non-tangible" SKUs 
  and B.flgDeletedFromSOP = '0' 
  and B.flgAvailablePicking = '1'
  and ISNULL(BS.iSKUQuantity,0) > 0
--ORDER BY --(ISNULL(SL.iQOS,0.0)*12 / (ISNULL(YTD.YTDQtySold,0.0)+ISNULL(BOM.YTDBOMQty,0.0))) DESC     , 
--        PickBinNumber
        --,ISNULL(BS.iSKUQuantity,0)
        --, TwelveMonthSales DESC
        
        
        
) x
GROUP BY PickBinNumber
ORDER BY COUNT(distinct SKU) DESC        
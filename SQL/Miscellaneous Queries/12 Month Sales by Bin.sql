-- select top 5 * from tng.tblskubase

-- 12 Month Sales by Bin
--   run on dw.speedway2.com
/* 12 Month Sales by Bin.rdl
    ver 21.30.1
*/
DECLARE @Location VARCHAR(10),  @BinLocation VARCHAR(10),   @MinQty int     ,@MaxQty int
SELECT  @Location = '99' , @BinLocation = 'BF',     @MinQty = 0     ,@MaxQty = 100    -- bin X01AA2            13,160
	
-- SKUs will not show on the report if they have a NEGATIVE 12 month sales value 
--    (more where returned than sold) unless @MinQty is set below 0
SELECT DISTINCT BS.ixLocation,
                (CASE WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z01' AND 'Z24' THEN 'Z'
					  WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z26' AND 'Z75' THEN 'Z2'
					  ELSE SUBSTRING(BS.sPickingBin, 1, 1)							  
			     END) AS BinGroup
	 , BS.sPickingBin AS PickBinNumber
     , SL.iPickingBinMin 'PickBinMIN'
     , SL.iPickingBinMax 'PickBinMAX'
     , SL.iCartonQuantity 'PickBinRestockUnit'
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
     ) BOAccpeted,
    AOW.ixSOPSKU,
    (CASE WHEN AOW.ixSOPSKU IS NOT NULL THEN 'Y'
    ELSE 'N'
    END
    ) AS 'AvailableOnWeb'
FROM tblBinSku BS --14,614 rows
    LEFT JOIN tblSKU S ON S.ixSKU = BS.ixSKU
    LEFT JOIN tblSKULocation SL ON SL.ixSKU = BS.ixSKU 
       AND SL.ixLocation = @Location
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
    LEFT JOIN (-- available on the Web
                SELECT TNG.ixSOPSKU
                FROM (  select s.ixSOPSKU 
                        from  tng.tblskubase AS b
                            inner JOIN  tng.tblskuvariant s ON b.ixSKUBase = s.ixSKUBase
                            inner JOIN  tng.tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
                            inner JOIN  tng.tblproductpage AS pp ON ppsb.ixProductPage = pp.ixProductPage
                        WHERE b.flgWebPublish = 1
                            AND s.flgPublish = 1
                            AND pp.flgActive = 1
                            AND dbo.fn_isProductSaleable(s.flgFactoryShip, s.flgDiscontinued, s.flgBackorderable, s.iTotalQAV, s.flgMTO) = 1
                    ) TNG  -- 63 seconds 171,260
               ) AOW on AOW.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = BS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 		  
WHERE BS.ixLocation = @Location
-- and S.ixSKU in ('2763714102','72515111') FOR TESTING/TROUBLESHOOTING ONLY
  and BS.sPickingBin LIKE '%' + @BinLocation + '%'
  --where sku like '%' + @Sku + '%'    
  and ISNULL(YTD.YTDQtySold,0) BETWEEN @MinQty AND @MaxQty
  and S.flgIntangible = 0
  and S.flgDeletedFromSOP = '0'		
  and SUBSTRING(BS.sPickingBin, 1, 1) NOT IN ('!', '~') -- to exclude more essentially "non-tangible" SKUs 
  and B.flgDeletedFromSOP = '0' 
  and B.flgAvailablePicking = '1'
ORDER BY --(ISNULL(SL.iQOS,0.0)*12 / (ISNULL(YTD.YTDQtySold,0.0)+ISNULL(BOM.YTDBOMQty,0.0))) DESC     , 
        PickBinNumber
       , TwelveMonthSales DESC
       
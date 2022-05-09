				
SELECT DISTINCT (CASE WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z01' AND 'Z24' THEN 'Z'
					  WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z26' AND 'Z75' THEN 'Z2'
					  ELSE SUBSTRING(BS.sPickingBin, 1, 1)							  
			     END) AS BinGroup
	 , BS.sPickingBin AS PickBinNumber
     , BS.ixSKU AS SKU
     , S.sDescription AS SKUDescription
     , ISNULL(BS.iSKUQuantity - BS.iQuantityCommitted,0) AS PickBinQAV
     , ISNULL(SL.iQAV,0) AS SKUQAV
     , ISNULL(SL.iQOS,0) AS SKUQOS 
     , ISNULL(YTD.YTDQtySold,0) AS TwelveMonthSales
     , ISNULL(BOM.YTDBOMQty,0) AS TwelveMonthBOM
     , S.dtCreateDate 
FROM tblBinSku BS --14,614 rows
LEFT JOIN tblSKU S ON S.ixSKU = BS.ixSKU
LEFT JOIN tblSKULocation SL ON SL.ixSKU = BS.ixSKU 
LEFT JOIN tblBin B ON B.ixBin = BS.ixBin
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
  and SL.ixLocation = '99'  
  and (CASE WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z01' AND 'Z24' THEN 'Z'
					  WHEN SUBSTRING(BS.sPickingBin, 1, 3) BETWEEN 'Z26' AND 'Z75' THEN 'Z2'
					  ELSE SUBSTRING(BS.sPickingBin, 1, 1)							  
			     END) IN (@BinGroup)
  and S.flgIntangible = '0' 
  and S.flgActive = '1'
  and S.flgDeletedFromSOP = '0'		
  and SUBSTRING(BS.sPickingBin, 1, 1) NOT IN ('!', '~') -- to exclude more essentially "non-tangible" SKUs 
 -- and B.flgDeletedFromSOP = '0' 
  and B.flgAvailablePicking = '1'
ORDER BY BinGroup
       , PickBinNumber
       , TwelveMonthSales DESC
	

 
						  
															
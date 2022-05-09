/*
 active SKUs in the web catalog with the following columns: 
 SKU, SOP Desc, Web Desc, Retail Price, Prime Vendor Cost, 
 GM, 12 Month Sales, Length, Width, Height, Actual Weight, 
 Dimensional Weight (Length x Width x Height) / 166
 */
 
 
SELECT CD.ixSKU
     , ISNULL(S.sWebDescription, S.sDescription) AS SKUDescription
     , S.sSEMACategory
     , S.sSEMASubCategory
     , S.sSEMAPart
     , CD.mPriceLevel1 AS CatalogPrice
     , S.mPriceLevel1
     , S.mAverageCost 
     , VS.mCost
     -- add in GM  $ AND %   
     , ISNULL(TMSales.Qty,0) - ISNULL(TMRtns.Qty,0) AS [12MoSales]
     , S.iLength
     , S.iWidth
     , S.iHeight
     , S.dWeight     
     , S.dDimWeight
     , ((iLength*iHeight*iWidth)/166.00) AS CalcDimWeight       
     , (CASE WHEN R.Rate > R2.Rate THEN R.Rate
             WHEN R2.Rate > R.Rate THEN R2.Rate
             ELSE R.Rate
          END) AS UPSRateSOP 
     --, (CASE WHEN R.Rate > R3.Rate THEN R.Rate
     --        WHEN R3.Rate > R.Rate THEN R3.Rate
     --        ELSE R.Rate
     --     END) AS UPSRateCalc                     
FROM tblCatalogDetail CD 
LEFT JOIN tblSKU S ON S.ixSKU = CD.ixSKU
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU AND iOrdinality = 1 
LEFT JOIN [SMITemp].dbo.ASC_UPS_Zone4_Rates R ON R.Weight = (CEILING(S.dWeight))
LEFT JOIN [SMITemp].dbo.ASC_UPS_Zone4_Rates R2 ON R2.Weight = (CEILING(S.dDimWeight))
--LEFT JOIN [SMITemp].dbo.ASC_UPS_Zone4_Rates R3 ON R3.Weight = (CEILING((iLength*iHeight*iWidth)/166.00))
LEFT JOIN (SELECT ixSKU 
                , SUM(iQuantity) AS Qty
           FROM tblOrderLine OL 
           WHERE dtOrderDate BETWEEN DATEADD(MM, -12, GETDATE()) AND GETDATE()
           GROUP BY ixSKU
          ) TMSales ON TMSales.ixSKU = CD.ixSKU
LEFT JOIN (SELECT ixSKU 
                , SUM(CMD.iQuantityCredited) AS Qty
           FROM tblCreditMemoDetail CMD 
           LEFT JOIN tblCreditMemoMaster  CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo
           WHERE CMM.dtCreateDate BETWEEN DATEADD(MM, -12, GETDATE()) AND GETDATE()
           GROUP BY ixSKU
          ) TMRtns ON TMRtns.ixSKU = CD.ixSKU          
WHERE CD.ixCatalog = 'WEB.15' 
  AND S.flgActive = 1 -- 126,581 
  AND S.flgIntangible = 0 
  AND S.flgDeletedFromSOP = 0 
ORDER BY ixSKU
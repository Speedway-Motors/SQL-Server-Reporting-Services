-- Top 50 by qty sold 
SELECT TOP 50 OL.ixSKU 
     , S.sDescription 
     , PRS.PRSPricing AS PRSPricing
     , S.mPriceLevel1 AS Retail 
     , SUM(OL.iQuantity) AS QtySold 
     , SUM(OL.mExtendedPrice) AS TotalMerch
     , SUM(OL.mExtendedCost) AS TotalCost
     , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP
FROM tblOrderLine OL 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder   
LEFT JOIN (SELECT CD.ixSKU AS SKU 
                , CD.mPriceLevel3 AS PRSPricing 
           FROM tblCatalogDetail CD 
           WHERE CD.ixCatalog = 'PRS13') PRS ON PRS.SKU = OL.ixSKU
WHERE OL.dtOrderDate BETWEEN '1/01/15' AND '1/22/15'  -- Changeout Dates for 12 month segmants
  AND flgLineStatus IN ('Shipped', 'Dropshipped')  
  AND O.sOrderType = 'PRS'
  AND O.sSourceCodeGiven LIKE '%PRS%'
  AND O.sOrderStatus = 'Shipped'  
  AND S.flgDeletedFromSOP = '0'     
  AND S.mPriceLevel1 >= 50  
  AND S.flgActive = '1'    
  AND OL.flgKitComponent = '0'  
  AND S.ixSKU NOT IN (SELECT ixSKU 
					  FROM tblBinSku 
					  WHERE ixLocation = 99 
					     AND sPickingBin LIKE 'SHOP%' 
					  )
  AND S.ixSKU NOT LIKE '121%'   
  AND (PRS.PRSPricing IS NULL OR PRS.PRSPricing >= 50)
GROUP BY OL.ixSKU
       , S.sDescription
       , PRS.PRSPricing
       , S.mPriceLevel1
ORDER BY SUM(OL.iQuantity) DESC        
--30 days = Sept, Apr, June, Nov -- 28 days = Feb

-- Top 50 by GP Margin 
SELECT TOP 50 OL.ixSKU 
     , S.sDescription 
     , PRS.PRSPricing AS PRSPricing
     , S.mPriceLevel1 AS Retail 
     , SUM(OL.iQuantity) AS QtySold 
     , SUM(OL.mExtendedPrice) AS TotalMerch
     , SUM(OL.mExtendedCost) AS TotalCost
     , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP
FROM tblOrderLine OL 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
LEFT JOIN (SELECT CD.ixSKU AS SKU 
                , CD.mPriceLevel3 AS PRSPricing 
           FROM tblCatalogDetail CD 
           WHERE CD.ixCatalog = 'PRS13') PRS ON PRS.SKU = OL.ixSKU     
WHERE OL.dtOrderDate BETWEEN '1/01/15' AND '1/22/15' -- Changeout Dates for 12 month segmants
  AND flgLineStatus IN ('Shipped', 'Dropshipped')  
  AND O.sOrderType = 'PRS'
  AND O.sSourceCodeGiven LIKE '%PRS%'
  AND O.sOrderStatus = 'Shipped'  
  AND S.flgDeletedFromSOP = '0'     
  AND S.mPriceLevel1 >= 50  
  AND S.flgActive = '1'    
  AND OL.flgKitComponent = '0'  
  AND S.ixSKU NOT IN (SELECT ixSKU 
					  FROM tblBinSku 
					  WHERE ixLocation = 99 
					     AND sPickingBin LIKE 'SHOP%' 
					  )
  AND S.ixSKU NOT LIKE '121%'   
  AND (PRS.PRSPricing IS NULL OR PRS.PRSPricing >= 50) 
GROUP BY OL.ixSKU
       , S.sDescription
       , PRS.PRSPricing
       , S.mPriceLevel1
ORDER BY SUM(mExtendedPrice) - SUM(mExtendedCost) DESC        
--30 days = Sept, Apr, June, Nov -- 28 days = Feb
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
                , CD.mPriceLevel4 AS PRSPricing 
           FROM tblCatalogDetail CD 
           WHERE CD.ixCatalog = 'PRS10') PRS ON PRS.SKU = OL.ixSKU
WHERE S.flgActive = '1'
  AND S.flgDeletedFromSOP = '0'     
  AND S.mPriceLevel1 >= 50
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped')
  AND O.sOrderType = 'PRS'
  AND O.sSourceCodeGiven LIKE '%PRS%'
  AND O.sOrderStatus = 'Shipped'
  AND OL.dtOrderDate BETWEEN '11/01/12' AND '11/30/12'  -- Changeout Dates for 12 month segmants 
  AND OL.flgKitComponent = '0'  
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
                , CD.mPriceLevel4 AS PRSPricing 
           FROM tblCatalogDetail CD 
           WHERE CD.ixCatalog = 'PRS10') PRS ON PRS.SKU = OL.ixSKU     
WHERE S.flgActive = '1'
  AND S.flgDeletedFromSOP = '0'     
  AND S.mPriceLevel1 >= 50  
  AND flgLineStatus IN ('Shipped', 'Dropshipped')
  AND O.sOrderType = 'PRS'
  AND O.sSourceCodeGiven LIKE '%PRS%'
  AND O.sOrderStatus = 'Shipped'
  AND OL.dtOrderDate BETWEEN '11/01/12' AND '11/30/12'  -- Changeout Dates for 12 month segmants 
  AND OL.flgKitComponent = '0'  
  AND (PRS.PRSPricing IS NULL OR PRS.PRSPricing >= 50) 
GROUP BY OL.ixSKU
       , S.sDescription
       , PRS.PRSPricing
       , S.mPriceLevel1
ORDER BY SUM(mExtendedPrice) - SUM(mExtendedCost) DESC        
--30 days = Sept, Apr, June, Nov -- 28 days = Feb
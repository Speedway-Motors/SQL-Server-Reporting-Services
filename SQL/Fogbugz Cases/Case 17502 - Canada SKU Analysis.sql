-- US Analysis

SELECT S.ixSKU 
     , S.sDescription AS Descr
     , S.mPriceLevel1 AS Retail
     , S.mAverageCost AS Cost 
     , S.ixPGC AS PGC
     , PGC.sDescription
     , PGC.ixMarket
     , RTRIM(S.sSEMACategory) AS Category
     , RTRIM(S.sSEMASubCategory) AS SubCategory
     , RTRIM(S.sSEMAPart) AS Part
     , SUM(mExtendedPrice) AS Merch
     , SUM(mExtendedCost) AS Cost 
     , SUM(OL.iQuantity) AS QtySold
FROM tblSKU S 
JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
WHERE S.flgActive = '1' 
  AND S.flgDeletedFromSOP = '0' 
  AND S.dtDiscontinuedDate > GETDATE() --??
  AND S.flgIntangible = '0' 
  AND PGC.ixMarket IN ('SR', 'B', 'R') 
  AND OL.dtShippedDate BETWEEN '01/01/12' AND '12/31/12' 
  AND (O.sShipToCountry = 'US'
   OR O.sShipToCountry IS NULL)
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderStatus = 'Shipped'
GROUP BY S.ixSKU 
       , S.sDescription 
       , S.mPriceLevel1 
       , S.mAverageCost  
       , S.ixPGC 
       , PGC.sDescription
       , PGC.ixMarket
       , S.sSEMACategory
       , S.sSEMASubCategory
       , S.sSEMAPart  
ORDER BY PGC.ixMarket
       , S.sSEMACategory
       , Merch DESC       
  
-- Canada Analysis

SELECT S.ixSKU 
     , S.sDescription AS Descr
     , S.mPriceLevel1 AS Retail
     , S.mAverageCost AS Cost 
     , S.ixPGC AS PGC
     , PGC.sDescription
     , PGC.ixMarket
     , RTRIM(S.sSEMACategory) AS Category
     , RTRIM(S.sSEMASubCategory) AS SubCategory
     , RTRIM(S.sSEMAPart) AS Part
     , SUM(mExtendedPrice) AS Merch
     , SUM(mExtendedCost) AS Cost 
     , SUM(OL.iQuantity) AS QtySold
FROM tblSKU S 
JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
WHERE S.flgActive = '1' 
  AND S.flgDeletedFromSOP = '0' 
  AND S.dtDiscontinuedDate > GETDATE() --??
  AND S.flgIntangible = '0' 
  AND PGC.ixMarket IN ('SR', 'B', 'R') 
  AND OL.dtShippedDate BETWEEN '01/01/12' AND '12/31/12' 
  AND O.sShipToCountry = 'CANADA'
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderStatus = 'Shipped'
GROUP BY S.ixSKU 
       , S.sDescription 
       , S.mPriceLevel1 
       , S.mAverageCost  
       , S.ixPGC 
       , PGC.sDescription
       , PGC.ixMarket
       , S.sSEMACategory
       , S.sSEMASubCategory
       , S.sSEMAPart  
ORDER BY PGC.ixMarket
       , S.sSEMACategory
       , Merch DESC     
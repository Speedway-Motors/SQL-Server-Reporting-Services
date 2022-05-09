

SELECT S.ixSKU AS SKU
     , S.sDescription AS Description
     , CD.ixCatalog AS Catalog
     , CD.mPriceLevel1 AS CatalogPrice
     , S.mLatestCost AS LatestCost
     , S.mAverageCost AS AverageCost
     , CM.dtStartDate AS StartDate
     , CM.dtEndDate AS EndDate 	
FROM tblCatalogDetail CD 
LEFT JOIN tblCatalogMaster CM ON CM.ixCatalog = CD.ixCatalog
LEFT JOIN tblSKU S ON S.ixSKU = CD.ixSKU
WHERE CM.dtEndDate >= '01/01/12' 
  AND (CD.mPriceLevel1 <= S.mLatestCost
         OR CD.mPriceLevel1 <= S.mAverageCost)     
  --1664 before adding additional conditions
  AND S.flgActive = '1' 
  --1248 before adding additional conditions
  AND S.flgDeletedFromSOP = '0'
  --1248 SKUs as of 07/27/12
ORDER BY CatalogPrice DESC
     
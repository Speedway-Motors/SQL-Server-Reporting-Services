SELECT OL.ixSKU 
     , ISNULL(S.sWebDescription, S.sDescription) AS Descript 
     , S.sSEMACategory
     , S.sSEMASubCategory
     , S.sSEMAPart
     , SUM(OL.iQuantity) AS TotQty
     , COUNT(DISTINCT O.ixOrder) AS OrdCnt 
     , COUNT(DISTINCT O.ixCustomer) AS CustCnt 
     , SUM(OL.mExtendedPrice) AS TotalRev 
     , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP
   --  , (SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost)) / (SUM(OL.mExtendedPrice)) AS 'GP%' 
FROM tblOrderLine OL 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblCustomer C ON C.ixCustomer = OL.ixCustomer
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder    
LEFT JOIN tblDate D ON D.ixDate = O.ixOrderDate
WHERE D.iYear = '2015' 
  AND OL.flgKitComponent = 0 
  AND OL.iQuantity > 0
  AND O.mMerchandise > 1 
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped') 
  AND O.sOrderType = 'PRS' -- 'MRR' 
  AND S.flgIntangible = 0
  AND O.ixOrder NOT LIKE '%-%' 
GROUP BY OL.ixSKU
       , S.sDescription
       , ISNULL(S.sWebDescription, S.sDescription)
       , S.sSEMACategory
       , S.sSEMASubCategory
       , S.sSEMAPart
ORDER BY TotalRev DESC       
       
  


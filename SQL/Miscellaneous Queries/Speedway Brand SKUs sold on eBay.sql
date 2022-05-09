-- top selling private label products on ebay 
-- speedway brand
-- 12 months 
-- listed in order of margin 
-- ignore cost less than .1 


SELECT OL.ixSKU
     , ISNULL(S.sWebDescription, S.sDescription) AS SKUDescription
     , B.sBrandDescription
     , S.mPriceLevel1
     , S.mAverageCost
     , SUM(iQuantity) AS TotQty
     , SUM(mExtendedPrice) AS TotMerch
     , SUM(mExtendedCost) AS TotCost 
FROM tblOrderLine OL
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU
LEFT JOIN tblBrand B ON B.ixBrand = S.ixBrand
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder
WHERE OL.dtOrderDate BETWEEN DATEADD(MM, -12, GETDATE()) AND GETDATE() 
  AND S.ixBrand NOT IN ('10191', '11032', '11311') 
  AND mAverageCost > 0.1 
  AND flgActive = 1 
  AND S.flgDeletedFromSOP = 0 
  AND OL.flgKitComponent = 0 
  AND flgLineStatus = 'Shipped' 
  AND O.sOrderType = 'Retail'
  AND O.sOrderChannel = 'AUCTION' 
  AND O.sOrderStatus = 'Shipped'                             
GROUP BY OL.ixSKU  
       , ISNULL(S.sWebDescription, S.sDescription)
       , B.sBrandDescription
       , S.mPriceLevel1
       , S.mAverageCost       
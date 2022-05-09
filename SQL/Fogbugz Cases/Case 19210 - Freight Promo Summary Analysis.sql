--SELECT SUM(O.mMerchandise) AS Sales 
--     , COUNT(DISTINCT O.ixOrder) AS OrdCnt 
--     , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM
--     , (CASE WHEN OSPS.PostPromoShipping = 0 THEN 'FREE'
--             WHEN OSPS.PostPromoShipping = 7.99 THEN 'FLAT'
--             WHEN OSPS.ixOrder IS NULL THEN 'NONE'
--             ELSE 'OTHER' 
--       END) AS FreightType 
--     , SUM (CASE WHEN OSPS.ixOrder IS NULL THEN O.mShipping
--             ELSE OSPS.PrePromoShipping
--           END) AS PreValue     
--     , SUM (CASE WHEN OSPS.ixOrder IS NULL THEN O.mShipping
--             ELSE OSPS.PostPromoShipping
--           END) AS PostValue              
--FROM tblOrder O 
--LEFT JOIN vwOrderShippingPromoSummary OSPS ON OSPS.ixOrder = O.ixOrder 
--WHERE dtShippedDate BETWEEN '01/01/13' AND '07/08/13' 
--  AND O.sOrderStatus = 'Shipped' 
--  AND O.sOrderChannel <> 'INTERNAL' 
--  AND O.sOrderType <> 'Internal' 
--GROUP BY (CASE WHEN OSPS.PostPromoShipping = 0 THEN 'FREE'
--               WHEN OSPS.PostPromoShipping = 7.99 THEN 'FLAT'
--               WHEN OSPS.ixOrder IS NULL THEN 'NONE'
--               ELSE 'OTHER' 
--         END) 
           
/* Updated Analysis Questions */ 

--Threshold Question  
SELECT O.ixOrder
     , SUM(O.mMerchandise) AS Sales 
     , COUNT(DISTINCT O.ixOrder) AS OrdCnt 
     , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM
     , SUM (CASE WHEN OSPS.ixOrder IS NULL THEN O.mShipping
             ELSE OSPS.PrePromoShipping
           END) AS PreValue     
     , SUM (CASE WHEN OSPS.ixOrder IS NULL THEN O.mShipping
             ELSE OSPS.PostPromoShipping
           END) AS PostValue    
     , (CASE WHEN SUM(O.mMerchandise) BETWEEN 0 AND 99.99 THEN 'Under100'
             WHEN SUM(O.mMerchandise) BETWEEN 100 AND 124.99 THEN 'Under125'
             WHEN SUM(O.mMerchandise) BETWEEN 125 AND 149.99 THEN 'Under150'
             WHEN SUM(O.mMerchandise) BETWEEN 150 AND 4000 THEN 'Over150'             
             ELSE 'OTHER' 
       END) AS Threshold                      
FROM tblOrder O 
LEFT JOIN vwOrderShippingPromoSummary OSPS ON OSPS.ixOrder = O.ixOrder 
WHERE dtShippedDate BETWEEN '01/01/13' AND '07/08/13' 
  AND O.sOrderStatus = 'Shipped' 
  AND O.sOrderChannel <> 'INTERNAL' 
  AND O.sOrderType <> 'Internal' 
  AND OSPS.PostPromoShipping = '7.99'
GROUP BY O.ixOrder  
--HAVING SUM(O.mMerchandise) BETWEEN 0 AND 99.99
ORDER BY Threshold, Sales DESC

--Free Freight Question  
SELECT O.ixOrder
     , SUM(O.mMerchandise) AS Sales 
     , COUNT(DISTINCT O.ixOrder) AS OrdCnt 
     , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM
     , SUM (CASE WHEN OSPS.ixOrder IS NULL THEN O.mShipping
             ELSE OSPS.PrePromoShipping
           END) AS PreValue     
     , SUM (CASE WHEN OSPS.ixOrder IS NULL THEN O.mShipping
             ELSE OSPS.PostPromoShipping
           END) AS PostValue    
     , (CASE WHEN SUM(O.mMerchandise) BETWEEN 0 AND 99.99 THEN 'Under100'
             WHEN SUM(O.mMerchandise) BETWEEN 100 AND 124.99 THEN 'Under125'
             WHEN SUM(O.mMerchandise) BETWEEN 125 AND 149.99 THEN 'Under150'
             WHEN SUM(O.mMerchandise) BETWEEN 150 AND 4000 THEN 'Over150'             
             ELSE 'OTHER' 
       END) AS Threshold                      
FROM tblOrder O 
LEFT JOIN vwOrderShippingPromoSummary OSPS ON OSPS.ixOrder = O.ixOrder 
WHERE dtShippedDate BETWEEN '01/01/13' AND '07/08/13' 
  AND O.sOrderStatus = 'Shipped' 
  AND O.sOrderChannel <> 'INTERNAL' 
  AND O.sOrderType <> 'Internal' 
  AND OSPS.PostPromoShipping = '7.99'
GROUP BY O.ixOrder  
--HAVING SUM(O.mMerchandise) BETWEEN 0 AND 99.99
ORDER BY Threshold, Sales DESC  
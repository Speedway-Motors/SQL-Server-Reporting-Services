--Alaina, go ahead and do this one using the new tblOrderPromoCodeXref table and the view vwOrderCombinedPromoSummary.
--  The PromoID's to use are 147-150 and 172-175 
-- 1/19/13 through 4/19/13 per Philip

SELECT TOP 10 *
FROM tblOrderPromoCodeXref

SELECT TOP 10 *
FROM vwOrderCombinedPromoSummary


-- 36 rows
SELECT O.sMatchbackSourceCode 
     --, SUM(O.mMerchandise) AS Sales
     --, SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
     --           ELSE 1 
     --      END) AS OrdCnt
     , SUM(ISNULL(TotalMerchandiseDiscount,0)) AS MerchDisc --Include shipping discount??            
     , SUM(ISNULL(TotalShippingDiscount,0)) AS ShipDisc
FROM tblOrderPromoCodeXref OPCX
LEFT JOIN tblOrder O ON O.ixOrder = OPCX.ixOrder 
LEFT JOIN vwOrderCombinedPromoSummary OCPS ON OCPS.ixOrder = OPCX.ixOrder 
WHERE (OPCX.ixPromoId BETWEEN '147' AND '150' 
   OR OPCX.ixPromoId BETWEEN '172' AND '175')
  AND O.dtShippedDate BETWEEN '1/19/13' AND '4/19/13' --dtOrderDate?? 
  AND O.sMatchbackSourceCode BETWEEN '34925' AND '34975'
  AND O.sOrderType <> 'Internal'
  AND O.sOrderChannel <> 'INTERNAL' 
  AND O.sOrderStatus = 'Shipped'
GROUP BY O.sMatchbackSourceCode  


--check... 34925 and 34926

SELECT O.* 
FROM tblOrder O
LEFT JOIN tblOrderPromoCodeXref OPCX ON OPCX.ixOrder = O.ixOrder 
WHERE sMatchbackSourceCode = '34925'
  AND dtShippedDate BETWEEN '1/19/13' AND '4/19/13' 
  AND O.sOrderType <> 'Internal'
  AND O.sOrderChannel <> 'INTERNAL' 
  AND O.sOrderStatus = 'Shipped'
  AND (OPCX.ixPromoId BETWEEN '147' AND '150' 
   OR OPCX.ixPromoId BETWEEN '172' AND '175')

SELECT *
FROM vwOrderCombinedPromoSummary 
WHERE ixOrder IN ('5168408', '5174404', '5189302', '5231001', '5238902', '5269004', '5283005', '5284406',
					'5300400', '5311407', '5341000', '5350900', '5482903', '5526003', '5591400', '5609907',  
				  '5729609', '5743000', '5889908')
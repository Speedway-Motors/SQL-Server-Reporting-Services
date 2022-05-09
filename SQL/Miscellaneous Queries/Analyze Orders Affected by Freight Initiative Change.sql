SELECT COUNT(DISTINCT FSE.ixOrder) 
FROM tblOrderFreeShippingEligible FSE 
LEFT JOIN tblOrder O ON O.ixOrder = FSE.ixOrder
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU
WHERE O.dtOrderDate BETWEEN '06/26/15' AND '7/13/15' -- 12,160
  AND O.sOrderStatus IN ('Shipped', 'Open') -- 11,696
  AND FSE.ixOrder IN (SELECT DISTINCT ixOrder 
                          FROM [SMITemp].dbo.ASC_OrdersAffected) -- 488	-- 11,243		  

-- 453 orders would have potentially been affected by this change 

SELECT COUNT(DISTINCT FSE.ixOrder) 
FROM tblOrderFreeShippingEligible FSE 
LEFT JOIN tblOrder O ON O.ixOrder = FSE.ixOrder
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU
WHERE O.dtOrderDate BETWEEN '06/26/15' AND '7/13/15' -- 12,160
  AND O.sOrderStatus IN ('Shipped', 'Open') -- 11,696
  AND FSE.ixOrder IN (SELECT DISTINCT ixOrder 
                          FROM [SMITemp].dbo.ASC_OrdersAffected) -- 488	-- 11,243		  
  AND FSE.flgFreeShippingAccepted = 1      
  
-- 285 orders that accepted the free shipping would have been affected by this change                        


SELECT COUNT (DISTINCT FSE.ixOrder) AS Records
     , SUM(O.mMerchandise) AS Merch
     , (SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) AS 'GM$'
     , (SUM(O.mMerchandise)-SUM(O.mMerchandiseCost))/(SUM(O.mMerchandise)) AS 'GM%'     
     , (SUM(O.mMerchandise)/COUNT(DISTINCT FSE.ixOrder)) AS AOV 
FROM tblOrderFreeShippingEligible FSE 
LEFT JOIN tblOrder O ON O.ixOrder = FSE.ixOrder
WHERE O.dtOrderDate BETWEEN '06/26/15' AND '7/13/15' -- 12,160
  AND O.sOrderStatus IN ('Shipped', 'Open') -- 11,696
  AND FSE.ixOrder IN (SELECT DISTINCT ixOrder 
                          FROM [SMITemp].dbo.ASC_OrdersAffected)
                          
                          
-- Records	Merch		GM$			GM%		AOV
--  453		$243,065	$84,638 	34.8%	$537       


SELECT COUNT (DISTINCT FSE.ixOrder) AS Records
     , SUM(O.mMerchandise) AS Merch
     , (SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) AS 'GM$'
     , (SUM(O.mMerchandise)-SUM(O.mMerchandiseCost))/(SUM(O.mMerchandise)) AS 'GM%'     
     , (SUM(O.mMerchandise)/COUNT(DISTINCT FSE.ixOrder)) AS AOV 
FROM tblOrderFreeShippingEligible FSE 
LEFT JOIN tblOrder O ON O.ixOrder = FSE.ixOrder
WHERE O.dtOrderDate BETWEEN '06/26/15' AND '7/13/15' -- 12,160
  AND O.sOrderStatus IN ('Shipped', 'Open') -- 11,696
  AND FSE.ixOrder IN (SELECT DISTINCT ixOrder 
                          FROM [SMITemp].dbo.ASC_OrdersAffected)
  AND FSE.flgFreeShippingAccepted = 1                                
                          
                          
-- Records	Merch		GM$			GM%		AOV
-- 285		$149,700	$51,403 	34.3%	$525           



SELECT COUNT(DISTINCT O.ixOrder) 
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU
WHERE O.dtOrderDate BETWEEN '07/14/14' AND '7/13/15' -- 561,039
  AND O.sOrderStatus IN ('Shipped', 'Open') -- 501,768
  AND O.sOrderType = 'Retail' -- 464,351
  AND (O.sShipToCountry IS NULL OR O.sShipToCountry = 'US') -- 458,545
  AND O.sShipToState NOT IN ('AK', 'HI') -- 456,956
  AND O.iShipMethod <> 8 -- 452,690
  AND O.ixOrder IN (SELECT DISTINCT ixOrder 
                    FROM [SMITemp].dbo.ASC_OrdersAffectedTwelveMonths) --10,289


SELECT COUNT (DISTINCT O.ixOrder) AS Records
     , SUM(O.mMerchandise) AS Merch
     , (SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) AS 'GM$'
     , (SUM(O.mMerchandise)-SUM(O.mMerchandiseCost))/(SUM(O.mMerchandise)) AS 'GM%'     
     , (SUM(O.mMerchandise)/COUNT(DISTINCT O.ixOrder)) AS AOV 
FROM tblOrder O 
WHERE O.dtOrderDate BETWEEN '07/14/14' AND '7/13/15' 
  AND O.sOrderStatus IN ('Shipped', 'Open') 
  AND O.sOrderType = 'Retail'
  AND (O.sShipToCountry IS NULL OR O.sShipToCountry = 'US')  
  AND O.sShipToState NOT IN ('AK', 'HI')  
  AND O.iShipMethod <> 8
  AND O.ixOrder IN (SELECT DISTINCT ixOrder 
                    FROM [SMITemp].dbo.ASC_OrdersAffectedTwelveMonths)
                                                   
-- Records	Merch			GM$			GM%		AOV
-- 10,289	$5,957,186		$2,053,942 	34.5%	$579    


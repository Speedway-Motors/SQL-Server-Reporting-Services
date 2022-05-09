-- Raw data of all orders shipped via free shipping since promotion began --37,204 Orders, 56,632 Packages 
/*****************************************     
SELECT DISTINCT O.ixOrder
     , O.iShipMethod
     , O.dtShippedDate 
     , COUNT(DISTINCT P.sTrackingNumber) AS TotalPkgs 
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder
LEFT JOIN tblShippingPromo SP ON SP.ixOrder = O.ixOrder
WHERE O.dtOrderDate BETWEEN '06/26/15' AND '10/6/15' 
  AND sOrderStatus = 'Shipped' 
  AND sOrderType = 'Retail'
  AND SP.ixPromoId IS NULL  
  AND O.mShipping = 0 
  AND O.mMerchandise > 99
  AND O.iShipMethod NOT IN (1, 8)
  AND sShipToCountry = 'US'
  AND flgIsBackorder = 0
  AND flgLineStatus = 'Shipped'
  AND iTotalTangibleLines > 0 
  AND O.dtShippedDate IS NOT NULL
GROUP BY O.ixOrder
       , O.iShipMethod
       , O.dtShippedDate 
HAVING COUNT(DISTINCT P.sTrackingNumber) > 0
ORDER BY dtShippedDate
**************************************************/
       

-- Raw data of all orders shipped via free shipping since promotion began by ship date/day of week 
/*****************************************     
SELECT O.dtShippedDate 
     , D.sDayOfWeek
     , COUNT(DISTINCT P.sTrackingNumber) AS TotalPkgs 
     , COUNT(DISTINCT O.ixOrder) AS TotalOrders
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder
LEFT JOIN tblShippingPromo SP ON SP.ixOrder = O.ixOrder
LEFT JOIN tblDate D ON D.dtDate = O.dtShippedDate
WHERE O.dtOrderDate BETWEEN '06/26/15' AND '10/6/15' 
  AND sOrderStatus = 'Shipped' 
  AND sOrderType = 'Retail'
  AND SP.ixPromoId IS NULL  
  AND O.mShipping = 0 
  AND O.mMerchandise > 99
  AND O.iShipMethod NOT IN (1, 8)
  AND sShipToCountry = 'US'
  AND flgIsBackorder = 0
  AND flgLineStatus = 'Shipped'
  AND iTotalTangibleLines > 0 
  AND O.dtShippedDate IS NOT NULL
GROUP BY O.dtShippedDate 
       , D.sDayOfWeek
HAVING COUNT(DISTINCT P.sTrackingNumber) > 0
ORDER BY dtShippedDate
**************************************************/



SELECT O.dtShippedDate
     , D.sDayOfWeek
     , COUNT(DISTINCT P.sTrackingNumber) AS TotalPkgs 
     , COUNT(DISTINCT O.ixOrder) AS TotalOrders 
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder
LEFT JOIN tblShippingPromo SP ON SP.ixOrder = O.ixOrder
LEFT JOIN tblDate D ON D.dtDate = O.dtShippedDate
WHERE O.dtOrderDate BETWEEN '06/26/15' AND '10/6/15' 
  AND sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal'
  AND flgIsBackorder = 0
  AND flgLineStatus = 'Shipped'
  AND iTotalTangibleLines > 0 
  AND O.dtShippedDate IS NOT NULL
  AND O.ixOrder NOT IN (SELECT DISTINCT O.ixOrder
						FROM tblOrder O 
						LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
						LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder
						LEFT JOIN tblShippingPromo SP ON SP.ixOrder = O.ixOrder
						LEFT JOIN tblDate D ON D.dtDate = O.dtShippedDate
						WHERE O.dtOrderDate BETWEEN '06/26/15' AND '10/6/15' 
						  AND sOrderStatus = 'Shipped' 
						  AND sOrderType = 'Retail'
						  AND SP.ixPromoId IS NULL  
						  AND O.mShipping = 0 
						  AND O.mMerchandise > 99
						  AND O.iShipMethod NOT IN (1, 8)
						  AND sShipToCountry = 'US'
						  AND flgIsBackorder = 0
						  AND flgLineStatus = 'Shipped'
						  AND iTotalTangibleLines > 0 
						  AND O.dtShippedDate IS NOT NULL
					  )
GROUP BY O.dtShippedDate
       , D.sDayOfWeek
HAVING COUNT(DISTINCT P.sTrackingNumber) > 0     
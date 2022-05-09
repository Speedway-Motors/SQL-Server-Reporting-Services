

SELECT D.iMonth
     , D.iISOWeek
     , COUNT (*) AS 'Order Count'
    -- , O.ixOrder
    -- , O.ixCustomer
     , SUM (O.mMerchandise) AS 'Merch'
     , SUM (O.mMerchandiseCost) AS 'Merch Cost'
     , O.dtOrderDate 
FROM tblOrder O
LEFT JOIN tblDate D ON D.dtDate = O.dtOrderDate 
WHERE O.sShipToCountry IN ('CA', 'CANADA')
  and O.sOrderStatus = 'Shipped'
  and O.sOrderType <> 'Internal'
  and O.sOrderChannel <> 'INTERNAL'
  and O.mMerchandise > 0
  and O.dtOrderDate BETWEEN '03/28/11' AND '03/25/12'
GROUP BY D.iMonth, D.iISOWeek, O.dtOrderDate  
ORDER BY iMonth, iISOWeek, O.dtOrderDate 

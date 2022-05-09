SELECT D.iPeriod
     , D.iPeriodYear
     , SUM(O.mMerchandise) AS 'Merch.'
     , SUM(O.mMerchandiseCost) AS 'Merch. Cost' 
     , SUM(O.mMerchandise - O.mMerchandiseCost) AS 'Gross Profit'
FROM tblOrder O 
LEFT JOIN tblDate D ON O.ixOrderDate = D.ixDate
WHERE --D.iPeriod = '1'
      D.iPeriodYear IN ('2011','2010')
  and O.sOrderChannel = 'WEB'
  and O.sOrderStatus = 'Shipped'
  and O.sOrderType <> 'Internal'
  and O.mMerchandise > '0'
GROUP by D.iPeriod
       , D.iPeriodYear
ORDER by D.iPeriodYear 
       , D.iPeriod
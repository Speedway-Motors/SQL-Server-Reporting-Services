/**********************************
**********************************
            2012 DATA 
*********************************            
**********************************/            

--To determine the expected numbers of orders // 2,310 rows
SELECT *
FROM tblOrder O
WHERE O.dtShippedDate BETWEEN '01/01/2012' AND '12/31/2012'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
ORDER BY mShipping DESC

--To determine the overall picture for the year 
SELECT MAX(mShipping) AS MaxShipping --394.30
     , COUNT(DISTINCT ixOrder) AS TotalOrders --2310
     , (SUM(mShipping))/(COUNT(DISTINCT ixOrder)) AS AvgOrderSize --16.4213
FROM tblOrder O
WHERE O.dtShippedDate BETWEEN '01/01/2012' AND '12/31/2012'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
  
--To breakdown the information by week   
SELECT D.iISOWeek
     , COUNT(DISTINCT ixOrder) AS TotalOrders
     , MAX(mShipping) AS MaxShipping
     , SUM(mShipping) AS TotalShipping
     , (SUM(mShipping))/(COUNT(DISTINCT ixOrder)) AS AvgOrderSize
FROM tblOrder O 
JOIN tblDate D ON D.ixDate = O.ixShippedDate 
WHERE O.dtShippedDate BETWEEN '01/01/2012' AND '12/31/2012'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
GROUP BY D.iISOWeek
ORDER BY D.iISOWeek  



/**********************************
**********************************
            2011 DATA 
*********************************            
**********************************/   

--To determine the expected numbers of orders // 3,200 rows
SELECT *
FROM tblOrder O
WHERE O.dtShippedDate BETWEEN '01/01/2011' AND '12/31/2011'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
ORDER BY mShipping DESC

--To determine the overall picture for the year 
SELECT MAX(mShipping) AS MaxShipping --525.30
     , COUNT(DISTINCT ixOrder) AS TotalOrders --3200
     , (SUM(mShipping))/(COUNT(DISTINCT ixOrder)) AS AvgOrderSize --12.9321
FROM tblOrder O
WHERE O.dtShippedDate BETWEEN '01/01/2011' AND '12/31/2011'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
  
--To breakdown the information by week   
SELECT D.iISOWeek
     , COUNT(DISTINCT ixOrder) AS TotalOrders
     , MAX(mShipping) AS MaxShipping
     , SUM(mShipping) AS TotalShipping
     , (SUM(mShipping))/(COUNT(DISTINCT ixOrder)) AS AvgOrderSize
FROM tblOrder O 
JOIN tblDate D ON D.ixDate = O.ixShippedDate 
WHERE O.dtShippedDate BETWEEN '01/01/2011' AND '12/31/2011'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
GROUP BY D.iISOWeek
ORDER BY D.iISOWeek  


/**********************************
**********************************
            2010 DATA 
*********************************            
**********************************/   

--To determine the expected numbers of orders // 2,688 rows
SELECT *
FROM tblOrder O
WHERE O.dtShippedDate BETWEEN '01/01/2010' AND '12/31/2010'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
ORDER BY mShipping DESC

--To determine the overall picture for the year 
SELECT MAX(mShipping) AS MaxShipping --407.45
     , COUNT(DISTINCT ixOrder) AS TotalOrders --2688
     , (SUM(mShipping))/(COUNT(DISTINCT ixOrder)) AS AvgOrderSize --17.491
FROM tblOrder O
WHERE O.dtShippedDate BETWEEN '01/01/2010' AND '12/31/2010'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
  
--To breakdown the information by week   
SELECT D.iISOWeek
     , COUNT(DISTINCT ixOrder) AS TotalOrders
     , MAX(mShipping) AS MaxShipping
     , SUM(mShipping) AS TotalShipping
     , (SUM(mShipping))/(COUNT(DISTINCT ixOrder)) AS AvgOrderSize
FROM tblOrder O 
JOIN tblDate D ON D.ixDate = O.ixShippedDate 
WHERE O.dtShippedDate BETWEEN '01/01/2010' AND '12/31/2010'
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
--  AND O.sOrderType NOT IN ('Internal','Customer Service')
--  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
--  AND O.mMerchandise > 0 
  AND O.iShipMethod IN ('6', '7') 
  AND O.mShipping > 0
GROUP BY D.iISOWeek
ORDER BY D.iISOWeek  
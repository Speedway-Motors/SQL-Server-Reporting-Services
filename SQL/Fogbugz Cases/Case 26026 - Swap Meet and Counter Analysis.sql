SELECT *
FROM tblOrder O 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
WHERE dtShippedDate = '4/25/15' 
  AND (sOrderChannel = 'COUNTER' 
     OR iShipMethod = 1
       )  
  AND sOrderStatus = 'Shipped'
  
  
SELECT SUM(OL.mExtendedPrice) 
     , SUM(OL.mExtendedCost) 
     , M.sDescription
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
LEFT JOIN tblMarket M ON M.ixMarket = PGC.ixMarket
WHERE O.dtShippedDate = '4/25/15' 
  AND (sOrderChannel = 'COUNTER' 
     OR iShipMethod = 1
       )  
  AND sOrderStatus = 'Shipped'  
  AND flgLineStatus IN ('Shipped', 'Dropshipped')  
GROUP BY M.sDescription   


  
SELECT SUM(OL.mExtendedPrice) 
     , SUM(OL.mExtendedCost) 
     , M.sDescription
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
LEFT JOIN tblMarket M ON M.ixMarket = PGC.ixMarket
WHERE O.dtShippedDate = '4/26/14' 
  AND (sOrderChannel = 'COUNTER' 
     OR iShipMethod = 1
       )  
  AND sOrderStatus = 'Shipped'  
  AND flgLineStatus IN ('Shipped', 'Dropshipped')  
GROUP BY M.sDescription   
  
  
SELECT SUM(mMerchandise) AS Merch 
     , COUNT(DISTINCT ixOrder) AS Orders
     , dtShippedDate
FROM tblOrder O 
LEFT JOIN tblDate D ON D.ixDate = O.ixShippedDate
WHERE dtShippedDate BETWEEN '01/01/15' AND GETDATE() 
  AND D.sDayOfWeek = 'SATURDAY'
  AND (sOrderChannel = 'COUNTER' 
     OR iShipMethod = 1
       )  
  AND sOrderStatus = 'Shipped'
GROUP BY dtShippedDate
ORDER BY dtShippedDate
         

  
SELECT SUM(mMerchandise) AS Merch
     , COUNT(DISTINCT ixOrder) AS Orders
     , dtShippedDate
FROM tblOrder O 
LEFT JOIN tblDate D ON D.ixDate = O.ixShippedDate
WHERE dtShippedDate BETWEEN '01/01/14' AND '12/31/14'
  AND D.sDayOfWeek = 'SATURDAY'
  AND (sOrderChannel = 'COUNTER' 
     OR iShipMethod = 1
       )  
  AND sOrderStatus = 'Shipped'
GROUP BY dtShippedDate
ORDER BY dtShippedDate
                  
                  

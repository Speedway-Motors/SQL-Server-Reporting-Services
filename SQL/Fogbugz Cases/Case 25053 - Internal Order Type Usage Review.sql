

SELECT COUNT (DISTINCT O.ixOrder) AS OrdCnt  
     , MAX(O.dtOrderDate) AS MostRecent 
     , SUM(mMerchandise) AS TotalMerch
     , O.sOrderTaker
     , E.sLastname + ', ' + E.sFirstname AS Name 
FROM tblOrder O 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
LEFT JOIN tblEmployee E ON E.ixEmployee = sOrderTaker
WHERE dtOrderDate BETWEEN '7/1/14' AND GETDATE() 
  AND sOrderChannel = 'INTERNAL' 
  AND sOrderType = 'Internal'
  AND C.ixCustomerType NOT IN ('45','46','82.1') 
  --AND sSourceCodeGiven <> 'INTERNAL'
  AND sOrderStatus = 'Shipped'
  AND mMerchandise > 1 
  AND (sMethodOfPayment = 'CASH' OR iTotalTangibleLines > 0)
  AND sOrderTaker NOT IN ('JJM', 'KDL', 'PRG')
GROUP BY O.sOrderTaker
     , E.sLastname + ', ' + E.sFirstname    
ORDER BY OrdCnt DESC
  
  
  



SELECT O.ixOrder 
     , O.dtOrderDate
     , mMerchandise
     , O.sOrderTaker
     , E.sLastname + ', ' + E.sFirstname AS Name 
FROM tblOrder O 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
LEFT JOIN tblEmployee E ON E.ixEmployee = sOrderTaker
WHERE dtOrderDate BETWEEN '7/1/14' AND GETDATE() 
  AND sOrderChannel = 'INTERNAL' 
  AND sOrderType = 'Internal'
  AND C.ixCustomerType NOT IN ('45','46','82.1') 
  --AND sSourceCodeGiven <> 'INTERNAL'
  AND sOrderStatus = 'Shipped'
  AND mMerchandise > 1 
  AND (sMethodOfPayment = 'CASH' OR iTotalTangibleLines > 0)
  AND sOrderTaker NOT IN ('JJM', 'KDL', 'PRG')
ORDER BY sOrderTaker
  

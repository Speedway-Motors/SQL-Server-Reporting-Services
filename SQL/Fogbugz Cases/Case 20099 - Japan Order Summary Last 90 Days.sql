
--customers 545355,710966,1326977, and 1284270 all have Japan as their mailing country address 
--but shipped elsewhere 
SELECT DISTINCT C.ixCustomer
     , sCustomerType
     , sCustomerFirstName
     , sCustomerLastName
     , sEmailAddress
     , SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS OrdCnt 
     , SUM(mMerchandise) AS Merch 
FROM tblCustomer C 
LEFT JOIN tblOrder O ON O.ixCustomer = C.ixCustomer
WHERE dtOrderDate BETWEEN DATEADD(dd, -90, GETDATE()) AND GETDATE()
  AND O.sOrderStatus = 'Shipped' 
  AND C.sMailToCountry LIKE 'JAP%'       
GROUP BY C.ixCustomer
       , sCustomerType
       , sCustomerFirstName
       , sCustomerLastName
       , sEmailAddress   

--ADD in customer 1084571 shipped to Japan but mailing country address is null        
SELECT DISTINCT C.ixCustomer
     , sCustomerType
     , sCustomerFirstName
     , sCustomerLastName
     , sEmailAddress
     , SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS OrdCnt 
     , SUM(mMerchandise) AS Merch 
FROM tblCustomer C 
LEFT JOIN tblOrder O ON O.ixCustomer = C.ixCustomer
WHERE dtOrderDate BETWEEN DATEADD(dd, -90, GETDATE()) AND GETDATE()
  AND O.sOrderStatus = 'Shipped' 
  AND C.ixCustomer = '1084571'    
GROUP BY C.ixCustomer
       , sCustomerType
       , sCustomerFirstName
       , sCustomerLastName
       , sEmailAddress         
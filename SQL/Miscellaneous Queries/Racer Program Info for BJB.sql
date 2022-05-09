-- USE SMI

SELECT C.ixCustomer
     , sCustomerFirstName
     , sCustomerLastName
     , LY.TotalSpend
     , TY.TotalSpend
FROM tblCustomer C 
LEFT JOIN (SELECT SUM(mMerchandise) AS TotalSpend
		        , O.ixCustomer 
		   FROM tblOrder O 
		   WHERE dtOrderDate BETWEEN '01/01/14' AND '12/31/14'
		     AND O.sOrderStatus = 'Shipped' 
		   GROUP BY O.ixCustomer
		  ) LY ON LY.ixCustomer = C.ixCustomer
LEFT JOIN (SELECT SUM(mMerchandise) AS TotalSpend
		        , O.ixCustomer 
		   FROM tblOrder O 
		   WHERE dtOrderDate BETWEEN '01/01/15' AND '12/31/15'
		     AND O.sOrderStatus = 'Shipped' 
		   GROUP BY O.ixCustomer
		  ) TY ON TY.ixCustomer = C.ixCustomer		  
WHERE C.ixCustomerType = '44' 
  AND (LY.TotalSpend > 0 
        OR TY.TotalSpend > 0)
ORDER BY sCustomerLastName        

-- Use AFCO 

SELECT C.ixCustomer
     , sCustomerFirstName
     , sCustomerLastName
     , LY.TotalSpend
     , TY.TotalSpend
FROM tblCustomer C 
LEFT JOIN (SELECT SUM(mMerchandise) AS TotalSpend
		        , O.ixCustomer 
		   FROM tblOrder O 
		   WHERE dtOrderDate BETWEEN '01/01/14' AND '12/31/14'
		     AND O.sOrderStatus = 'Shipped' 
		   GROUP BY O.ixCustomer
		  ) LY ON LY.ixCustomer = C.ixCustomer
LEFT JOIN (SELECT SUM(mMerchandise) AS TotalSpend
		        , O.ixCustomer 
		   FROM tblOrder O 
		   WHERE dtOrderDate BETWEEN '01/01/15' AND '12/31/15'
		     AND O.sOrderStatus = 'Shipped' 
		   GROUP BY O.ixCustomer
		  ) TY ON TY.ixCustomer = C.ixCustomer		  
WHERE C.ixCustomer IN ( '14223', '11286', '22463', '16569') 
  AND (LY.TotalSpend > 0 
        OR TY.TotalSpend > 0)
ORDER BY sCustomerLastName        
   
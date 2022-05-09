SELECT DISTINCT O.ixCustomer --19,803
     , COUNT (DISTINCT O.ixOrder) CNT
     , C.sCustomerFirstName
     , C.sCustomerLastName
     , C.sMailToCity
     , C.sMailToState
     , C.sMailToZip     
     , C.sMailToCountry
	 , C.sEmailAddress
	 , C.sDayPhone
FROM tblOrder O
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE dtShippedDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
  AND sOrderChannel = 'AUCTION'
  AND sOrderType <> 'Internal' 
  AND sOrderStatus = 'Shipped' 
  AND C.flgDeletedFromSOP = '0'
GROUP BY O.ixCustomer --19,803
     , C.sCustomerFirstName
     , C.sCustomerLastName
     , C.sMailToCity
     , C.sMailToState
     , C.sMailToZip     
     , C.sMailToCountry
	 , C.sEmailAddress
	 , C.sDayPhone  
ORDER BY CNT DESC
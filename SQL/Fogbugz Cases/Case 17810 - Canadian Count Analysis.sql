SELECT DISTINCT C.ixCustomer --7,682 customers in the starting pool
FROM dbo.ASC_DistinctCanadianBillingCustomers DC 
LEFT JOIN [SMI Reporting].dbo.tblCustomer C ON C.ixCustomer = DC.ixCustomer 
WHERE C.sMailToCountry NOT IN ('CANADA', 'CA', 'CAN') --62 customers with a non-Canadian mailing address but a Canadian billing address
  AND C.sEmailAddress IS NOT NULL -- 60 of the above customers have email addresses on file

SELECT DISTINCT O.ixCustomer --starting pool of 7,682 customers
FROM dbo.ASC_DistinctCanadianBillingCustomers DC 
LEFT JOIN [SMI Reporting].dbo.tblOrder O ON O.ixCustomer = DC.ixCustomer 
LEFT JOIN [SMI Reporting].dbo.tblCustomer C ON C.ixCustomer = DC.ixCustomer 
WHERE O.sShipToCountry NOT IN ('CANADA', 'CA', 'CANADA 57H0G1') --2,937 customers
  AND O.dtOrderDate BETWEEN DATEADD(mm,-72,GETDATE()) AND GETDATE() --2,868 customers
  AND O.sOrderType <> 'Internal' --2,857 customers
  AND O.sOrderChannel <> 'INTERNAL' --2,849 customers
  AND O.mMerchandise > 1 --2,841 customers
  AND O.sOrderStatus = 'Shipped' --2,799 customers
  AND C.sEmailAddress IS NOT NULL --2,383 of the above customers have email addresses on file

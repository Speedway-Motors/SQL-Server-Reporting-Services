-- Case 18345 - Canadian 72M buyers with invalid Postal Codes

select C.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName,  
C.sMailToState, C.sMailToZip, C.sEmailAddress
from [SMI Reporting].dbo.tblCustomer C
WHERE (C.sMailingStatus is NULL OR C.sMailingStatus = '0')      
  and C.sCustomerType = 'Retail'
  and C.flgDeletedFromSOP = 0
  and C.ixCustomer in ( -- Customers who've ordered in last 72 months
                     select distinct ixCustomer 
                     from [SMI Reporting].dbo.tblOrder 
                     where sOrderStatus = 'Shipped'
                         and dtShippedDate >= DATEADD(yy, -6, getdate()) 
                     )  
                     -- 2,358 customers ordered in the past 72 months
                     -- 5,938 customers ordered in entire Order History
/*** SPECIFICS FOR CANADA ****/
    and  C.sMailToCountry = 'CANADA'
    and len(sMailToZip) NOT between 6 and 7
    and C.sEmailAddress is NOT NULL
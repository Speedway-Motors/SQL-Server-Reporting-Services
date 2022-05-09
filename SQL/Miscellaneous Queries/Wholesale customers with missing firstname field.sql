-- Wholesale customers with missing firstname field
select distinct sCustomerType
from tblCustomer
where flgDeletedFromSOP = 0 
/*
MRR
Other
PRS
Retail
*/


select ixCustomer, sCustomerType, sCustomerFirstName, sCustomerLastName, sMailToCity, sMailToState,sMailToZip,sMailToCountry, dtAccountCreateDate
from tblCustomer
where sCustomerType in ('PRS','MRR')
and sCustomerFirstName is NULL
and ixCustomer in (-- has sales in the last 36 months
                   select ixCustomer 
                   from tblOrder 
                   where dtOrderDate >= '05/12/2011' and sOrderStatus = 'Shipped'
                   )
order by dtAccountCreateDate desc




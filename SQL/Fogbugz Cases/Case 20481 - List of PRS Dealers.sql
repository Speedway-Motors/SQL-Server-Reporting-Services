-- Case 20481 - List of PRS Dealers

select sCustomerType, count(*)
from tblCustomer
group by sCustomerType
order by count(*) desc
/*
sCustomerType	Qty
Retail	        1,449,056
Other	            9,273
MRR	                  657
PRS	                  380
*/


SELECT ixCustomer 'Cust #'  
    ,sCustomerFirstName
    ,sCustomerLastName
    ,iPriceLevel
  --  ,ixCustomerType
    ,sMailingStatus
    ,sEmailAddress
  --  ,flgDeletedFromSOP
FROM tblCustomer
WHERE sCustomerType = 'PRS'
    and flgDeletedFromSOP = 0
    and iPriceLevel in (3,4)
ORDER BY sMailingStatus desc -- flgDeletedFromSOP desc
/*
select * from tblSourceCode
where upper(ixSourceCode) like '%PLAT%'
*/

-- customer type of 41?

-- 84 dif customers from 2010 that had 1 or more orders with sSourceCodeGiven = 'PLATINUM'

SELECT O.ixCustomer,
      OL.ixSKU, 
      OL.iQuantity, 
      OL.mExtendedPrice
FROM tblOrder O
   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
WHERE O.sOrderStatus = 'Shipped'
   and O.dtShippedDate < '01/01/11'
	and O.dtShippedDate > '12/31/09'
   and O.sSourceCodeGiven = 'PLATINUM'

/*
select sCustomerType, count(*) CustCount
from tblCustomer
group by sCustomerType

sCustomerType	CustCount
Other	         10855
Retail	      7084
MRR	         15
PRS	         10
*/
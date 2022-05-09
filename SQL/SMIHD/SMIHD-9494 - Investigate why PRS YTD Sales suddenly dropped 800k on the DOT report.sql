-- SMIHD-9494 - Investigate why PRS YTD Sales suddenly dropped 800k on the DOT report
SELECT COUNT(*) 
FROM tblCustomer 
where sCustomerType = 'PRS'
and flgDeletedFromSOP = 0   -- 623 as of 12-22-17

select sCustomerType, COUNT(*)
from tblCustomer
where dtDateLastSOPUpdate >= '12/19/2017'
group by sCustomerType 


select distinct ixCustomer
from tblOrder
where dtOrderDate > '01/01/2017'
and ixCustomerType = '30'
and ixCustomer NOT IN (SELECT ixCustomer from tblCustomer where sCustomerType = 'PRS')

select * from tblCustomerType

select ixCustomer, SUM(mMerchandise)
from tblOrder
where ixCustomer in (1770000) -- 1232364,724980,421045,1109787,1265333,
and dtOrderDate > '01/01/2017'
and ixOrder NOT LIKE 'P%'
and ixOrder NOT LIKE 'Q%'
and sOrderStatus <> 'Cancelled'
group by ixCustomer

select distinct sOrderStatus from tblOrder


select ixCustomer, sCustomerLastName, ixCustomerType, sCustomerType
from tblCustomer
where ixCustomer = 1770000 -- (1232364,724980,421045,1109787,1265333)


select ixCustomer, SUM(mMerchandise)
from tblOrder
where ixCustomer in (1770000) -- 1232364,724980,421045,1109787,1265333,
and dtOrderDate > '01/01/2017'
and ixOrder NOT LIKE 'P%'
and ixOrder NOT LIKE 'Q%'
and sOrderStatus <> 'Cancelled'
and ixCustomerType = 30
group by ixCustomer
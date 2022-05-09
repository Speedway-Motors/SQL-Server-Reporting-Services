-- Case 18102 - Research non-internal order channels


To determine if an exception report is needed on the data warehouse
please let me know how me orders were placed that...

 

- Han an order date from 1.1.12-12.31.12

- and Customer flag of either "45" or "46"

- and any channel other than internal.







select C.ixCustomerType as 'CurrentCustFlag', 
    C.sCustomerType,
    C.ixCustomer,
    O.ixOrder, O.dtShippedDate,
    O.sOrderType, O.sOrderChannel,
    O.sMethodOfPayment, 
    O.sShipToZip
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where C.ixCustomerType in ('45','46')
    and O.dtOrderDate between '01/01/2012' and '12/31/2012'
    and O.sOrderType <> 'Internal'
    and O.sOrderStatus = 'Shipped'



select C.ixCustomerType as 'CurrentCustFlag', 
    C.sCustomerType,
    C.ixCustomer,
    O.ixOrder, O.dtShippedDate,
    O.sOrderType, O.sOrderChannel,
    O.sMethodOfPayment, 
    O.sShipToZip
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where C.ixCustomerType in ('45','46')
    and O.dtOrderDate between '01/01/2013' and '12/31/2013'
    and O.sOrderType <> 'Customer Service'
    AND O.sOrderChannel  'INTERNAL'
    
    and O.sOrderStatus = 'Shipped'


Order Channel is manually selected on EVERy order, there is no default



SELECT sOrderChannel,
count(*)
FROM tblOrder
group by sOrderChannel





SELECT sCustomerType,
count(*)
FROM tblCustomer
group by sCustomerType


select MIN(dtOrderDate) from tblOrder where flgDeviceType like 'MOBILE%'

select distinct flgDeviceType from tblOrder



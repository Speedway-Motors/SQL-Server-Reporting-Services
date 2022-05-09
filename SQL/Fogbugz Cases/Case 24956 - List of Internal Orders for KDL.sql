select C.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, C.sMailToCountry, C.sMailToState, 
-- C.ixAccountManager, 
C.ixCustomerType, C.sCustomerType, CT.sDescription 'TypeDescription',
C.ixSourceCode 'CustSC', O.sSourceCodeGiven,
O.sOrderType, O.sOrderChannel,
SUM(mMerchandise) Sales
from tblOrder O
join tblCustomer C on O.ixCustomer = C.ixCustomer
left join tblCustomerType CT on C.ixCustomerType = CT.ixCustomerType
where dtOrderDate >= '01/01/2014'
and sOrderStatus = 'Shipped'
and sOrderType = 'Internal' -- 1,056,000 
and sOrderChannel = 'INTERNAL' -- 1,257,000
and O.mMerchandise > 1 
group by C.ixCustomer, C.sCustomerFirstName, C
.sCustomerLastName, C.sMailToCountry, C.sMailToState, 
    --C.ixAccountManager, 
    C.ixCustomerType, C.sCustomerType, CT.sDescription, 
    C.ixSourceCode, O.sSourceCodeGiven,
    O.sOrderType, O.sOrderChannel    
order by SUM(mMerchandise) desc
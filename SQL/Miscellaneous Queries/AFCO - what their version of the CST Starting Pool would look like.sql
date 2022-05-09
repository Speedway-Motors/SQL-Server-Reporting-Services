-- AFCO - what their version of the CST Starting Pool would look like

-- AFCO retail buyers that have ordered in the last 6 years
select count(distinct C.ixCustomer)
from tblCustomer C                                  -- 27,200 total customers
    join tblOrder O on C.ixCustomer = O.ixCustomer
where C.flgDeletedFromSOP = 0
    and O.dtShippedDate > '09/09/2011'
    and O.sOrderStatus = 'Shipped'                  
    and O.mMerchandise > 0                          --  6,103 that have ordered in the last 6 years
    AND C.sCustomerType = 'Retail'                  --  3,659 <-- TOTAL size of their CST Starting Pool if they had one!?!



select C.sCustomerType, count(*)
from tblCustomer C
group by C.sCustomerType



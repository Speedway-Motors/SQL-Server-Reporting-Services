-- Customer Type Info for Ken

select * from tblCustomerType


SELECT COUNT(ixCustomer) CustCount, C.ixCustomerType 'CustType', CT.sDescription 'TypeDescription'
from tblCustomer C
    JOIN tblCustomerType CT on C.ixCustomerType = CT.ixCustomerType
where flgDeletedFromSOP = 0
and C.ixCustomerType NOT IN ('1','40','30')
group by C.ixCustomerType, CT.sDescription
order by COUNT(ixCustomer) desc

select ixCustomer, sCustomerType
from tblCustomer 
where ixCustomerType in ('50','60')
order by sCustomerType


SELECT ixCustomer, dtAccountCreateDate -- C.ixCustomerType 'CustType', CT.sDescription 'TypeDescription'
from tblCustomer C
    JOIN tblCustomerType CT on C.ixCustomerType = CT.ixCustomerType
where flgDeletedFromSOP = 0
and C.ixCustomerType = '20'
order by dtAccountCreateDate
order by 
-- Case 23031 - SAE and SCCA new customers

select * from tblCustomerOffer where ixSourceCode = '37882'


select Distinct O.ixCustomer, 
--O.ixOrder, O.sOrderStatus, 
C.dtAccountCreateDate -- 108 Orders, 94 Customers, 41 of which had accounts created BEFORE Febuary 2014
from tblOrder O
    join tblCustomer C on O.ixCustomer = C.ixCustomer
where (O.sSourceCodeGiven ='37882'
or O.sMatchbackSourceCode = '37882')
and O.sOrderStatus = 'Shipped'
and dtAccountCreateDate > = '02/01/2014'
ORDER BY dtAccountCreateDate


Select top 10 * from tblCustomer


select * from tblCustomer where ixSourceCode = '37882' 
order by dtAccountCreateDate
-- SMIHD-2468 - Customers with flag 20
select * from tblCustomer
where ixCustomerType = '20'
and flgDeletedFromSOP = 0
order by ixCustomer


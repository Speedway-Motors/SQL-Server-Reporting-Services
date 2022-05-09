11530


select * from tblSourceCode
where ixSourceCode in ('313HH','316HH','318HH')


select sMatchbackSourceCode, count(distinct ixCustomer) CustCount
from tblOrder
where sMatchbackSourceCode in ('313HH','316HH','318HH')
and sOrderStatus = 'Shipped'
group by sMatchbackSourceCode


select ixSourceCode
from tblCustomer
where ixCustomer in ('173489','209393','564832','779233','1006942','1214443','1944632')






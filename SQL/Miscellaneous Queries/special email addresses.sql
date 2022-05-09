-- special email addresses
select ixCustomer, ixSourceCode, dtAccountCreateDate, sEmailAddress
from tblCustomer 
where ixCustomer in ('788234','1973732','909551','1160321','1674829',
'1220430','1228855','1521761','1269078','852989')
order by dtAccountCreateDate desc

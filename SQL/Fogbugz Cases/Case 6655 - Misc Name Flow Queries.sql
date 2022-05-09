select
	count(distinct O.ixCustomer)
--	O.ixCustomer
from
	tblOrder O
	left join tblCustomer C on C.ixCustomer = O.ixCustomer
where
	O.dtOrderDate > '01/01/10' and O.dtOrderDate <= '12/31/10'
	and  O.ixCustomer not in (
		select 
			distinct O1.ixCustomer
		from
			tblOrder O1
		where
			O1.dtOrderDate < '01/01/10'
		)
	and C.dtAccountCreateDate >= '01/01/10' 
	and C.dtAccountCreateDate <= '12/31/10'
	and O.sOrderStatus = 'Shipped'
		

select 
	count(1) 
from 
	tblCustomer C
where 
	C.dtAccountCreateDate >= '01/01/10' 
	and C.dtAccountCreateDate <= '12/31/10'
	
	
	
select
	count(distinct O.ixCustomer)
from
	tblOrder O
where
	O.dtOrderDate >= '01/01/05' and O.dtOrderDate <= '12/31/05'
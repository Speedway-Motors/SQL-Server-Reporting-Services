
/*307, 309, 310*/

create view vwCustCat307
as
select 
	ixCustomer,
	(case when ixSourceCode like ('307%') then 1 else 0 end) as 'Cat307'
from tblCustomerOffer
where ixSourceCode like ('307%')
group by 
	ixCustomer,
	(case when ixSourceCode like ('307%') then 1 else 0 end)

create view vwCustCat309
as
select 
	ixCustomer,
	(case when ixSourceCode like ('309%') then 1 else 0 end) as 'Cat309'
from tblCustomerOffer
where ixSourceCode like ('309%') 
group by 
	ixCustomer,
	(case when ixSourceCode like ('309%') then 1 else 0 end)

create view vwCustCat310
as
select 
	ixCustomer,
	(case when ixSourceCode like ('310%') then 1 else 0 end) as 'Cat310'
from tblCustomerOffer
where ixSourceCode like ('310%')
group by 
	ixCustomer,
	(case when ixSourceCode like ('310%') then 1 else 0 end)


select
	tblCustomer.ixCustomer,
	vwCustCat307.Cat307,
	vwCustCat309.Cat309,
	vwCustCat310.Cat310
from tblCustomer
	left join vwCustCat307 on tblCustomer.ixCustomer = vwCustCat307.ixCustomer
	left join vwCustCat309 on tblCustomer.ixCustomer = vwCustCat309.ixCustomer
	left join vwCustCat310 on tblCustomer.ixCustomer = vwCustCat310.ixCustomer
where
	vwCustCat307.Cat307 = 1 or vwCustCat309.Cat309 = 1 or vwCustCat310.Cat310 = 1
group by
	tblCustomer.ixCustomer,
	vwCustCat307.Cat307,
	vwCustCat309.Cat309,
	vwCustCat310.Cat310


drop view vwCustCat307
drop view vwCustCat309
drop view vwCustCat310

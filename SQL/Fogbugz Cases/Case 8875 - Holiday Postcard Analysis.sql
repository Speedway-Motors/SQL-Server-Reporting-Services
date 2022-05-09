create view vwCat302_PostcardTest
as
select
	ixCustomer, ixSourceCode
from
	tblCustomerOffer
where
	ixSourceCode in ('30230!', '30230')
group by
	ixCustomer, ixSourceCode


select
	vwCat302_PostcardTest.ixSourceCode,
	count(distinct(vwCat302_PostcardTest.ixCustomer))as '# Customers',
	sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from
	tblOrder
	join vwCat302_PostcardTest on tblOrder.ixCustomer = vwCat302_PostcardTest.ixCustomer
where
	(tblOrder.sSourceCodeGiven like ('302__') or tblOrder.sMatchbackSourceCode like ('302__%'))
	and
	(tblOrder.dtOrderDate >= '11/24/10' and tblOrder.dtOrderDate <= '02/27/11')
	and
	tblOrder.sOrderStatus = 'Shipped'
group by
	vwCat302_PostcardTest.ixSourceCode
	


/*source code 30230 sales*/
select
	count(distinct(vwCat302_PostcardTest.ixCustomer))as '# Customers',
	count(distinct(tblOrder.ixCustomer))as '# Customers',
	sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from
	tblOrder
where
	(tblOrder.sSourceCodeGiven = '30230' or tblOrder.sMatchbackSourceCode = '30230')
	and
	(tblOrder.dtOrderDate >= '11/24/10' and tblOrder.dtOrderDate <= '02/27/11')
	and
	tblOrder.sOrderStatus = 'Shipped'


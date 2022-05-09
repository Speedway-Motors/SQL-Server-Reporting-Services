-- Case 17650 - Customers clearing CST when they should be excluded
--
select * from tblCustomerOffer
	where ixCustomer = '374482'
	order by ixCreateDate desc


4-26-2012 when he got marked status 9 

ixCustomerOffer	dtCreateDate	ixSourceCode
17027187	    2013-01-22  	35851
16683247	    2012-12-31  	4029 -- doesn't exist
16394165	    2012-12-26  	34947


34947	349	60M, 2+, $100+ $7.99 FR
35851	358	48M, 3+, $100+ $7.99 FR


ixCustomerOffer	dtCreateDate	ixSourceCode
17027187	    2013-01-22  	35851
16683247	    2012-12-31  	4029 -- doesn't exist
16394165	    2012-12-26  	34947

select * from tblSourceCode where ixSourceCode in ('35851','4029','34947')

select * from vwCSTStartingPool where ixCustomer = '374482'


select ixCustomer from tblCustomerOffer
where ixCustomer in (select distinct ixCustomer from tblCustomer where flgDeletedFromSOP = 1)
and 


where 

he is unsubscribed from Race



select CO.ixCustomerOffer, CO.dtCreateDate 'SentOfferDate',
    CM.ixCatalog, CM.sMarket 
from tblCustomerOffer CO
    join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    join tblCatalogMaster CM on CM.ixCatalog = SC.ixCatalog
where CO.ixCustomer = '314364'
  and CM.sMarket = 'R'
order by CO.ixCreateDate desc


select COUNT(CO*) from tblCustomerOffer
where ixDate >= 16


select * from tblCatalogMaster 
where dtStartDate between '06/30/2011' and '02/10/2013'





select * from tblCustomer where dtLastSOPUpdate

-- SMIHD-2606 - list of 2015 NSRA STREET ROD NATIONALS customers 
select ixCustomer, sCustomerFirstName, sCustomerLastName, 
-- sMailToCOLine,    <-- excluded because all 470 were NULL
sMailToStreetAddress1, sMailToStreetAddress2,
sMailToCity, sMailToState, sMailToZip,
sEmailAddress,
dtAccountCreateDate
from tblCustomer C
where C.flgDeletedFromSOP = 0
and C.ixSourceCode = '505110'
order by dtAccountCreateDate

-- nobody is opted out
select * from tblMailingOptIn
where ixCustomer in (SELECT ixCustomer from tblCustomer where ixSourceCode = '505110')
and sOptInStatus in ('UK','Y')


select * from tblSourceCode
where ixSourceCode = '505110'
/*
ixSourceCode	ixCatalog	sDescription	                sCatalogMarket	dtStartDate	dtEndDate
505110	        505	        2015 NSRA STREET ROD NATIONALS	SR	            2015-07-06  2016-07-20
*/





-- Case 21603 - Blizzard Bash customer activity
select C.ixCustomer, C.dtAccountCreateDate,
sum(O.mMerchandise) 'Sales',
count(O.ixOrder) 'Orders' -- <-- exclude backorders
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
where C.ixSourceCode = '361548'     
group by C.ixCustomer, C.dtAccountCreateDate
order by C.dtAccountCreateDate, sum(O.mMerchandise) desc
   
   
-- 90 Customers... all created either Jan 14 or 15th of 2014. 
select * from tblCustomer where ixSourceCode = '361548'   


-- SC details
select * from tblSourceCode where ixSourceCode = '361548'
/*
ixSourceCode	sDescription	ixCatalog	dtStartDate	dtEndDate	sCatalogMarket	iQuantityPrinted
361548	        BLIZZARD BASH	361	        2013-10-21  2014-10-21 	R	            300
*/

select CO.*
from tblCustomerOffer CO
    left join tblCustomer C on CO.ixCustomer = C.ixCustomer
where C.ixSourceCode = '361548'
order by dtCreateDate

select CO.*
from tblCustomerOffer CO
    left join tblCustomer C on CO.ixCustomer = C.ixCustomer
where C.ixSourceCode = '361548'
order by dtCreateDate



-- Catalogs sent (regardless if it was through CST or elsewehere)
select C.ixCustomer, dbo.GetCatalogsMailedToCust (C.ixCustomer) as CatalogsSent, C.dtAccountCreateDate
from tblCustomer C
where C.ixSourceCode = '361548'



select * from tblOrderLine where ixOrder = '5109150' --ixCustomer = '1692875'


select
	dbo.GetCatalogsMailedToCust(C.ixCustomer) CatSet,
	count(1) 'CatCount',
	len(dbo.GetCatalogsMailedToCust(C.ixCustomer))- len(replace(dbo.GetCatalogsMailedToCust(C.ixCustomer), ',', ''))+1 as 'Distinct Catalogs',
	(len(dbo.GetCatalogsMailedToCust(C.ixCustomer))- len(replace(dbo.GetCatalogsMailedToCust(C.ixCustomer), ',', ''))+1)*count(1) as 'Total Catalogs'
from
	tblCustomer C
where
	C.dtAccountCreateDate between '01/01/12' and '02/01/12'
--and dbo.GetCatalogsMailedToCust(C.ixCustomer) like '%345' 	-- set contains a specific catalog
group by
	dbo.GetCatalogsMailedToCust(C.ixCustomer)
order by CatSet
	--(len(dbo.GetCatalogsMailedToCust(C.ixCustomer))- len(replace(dbo.GetCatalogsMailedToCust(C.ixCustomer), ',', ''))+1)*count(1) desc
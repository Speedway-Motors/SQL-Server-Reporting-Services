-- Customers with no intial Source Code

select count(*) -- 6892
from tblCustomer
where flgDeletedFromSOP = 0
and ixSourceCode is NULL

select ixCustomer, dtAccountCreateDate
from tblCustomer
where flgDeletedFromSOP = 0
and ixSourceCode in (select distinct C.ixSourceCode
                    from tblCustomer C
                    full outer join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
                    where SC.ixSourceCode is null ) --('1716','RTL1','1704','PRS1975','SRP1','1533','1246','PRS001')
order by dtAccountCreateDate

select * from tblSourceCode where dtDateLastSOPUpdate < '06/25/2014'


-- SCs in tblCustomer but NOT IN tblSourceCode  -- 649
select C.ixSourceCode, COUNT(C.ixCustomer) CustQty
from tblCustomer C
full outer join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
where SC.ixSourceCode is null 
and C.flgDeletedFromSOP = 0
group by C.ixSourceCode
order by COUNT(C.ixCustomer) desc

select distinct C.ixSourceCode
into [SMITemp].dbo.PJC_Temp_Deleted_SourceCodes
from tblCustomer C
full outer join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
where SC.ixSourceCode is null 
and C.flgDeletedFromSOP = 0

--INSERT INTO tblSourceCode
select T.ixSourceCode, 0,0,'UK','unknown','unknown',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'unknown',NULL,NULL
FROM [SMITemp].dbo.PJC_Temp_Deleted_SourceCodes T

select * from tblSourceCode
where  dtDateLastSOPUpdate is NULL
and ixStartDate = 0
and ixEndDate = 0

select distinct sCatalogMarket from tblSourceCode



-- NULL source code count by customer create year
select count(1) '# Customers',d.iYear
from 
	tblCustomer c 
	left join tblSourceCode sc on c.ixSourceCode=sc.ixSourceCode
	left join tblDate d on c.ixAccountCreateDate=d.ixDate
where
	sc.ixSourceCode is null
	and c.flgDeletedFromSOP=0
group by
	d.iYear
order by 
	d.iYear
	
	
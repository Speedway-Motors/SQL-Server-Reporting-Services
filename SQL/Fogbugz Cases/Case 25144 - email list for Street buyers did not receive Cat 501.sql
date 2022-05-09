-- Case 25144 - email list for Street buyers did not receive Cat 501
-- all source codes in the file... exclude the "don't use" source codes
select ixSourceCode, COUNT(*)
from PJC_25144_CST_Cat501_EmailOUtputFile
group by ixSourceCode


select * 
into PJC_25144_CST_Cat501_EmailOUtputFile_MOD
from PJC_25144_CST_Cat501_EmailOUtputFile
where ixSourceCode LIKE '9%'
-- ADD Email field varchar(65)

-- remove customes that received 501 Catalog
select *
-- DELETE
from PJC_25144_CST_Cat501_EmailOUtputFile_MOD  -- 7,326
where ixCustomer in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomerOffer CO
                        join [SMI Reporting].dbo.tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                     where SC.ixCatalog = '501')
                     
                        

-- populate Email address
update E
set Email = C.sEmailAddress
from PJC_25144_CST_Cat501_EmailOUtputFile_MOD E
    join [SMI Reporting].dbo.tblCustomer C on E.ixCustomer = C.ixCustomer


-- final list to send
select * from PJC_25144_CST_Cat501_EmailOUtputFile_MOD
where Email is NOT NULL    





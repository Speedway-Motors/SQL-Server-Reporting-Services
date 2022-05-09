-- Case 17159 - Deceased File Analysis for Cat 349

select * from PJC_17159_RRD_DeceasedFile_Cat349_2012_1226 -- 182   --113 currently flagged as deceased

select count(ixCustomer) from PJC_17159_RRD_DeceasedFile_Cat349_2012_1226           -- 182
select count(distinct ixCustomer) from PJC_17159_RRD_DeceasedFile_Cat349_2012_1226  -- 182 

-- Customers currently flagged as Deceased
select count(*) 
from PJC_17159_RRD_DeceasedFile_Cat349_2012_122 6 --113
where ixCustomer in 
        (select ixCustomer 
         from [SMI Reporting].dbo.tblCustomer 
         where sMailingStatus = 8 
         and flgDeletedFromSOP = 0 )




/**** Customers to update ****/
    -- sMailingStatus changed to 8
    -- DeceasedDateApplied set to 12/26/2012
    -- DeceasedStatusProvider "RR Donnelley"
select (ixCustomer) from PJC_17159_RRD_DeceasedFile_Cat349_2012_1226 -- 69 to update
where ixCustomer in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomer 
                     where sMailingStatus is NULL
                        or sMailingStatus <> 8 )    
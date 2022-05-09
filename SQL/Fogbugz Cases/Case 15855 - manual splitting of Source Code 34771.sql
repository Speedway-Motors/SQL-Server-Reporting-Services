-- Case 15855 - manual splitting of Source Code 34771

select count(*) from PJC_347_CST_OutputFile         -- 155657



select count(*) from PJC_347_CST_OutputFile
    where ixSourceCode = '34771'                    -- 11949 
select count(*) from PJC_SourceCode_34771_Customers -- 6241
select count(*) from PJC_SourceCode_34772_Customers -- 5024
select count(*) from PJC_SourceCode_34773_Customers -- 684




-- truncate table PJC_SourceCode_34771_Customers
select * from PJC_SourceCode_34771_Customers
-- truncate table PJC_SourceCode_34772_Customers
select * from PJC_SourceCode_34772_Customers
-- truncate table PJC_SourceCode_34773_Customers
select * from PJC_SourceCode_34773_Customers


-- 34771 -Original source codes from website
insert into PJC_SourceCode_34771_Customers
select ORIG.ixCustomer, '34771' as ixSourceCode -- 6241     
from PJC_347_CST_OutputFile ORIG
    join tblCustomer C on C.ixCustomer = ORIG.ixCustomer 
where C.ixSourceCode in ('WCR2', 'WCR3', 'WCR4', 'WCR22','WCR7')
    and ORIG.ixSourceCode = '34771'   
    
-- 34773 -Original source codes from catalogs.com
insert into PJC_SourceCode_34773_Customers
select ORIG.ixCustomer, '34773' as ixSourceCode -- 684     
from PJC_347_CST_OutputFile ORIG
    join tblCustomer C on C.ixCustomer = ORIG.ixCustomer 
where C.ixSourceCode in ('CCTB', 'CCR', 'CCSM','CCSR')
    and ORIG.ixSourceCode = '34771'   

-- 34772 -Original source codes from OTHER
-- INPUT all custs from original 34771 list,
-- then delete ones that are now in 34773 and 34773
insert into PJC_SourceCode_34772_Customers
select ORIG.ixCustomer, '34772' as ixSourceCode -- 6241     
from PJC_347_CST_OutputFile ORIG
    join tblCustomer C on C.ixCustomer = ORIG.ixCustomer 
where ORIG.ixSourceCode = '34771'   

delete from PJC_SourceCode_34772_Customers
where ixCustomer in (select ixCustomer from PJC_SourceCode_34771_Customers)

delete from PJC_SourceCode_34772_Customers
where ixCustomer in (select ixCustomer from PJC_SourceCode_34773_Customers)


-- sent counts to Kyle, and he approved 10-3-12

-- Now create new file to send to Al to load into SOP

select * 
into PJC_347_CST_MODIFIED_OutputFile
from PJC_347_CST_OutputFile


select count(*) from PJC_347_CST_MODIFIED_OutputFile -- 155,657

select ixSourceCode, count(*)
from PJC_347_CST_MODIFIED_OutputFile
where ixSourceCode between '34771' and '34773'  
group by ixSourceCode

/*
ixSourceCode	(No column name)
34771	11949
*/

delete from PJC_347_CST_MODIFIED_OutputFile
where ixSourceCode = '34771'

insert into PJC_347_CST_MODIFIED_OutputFile
select *
from PJC_SourceCode_34771_Customers

insert into PJC_347_CST_MODIFIED_OutputFile
select *
from PJC_SourceCode_34772_Customers

insert into PJC_347_CST_MODIFIED_OutputFile
select *
from PJC_SourceCode_34773_Customers





select * from PJC_347_CST_MODIFIED_OutputFile







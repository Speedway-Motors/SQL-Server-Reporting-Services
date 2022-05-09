-- Case 16057 - manually split Source Code 34471 from CST Output file

select count(*) from PJC_344_CST_OutputFile         -- 253016



select count(*) from PJC_344_CST_OutputFile
    where ixSourceCode = '34471'                    -- 54416 
                                                    -- =====
select count(*) from PJC_SourceCode_34471_Customers -- 24039
select count(*) from PJC_SourceCode_34472_Customers -- 29270
select count(*) from PJC_SourceCode_34473_Customers --  1107




-- truncate table PJC_SourceCode_34471_Customers
select * from PJC_SourceCode_34471_Customers
-- truncate table PJC_SourceCode_34472_Customers
select * from PJC_SourceCode_34472_Customers
-- truncate table PJC_SourceCode_34473_Customers
select * from PJC_SourceCode_34473_Customers


-- 34471 -Original source codes from website
--insert into PJC_SourceCode_34471_Customers
select ORIG.ixCustomer, '34471' as ixSourceCode -- 24039     
into PJC_SourceCode_34471_Customers
from PJC_344_CST_OutputFile ORIG
    join tblCustomer C on C.ixCustomer = ORIG.ixCustomer 
where C.ixSourceCode in ('WCR2', 'WCR3', 'WCR4', 'WCR22','WCR7')
    and ORIG.ixSourceCode = '34471'   
    
-- 34473 -Original source codes from catalogs.com
--insert into PJC_SourceCode_34473_Customers
select ORIG.ixCustomer, '34473' as ixSourceCode -- 1107
into PJC_SourceCode_34473_Customers     
from PJC_344_CST_OutputFile ORIG
    join tblCustomer C on C.ixCustomer = ORIG.ixCustomer 
where C.ixSourceCode in ('CCTB', 'CCR', 'CCSM','CCSR')
    and ORIG.ixSourceCode = '34471'   

-- 34472 -Original source codes from OTHER
-- INPUT all custs from original 34471 list,
-- then delete ones that are now in 34473 and 34473
--insert into PJC_SourceCode_34472_Customers
select ORIG.ixCustomer, '34472' as ixSourceCode -- 54416     
into PJC_SourceCode_34472_Customers
from PJC_344_CST_OutputFile ORIG
    join tblCustomer C on C.ixCustomer = ORIG.ixCustomer 
where ORIG.ixSourceCode = '34471'   

delete from PJC_SourceCode_34472_Customers
where ixCustomer in (select ixCustomer from PJC_SourceCode_34471_Customers)

delete from PJC_SourceCode_34472_Customers
where ixCustomer in (select ixCustomer from PJC_SourceCode_34473_Customers)


-- sent counts to Kyle, and he approved 10-3-12

-- Now create new file to send to Al to load into SOP

select * 
into PJC_344_CST_MODIFIED_OutputFile -- 253016
from PJC_344_CST_OutputFile


select count(*) from PJC_344_CST_MODIFIED_OutputFile -- 155,657

select ixSourceCode, count(*) QTY
from PJC_344_CST_MODIFIED_OutputFile
where ixSourceCode between '34471' and '34473'  
group by ixSourceCode

/*
BEFORE CHANGE
ixSourceCode	QTY
34471	        54416

AFTER
ixSourceCode	QTY
34472	        29270
34473	         1107
34471	        24039
*/

delete from PJC_344_CST_MODIFIED_OutputFile
where ixSourceCode = '34471'

insert into PJC_344_CST_MODIFIED_OutputFile
select *
from PJC_SourceCode_34471_Customers

insert into PJC_344_CST_MODIFIED_OutputFile
select *
from PJC_SourceCode_34472_Customers

insert into PJC_344_CST_MODIFIED_OutputFile
select *
from PJC_SourceCode_34473_Customers





select * from PJC_344_CST_MODIFIED_OutputFile





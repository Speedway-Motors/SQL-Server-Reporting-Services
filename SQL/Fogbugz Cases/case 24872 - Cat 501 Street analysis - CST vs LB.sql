-- case 24872 - Cat 501 Street analysis - CST vs LB 

-- SQL based on code from "case 24599 - compare CST 5002 to LB 501 STREET.sql"

-- put final results into table PJC_24599_CSTMergedWithLB to make it easy for Elaina to refresh Tableau dataset


select COUNT(*) from PJC_24872_CST_OutputFile_501

-- copy data from original CST export file table
-- DROP TABLE PJC_24872_CST501
select * into PJC_24872_CST501
from PJC_24872_CST_OutputFile_501

select * from PJC_24872_CST501
-- PJC_24599_CSTMergedWithLB

select * from PJC_24872_CST501
select COUNT(*) from PJC_24872_CST_OutputFile_501   -- 381,375
select COUNT(ixCustomer) from PJC_24872_CST501      -- 381,375

select ixSourceCode 'SC     ', COUNT(*) Qty
from PJC_24872_CST501
group by ixSourceCode
order by ixSourceCode
/*
SC     	Qty
50102	28869
50103	41709
50104	17850
50105	10393
50106	9294
50107	10399
50108	25660
50109	1294
50110	24861
50111	7091
50112	18944
50113	27320
50114	7805
50115	6839
50116	6699
50117	7634
50118	20958
50119	1159
50120	15506
50121	15421
50122	5424
50123	5117
50124	5778
50125	1580
50150	6060
50170	34628
50171	9479
50172	7604
*/


-- TRUNCATE TABLE PJC_24872_LB501
-- DROP TABLE PJC_24872_LB501
select top 100 * from PJC_24872_LB501 order by NEWID()

select COUNT(ixCustomer) from PJC_24872_LB501            -- 294,868
select COUNT(distinct ixCustomer) from PJC_24872_LB501   -- 294,868

-- Customers in LB campaign but NOT CST 
select COUNT(ixCustomer) from PJC_24872_LB501 -- 39,141 V1      39,057 V2       
where ixCustomer NOT IN (Select ixCustomer from PJC_24872_CST501)

-- Customers in CST campaign but NOT LB
select COUNT(ixCustomer) from PJC_24872_CST501 -- 125,648 V1    131,886 V2                     51,711 requestors + 6,060 Canadian custs in the CST pull      
where ixCustomer NOT IN (Select ixCustomer from PJC_24872_LB501)

/*
-- 1.Which segments do the customers from the Longbow list fall into on the #5002 Street Campaign?
update LB 
set CSTSegment = CST.ixSourceCode  -- 232,442
from PJC_24872_LB501 LB
 join PJC_24872_CST501 CST on LB.ixCustomer = CST.ixCustomer

UPDATE PJC_24872_LB501
SET CSTSegment = 'NONE'
where CSTSegment is NULL

-- 2.	Which customers are on the CST  #5002 Street Campaign that aren’t on the Longbow Mailing List?

select CSTSegment, COUNT(*) BLCustCount
from PJC_24872_LB501
group by CSTSegment
order by CSTSegment


select CST.*,
from 
[SMI Reporting].dbo.CSTCustSummary CST
join PJC_24872_LB501 LB on CST.ixCustomer = LB.ixCustomer
where LB.CSTSegment = 'NONE'
order by MLStreet
*/

/* backing up current version before making new version 
SELECT *
into PJC_24872_Cat501_CSTandLB_Ver1
from PJC_24872_Cat501_CSTandLB
*/
-- DROP TABLE PJC_24872_Cat501_CSTandLB

select CST.ixCustomer CSTCustomer,CST.ixSourceCode CSTSegment,  
    LB.ixCustomer LBCustomer,
    CSTSUM.*,
    LB.EV30days,
    LB.EV42days,
    LB.EV60days,
    LB.EV90days
into PJC_24872_Cat501_CSTandLB
from PJC_24872_CST501 CST
full outer join PJC_24872_LB501 LB on CST.ixCustomer = LB.ixCustomer
left join [SMI Reporting].dbo.CSTCustSummary CSTSUM on isNULL(CST.ixCustomer,LB.ixCustomer) = CSTSUM.ixCustomer




select COUNT(*) from PJC_24872_Cat501_CSTandLB -- 420,432
select COUNT(*) from PJC_24872_Cat501_CSTandLB -- 420,432

-- sample
select * from PJC_24872_Cat501_CSTandLB order by NEWID()

/*
update A 
set dtAccountCreateDate = B.dtAccountCreateDate
from PJC_24872_Cat501_CSTandLB A
 join [SMI Reporting].dbo.tblCustomer B on  isNULL(A.CSTCustomer,A.LBCustomer) = B.ixCustomer
where A.dtAccountCreateDate is NULL 

select SUM(MLStreet)
from PJC_24872_Cat501_CSTandLB -- 8,123,568.84
where LBCustomer is NULL

select SUM(MLStreet)
from PJC_24872_Cat501_CSTandLB  -- 17,9083,839.885
where CSTCustomer is NOT NULL
*/



select top 200000 * from PJC_24872_Cat501_CSTandLB -- 220432
order by CatsSinceLastOrder desc


select * from [SMI Reporting].dbo.tblCustomerOffer where ixCustomer = '1056837'


select COUNT(*) from [SMI Reporting].dbo.tblCustomerOffer
where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where flgDeletedFromSOP = 1)


-- putting final results into table PJC_24599_CSTMergedWithLB to make it easy for Elaina to refresh Tableau dataset
-- TRUNCATE TABLE PJC_24599_CSTMergedWithLB
insert into PJC_24599_CSTMergedWithLB -- 420,516
Select * 
from PJC_24872_Cat501_CSTandLB

select top 100 * from PJC_24599_CSTMergedWithLB
order by NEWID()


select top 10 * from PJC_24872_Cat501_CSTandLB
WHERE Recency = 0
what does your output look like for those columns


-- TRUNCATE TABLE PJC_24872_Cat501_CSTandLB
insert into PJC_24872_Cat501_CSTandLB -- 420,516
Select * 
from  PJC_24599_CSTMergedWithLB





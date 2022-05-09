-- case 24599 - Cat 501 Street analysis - CST vs LB 

-- put final results into table PJC_24599_CSTMergedWithLB to make it easy for Elaina to refresh Tableau dataset

select * from PJC_24872_CST501

select COUNT(ixCustomer) from PJC_24872_CST501   -- 403,422
select COUNT(ixCustomer) from PJC_24872_CST501   -- 403,422

select ixSourceCode, COUNT(*)
from PJC_24872_CST501
group by ixSourceCode
order by ixSourceCode
/*
ixSourceCode	(No column name)
500210	25625
5002123	17829
500213	24813
5002132	7815
5002142	20859
50022	28833
500222	6702
500223	20960
5002247	1290
500225	7446
5002263	1159
5002279	986
5002296	11956
5002297	24313
5002352	10375
500236	25171
500238	5695
500244	11203
5002543	41655
5002544	10368
5002545	27365
5002546	6842
5002547	7634
5002550	11383
5002551	8611
5002555	7688
5002556	3804
500257	15764
50029	9278
*/

-- DROP TABLE PJC_24872_LB501
select * from PJC_24872_LB501

select COUNT(ixCustomer) from PJC_24872_LB501   -- 275,096
select COUNT(ixCustomer) from PJC_24872_LB501   -- 275,096

-- Customers in LB campaign but NOT CST 
select COUNT(ixCustomer) from PJC_24872_LB501 -- 37,030 Version2         34,835 Version1
where ixCustomer NOT IN (Select ixCustomer from PJC_24872_CST501)

-- Customers in CST campaign but NOT LB
select COUNT(ixCustomer) from PJC_24872_CST501 -- 165,356 V2            170,980 V1
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

select CST.ixCustomer CSTCustomer,CST.ixSourceCode CSTSegment,LB.ixCustomer LBCustomer,
CSTSUM.*
into PJC_24872_Cat501_CSTandLB
from PJC_24872_CST501 CST
full outer join PJC_24872_LB501 LB on CST.ixCustomer = LB.ixCustomer
left join [SMI Reporting].dbo.CSTCustSummary CSTSUM on isNULL(CST.ixCustomer,LB.ixCustomer) = CSTSUM.ixCustomer

select COUNT(*) from PJC_24872_Cat501_CSTandLB -- 440,452

select top 10 * from PJC_24872_Cat501_CSTandLB

/*
update A 
set dtAccountCreateDate = B.dtAccountCreateDate
from PJC_24872_Cat501_CSTandLB A
 join [SMI Reporting].dbo.tblCustomer B on  isNULL(A.CSTCustomer,A.LBCustomer) = B.ixCustomer
where A.dtAccountCreateDate is NULL 

select SUM(MLStreet)
from PJC_24872_Cat501_CSTandLB
where LBCustomer is NULL

select SUM(MLStreet)
from PJC_24872_Cat501_CSTandLB
where CSTCustomer is NOT NULL
*/

3.	Which customers are on the Longbow Mailing List that aren’t on the #5002 Street Campaign List (shouldn’t be as many But if it is projecting to double revenue then there better be a few)?



select * from PJC_24872_Cat501_CSTandLB
order by CatsSinceLastOrder desc


select * from [SMI Reporting].dbo.tblCustomerOffer where ixCustomer = '1056837'


select COUNT(*) from [SMI Reporting].dbo.tblCustomerOffer
where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where flgDeletedFromSOP = 1)
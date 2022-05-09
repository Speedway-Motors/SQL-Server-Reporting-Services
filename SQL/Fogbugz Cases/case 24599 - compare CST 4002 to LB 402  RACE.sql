-- case 24599 - compare CST 402 to LB 402  RACE


/*********************************************************************************
 *********************************   CST FILE    *********************************
 *********************************************************************************/
 
-- DROP TABLE PJC_24599_CST402Race
select * from PJC_24599_CST402Race

select COUNT(ixCustomer) from PJC_24599_CST402Race   -- 297,621
select COUNT(ixCustomer) from PJC_24599_CST402Race   -- 297,621

select ixSourceCode, COUNT(*) CustQty
from PJC_24599_CST402Race
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
40202	17193
40203	31824
40204	29462
40205	5092
40206	8113
40207	4781
40208	17013
40209	2928
40210	26866
40211	15979
40212	12957
40213	2955
40214	5450
40215	3108
40216	13341
40217	1810
40218	17740
40219	9382
40220	8073
40221	2489
40222	4596
40223	2829
40224	12193
40225	6983
40226	5774
40227	4848
40228	2097
40229	3638
40230	2454
40270	12041
40271	1612
40272	2000
*/


/*********************************************************************************
 *********************************    LB FILE    *********************************
 *********************************************************************************/
 
-- DROP TABLE PJC_24599_LB402Race
select * from PJC_24599_LB402Race

select COUNT(ixCustomer) from PJC_24599_LB402Race   -- 196,646
select COUNT(ixCustomer) from PJC_24599_LB402Race   -- 196,646

-- Customers in LB campaign but NOT CST 
select COUNT(ixCustomer) from PJC_24599_LB402Race -- 41,267 Version1
where ixCustomer NOT IN (Select ixCustomer from PJC_24599_CST402Race)

-- Customers in CST campaign but NOT LB
select COUNT(ixCustomer) from PJC_24599_CST402Race -- 142,242 Version1
where ixCustomer NOT IN (Select ixCustomer from PJC_24599_LB402Race)

/*
-- 1.Which segments do the customers from the Longbow list fall into on the #5002 Street Campaign?
update LB 
set CSTSegment = CST.ixSourceCode  -- 232,442
from PJC_24599_LB402Race LB
 join PJC_24599_CST402Race CST on LB.ixCustomer = CST.ixCustomer

UPDATE PJC_24599_LB402Race
SET CSTSegment = 'NONE'
where CSTSegment is NULL

-- 2.	Which customers are on the CST  #5002 Street Campaign that aren’t on the Longbow Mailing List?

select CSTSegment, COUNT(*) BLCustCount
from PJC_24599_LB402Race
group by CSTSegment
order by CSTSegment


select CST.*,
from 
[SMI Reporting].dbo.CSTCustSummary CST
join PJC_24599_LB402Race LB on CST.ixCustomer = LB.ixCustomer
where LB.CSTSegment = 'NONE'
order by MLStreet
*/

/* backing up current version before making new version 
SELECT *
into PJC_24599_402Race_CSTMergedWithLB_Ver1
from PJC_24599_402Race_CSTMergedWithLB
*/
-- DROP TABLE PJC_24599_402Race_CSTMergedWithLB

select CST.ixCustomer CSTCustomer,CST.ixSourceCode CSTSegment,LB.ixCustomer LBCustomer, 
CSTSUM.*
into PJC_24599_402Race_CSTMergedWithLB
from PJC_24599_CST402Race CST
full outer join PJC_24599_LB402Race LB on CST.ixCustomer = LB.ixCustomer
left join [SMI Reporting].dbo.CSTCustSummary CSTSUM on isNULL(CST.ixCustomer,LB.ixCustomer) = CSTSUM.ixCustomer

select COUNT(*) from PJC_24599_402Race_CSTMergedWithLB -- 338,888

select top 10 * from PJC_24599_402Race_CSTMergedWithLB

/*
update A 
set dtAccountCreateDate = B.dtAccountCreateDate
from PJC_24599_402Race_CSTMergedWithLB A
 join [SMI Reporting].dbo.tblCustomer B on  isNULL(A.CSTCustomer,A.LBCustomer) = B.ixCustomer
where A.dtAccountCreateDate is NULL 

select SUM(MLStreet)
from PJC_24599_402Race_CSTMergedWithLB
where LBCustomer is NULL

select SUM(MLStreet)
from PJC_24599_402Race_CSTMergedWithLB
where CSTCustomer is NOT NULL
*/

3.	Which customers are on the Longbow Mailing List that are NOT on the #5002 Street Campaign List (should not be as many But if it is projecting to double revenue then there better be a few)?



select * from PJC_24599_402Race_CSTMergedWithLB
order by CatsSinceLastOrder desc


select * from [SMI Reporting].dbo.tblCustomerOffer where ixCustomer = '1056837'


select COUNT(*) from [SMI Reporting].dbo.tblCustomerOffer
where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where flgDeletedFromSOP = 1)




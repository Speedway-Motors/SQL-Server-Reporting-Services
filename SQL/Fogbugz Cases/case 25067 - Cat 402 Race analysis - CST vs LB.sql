-- case 25067 - Cat 402 Race analysis - CST vs LB 


-- SQL based on code from case 24872

-- put final results into table PJC_24599_CSTMergedWithLB to make it easy for Elaina to refresh Tableau dataset


select COUNT(*) from PJC_25067_CST_OutputFile_402 -- 259,379

-- copy data from original CST export file table
-- DROP TABLE PJC_25067_CST402
select * into PJC_25067_CST402 -- 259,379
from PJC_25067_CST_OutputFile_402


select COUNT(*) from PJC_25067_CST402                   -- 259,379
select COUNT(*) from PJC_25067_CST_OutputFile_402       -- 259,379
select COUNT(distinct ixCustomer) from PJC_25067_CST402 -- 259,379

select * from PJC_25067_CST402
-- PJC_24599_CSTMergedWithLB

select ixSourceCode 'SC     ', COUNT(*) Qty
from PJC_25067_CST402
group by ixSourceCode
order by ixSourceCode


-- DROP TABLE PJC_CustsRcvdStreetPromosForCat501
select ixSourceCode, COUNT(*)
from PJC_25067_CST_OutputFile_402 CST
    join PJC_CustsRcvdStreetPromosForCat501 SP on CST.ixCustomer = SP.ixCustomer
group by ixSourceCode
order by ixSourceCode

select ixSourceCode, COUNT(CST.ixCustomer)
from PJC_25067_CST_OutputFile_402 CST
    join PJC_CustsRcvdStreetPromosForCat501 SP on CST.ixCustomer = SP.ixCustomer
group by ixSourceCode
order by ixSourceCode

/*
SC     	Qty
40202	31144
40203	18189
40204	2402
40205	4197
40206	2207
40207	8310
40208	879
40209	730
40210	10014
40211	5108
40212	18147
40213	11275
40214	2762
40215	3913
40216	2684
40217	8724
40218	676
40219	703
40220	6860
40221	5008
40222	1264
40223	7667
40224	6698
40225	1263
40226	2503
40227	1255
40228	6040
40229	8267
40230	6341
40231	1744
40232	2941
40233	1825
40234	7352
40235	762
40236	1024
40237	9533
40238	8146
40239	9366
40240	8095
40241	2482
40242	4586
40243	579
40270	12174
40271	1567
40272	1973
*/



-- be sure to format the money columns as CURRENCY!!
-- changed name from PJC_25067_LB402 to PJC_25067_402_Race_LB

-- TRUNCATE TABLE PJC_25067_402_Race_LB
-- DROP TABLE PJC_25067_402_Race_LB
select top 100 * from PJC_25067_402_Race_LB order by NEWID()

/*
ixCustomer	EV30days	EV42days	EV60days	EV90days	YearAmount
580005	1.2347	2.0896	3.0394	4.2741	0.00
1849735	7.9738	12.4037	19.0486	26.5794	0.00
2020641	3.3531	4.9127	7.0962	9.2796	77.98
213150	3.8627	5.6975	8.4014	11.9744	71.98
1184365	12.7935	17.9653	26.4036	34.8418	0.00
708821	5.5222	9.5912	14.5322	19.1825	0.00
*/

-- DUPE CHECK
select COUNT(ixCustomer) 'CustCnt',
       COUNT(distinct ixCustomer) 'DistCustCnt',
       ABS(COUNT(ixCustomer) - COUNT(distinct ixCustomer)) 'Dupes'
from PJC_25067_402_Race_LB   -- 294,208
/*
CustCnt	DistCustCnt	Dupes
294208	294208	    0
*/



-- Customers in LB campaign but NOT CST 
select COUNT(LB.ixCustomer) 
from PJC_25067_402_Race_LB LB   -- 101,440      
    left join PJC_25067_CST402 CST on LB.ixCustomer = CST.ixCustomer
where CST.ixCustomer is NULL

-- Customers in CST campaign but NOT LB
select COUNT(CST.ixCustomer) 
from PJC_25067_CST402 CST   -- 66,611       
left join  PJC_25067_402_Race_LB LB on LB.ixCustomer = CST.ixCustomer
where LB.ixCustomer is NULL



/*
-- 1.Which segments do the customers from the Longbow list fall into on the #5002 Street Campaign?
update LB 
set CSTSegment = CST.ixSourceCode  -- 232,442
from PJC_25067_402_Race_LB LB
 join PJC_25067_CST402 CST on LB.ixCustomer = CST.ixCustomer

UPDATE PJC_25067_402_Race_LB
SET CSTSegment = 'NONE'
where CSTSegment is NULL

-- 2.	Which customers are on the CST  #5002 Street Campaign that aren’t on the Longbow Mailing List?

select CSTSegment, COUNT(*) BLCustCount
from PJC_25067_402_Race_LB
group by CSTSegment
order by CSTSegment


select CST.*,
from 
[SMI Reporting].dbo.tblCSTCustSummary_Rollup CST
join PJC_25067_402_Race_LB LB on CST.ixCustomer = LB.ixCustomer
where LB.CSTSegment = 'NONE'
order by MLStreet
*/

/* backing up current version before making new version 
SELECT *
into PJC_25067_Cat402_CSTandLB_Ver1
from PJC_25067_Cat402_CSTandLB
*/
-- DROP TABLE PJC_25067_Cat402_CSTandLB

select CST.ixCustomer CSTCustomer,CST.ixSourceCode CSTSegment,  -- 360,819
    LB.ixCustomer LBCustomer,
    CSTSUM.*,
    LB.EV30days,
    LB.EV42days,
    LB.EV60days,
    LB.EV90days,
    LB.YearAmount
into PJC_25067_Cat402_CSTandLB
from PJC_25067_CST402 CST
full outer join PJC_25067_402_Race_LB LB on CST.ixCustomer = LB.ixCustomer
left join [SMI Reporting].dbo.tblCSTCustSummary_Rollup CSTSUM on isNULL(CST.ixCustomer,LB.ixCustomer) = CSTSUM.ixCustomer



select MAX(dtAccountCreateDate) from [SMI Reporting].dbo.tblCSTCustSummary_Rollup

SELECT * FROM [SMI Reporting].dbo.tblCSTCustSummary_Rollup


select COUNT(*) from PJC_25067_Cat402_CSTandLB -- 360,819
select COUNT(distinct isNULL(CSTCustomer,LBCustomer)) from PJC_25067_Cat402_CSTandLB -- 360,819


-- sample
select top 100 * from PJC_25067_Cat402_CSTandLB order by NEWID()

/*
update A 
set dtAccountCreateDate = B.dtAccountCreateDate
from PJC_25067_Cat402_CSTandLB A
 join [SMI Reporting].dbo.tblCustomer B on  isNULL(A.CSTCustomer,A.LBCustomer) = B.ixCustomer
where A.dtAccountCreateDate is NULL 

select SUM(MLStreet)
from PJC_25067_Cat402_CSTandLB -- 8,123,568.84
where LBCustomer is NULL

select SUM(MLStreet)
from PJC_25067_Cat402_CSTandLB  -- 17,9083,839.885
where CSTCustomer is NOT NULL
*/

-- PUT INTO EXCEL FILE FOR DYLAN
SELECT  
    CSTCustomer, CSTSegment, LBCustomer, sMailToState, ixOrigCustSourceCode, CustGroup, dtAccountCreateDate, 
    Recency, Frequency, 
    MLTotal, AOV, MLRace, MLStreet, MLBoth, MLTBucket, MLSprintMidget, MLPedalCar, MLSportCompact, MLSafetyEquip, MLToolsAndEquip, 
    EV30days, EV42days, EV60days, EV90days, YearAmount,
    OptInRace, OptInStreet, OptInSprintMidget, OptInTBucket, 
    LatestOrder, CatsSinceLastOrder 
INTO PJC_25067_Cat402_CSTandLB_EXCEL   
FROM PJC_25067_Cat402_CSTandLB
order by sMailToState desc




select top 200000 * from PJC_25067_Cat402_CSTandLB -- 220432
order by CatsSinceLastOrder desc


select * from [SMI Reporting].dbo.tblCustomerOffer where ixCustomer = '1056837'


select COUNT(*) from [SMI Reporting].dbo.tblCustomerOffer
where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where flgDeletedFromSOP = 1)


-- putting final results into table PJC_24599_CSTMergedWithLB to make it easy for Elaina to refresh Tableau dataset
-- TRUNCATE TABLE PJC_24599_CSTMergedWithLB
insert into PJC_24599_CSTMergedWithLB -- 420,516
Select * 
from PJC_25067_Cat402_CSTandLB

select top 100 * from PJC_24599_CSTMergedWithLB
order by NEWID()


select top 10 * from PJC_25067_Cat402_CSTandLB
WHERE Recency = 0
what does your output look like for those columns


-- TRUNCATE TABLE PJC_25067_Cat402_CSTandLB
insert into PJC_25067_Cat402_CSTandLB -- 420,516
Select * 
from  PJC_24599_CSTMergedWithLB


/**** CHECKING MODIFIED OUTPUT BEFORE loading into SOP ******/
-- DROP TABLE PJC_25067_CST_OutputFile_402MOD
select COUNT(*) from PJC_25067_CST_OutputFile_402MOD                    -- 259379
select count(distinct ixCustomer) from PJC_25067_CST_OutputFile_402MOD  -- 259379

select ixSourceCode, COUNT(*)
from PJC_25067_CST_OutputFile_402MOD
group by ixSourceCode
order by ixSourceCode
/*
ixSourceCode	(No column name)
40243A	290
40216C	671
40239C	4683
40270C	3044
40203	18189
40212	18147
40241A	1241
40239A	4683
40240A	4048
40237	9533
40222	1264
40221A	1252
40202	31144
40206	2207
40217A	2181
40226	2503
40233	1825
40270H	3043
40216F	671
40219C	176
40272H	493
40242A	2293
40236	1024
40270A	3044
40209	730
40228	6040
40218	676
40271H	391
40232	2941
40241C	1241
40229	8267
40221C	1252
40235	762
40217H	2181
40213	11275
40216A	671
40240C	4047
40211	5108
40271A	392
40231	1744
40216H	671
40238	8146
40207	8310
40220	6860
40223	7667
40219F	176
40204	2402
40221F	1252
40270F	3043
40215	3913
40271C	392
40217C	2181
40234	7352
40272A	494
40205	4197
40242C	2293
40243C	289
40271F	392
40214	2762
40210	10014
40225	1263
40230	6341
40227	1255
40272F	493
40219H	175
40217F	2181
40208	879
40221H	1252
40224	6698
40219A	176
40272C	493
*/



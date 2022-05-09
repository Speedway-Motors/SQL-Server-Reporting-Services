-- Case 21437 - CST customer market segment overlap analysis

-- SERVER = LNK-WEB2\SQLEXPRESS
-- DB = CustomerSegmentationDB

select C.ixCampaign, CSX.sSourceCode, C.sDescription, S.iRecency, S.iFrequency, S.mMonetary, S.sMarket,
   CAST(S.iRecency as varchar(2))+'|'+CAST(S.iFrequency as varchar(1))+'|'+CAST(S.mMonetary as varchar(7))+'|'+CAST(S.sMarket as varchar(2)) 'RFMM'
--into PJC_21437_TestSegmentsRFM     
from tblCampaign_Segment_xref CSX
    join tblCampaign C on C.ixCampaign = CSX.ixCampaign
    join tblSegment S on CSX.ixSegment = S.ixSegment
where C.ixCampaign between 75 and 78 -- the four test campaigns built by Philip
    --C.dtCreateDate >= '02/03/2014'    
    
    
-- EXPORTED THE OUTPUT TO LNK-DW1.[SMITemp].dbo.PJC_21437_TestSegmentsRFM

-- COMBINED THE 4 CST OUTPUT FILES AND IMPORTED THEM INTO LNK-DW1.[SMITemp].dbo.PJC_21437_CSTCombinedFileOutputs

-- RAN THE FOLLOWING ON LNK-DW1 [SMITemp]

select top 10 * from PJC_21437_CSTCombinedFileOutputs

select COUNT(ixCustomer) -- 684,866
from PJC_21437_CSTCombinedFileOutputs

select COUNT(distinct ixCustomer) -- 177,035
from PJC_21437_CSTCombinedFileOutputs

-- Each campaign had approx 171K customers.
-- NOTE: the numbers were not idential due to customers being able to "unsubscribe" from specific markets.

select  COUNT(*) 'Qty', ixSourceCode
from PJC_21437_CSTCombinedFileOutputs
group by ixSourceCode
order by ixSourceCode
/*
Qty	ixSourceCode
81454	Test 2014OW10
73535	Test 2014OW17
108	Test 2014OW190
714	Test 2014OW191
351	Test 2014OW192
20	Test 2014OW193
1683	Test 2014OW247
1975	Test 2014OW62
4139	Test 2014OW64
350	Test 2014OW66
767	Test 2014OW68
417	Test 2014OW69
33	Test 2014OW70
41	Test 2014OW71
173	Test 2014OW72
644	Test 2014OW73
1006	Test 2014OW74
191	Test 2014OW75
958	Test 2014OW76
82944	Test 2014R10
1464	Test 2014R101
5083	Test 2014R102
886	Test 2014R14
6213	Test 2014R15
177	Test 2014R156
7520	Test 2014R16
22362	Test 2014R17
1688	Test 2014R247
2751	Test 2014R64
15197	Test 2014R86
7402	Test 2014R87
3453	Test 2014R88
169	Test 2014R89
924	Test 2014R94
3748	Test 2014R96
1920	Test 2014R97
6911	Test 2014R98
273	Test 2014R99
25574	Test 2014S10
3190	Test 2014S118
91	Test 2014S119
2823	Test 2014S120
7597	Test 2014S121
9149	Test 2014S122
1405	Test 2014S123
911	Test 2014S124
49911	Test 2014S17
25263	Test 2014S2
1728	Test 2014S247
459	Test 2014S3
10480	Test 2014S4
3553	Test 2014S5
2532	Test 2014S6
2728	Test 2014S64
9710	Test 2014S7
12997	Test 2014S8
5149	Test 2014S9
108882	Test 2014TB10
49056	Test 2014TB17
544	Test 2014TB232
391	Test 2014TB233
108	Test 2014TB234
1	Test 2014TB235
159	Test 2014TB236
578	Test 2014TB237
626	Test 2014TB238
91	Test 2014TB239
64	Test 2014TB240
342	Test 2014TB241
950	Test 2014TB242
476	Test 2014TB243
32	Test 2014TB244
324	Test 2014TB245
1855	Test 2014TB246
2795	Test 2014TB247
2698	Test 2014TB64
*/

select distinct ixSourceCode from PJC_21437_CSTCombinedFileOutputs

-- drop table ASC_21437_CST4TestMarketPulls
select *
into ASC_21437_CST4TestMarketPulls
from PJC_21437_CSTCombinedFileOutputs CFO
    join PJC_21437_TestSegmentsRFM RFM on CFO.ixSourceCode = RFM.sSourceCode


-- truncate table ASC_21437_CST4TestMarketPulls_Flat
-- drop table ASC_21437_CST4TestMarketPulls_Flat

-- initial pull of all customers
select DISTINCT ixCustomer  -- 177,035
into ASC_21437_CST4TestMarketPulls_Flat
from ASC_21437_CST4TestMarketPulls
 
-- added columns Street, Race, TBucket, OpenWheel


/** UPDATES BASED ON MARKET **/
-- STREET
update FLAT 
set FLAT.Street = B.RFMM,
    FLAT.StreetFrequency = B.iFrequency,
    FLAT.StreetMonetary = B.mMonetary,
    FLAT.StreetRecency = B.iRecency,
    FLAT.StreetMarket = B.sMarket
from ASC_21437_CST4TestMarketPulls_Flat FLAT
 join ASC_21437_CST4TestMarketPulls B on FLAT.ixCustomer = B.ixCustomer 
WHERE B.ixSourceCode like '%2014S%'

-- RACE 
update FLAT 
set FLAT.Race = B.RFMM,
    FLAT.RaceFrequency = B.iFrequency,
    FLAT.RaceMonetary = B.mMonetary,
    FLAT.RaceRecency = B.iRecency,
    FLAT.RaceMarket = B.sMarket
from ASC_21437_CST4TestMarketPulls_Flat FLAT
 join ASC_21437_CST4TestMarketPulls B on FLAT.ixCustomer = B.ixCustomer 
WHERE B.ixSourceCode like '%2014R%'

-- TBUCKET
update FLAT 
set FLAT.TBucket = B.RFMM,
    FLAT.TBucketFrequency = B.iFrequency,
    FLAT.TBucketMonetary = B.mMonetary,
    FLAT.TBucketRecency = B.iRecency,
    FLAT.TBucketMarket = B.sMarket
from ASC_21437_CST4TestMarketPulls_Flat FLAT
 join ASC_21437_CST4TestMarketPulls B on FLAT.ixCustomer = B.ixCustomer 
WHERE B.ixSourceCode like '%2014TB%'

-- OPENWHEEL OpenWheel
update FLAT 
set FLAT.OpenWheel = B.RFMM,
    FLAT.OpenWheelFrequency = B.iFrequency,
    FLAT.OpenWheelMonetary = B.mMonetary,
    FLAT.OpenWheelRecency = B.iRecency,
    FLAT.OpenWheelMarket = B.sMarket
from ASC_21437_CST4TestMarketPulls_Flat FLAT
 join ASC_21437_CST4TestMarketPulls B on FLAT.ixCustomer = B.ixCustomer 
WHERE B.ixSourceCode like '%2014OW%'



-- CHECKS TO MAKE SURE correct # of rows has values for each market
select COUNT(*)
from ASC_21437_CST4TestMarketPulls
WHERE ixSourceCode like '%2014OW%'

select COUNT(*)
from ASC_21437_CST4TestMarketPulls_Flat
WHERE OpenWheel is NOT NULL


select top 10 * from ASC_21437_CST4TestMarketPulls_Flat


select COUNT(*)
from ASC_21437_CST4TestMarketPulls
WHERE ixSourceCode like '%2014S%'

select COUNT(*)
from ASC_21437_CST4TestMarketPulls_Flat
WHERE Street is NOT NULL


select COUNT(*)
from ASC_21437_CST4TestMarketPulls
WHERE ixSourceCode like '%2014TB%'

select COUNT(*)
from ASC_21437_CST4TestMarketPulls_Flat
WHERE TBucket is NOT NULL

select COUNT(*)
from ASC_21437_CST4TestMarketPulls
WHERE ixSourceCode like '%2014R%'

select COUNT(*)
from ASC_21437_CST4TestMarketPulls_Flat
WHERE Race is NOT NULL



select MAX(len (ixSourceCode)) from ASC_21437_CST4TestMarketPulls

select * from ASC_21437_CST4TestMarketPulls


select distinct ixSourceCode from ASC_21437_CST4TestMarketPulls
order by ixSourceCode


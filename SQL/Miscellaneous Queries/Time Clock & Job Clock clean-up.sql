-- Time Clock & Job Clock clean-up
SELECT * INTO [SMITemp].dbo.tblJobClock_BU_0311214 -- 683,337
from tblJobClock

select count(*) from tblJobClock                            -- 683337
select count(*) from [SMITemp].dbo.tblJobClock_BU_0311214   -- 683337


SELECT * INTO [SMITemp].dbo.tblTimeClock_BU_0311214 -- 215480
from tblTimeClock

select count(*) from tblTimeClock                            -- 215480
select count(*) from [SMITemp].dbo.tblTimeClock_BU_0311214   -- 215480


SELECT * INTO [SMITemp].dbo.tblTimeClockDetail_BU_0311214 -- 24654
from tblTimeClockDetail

select count(*) from tblTimeClockDetail                             -- 24654
select count(*) from [SMITemp].dbo.tblTimeClockDetail_BU_0311214    -- 24654


select count(*) from  [SMITemp].dbo.tblJobClock_BU_0311214 where ixDate >= 16803                -- 39969
select count(*) from tblJobClock where ixDate >= 16803 and dtDateLastSOPUpdate = '03/11/2014'   -- 40165
select * from tblJobClock where ixDate >= 16803 and dtDateLastSOPUpdate < '03/11/2014'   --
/*
ixDate	iStartTime	iStopTime	sJob	ixEmployee	dtDate	ixTransferNumber	ixSKU	sAction	iCompletedQuantity	iScrappedQuantity	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
16824	63556	63617	81-1	JCM2	2014-01-22 00:00:00.000	NULL	NULL	NULL	NULL	NULL	2014-01-23 00:00:00.000	12453
16827	47146	47207	87-1	NJS1	2014-01-25 00:00:00.000	NULL	NULL	NULL	NULL	NULL	2014-01-25 00:00:00.000	47155
16832	63255	63316	81-1	JCM2	2014-01-30 00:00:00.000	NULL	NULL	NULL	NULL	NULL	2014-01-31 00:00:00.000	12431
16864	47011	47072	87-1	JLM2	2014-03-03 00:00:00.000	NULL	NULL	NULL	NULL	NULL	2014-03-05 00:00:00.000	64942
*/

select count(*) from  [SMITemp].dbo.tblTimeClock_BU_0311214 where ixDate >= 16803               -- 10696
select count(*) from  tblTimeClock where ixDate >= 16803 and dtDateLastSOPUpdate = '03/11/2014' -- 10695
select * from  tblTimeClock where ixDate >= 16803 and dtDateLastSOPUpdate < '03/11/2014' --  
/*
ixDate	ixEmployee	ixTime	dtDate	    sComment	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
16864	JLM2	    0	    2014-03-03 	NULL	    2014-03-06      	52024
*/

select count(*) from  [SMITemp].dbo.tblTimeClockDetail_BU_0311214 where ixDate >= 16803               -- 17004
select count(*) from  tblTimeClockDetail where ixDate >= 16803 and dtDateLastSOPUpdate = '03/11/2014' --  17007
select *  from  tblTimeClockDetail where ixDate >= 16803 and dtDateLastSOPUpdate < '03/11/2014' --  ALL UPDATED

select * from tblTimeClockDetail where ixTimeOut is NULL and ixDate >= 16803
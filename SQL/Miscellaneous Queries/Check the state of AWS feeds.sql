-- Check the state of AWS feeds

SELECT @@SPID as 'Current SPID' -- 61

-- select top (5) * from tblAwsBatch order by 1 desc
-- select top 5 * from tblAwsQueue order by 1 desc
select 'UnprocessedOnDestination',* 
from DW.dbo.[tblAwsBulkTransferData]   btd 
where dtEndProcessTimeUtc is null;


-- LNK-SQL-LIVE-1
select format(sum(iAwsBatchSize),'###,###,###') as 'TotalProcessed' -- 110 sec
    ,CONVERT(VARCHAR,GETDATE(), 120) 'AsOf'
from tblAwsBatch

/*
Total                   
Processed	    AsOf                Duration            -- avg approx 2m updates/day
=============   =================== ======== 
  227,112,689	2019-09-24 08:30:18 33 sec     <-- periodicly reset?
1,690,899,281	2019-05-10 15:07:41 @2:45
1,619,636,832	2019-04-11 10:43:38
1,615,219,490	2019-04-09 16:20:38 
1,024,585,822	2018-08-09 10:07:17    
  979,502,459	2018-07-20 09:33:04
  930,635,735	2018-06-28 16:09:54  
  922,546,184	2018-06-25 13:06:38
  763,518,231	2018-04-05 10:45:10
  772,911,709	2018-04-10 11:01:55


ixAwsBulkTransferData
119819
*/


-- Info about what is in the queues
-- RUN in LNK-SQL-LIVE-1.[SMI Reporting]
select (select format(count(*),'###,###,##0') from tblAwsQueue (nolock) ) as QueueCount
    ,(select format(count(*),'###,###,###')from tblAwsQueueStage (nolock)) as 'QueueStageCount'
    ,(select max(ixAwsQueueTypeReference) as 'LastProcessedType'  from tblAwsQueue (nolock) ) as 'LastProcessedType'
    ,(select min(ixAwsQueueTypeReference) as 'LastProcessedType'  from tblAwsQueue (nolock) ) as 'minProcessedType'
    , FORMAT (getdate(),'MM/dd/yy hh:mm')
    /*          Queue   Last    Min
        Queue   Stage   Procsd  Procsd
        Count	Count	Type	Type    As OF
        ======  =====   ======  ======  ==============
        0	    523,354	NULL	NULL	11/26/19 08:11
        0	    397,608	NULL	NULL	11/26/19 09:40
        0	    158,311	NULL	NULL	11/26/19 11:01
    */


-- Info by type of the queue
-- RUN in LNK-SQL-LIVE-1.[SMI Reporting]
SELECT r.ixAwsQueueTypeReference, format(count(*),'###,###,###') as 'CntInStagingQueue', r.sTableName, FORMAT(getdate(),'yyyy.MM.dd hh:mm') 'AsOf'
FROM tblAwsQueueStage q (nolock) 
    inner join tblAwsQueueTypeReference r on q.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
--where r.ixAwsQueueTypeReference = 5  -- if you want to only look at a specific table
GROUP BY r.ixAwsQueueTypeReference, r.sTableName
   HAVING COUNT(*) > 10 -- more than X recoords in the queue    -- 9k@15:25
ORDER BY count(*) desc, sTableName
/*
ixAws
Queue   CntIn
Type    Staging
Ref     Queue	    sTableName	        AsOf
====    ======      =================   ================
99	    2,342,243	tblSKUTransaction	2019.11.27 11:40
99	    2,074,645	tblSKUTransaction	2019.11.27 01:18
99	    1,716,585	tblSKUTransaction	2019.11.27 04:36
*/


-- Info by type of the staging queue
-- RUN in LNK-SQL-LIVE-1.[SMI Reporting]
-- There are only records in this table for a short period of time.  Just long enough that it takes to take a snapshot of the data at that point in time

select r.ixAwsQueueTypeReference, r.sTableName, format(count(*),'###,###,###') as 'CntInQueue' 
from tblAwsQueue q (nolock) 
    inner join tblAwsQueueTypeReference r on q.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
group by r.ixAwsQueueTypeReference, r.sTableName
order by count(*) desc


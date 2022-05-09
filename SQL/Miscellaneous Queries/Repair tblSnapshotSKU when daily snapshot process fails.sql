-- Repair tblSnapshotSKU when daily snapshot process fails

SELECT @@SPID as 'Current SPID' -- 131

/******************************************************************************************************** 
    Snapshot data is fully collected in SOP before ANY records are fed to LNK-SQL-LIVE1.  
    The snapshot data in SOP is overwritten each day, so it NEEDS TO BE RESTORED THE SAME DAY IT FAILS!!!
    
    If not refed same day, insert the missing SKUs with the same data from the previous day.
    This will ensure matches on vendors, PGC's etc. instead of attempted matches on NULL.
    
    Failures usually caused by the server rebooting before the daily snapshot job has completed.
 ***********************************************************************************************************/
 
/****** VERIFY NO DAYS ARE MISSING and daily rowcounts are >= # of rows below *******/
select SS.ixDate, FORMAT(D.dtDate,'yyyy.MM.dd'), FORMAT(count(SS.ixSKU),'###,###') RecCnt
from tblSnapshotSKU SS
    left join tblDate D on SS.ixDate = D.ixDate
where SS.ixDate >= 19603 --	2021.09.01    <-- verified thru 19603 2021.09.01
group by SS.ixDate, D.dtDate
--having  COUNT(*) < 515856 --   <-- run with this commented out (rows returned should = days of current month.  If so, re-run with the commented back in to see if any days were short of rows 
order by ixDate

    /*********************************************************************       
        PROBLEM DAYS where tblSnapshotSKU failed to populate fully     
        DATES FROM 2/1/13 TO 08/11/20 - any problem dates have been fixed       
    **********************************************************************/   
    /*                  approx 
                        rows
    dtDate      ixDate  MISSING             Resolution
    ======      ======  ===========     ====================================
    10/25/20    19292   ALL
    10/15/20    19281   ALL
    08/27/20    19233   310k
    08/11/20    19211   455k
    10/22/19    18923   11k
    10/05/19    18906   30k             inserted data manually on 10-23-19
    */

        -- counts before and after problem date
        select SS.ixDate, CONVERT(VARCHAR, D.dtDate, 102)  AS 'Date' , FORMAT(COUNT(SS.ixSKU),'###,###') 'SKUcnt'
        from tblSnapshotSKU SS
            join tblDate D on SS.ixDate = D.ixDate
        where SS.ixDate in (19291, 19292, 19293)
        -- <-- start with 1st of month...the dates line up with rownumbers for quick translation
        group by SS.ixDate, D.dtDate
        order by SS.ixDate
        /*
        ixDate	Date	    QTY
        ======  ==========  =======
        19291	2020.10.24	495,602
        19292	2020.10.24  0       <-- corrected to 495,602
        19293	2020.10.26	495,606

        19281	2020.10.14	494,874
        19282   2020.10.15  0         <-- corrected to 494,874
        19283	2020.10.16	495,002

        19232	2020.08.26	489,039
        19233	2020.08.27	172,116 <-- corrected to 487,596
        19234	2020.08.28	150,038 

        19216	2020.08.10	487,582
        19217	2020.08.11	33,270  <-- corrected to 487,596
        19218	2020.08.12	487,960

        19181	2020.07.06	479,576
        19182	2020.07.07	300,412 <-- corrected to 479,667
        19183	2020.07.08	479,837

        19062	2020.03.09	467,545
        19063	2020.03.10	441,536 <-- corrected to 467,670
        19064	2020.03.11	467,833

        19017	2020.01.24	464,895
        19018	2020.01.25	138,579  <-- corrected to 464,956
        19019	2020.01.26	464,956

        */

select count(distinct ixDate) 
from tblSnapshotSKU
where ixDate between 19207 and 19234



/*************************************************
    PROBLEM ixDate = 19292  
 ************************************************/
    select FORMAT(COUNT(*),'###,###') RecCount from tblSnapshotSKU where ixDate = 19292  -- 0    PROBLEM ixDate
    
    /*  1. ONLY IF THE DATA IS BAD... clear the data for the problem day

        DELETE from tblSnapshotSKU -- 7,691
        where ixDate = 16877
    */

    select FORMAT(COUNT(*),'###,###') RecCount from tblSnapshotSKU where ixDate = 19291  -- 495,602  PREVIOUS GOOD ixDate
    
    -- 2. insert the previous days data into the table adding 1 to the ixDate
    -- DROP TABLE [SMITemp].dbo.PJC_Missing_Snapshot_SKUs
    SELECT ixSKU, 
        iFIFOQuantity, mFIFOExtendedCost, mAverageCost, 
        (ixDate+1) as ixDate, -- converting it to the date that missing SKUs so it can be directly inserted into tblSnapshotSKU
        mLastCost, ixPGC, ixPrimaryVendor, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, mPriceLevel1
    into [SMITemp].dbo.PJC_Missing_Snapshot_SKUs -- 316,927 -- roughly 4- 6 mins
    FROM  [SMI Reporting].dbo.tblSnapshotSKU GOOD
    WHERE GOOD.ixDate = 19291
        AND ixSKU NOT IN (-- The Date w/missing SKUs
                          SELECT ixSKU 
                          from tblSnapshotSKU
                          WHERE ixDate = 19292)--Problem Date
                          
    SELECT FORMAT(COUNT(*),'###,###') RecCount FROM  [SMITemp].dbo.PJC_Missing_Snapshot_SKUs -- 495,602
    
    select top 10 * from  [SMITemp].dbo.PJC_Missing_Snapshot_SKUs  -- verify ixDate was altered to the date that is being "repaired" 
        


BEGIN TRAN    
    -- set rowcount 20000
    -- set rowcount 50000    -- 10K seems to be a good batch size         400k done
    SELECT GETDATE() AS 'insert START'   
    GO 
        INSERT INTO [SMI Reporting].dbo.tblSnapshotSKU
        select M.*
        from [SMITemp].dbo.PJC_Missing_Snapshot_SKUs M 
    GO

    DELETE FROM [SMITemp].dbo.PJC_Missing_Snapshot_SKUs 
    WHERE ixSKU in (select ixSKU from [SMI Reporting].dbo.tblSnapshotSKU
                    where ixDate = 19292)-- problem date
    GO
    SELECT GETDATE() AS 'delete END'    
    
ROLLBACK TRAN        
        /*  Avg     batch
            Mins    size
            1.5     50K --  3.3 3.5 3.0 4.0 3.6 3.4 6.0 3.7 3.4 3.0

            10,945g
             1,233s

             384
             511

             11,330
             1,744

        */                 
    SELECT COUNT(*) FROM [SMITemp].dbo.PJC_Missing_Snapshot_SKUs   -- 250K to go
    SELECT * FROM [SMITemp].dbo.PJC_Missing_Snapshot_SKUs   

    -- 3. verify
    select ixDate, FORMAT(COUNT(*),'###,###') 'SKUCount'
    from tblSnapshotSKU 
    where ixDate between 19291 and 19293 -- 453834v  verify previous day qty is matched OR slightly exceeded if problem day had some initial data
    group by ixDate
    order by ixDate
    /*
    ixDate	SKUCount
    19291	495,602
    19292	495,602
    19293	495,606
    */
  
 

 -- how long is daily process taking to complete?  -- NO LONGER USABLE SINCE SSA job populates same datetimestamp for every record
 -- DROP table #DailyRunTime
SELECT ixDate,
     min(ixTimeLastSOPUpdate) 'ixStartTime',  
     max(ixTimeLastSOPUpdate) 'ixFinishTime',
     (max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate)) 'TotalSeconds',
     count(*) 'RecCount'
INTO #DailyRunTime
FROM tblSnapshotSKU
WHERE ixDate between 19273 and 19273 --between 18629 and 18993 -- 1/1/19 and 12/31/19   approx 10 mins to run on DW1
GROUP BY ixDate

/*      avg hrs to 
year Q  complete daily process
==== =  =======================
2019    
2019    3.7 -- 1/1/19-10/21/19
2018    6.7 -- Aug-Dec
2016 3  4.0 -- thru 7/1-8/20

*/

select * 
from #DailyRunTime
order by ixDate desc
/*                                                AVG  RANGE    DATES
                                            1 wk: 5.9  4.3-6.9  (9/23-9/29)
        ixStart ixFinish Total              4 wk: 6.3  4.3-8.2  (9/02-9/29)
ixDate	Time	Time	Seconds Hrs         
======  ====    =====   ======= ===
19274	6366	6374	8	
19273	5466	5475	9
19272	4268	4276	8  
19271	4270	4278	8  
19270	4267	4276	9
19269	6367	6374	7	        
19268	1079	53735	52656	n/a -- testing new SSA job
19267	330	    19203	18873	5.3
19266	329	    25060	24731   6.9
19265	328 	15809	15481   4.3 -- MON 09/28/2020
19264	1175	19148	17973   5.0
19263	329 	23465	23136   6.4
19262	328	    20016	19688   5.5
19261	334	    23417	23083   6.4
19260	329	    23616	23287   6.5 
19259	328	    24073	23745   6.6
19258	330	    21648	21318   5.9 -- MON 09/21/2020
19257	328	    22375	22047   6.1
19256	328	    9687	9359    incorrect
19255	335	    51817	51482   restarted
19254	331	    61198	60867   restarted
19253	330	    23966	23636   6.6
19252	329	    24484	24155	6.7
19251	327 	22807	22480   6.2
19250	328 	23763	23435   6.5
19249	329 	21537	21208   5.9
19248	328	    27846	27518   7.6  -- 07:44:06  
19247	329	    20861	20532   5.7  -- removed Begin TRY and Catch logic
19246	332	    23679	23347   6.5  -- changed proc to insert only
19245	338	    24946	24608   6.8
19244	332	    21356	21024   5.8
19243	330	    20930	20600   5.7
19242	328	    29994	29666   8.2
19241	329	    20603	20274   5.6
19240	329	    29767	29438   8.2
19239	6624	28978	22354   6.2 -- WED 09/02/2020
19238	6629	53998	47369   13.2
19237	7714	29401	21687    6.0

ixDate	TotSec  Hrs
======  ======  ====
19236	26538	 7.3
19235	47573	13.2

select * from tblTime where ixTime = 19203 -- 06:55:46 - 08:19:54  

select ixTime, chTime from tblTime where chTime like '%00:00'
/*
ixTime	chTime
25200	07:00:00  
28800	08:00:00  
32400	09:00:00  
*/

select count(*) from tblSKULocation where flgActive = 1
select count(*) from vwSKUMultiLocation where flgActive = 1 or iQAV > 0 208889 active 213,581
select count(*) from vwSKUMultiLocation where flgActive = 0 and iQAV > 0 -- 4692


select top 10 * from tblCatalogDetail



 
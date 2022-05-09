-- Age of most recent SKU Transaction on LNK-SQL-LIVE1 2 and AWS

/*  NEED function GetTodaysixDate on LNK-SQL-LIVE2
    SKU Transactions are not currently fed to AWS.  Add them to the report later on
*/
SELECT (select [dbo].GetTodaysixDate()) 'TodaysixDate',
        (select max(ixDate) from tblSKUTransaction) 'NewestTransactionixDate'
INTO #TempDates

-- Most recent SKU Transactions
select top 1 
    'LNK-SQL-LIVE-1' Server,
   (TD.TodaysixDate-TD.NewestTransactionixDate)         AS 'DaysOld',
   (ST.ixTimeLastSOPUpdate-ST.ixTime)                   AS 'SecondsOld'  
--   CONVERT(VARCHAR(10), getdate(), 108)                 AS 'CurrentTime',
--   T2.chTime                                            AS 'SOPUpdated',
--   T.chTime                                             AS 'TransTime',  
--   CONVERT(VARCHAR(10), getdate(), 101)                 AS 'Today',
--   CONVERT(VARCHAR(10), D.dtDate, 101)                  AS 'TransDate',
--   CONVERT(VARCHAR(10), ST.dtDateLastSOPUpdate, 101)    AS 'SOPUpdateDate',
--   iSeq
from tblSKUTransaction ST
    join tblTime T on ST.ixTime = T.ixTime
    join tblTime T2 on ST.ixTimeLastSOPUpdate = T2.ixTime
    join tblDate D on D.ixDate = ST.ixDate
    left join #TempDates TD on TD.NewestTransactionixDate = D.ixDate
where ST.ixDate = TD.NewestTransactionixDate 
order by T.chTime desc

DROP TABLE #TempDates

-- select * from #TempDates 


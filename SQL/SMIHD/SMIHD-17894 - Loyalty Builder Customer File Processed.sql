-- SMIHD-17894 - Loyalty Builder Customer File Processed
-- the subscription SSA job will be edited to only deliver when there are records returned
select sFileProcessingType as 'FileProcessingType',
    dtStartUtc as 'FileStartedUTC',
    dtEndUtc 'FileEndedUTC',
    iRecordsProcessed 'RecordsProcessed',
    iTotalTimeInMinutes 'TotalMinutes'
from openquery([TNGREADREPLICA],
                'SELECT fpt.sFileProcessingType, fph.dtEndUtc, fph.dtStartUtc, fph.iRecordsProcessed, fph.iTotalTimeInMinutes 
                FROM LoggingLive.tblFileProcessingHistory AS fph 
                    INNER JOIN LoggingLive.tblFileProcessingType AS fpt ON fph.ixFileProcessingType = fpt.ixFileProcessingType
                WHERE fph.dtEndUtc > DATE_ADD(NOW(),INTERVAL -240 hour)
                ORDER BY 1 DESC;
                ')


/*orig from Ron
select * from openquery([TNGREADREPLICA],
'SELECT 
fpt.sFileProcessingType, fph.dtEndUtc, fph.dtStartUtc, fph.iRecordsProcessed, fph.iTotalTimeInMinutes 
FROM 
LoggingLive.tblFileProcessingHistory AS fph 
INNER JOIN
LoggingLive.tblFileProcessingType AS fpt ON fph.ixFileProcessingType = fpt.ixFileProcessingType
WHERE
fph.dtEndUtc > DATE_ADD(NOW(),INTERVAL -240 hour)
ORDER BY 1 DESC;
')

*/

SELECT * FROM tblJobClock
where sJob in ('41-6','41-12')
order by sJob, dtDate desc
/*
        Last
Job     Logged
=====   ==========
41-6    04-22-2020  
41-12   12-02-2019  only logged twice for 107 seconds total (probably only for testing)





*/





IF EXISTS(select *
          from openquery([TNGREADREPLICA],
                        'SELECT fpt.sFileProcessingType, fph.dtEndUtc, fph.dtStartUtc, fph.iRecordsProcessed, fph.iTotalTimeInMinutes 
                        FROM LoggingLive.tblFileProcessingHistory AS fph 
                            INNER JOIN LoggingLive.tblFileProcessingType AS fpt ON fph.ixFileProcessingType = fpt.ixFileProcessingType
                        WHERE fph.dtEndUtc > DATE_ADD(NOW(),INTERVAL -240 hour)
                        ORDER BY 1 DESC;
                        ')
           )

BEGIN
   exec [ReportServer].dbo.AddEvent @EventType='TimedSubscription', @EventData='16e4f599-cb88-48f1-a879-ecd0f1c79f8e'
END

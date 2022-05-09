-- Failed Report Subscriptions
USE [ReportServer];  -- You may change the database name. 
GO 

SELECT 
     CAT.[Path] 'Path/ReportName'
     --CAT.[Name] AS RptName
     --, U.UserName
     ,U.UserName AS 'SubscriptionOwner' 
     --, res.ScheduleID AS JobID
     /*
     , LEFT(CAST(sch.next_run_date AS CHAR(8)) , 4) + '-'
             + SUBSTRING(CAST(sch.next_run_date AS CHAR(8)) , 5 , 2) + '-'
             + RIGHT(CAST(sch.next_run_date AS CHAR(8)) , 2) + ' '
             + CASE WHEN LEN(CAST(sch.next_run_time AS VARCHAR(6))) = 5
                     THEN '0' + LEFT(CAST(sch.next_run_time AS VARCHAR(6)) , 1)
                     ELSE LEFT(CAST(sch.next_run_time AS VARCHAR(6)) , 2)
                     END + ':'
                     + CASE WHEN LEN(CAST(sch.next_run_time AS VARCHAR(6))) = 5
                     THEN SUBSTRING(CAST(sch.next_run_time AS VARCHAR(6)) , 2 , 2)
                     ELSE SUBSTRING(CAST(sch.next_run_time AS VARCHAR(6)) , 3 , 2)
                     END + ':00.000' AS NextRunTime
                     , CASE WHEN job.[enabled] = 1 THEN 'Enabled'
                     ELSE 'Disabled'
                END AS JobStatus
      */                
     , sub.LastRuntime
     , sub.LastStatus
     , sub.ModifiedDate 'LastModified'        
    -- , sub.EventType
     , sub.Parameters
    -- , sub.Version
    ,sub.[Description] 'SubscriptionDescription' 
    ,sub.DeliveryExtension 
FROM
 dbo.Catalog AS cat 
    INNER JOIN dbo.Subscriptions AS sub ON CAT.ItemID = sub.Report_OID
    INNER JOIN dbo.ReportSchedule AS res ON CAT.ItemID = res.ReportID
                                         AND sub.SubscriptionID = res.SubscriptionID
    INNER JOIN msdb.dbo.sysjobs AS job ON CAST(res.ScheduleID AS VARCHAR(36)) = job.[name]
    INNER JOIN msdb.dbo.sysjobschedules AS sch ON job.job_id = sch.job_id
    INNER JOIN dbo.Users U ON U.UserID = sub.OwnerID
 WHERE sub.LastStatus NOT LIKE 'Mail sent to%' 
 and sub.LastStatus <> 'New Subscription'
 and sub.LastRunTime > DATEADD(dd,-4,DATEDIFF(dd,0,getdate())) -- past 7 days
-- U.UserName LIKE '%r%m%'  
-- sub.SubscriptionID in ('80977E60-99DD-458D-B6FA-65609D3914DD','86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8') 
ORDER BY CAT.Path
    -- sub.LastStatus -- to see failed subscriptions

    
    
    
    
/*    
SELECT * FROM dbo.Subscriptions
where sub.LastStatus NOT LIKE 'Mail sent to%' 
 and sub.LastStatus <> 'New Subscription'
 and sub.LastRunTime > DATEADD(dd,-7,DATEDIFF(dd,0,getdate()))
 */
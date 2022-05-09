-- Subscription Query 1st Version

USE [REPORTSERVER]

SELECT
    CAT.Name AS 'ReportName',
    CAT.[Path],
    U.UserName 'SubscriptionOwner',
--    sub.SubscriptionID,
    REP_SCH.ScheduleID AS 'SQLJobID', 
    CASE SCH.recurrencetype WHEN 1 THEN 'Once' WHEN 3 THEN CASE SCH.daysinterval WHEN 1 THEN 'Every day' ELSE 'Every other ' + CAST(SCH.daysinterval AS varchar) + ' day.' END WHEN 4 THEN CASE SCH.daysofweek WHEN 1 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Sunday' WHEN 2 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Monday' WHEN 4 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Tuesday' WHEN 8 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Wednesday' WHEN 16 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Thursday' WHEN 32 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Friday' WHEN 64 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Saturday' WHEN 42 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Monday, Wednesday, and Friday' WHEN 62 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Monday, Tuesday, Wednesday, Thursday and Friday' WHEN 126 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week FROM Monday to Saturday' WHEN 127 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar)  + ' week on every day' END WHEN 5 THEN CASE SCH.daysofmonth WHEN 1 THEN 'Day ' + '1' + ' of each month' WHEN 2 THEN 'Day ' + '2' + ' of each month' WHEN 4 THEN 'Day ' + '3' + ' of each month' WHEN 8 THEN 'Day ' + '4' + ' of each month' WHEN 16 THEN 'Day ' + '5' + ' of each month' WHEN 32 THEN 'Day ' + '6' + ' of each month' WHEN 64 THEN 'Day ' + '7' + ' of each month' WHEN 128 THEN 'Day ' + '8' + ' of each month' WHEN 256 THEN 'Day ' + '9' + ' of each month' WHEN 512 THEN 'Day ' + '10' + ' of each month' 
        WHEN 1024 THEN 'Day ' + '11' + ' of each month' WHEN 2048 THEN 'Day ' + '12' + ' of each month' WHEN 4096 THEN 'Day ' + '13' + ' of each month' WHEN 8192 THEN 'Day ' + '14' + ' of each month' WHEN 16384 THEN 'Day ' + '15' + ' of each month' WHEN 32768 THEN 'Day ' + '16' + ' of each month' WHEN 65536 THEN 'Day ' + '17' + ' of each month' WHEN 131072 THEN 'Day ' + '18' + ' of each month' WhEN 262144 THEN 'Day ' + '19' + ' of each month' WHEN 524288 THEN 'Day ' + '20' + ' of each month' WHEN 1048576 THEN 'Day ' + '21' + ' of each month' WHEN 2097152 THEN 'Day ' + '22' + ' of each month' WHEN 4194304 THEN 'Day ' + '23' + ' of each month' WHEN 8388608 THEN 'Day ' + '24' + ' of each month' WHEN 16777216 THEN 'Day ' + '25' + ' of each month' WHEN 33554432 THEN 'Day ' + '26' + ' of each month' WHEN 67108864 THEN 'Day ' + '27' + ' of each month' WHEN 134217728 THEN 'Day ' + '28' + ' of each month' WHEN 268435456 THEN 'Day ' + '29' + ' of each month' WHEN 536870912 THEN 'Day ' + '30' + ' of each month' WHEN 1073741824 THEN 'Day ' + '31' + ' of each month' END WHEN 6 THEN 'The ' + CASE SCH.monthlyweek WHEN 1 THEN 'first' WHEN 2 THEN 'second' WHEN 3 THEN 'third' WHEN 4 THEN 'fourth' WHEN 5 THEN 'last' ELSE 'UNKNOWN' END + ' week of each month on ' + CASE SCH.daysofweek WHEN 2 THEN 'Monday' WHEN 4 THEN 'Tuesday' ELSE 'Unknown' END ELSE 'Unknown' END + ' at ' + LTRIM(RIGHT(CONVERT(varchar, SCH.StartDate, 100), 7)) 
    AS 'ScheduleDetails'
    , LTRIM(RIGHT(CONVERT(varchar, SCH.StartDate, 100), 7)) 'ExecStartTime'
    , SCH.RecurrenceType
    , sub.Parameters
    , sub.ModifiedDate
    , CASE WHEN job.[enabled] = 1 THEN 'Enabled' ELSE 'Disabled' END AS 'JobStatus'
    , sub.LastStatus
    , sub.LastRuntime
    , LEFT(CAST(schd.next_run_date AS CHAR(8)) , 4) + '-' + SUBSTRING(CAST(schd.next_run_date AS CHAR(8)) , 5 , 2) + '-' + RIGHT(CAST(schd.next_run_date AS CHAR(8)) , 2) + ' ' + CASE WHEN LEN(CAST(schd.next_run_time AS VARCHAR(6))) = 5 THEN '0' + LEFT(CAST(schd.next_run_time AS VARCHAR(6)) , 1) ELSE LEFT(CAST(schd.next_run_time AS VARCHAR(6)) , 2) END + ':' + CASE WHEN LEN(CAST(schd.next_run_time AS VARCHAR(6))) = 5 THEN SUBSTRING(CAST(schd.next_run_time AS VARCHAR(6)) , 2 , 2)ELSE SUBSTRING(CAST(schd.next_run_time AS VARCHAR(6)) , 3 , 2) END + ':00.000' AS NextRunTime, CAT.Path AS 'ReportPath' 
FROM dbo.Catalog AS cat 
    INNER JOIN dbo.ReportSchedule AS REP_SCH ON CAT.ItemID = REP_SCH.ReportID 
    INNER JOIN msdb.dbo.sysjobs AS job ON CAST(REP_SCH.ScheduleID AS VARCHAR(36)) = job.[name]
    INNER JOIN msdb.dbo.sysjobschedules AS schd ON job.job_id = schd.job_id
    INNER JOIN dbo.Schedule AS SCH ON REP_SCH.ScheduleID = SCH.ScheduleID 
    INNER JOIN dbo.Subscriptions AS sub ON sub.SubscriptionID = REP_SCH.SubscriptionID
    INNER JOIN dbo.Users U ON U.UserID = sub.OwnerID    
WHERE (LEN(CAT.Name) > 0)
--  AND CAT.Name like '%AWS%' -- Report Name
 --  AND U.UserName NOT LIKE '%PJC%'
  --AND sub.Parameters like '%Z25A2%'
 -- AND LTRIM(RIGHT(CONVERT(varchar, SCH.StartDate, 100), 7)) like '%PM%'
 -- AND CAT.Path LIKE '/Speedway%'
 -- AND ItemID in ('35FAB226-8DB8-47D0-98E8-113A805A2F9B','7BF9AC6A-C525-4123-A1B6-A5AA4E4C4670')
--  AND sub.SubscriptionID in  ('242E4AFD-2259-4FC6-AF09-F5DF2858D992','B917C6A9-4F87-4DB5-B32E-3E346762A4A7')
-- and sub.LastStatus <> 'Disabled'
and job.[enabled] = 1 -- 'Enabled'
ORDER BY -- sub.SubscriptionID
    U.UserName
   , CAT.Path
 --  , 'ReportName' 
   , LTRIM(RIGHT(CONVERT(varchar, SCH.StartDate, 100), 7)) 
     --ExecStartTime        

select * from Subscriptions where SubscriptionID = '35FAB226-8DB8-47D0-98E8-113A805A2F9B'


/*

--OR
-- Subscription Query 2nd Version
--This code is from: http://www.sqlservercentral.com/Forums/Topic1131922-150-1.aspx#bm1132607 

SELECT CAT.[Name] AS RptName
     , U.UserName 'SubscriptionOwner'
     , CAT.[Path]
     , res.ScheduleID AS JobID
     , sub.LastRuntime
     , sub.LastStatus
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
     , sub.ModifiedDate
     , sub.Description
     , sub.EventType
     , sub.Parameters
     , sub.DeliveryExtension
     , sub.Version
FROM dbo.Catalog AS cat INNER JOIN dbo.Subscriptions AS sub ON CAT.ItemID = sub.Report_OID
    INNER JOIN dbo.ReportSchedule AS res ON CAT.ItemID = res.ReportID
                                         AND sub.SubscriptionID = res.SubscriptionID
    INNER JOIN msdb.dbo.sysjobs AS job ON CAST(res.ScheduleID AS VARCHAR(36)) = job.[name]
    INNER JOIN msdb.dbo.sysjobschedules AS sch ON job.job_id = sch.job_id
    INNER JOIN dbo.Users U ON U.UserID = sub.OwnerID
--WHERE --U.UserName NOT IN ('SPEEDWAYMOTORS\pjcrews','SPEEDWAYMOTORS\jmmoss','SPEEDWAYMOTORS\ascrook')
   -- and CAT.[Path] LIKE'%AFCO%'
-- U.UserName LIKE '%r%m%'  
 --sub.SubscriptionID in ('BEC8F5E4-FD85-4AB5-8A8F-8FCE056B11A9')
 --sub.SubscriptionID in ('80977E60-99DD-458D-B6FA-65609D3914DD','86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8') 
ORDER BY CAT.[Name]
    -- CAT.Path
    -- sub.LastStatus -- to see failed subscriptions
    -- U.UserName

    

SELECT * FROM [ReportServer].dbo.Subscriptions
WHERE SubscriptionID in ('80977E60-99DD-458D-B6FA-65609D3914DD','86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8')
    
  
-- SUBSCRIPTION COUNT BY OWNER
SELECT
     -- CAT.[Name] AS RptName
      U.UserName 'SubscriptionOwner'
     /*, CAT.[Path]
     , res.ScheduleID AS JobID
     , sub.LastRuntime
     , sub.LastStatus
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
     , sub.ModifiedDate
     , sub.Description
     , sub.EventType
     , sub.Parameters
     */
          , COUNT(CAT.ItemID)
FROM dbo.Catalog AS cat INNER JOIN dbo.Subscriptions AS sub ON CAT.ItemID = sub.Report_OID
 INNER JOIN dbo.ReportSchedule AS res ON CAT.ItemID = res.ReportID
                                         AND sub.SubscriptionID = res.SubscriptionID
 INNER JOIN msdb.dbo.sysjobs AS job ON CAST(res.ScheduleID AS VARCHAR(36)) = job.[name]
 INNER JOIN msdb.dbo.sysjobschedules AS sch ON job.job_id = sch.job_id
 INNER JOIN dbo.Users U ON U.UserID = sub.OwnerID
WHERE U.UserName NOT IN ('SPEEDWAYMOTORS\pjcrews','SPEEDWAYMOTORS\jmmoss','SPEEDWAYMOTORS\ascrook')
    and CAT.[Path] LIKE'%AFCO%'
-- U.UserName LIKE '%r%m%'  
 -- sub.SubscriptionID in ('B37D6216-DF0F-450B-9AD4-3D9B2140D506','DCE9ED23-36BC-4071-851F-32D058088F67','B795DCB6-5D0C-4881-BF46-9B9B56693D7A', 'AD8CF78B-CBBB-4BF4-A1B3-2863958A4981','3C47E220-E4D3-487F-BE9B-8F8B26D6A4CE')
 --sub.SubscriptionID in ('80977E60-99DD-458D-B6FA-65609D3914DD','86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8') 
GROUP BY U.UserName 
ORDER BY
    -- CAT.Path
    -- sub.LastStatus -- to see failed subscriptions
     U.UserName

*/


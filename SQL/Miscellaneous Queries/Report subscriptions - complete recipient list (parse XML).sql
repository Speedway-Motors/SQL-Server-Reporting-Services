-- Report Subscriptions - COMPLETE RECIPIENT LIST (parse XML)

/***********************   FIND EMPLOYEES  ***********************
    SELECT ixEmployee 'Emp', sFirstname 'First', sLastname 'Last',
        ixDepartment 'Dpt',	flgCurrentEmployee 'Cur', sEmailAddress 'Email',
        FORMAT(dtHireDate,'yyyy.MM.dd') 'Hired',	
        FORMAT(dtTerminationDate,'yyyy.MM.dd') 'Termed', flgPayroll
    FROM tblEmployee
    WHERE 
        UPPER(ixEmployee) like 'R%S%' --in ('SJP','JAP2')      
        --UPPER(sLastname) in ('STICHKA','COREY','AINSLIE','MUTH')      
        -- LOWER(sEmailAddress) in ('aawaters@afacoracing.com','aawaters@afcoracing.com','ajbenton@speedwaymotors.com')
        -- ixEmployee in ('WCN','AJBIII','DMH')
            -- AND flgCurrentEmployee = 0
        
            First   Last        Cur
    Emp     name	name	Dpt	Emp     Email
    ====    ======= ======= === ======= ==============================
    RTA	    RYAN	AINSLIE	82	1	    RTAINSLIE@SPEEDWAYMOTORS.COM
    AEC	    ALAN	COREY	9	1	    AECOREY@SPEEDWAYMOTORS.COM
    CAM1	CODY	MUTH	81	1	    CAMUTH@SPEEDWAYMOTORS.COM
    DKS	    DUSTIN	STICHKA	82	0	    DKSTICHKA@SPEEDWAYMOTORS.COM
        
 */

USE [ReportServer];

-- SUBSCRIPTION DETAILS
WITH subscriptionXmL

          AS (  SELECT CAT.Name AS 'ReportName', 
                CAT.[Path],
                U.UserName 'SubscriptionOwner',
                CASE S.recurrencetype WHEN 1 THEN 'Once' WHEN 3 THEN CASE S.daysinterval WHEN 1 THEN 'Every day' ELSE 'Every other ' + CAST(S.daysinterval AS varchar) + ' day.' END WHEN 4 THEN CASE S.daysofweek WHEN 1 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Sunday' WHEN 2 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Monday' WHEN 4 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Tuesday' WHEN 8 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Wednesday' WHEN 16 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Thursday' WHEN 32 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Friday' WHEN 64 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Saturday' WHEN 42 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Monday, Wednesday, and Friday' WHEN 62 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week on Monday, Tuesday, Wednesday, Thursday and Friday' WHEN 126 THEN 'Every ' + CAST(S.weeksinterval AS varchar) + ' week FROM Monday to Saturday' WHEN 127 THEN 'Every ' + CAST(S.weeksinterval AS varchar)  + ' week on every day' END WHEN 5 THEN CASE S.daysofmonth WHEN 1 THEN 'Day ' + '1' + ' of each month' WHEN 2 THEN 'Day ' + '2' + ' of each month' WHEN 4 THEN 'Day ' + '3' + ' of each month' WHEN 8 THEN 'Day ' + '4' + ' of each month' WHEN 16 THEN 'Day ' + '5' + ' of each month' WHEN 32 THEN 'Day ' + '6' + ' of each month' WHEN 64 THEN 'Day ' + '7' + ' of each month' WHEN 128 THEN 'Day ' + '8' + ' of each month' WHEN 256 THEN 'Day ' + '9' + ' of each month' WHEN 512 THEN 'Day ' + '10' + ' of each month' 
                    WHEN 1024 THEN 'Day ' + '11' + ' of each month' WHEN 2048 THEN 'Day ' + '12' + ' of each month' WHEN 4096 THEN 'Day ' + '13' + ' of each month' WHEN 8192 THEN 'Day ' + '14' + ' of each month' WHEN 16384 THEN 'Day ' + '15' + ' of each month' WHEN 32768 THEN 'Day ' + '16' + ' of each month' WHEN 65536 THEN 'Day ' + '17' + ' of each month' WHEN 131072 THEN 'Day ' + '18' + ' of each month' WhEN 262144 THEN 'Day ' + '19' + ' of each month' WHEN 524288 THEN 'Day ' + '20' + ' of each month' WHEN 1048576 THEN 'Day ' + '21' + ' of each month' WHEN 2097152 THEN 'Day ' + '22' + ' of each month' WHEN 4194304 THEN 'Day ' + '23' + ' of each month' WHEN 8388608 THEN 'Day ' + '24' + ' of each month' WHEN 16777216 THEN 'Day ' + '25' + ' of each month' WHEN 33554432 THEN 'Day ' + '26' + ' of each month' WHEN 67108864 THEN 'Day ' + '27' + ' of each month' WHEN 134217728 THEN 'Day ' + '28' + ' of each month' WHEN 268435456 THEN 'Day ' + '29' + ' of each month' WHEN 536870912 THEN 'Day ' + '30' + ' of each month' WHEN 1073741824 THEN 'Day ' + '31' + ' of each month' END WHEN 6 THEN 'The ' + CASE S.monthlyweek WHEN 1 THEN 'first' WHEN 2 THEN 'second' WHEN 3 THEN 'third' WHEN 4 THEN 'fourth' WHEN 5 THEN 'last' ELSE 'UNKNOWN' END + ' week of each month on ' + CASE S.daysofweek WHEN 2 THEN 'Monday' WHEN 4 THEN 'Tuesday' ELSE 'Unknown' END ELSE 'Unknown' END + ' at ' + LTRIM(RIGHT(CONVERT(varchar, S.StartDate, 100), 7)) 
                AS 'ScheduleDetails',
                LTRIM(RIGHT(CONVERT(varchar, S.StartDate, 100), 7)) 'ExecStartTime',

                CASE WHEN job.[enabled] = 1 THEN 'Enabled' ELSE 'Disabled' END AS 'JobStatus',
                SUB.SubscriptionID ,   SUB.OwnerID , SUB.ExtensionSettings ,
                 SUB.Report_OID ,
                 SUB.Locale ,
                 SUB.InactiveFlags ,
                --SUB.ExtensionSettings ,
                 CONVERT(XML, SUB.ExtensionSettings) AS ExtensionSettingsXML ,
                 SUB.ModifiedByID ,
                 SUB.ModifiedDate ,
                 SUB.EventType ,
                 SUB.MatchData ,
                 SUB.LastRunTime ,
                LEFT(CAST(schd.next_run_date AS CHAR(8)) , 4) + '-' + SUBSTRING(CAST(schd.next_run_date AS CHAR(8)) , 5 , 2) + '-' + RIGHT(CAST(schd.next_run_date AS CHAR(8)) , 2) + ' ' + CASE WHEN LEN(CAST(schd.next_run_time AS VARCHAR(6))) = 5 THEN '0' + LEFT(CAST(schd.next_run_time AS VARCHAR(6)) , 1) ELSE LEFT(CAST(schd.next_run_time AS VARCHAR(6)) , 2) END + ':' + CASE WHEN LEN(CAST(schd.next_run_time AS VARCHAR(6))) = 5 THEN SUBSTRING(CAST(schd.next_run_time AS VARCHAR(6)) , 2 , 2)ELSE SUBSTRING(CAST(schd.next_run_time AS VARCHAR(6)) , 3 , 2) END + ':00.000' AS NextRunTime,
                 SUB.Parameters , 
                 SUB.DeliveryExtension ,
                 SUB.Version
FROM ReportServer.dbo.Subscriptions SUB
       left join [ReportServer].dbo.Users U on SUB.OwnerID = U.UserID
        left join [ReportServer].dbo.ReportSchedule RS on RS.SubscriptionID = SUB.SubscriptionID
        left join [ReportServer].dbo.Schedule S on S.ScheduleID = RS.ScheduleID
        left join [ReportServer].dbo.Catalog CAT on CAT.ItemID = SUB.Report_OID  
       INNER JOIN msdb.dbo.sysjobs AS job ON CAST(RS.ScheduleID AS VARCHAR(36)) = job.[name]
       INNER JOIN msdb.dbo.sysjobschedules AS schd ON job.job_id = schd.job_id
              ),
                  -- Get the settings as pairs
         SettingsCTE
          AS (  SELECT ReportName,
                [Path],
                 ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'),
                        'Value') AS SettingName ,
                Settings.value('(./*:Value/text())[1]', 'nvarchar(max)') AS SettingValue,
         --       SubscriptionOwner,
                ScheduleDetails,
                ExecStartTime,
                JobStatus,
      --          LastStatus,
      --          LastRuntime,
                NextRunTime,
                ModifiedDate
                --SubscriptionID ,    OwnerID ,   ExtensionSettings
                FROM subscriptionXmL
                 CROSS APPLY subscriptionXmL.ExtensionSettingsXML.nodes('//*:ParameterValue') Queries ( Settings )
              )
     SELECT *
     FROM SettingsCTE
     WHERE SettingName IN ('TO', 'CC', 'BCC' )
  -- AND SettingValue LIKE '%rjmcdowell%'  -- select * from tblDate where ixDate = 18214
   -- sdrauth@afcoracing.co213110-1m
   AND (SettingValue) LIKE '%adschneider%' 
        --  OR
        --  UPPER(SettingValue) LIKE '%AEC%' 
        --  OR
        --  UPPER(SettingValue) LIKE 'CAMUTH%' 
         -- OR
        --  UPPER(SettingValue) LIKE '%DKS%' 
        
-- bphestermann@speedwaymotors.com; jwkorth@speedwaymotors.com;bdrobbins@speedwaymotors.com; bkdittman@speedwaymotors.com; djgarcia@speedwamotors.com; jlwinsor@speedwaymotors.com; adschneider@speedwaymotors.com
 -- CTRL-SHIFT-L to make text all LOWER CASE



 -- select * from tblEmployee where ixEmployee like 'A%S%' order by sFirstname   ADS1

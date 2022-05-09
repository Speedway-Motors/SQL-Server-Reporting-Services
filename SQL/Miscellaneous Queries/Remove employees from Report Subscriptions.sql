-- Remove employees from Report Subscriptions

-- RUN ON DW1

USE [ReportServer]

-- FIND EMPLOYEES
    SELECT ixEmployee,'   ',sLastname,sFirstname,'     ', sEmailAddress, 
        CONVERT(VARCHAR, dtHireDate, 101) AS 'HireDate', CONVERT(VARCHAR, dtTerminationDate, 101) AS 'TermDate', 
        ixDepartment 'Dept',flgCurrentEmployee, sPayrollId
    from -- [SMI Reporting].dbo.tblEmployee
         [AFCOReporting].dbo.tblEmployee
    where-- ixEmployee like '%H' 
         UPPER(sLastname) like 'HE%' --in ('BROWN')
        --OR ixEmployee in ('SJP','JAP2')
        --OR LOWER(ixEmployee) like 'jap%'
        /*  ix                                                                                                  flgCurrent  Payroll
            Employee	Lastname	Firstname	EmailAddress                    HireDate    TermDate    Dept    Employee    Id
            =========   =========   ==========  =============================   ==========  ==========  ====    ==========  =======
            KMB	     	BROWN	    KRISTOPHER	KMBROWN@SPEEDWAYMOTORS.COM	    12/06/2008	NULL	    85	    1           05860
            SAT	     	TUCKER	    SAM	     	SATUCKER@SPEEDWAYMOTORS.COM	    12/13/2013	NULL	    85	    1
            TDJ	     	JOHNSON	    TYLER	    TDJOHNSON@SPEEDWAYMOTORS.COM	09/06/2011	04/30/2016	20      0	   
            5GAF	   	FUESLER	    GREGORY	    GAFUESLER@SPEEDWAYMOTORS.COM	12/06/2008	12/14/2015	60	    0	        02002
        */



-- REPORT SUBSCRIPTIONS - complete recipient list (parse XML)
   WITH subscriptionXmL
      AS (  SELECT SubscriptionID, OwnerID, Report_OID ,
            Locale, InactiveFlags, ExtensionSettings ,
            CONVERT(XML, ExtensionSettings) AS ExtensionSettingsXML ,
            ModifiedByID, ModifiedDate, Description ,LastStatus ,
            EventType, MatchData, LastRunTime, Parameters ,
            DeliveryExtension, Version
            FROM ReportServer.dbo.Subscriptions
         ),
                 -- Get the settings as pairs
        SettingsCTE
      AS (  SELECT
            SubscriptionID ,
            ExtensionSettings ,
            -- include other fields if you need them.
            ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'),
                   'Value') AS SettingName ,
            Settings.value('(./*:Value/text())[1]', 'nvarchar(max)') AS SettingValue
           FROM subscriptionXmL
            CROSS APPLY subscriptionXmL.ExtensionSettingsXML.nodes('//*:ParameterValue') Queries ( Settings )
         )
    SELECT * FROM SettingsCTE
    WHERE SettingName IN ( 'TO', 'CC', 'BCC' )
   AND UPPER(SettingValue) LIKE 'KLB%'
  -- AND UPPER(SettingValue) LIKE '%DASMALL%'


-- USE list of SubscriptionID values from above query 
    SELECT *,
        --CAT.itemid, sub.Report_OID, REP_SCH.ScheduleID AS 'SQLJobID' ,SCH.RecurrenceType,
        REP_SCH.reportID
        ,CAT.Path AS 'ReportNameAndPath'
        ,U.UserName AS 'SubscriptionOwner' 
        ,CAT.Name AS 'ReportName'       
        ,CASE SCH.recurrencetype 
            WHEN 1 THEN 'Once' 
            WHEN 3 THEN 
            CASE SCH.daysinterval 
            WHEN 1 THEN 'Every day' ELSE 'Every other ' + CAST(SCH.daysinterval AS varchar) 
            + ' day.' END WHEN 4 THEN CASE SCH.daysofweek WHEN 1 THEN 'Every ' 
            + CAST(SCH.weeksinterval AS varchar) 
            + ' week on Sunday' WHEN 2 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Monday' WHEN 4 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Tuesday' WHEN 8 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Wednesday' WHEN 16 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) 
            + ' week on Thursday' WHEN 32 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Friday' WHEN 64 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Saturday' WHEN 42 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week on Monday, Wednesday, and Friday' WHEN 62 THEN 'Every ' 
            + CAST(SCH.weeksinterval AS varchar) + ' week on Monday, Tuesday, Wednesday, Thursday and Friday' WHEN 126 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) + ' week from Monday to Saturday' WHEN 127 THEN 'Every ' + CAST(SCH.weeksinterval AS varchar) 
            + ' week on every day' END WHEN 5 THEN CASE SCH.daysofmonth WHEN 1 THEN 'Day ' + '1' + ' of each month' WHEN 2 THEN 'Day ' + '2' + ' of each month' WHEN 4 THEN 'Day ' + '3' + ' of each month' WHEN 8 THEN 'Day ' + '4' + ' of each month' WHEN 16 THEN 'Day ' + '5' + ' of each month' WHEN 32 THEN 'Day ' + '6' + ' of each month' WHEN 64 THEN 'Day ' + '7' + ' of each month' WHEN 128 THEN 'Day ' + '8' + ' of each month' WHEN 256 THEN 'Day ' + '9'
            + ' of each month' WHEN 512 THEN 'Day ' + '10' + ' of each month' WHEN 1024 THEN 'Day ' + '11' + ' of each month' WHEN 2048 THEN 'Day ' + '12' + ' of each month' WHEN 4096 THEN 'Day ' + '13' + ' of each month' WHEN 8192 THEN 'Day ' + '14' + ' of each month' WHEN 16384 THEN 'Day ' + '15' + ' of each month' WHEN 32768 THEN 'Day ' + '16' + ' of each month' WHEN 65536 THEN 'Day ' + '17' + ' of each month' WHEN 131072 THEN 'Day ' + '18' + ' of each month' WhEN 262144 THEN 'Day ' + '19' + ' of each month' WHEN 524288 THEN 'Day ' + '20' + ' of each month' WHEN 1048576 THEN 'Day ' + '21' + ' of each month'
            WHEN 2097152 THEN 'Day ' + '22' + ' of each month' WHEN 4194304 THEN 'Day ' + '23' + ' of each month' WHEN 8388608 THEN 'Day ' + '24' + ' of each month' WHEN 16777216 THEN 'Day ' + '25' + ' of each month' WHEN 33554432 THEN 'Day ' + '26' + ' of each month' WHEN 67108864 THEN 'Day ' + '27' + ' of each month' WHEN 134217728 THEN 'Day ' + '28' + ' of each month' WHEN 268435456 THEN 'Day ' + '29' + ' of each month' WHEN 536870912 THEN 'Day ' + '30' + ' of each month' WHEN 1073741824 THEN 'Day ' + '31' + ' of each month' END WHEN 6 THEN 'The ' + CASE SCH.monthlyweek WHEN 1 THEN 'first' WHEN
            2 THEN 'second' WHEN 3 THEN 'third' WHEN 4 THEN 'fourth' WHEN 5 THEN 'last' ELSE 'UNKNOWN' END + ' week of each month on ' + CASE SCH.daysofweek
            WHEN 2 THEN 'Monday' WHEN 4 THEN 'Tuesday' ELSE 'Unknown' END ELSE 'Unknown' END + ' at ' 
            + LTRIM(RIGHT(CONVERT(varchar, SCH.StartDate, 100), 7)) AS 'ScheduleDetails'
        ,LTRIM(RIGHT(CONVERT(varchar, SCH.StartDate, 100), 7)) 'ExecStartTime'
    FROM [ReportServer].dbo.Catalog AS cat 
        INNER JOIN [ReportServer].dbo.ReportSchedule AS REP_SCH ON CAT.ItemID = REP_SCH.ReportID 
        INNER JOIN [ReportServer].dbo.Schedule AS SCH ON REP_SCH.ScheduleID = SCH.ScheduleID 
        INNER JOIN [ReportServer].dbo.Subscriptions AS sub ON sub.SubscriptionID = REP_SCH.SubscriptionID
        LEFT JOIN [ReportServer].dbo.Users U ON U.UserID = sub.OwnerID
     WHERE (LEN(CAT.Name) > 0)
        -- AND CAT.Name like 'RealTime Out of Stock%' -- Report Name
        -- AND LTRIM(RIGHT(CONVERT(varchar, SCH.StartDate, 100), 7)) like '%PM%'
        -- AND CAT.Path LIKE '/Speedway%'
        -- AND CAT.Path LIKE '/AFCO%' 
        -- AND ItemID in ('B37D6216-DF0F-450B-9AD4-3D9B2140D506','DCE9ED23-36BC-4071-851F-32D058088F67','B795DCB6-5D0C-4881-BF46-9B9B56693D7A','AD8CF78B-CBBB-4BF4-A1B3-2863958A4981','3C47E220-E4D3-487F-BE9B-8F8B26D6A4CE')
         AND U.UserName = 'SPEEDWAYMOTORS\klbeck'
       -- AND sub.SubscriptionID in ('DA4116E2-E088-436E-B68A-40DB16CBBA9E')  
       -- AND CAT.Name = 'Parts Not Returned'
    ORDER BY 'ReportName',ExecStartTime
     
     


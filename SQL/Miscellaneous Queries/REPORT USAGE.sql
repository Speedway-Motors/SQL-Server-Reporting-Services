-- REPORT USAGE STATISTICS

-- https://stevestedman.com/2016/01/ssrs-report-usage-queries/    

-- how many reports executions are in the log, and the oldest TimeStart
SELECT FORMAT(COUNT(*), '###,###') AS ReportExecutions,
       MIN(ExecutionLog.TimeStart) 'StartOfLog'
FROM [ReportServer].[dbo].ExecutionLog(NOLOCK); -- 89,565	2018-09-22 07:05:03.080
/*
Report
Executions	StartOfLog
89,680	    2018-09-22 07:05
*/

-- Just looking at what is in the log.
SELECT --TOP 10000 
               c.Name, c.[Path],
               -- l.InstanceName, l.ReportID,
               l.UserName, l.RequestType, l.Format, l.Parameters,
               l.TimeStart, l.TimeEnd,l.TimeDataRetrieval, l.TimeProcessing,  l.TimeRendering,
               l.Source, l.Status, l.ByteCount, l.[RowCount]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
    INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
ORDER BY l.UserName desc --l.TimeStart DESC;



--reports with the number of executions and time last run:
SELECT c.Name,
       --c.[Path],
       COUNT(*) AS TimesRun,
       MAX(l.TimeStart) AS [LastRun]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
    INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
    AND UPPER(c.Name) NOT LIKE '%SUB%'-- excludes sub reports & "Marketing Email Unsubscribes" report
    AND c.Name NOT IN ('High Priority Order Fulfillment Status','Mispull Detail','Open Counter Orders','Unverified Counter Orders') -- auto-refreshed reports
    AND l.UserName NOT IN ('SPEEDWAYMOTORS\pjcrews')
    AND l.TimeStart > '10/19/2018' -- PAST 30 DAYS
GROUP BY --l.ReportId,
         c.Name
         --c.[Path]
ORDER BY COUNT(*) DESC



        -- List the reports with the number of executions and time last run, including datasources.
        SELECT c.Name,
               c.[Path],
               COUNT(*) AS TimesRun,
               MAX(l.TimeStart) AS [LastRun],
        (
            SELECT SUBSTRING(
                            (
                                SELECT CAST(', ' AS VARCHAR(MAX))+CAST(c1.Name AS VARCHAR(MAX))
                                FROM [ReportServer].[dbo].[Catalog] AS c
                                INNER JOIN [ReportServer].[dbo].[DataSource] AS d ON c.ItemID = d.ItemID
                                INNER JOIN [ReportServer].[dbo].[Catalog] c1 ON d.Link = c1.ItemID
                                WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
                                      AND c.ItemId = l.ReportId
                                FOR XML PATH('')
                            ), 3, 10000000) AS list
        ) AS DataSources
        FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
        INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
        WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
        GROUP BY l.ReportId,
                 c.Name,
                 c.[Path];


                -- List the reports with the number of executions and time last run, including datasources and who has been using the report.
                SELECT c.Name,
                       c.[Path],
                       COUNT(*) AS TimesRun,
                       MAX(l.TimeStart) AS [LastRun],
                (
                    SELECT SUBSTRING(
                                    (
                                        SELECT CAST(', ' AS VARCHAR(MAX))+CAST(c1.Name AS VARCHAR(MAX))
                                        FROM [ReportServer].[dbo].[Catalog] AS c
                                        INNER JOIN [ReportServer].[dbo].[DataSource] AS d ON c.ItemID = d.ItemID
                                        INNER JOIN [ReportServer].[dbo].[Catalog] c1 ON d.Link = c1.ItemID
                                        WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
                                              AND c.ItemId = l.ReportId
                                        FOR XML PATH('')
                                    ), 3, 10000000) AS list
                ) AS DataSources,
                (
                    SELECT SUBSTRING(
                                    (
                                        SELECT CAST(', ' AS VARCHAR(MAX))+CAST(REPLACE(t.UserName, 'DOMAIN_NAME\', '') AS VARCHAR(MAX))
                                        FROM
                                        (
                                            SELECT TOP 100000 l2.UserName+'('+CAST(COUNT(*) AS VARCHAR(100))+')' AS UserName
                                            FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l2
                                            WHERE l2.ReportID = l.ReportId
                                            GROUP BY l2.UserName
                                            ORDER BY COUNT(*) DESC
                                        ) AS t
                                        FOR XML PATH('')
                                    ), 3, 10000000)
                ) AS UsedBy
                FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
                INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
                WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
                GROUP BY l.ReportId,
                         c.Name,
                         c.[Path];



-- Reports by count that have been run in the last 24 hours
SELECT c.Name,
       c.[Path],
       COUNT(*) AS TimesRun,
       MAX(l.TimeStart) AS [LastRun]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l -- 86
INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
    AND UPPER(c.Name) NOT LIKE '%SUB%'-- excludes sub reports & "Marketing Email Unsubscribes" report
    AND c.Name NOT IN ('High Priority Order Fulfillment Status','Mispull Detail','Open Counter Orders','Unverified Counter Orders') -- auto-refreshed reports
    AND l.UserName NOT IN ('SPEEDWAYMOTORS\pjcrews')
      AND l.TimeStart > GETDATE() - 1
GROUP BY l.ReportId,
         c.Name,
         c.[Path];



-- Reports by count that have been run in the last 7 days

SELECT c.Name,  -- 141
       c.[Path],
       COUNT(*) AS TimesRun,
       MAX(l.TimeStart) AS [LastRun]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
    AND UPPER(c.Name) NOT LIKE '%SUB%'-- excludes sub reports & "Marketing Email Unsubscribes" report
    AND c.Name NOT IN ('High Priority Order Fulfillment Status','Mispull Detail','Open Counter Orders','Unverified Counter Orders') -- auto-refreshed reports
    AND l.UserName NOT IN ('SPEEDWAYMOTORS\pjcrews')
      AND l.TimeStart > GETDATE() - 7
GROUP BY l.ReportId,
         c.Name,
         c.[Path];


-- Reports that haven’t been run since the last time the log was cleared.
-- NOTE this query is PATH SPECIFIC!  Beware that reports listed may have been used in other paths.
--  e.g.  Report X was not run by the Call Center however it was run repeatedly in the Accounting folder.
SELECT c.Name
    , c.[Path]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
    RIGHT OUTER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
WHERE c.Type in (2) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
      AND UPPER(c.Name) NOT LIKE '%SUB%'-- excludes sub reports & "Marketing Email Unsubscribes" report
      AND UPPER(c.[Path]) NOT LIKE '%/SYSTEMS/%'
      AND UPPER(c.[Path]) NOT LIKE '%/TEST/%'
      AND UPPER(c.[Path]) NOT LIKE '%/DEPLOYMENT/%'
      AND l.ReportID IS NULL
ORDER BY c.[Path]



--Report usage by user
SELECT l.UserName,  -- 81 different users have executed reports
       COUNT(*) AS TimesRun,
       MAX(l.TimeStart) AS [LastReportRun]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
WHERE UPPER(c.Name) NOT LIKE '%SUB%'-- excludes sub reports & "Marketing Email Unsubscribes" report
    AND c.Name NOT IN ('High Priority Order Fulfillment Status','Mispull Detail','Open Counter Orders','Unverified Counter Orders') -- auto-refreshed reports
    AND l.UserName NOT IN ('SPEEDWAYMOTORS\pjcrews')
GROUP BY l.UserName
ORDER BY MAX(l.TimeStart) -- l.UserName --COUNT(*) DESC


 
-- Reports Datasource
SELECT c.name,
       c1.Name datasource,
       c.ItemId
FROM [ReportServer].[dbo].[Catalog] AS c
INNER JOIN [ReportServer].[dbo].[DataSource] AS d ON c.ItemID = d.ItemID
INNER JOIN [ReportServer].[dbo].[Catalog] c1 ON d.Link = c1.ItemID
WHERE c.Type in (2,4) --  1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source


--Long Running Reports by average execution time
SELECT TOP 100 c.Name,
               c.[Path],
               AVG(l.TimeDataRetrieval + l.TimeProcessing + l.TimeRendering) / 1000.0 [AverageExecutionTimeSeconds],
               SUM(l.TimeDataRetrieval + l.TimeProcessing + l.TimeRendering) / 1000.0 [TotalExecutionTimeSeconds],
               SUM(l.TimeDataRetrieval + l.TimeProcessing + l.TimeRendering) / 1000.0 / 60 [TotalExecutionTimeMinutes],
               COUNT(*) TimesRun
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = c.ItemID
WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
GROUP BY c.Name,
         c.[Path],
         l.InstanceName,
         l.ReportID
HAVING AVG(l.TimeDataRetrieval + l.TimeProcessing + l.TimeRendering) / 1000.0 > 1
ORDER BY AVG(l.TimeDataRetrieval + l.TimeProcessing + l.TimeRendering) DESC
 
-- List the reports with the last time run
SELECT c.Name,
       c.[Path],
       MAX(l.TimeStart) AS [LastRun]
FROM [ReportServer].[dbo].[ExecutionLog] AS l WITH (NOLOCK)
INNER JOIN [ReportServer].[dbo].[Catalog] AS c WITH (NOLOCK) ON l.ReportID = c.ItemID
WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
GROUP BY l.ReportId,
         c.Name,
         c.[Path]
ORDER BY [LastRun] DESC;




Use ReportServer  
select * from ExecutionLog3 
where UPPER(UserName) like 'SPEEDWAYMOTORS\PJ%'
order by TimeStart DESC





/***********    Reports Executed and NOT Executed in last 30 days    *************/
-- SUBSCRIPTIONS EXECUTIONS ARE NOT COUNTED (Parts not Returned report only shows being run a few times but there are dozens of daily subscriptions)
-- sub-reports do NOT show as being executed if they're run within a parent report.  They only appear if manually executed individually.

SELECT DISTINCT
    SUBSTRING(t2.Path,1,LEN(t2.Path)-LEN(t2.Name)) 'ReportFolder'
    ,t2.Name
    ,REPLACE(t1.UserName,'SPEEDWAYMOTORS\','') 'UserName2'
    ,MAX(t1.TimeStart) 'LastExecuted'
INTO #temp01
FROM ReportServer.dbo.ExecutionLog t1
    JOIN ReportServer.dbo.Catalog t2 ON t1.ReportID = t2.ItemID
GROUP BY t2.Path,t2.Name,t1.UserName
ORDER BY ReportFolder,UserName2 --,t1.UserName

SELECT DISTINCT
    ReportFolder 
    ,Name 'ReportName'
    ,COUNT(Name) 'TimesExecuted'
    ,MAX(LastExecuted) 'LastExcecuted'
    ,ExecutedBy = STUFF((SELECT ', ' + UserName2 
                         FROM #temp01
                         WHERE Name = x.[Name]
                          FOR XML PATH(''), TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '')
FROM #temp01 x
WHERE Name <> ''
    AND UPPER(Name) NOT LIKE 'SUB%'
    AND UPPER(Name) NOT LIKE 'BB - SUB%'
    AND UPPER(Name) NOT LIKE 'DC - SUB%'        
GROUP BY ReportFolder,Name
ORDER BY TimesExecuted DESC,ReportFolder,Name

DROP TABLE #temp01







/***********    Reports NOT Executed in last 30 days    *************/
-- NOTE:  sub-reports do NOT show as being executed if they're run within a parent report.  
-- They only appear if they are MANUALLY executed individually.

/* 
        not 
CMP.    run     as of
===     ===     =========
AFCO     27     2017.04.25
SMI      81     2017.04.25
*/
/*
BEGIN TRY
  DROP TABLE #temp01
END TRY
BEGIN CATCH 
END CATCH

BEGIN TRY
DROP TABLE #temp02
END TRY
BEGIN CATCH
END CATCH

GO

WITH RankedReports
AS
(SELECT ReportID,
        TimeStart,
        UserName, 
        RANK() OVER (PARTITION BY ReportID ORDER BY TimeStart DESC) AS iRank
   FROM ReportServer.dbo.ExecutionLog t1
        JOIN 
        ReportServer.dbo.Catalog t2
          ON t1.ReportID = t2.ItemID AND t2.Type <> 1
)

SELECT 
DISTINCT     t1.UserName,t2.Name AS ReportName
    ,SUBSTRING(t2.Path,2,LEN(t2.Path)-LEN(t2.Name)-1) AS Folder,t2.Type
INTO #temp01
FROM RankedReports t1
    INNER JOIN ReportServer.dbo.Catalog t2 ON t1.ReportID = t2.ItemID
WHERE t1.iRank = 1
    AND t2.Type <> 1
ORDER BY t1.UserName,t2.Name;

SELECT 
  SUBSTRING(Path,2,LEN(Path)-LEN(Name)-1) AS ReportFolder
  ,Name AS ReportName
  ,CreationDate
  ,ModifiedDate
  ,Type
  INTO #temp02
FROM ReportServer.dbo.Catalog 
WHERE Name NOT IN (SELECT ReportName FROM #temp01) 
    AND Path <> '' 
ORDER BY Path

SELECT * FROM #temp02 
WHERE ReportFolder <> '' 
    AND Type = 2 
    AND UPPER(ReportName) NOT LIKE '%SUB%' -- sub-reports don't log as being executed when they're run through a parent report.
ORDER BY ReportFolder--ModifiedDate DESC

  DROP TABLE #temp01
  DROP TABLE #temp02  
  
/* REMOVE from projects
AFCO/Merchandising/Catalog Analysis/Catalog Square Inch Analysis 
AFCO/Merchandising/Catalog Analysis/Catalog Page Zero Analysis

*/  
*/
-- REPORTS NOT RUN past 30 days
DROP TABLE #temp01
DROP TABLE #temp02
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
AND Name not like '%SUB%' -- our exlclusions
AND SUBSTRING(Path,2,LEN(Path)-LEN(Name)-1) not like '%Systems%' -- our exlclusions
AND SUBSTRING(Path,2,LEN(Path)-LEN(Name)-1) not like '%Test%' -- our exlclusions
AND SUBSTRING(Path,2,LEN(Path)-LEN(Name)-1) not like '%Deployment%' -- our exlclusions
ORDER BY Path
SELECT * FROM #temp02 WHERE ReportFolder <> '' AND Type = 2 ORDER BY ModifiedDate DESC
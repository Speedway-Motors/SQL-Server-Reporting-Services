/* Assume you're using a standard setup: ReportServer*/
USE ReportServer
GO
/* Q1
What's been run today which isn't Succesful?
*/
SELECT C.Path AS ReportPath
,C.Name AS ReportName
,A.Status
,A.UserName
,A.Parameters
,A.TimeStart
,A.TimeEnd
,A.TimeDataRetrieval
,A.TimeProcessing
,A.ByteCount
,A.[RowCount]
FROM dbo.ExecutionLog AS A WITH(NOLOCK) 
INNER JOIN dbo.Catalog AS C WITH(NOLOCK) 
ON A.ReportID = C.ItemID
WHERE CAST(TimeStart AS DATE) = CAST(GETDATE() AS DATE)
AND [Status] NOT IN ('rsSuccess')

/* Q2
What User has been running a fair few reports today?
*/
SELECT UserName
,COUNT(*) AS FullSum
FROM dbo.ExecutionLog AS A WITH(NOLOCK) 
INNER JOIN dbo.Catalog AS C WITH(NOLOCK) 
ON A.ReportID = C.ItemID
WHERE CAST(TimeStart AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY
UserName
ORDER BY 2 DESC

/* Q3
What report has been executed the most today?
*/
SELECT C.Path+'/'+C.Name AS Path
,COUNT(*) AS FullSum
FROM dbo.ExecutionLog AS A WITH(NOLOCK) 
INNER JOIN dbo.Catalog AS C WITH(NOLOCK) 
ON A.ReportID = C.ItemID
WHERE CAST(TimeStart AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY
C.Path+'/'+C.Name
ORDER BY 1 DESC


select * from dbo.ExecutionLog


select UserName, COUNT(*) ReportRuns
from dbo.ExecutionLog
where TimeStart >= '2013-01-01 01:00:01'
  and UserName not in ('SPEEDWAYMOTORS\ascrook','SPEEDWAYMOTORS\pjcrews','SPEEDWAYMOTORS\ccchance',
                        'SPEEDWAYMOTORS\MSSQLDW',
                        'SPEEDWAYMOTORS\albredthauer')
group by UserName
order by ReportRuns desc





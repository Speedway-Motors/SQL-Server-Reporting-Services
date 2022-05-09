-- Report Executions
USE [ReportServer]

SELECT [Status] 'Report Exec Status', COUNT(*) 'Count'
FROM dbo.ExecutionLog
WHERE TimeStart >=  DATEADD(HH, -24, getdate()) --  last 24 hours
GROUP BY  [Status]
ORDER BY 'Count' DESC
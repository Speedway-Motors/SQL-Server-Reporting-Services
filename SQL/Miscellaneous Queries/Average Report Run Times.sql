-- AVERAGE REPORT RUN TIMES

USE ReportServer
GO

SELECT
    CAT.Name AS ReportName,
    ES.ReportID,
    CAT.CreationDate AS ReportCreationDate,
    CAT.ModifiedDate AS ReportModifiedDate,
    ES.RunCount AS ReportExecuteCount,
    EL.InstanceName AS LastExecutedServerName,
    EL.UserName AS LastExecutedbyUserName,
    EL.TimeStart AS LastExecutedTimeStart,
    EL.TimeEnd AS LastExecutedTimeEnd,
    EL.Status AS LastExecutedStatus,
    EL.ByteCount AS LastExecutedByteCount,
    EL.[RowCount] AS LastExecutedRowCount
FROM dbo.Catalog CAT
LEFT OUTER JOIN
    -- EXECUTION SUMMARRY
    (SELECT ReportID, 
    COUNT(TimeStart) 'RunCount', 
    MAX(TimeStart) 'LastTimeStart',
    AVG(DATEDIFF(s,TimeStart,TimeEnd)) 'AvgSec'
    FROM dbo.ExecutionLog
    WHERE [Status] = 'rsSuccess'
    -- SOURCE?  sTATUS? Request 
    GROUP BY ReportID
   -- ORDER BY 'RunCount'
    ) AS ES ON CAT.ItemID = ES.ReportID    
LEFT OUTER JOIN dbo.ExecutionLog AS EL ON CAT.ParentID = EL.ReportID 
                                          AND ES.LastTimeStart = EL.TimeStart
--WHERE 
--    CAT.Name = 'Garage Sale Sales by Type'
    --UPPER(EL.UserName) like '%CREWS%'
ORDER BY CAT.Name

SELECT DATEADD(DD, -2, getdate()) -- 2014-05-27 11:32:41.380
SELECT DATEADD(HH, -24, getdate()) -- 2014-05-27 11:32:41.380


SELECT * FROM dbo.ExecutionLog
WHERE TimeStart >=  DATEADD(HH, -24, getdate())
order by TimeStart



SELECT UserName,	RequestType,	Format,	Parameters,	
TimeStart,	TimeEnd,	TimeDataRetrieval,	TimeProcessing,	TimeRendering,
	Source,	Status,	ByteCount,	[RowCount]
FROM dbo.ExecutionLog
WHERE ReportID = '6ABABF8D-4C9A-49D9-AD57-34E2593093A3'
ORDER BY TimeStart DESC

    GROUP BY ReportID
    
    
    
    
SELECT ReportID, 
    COUNT(TimeStart) 'RunCount', 
    AVG(DATEDIFF(s,TimeStart,TimeEnd)) 'AvgSec'
FROM dbo.ExecutionLog
GROUP BY ReportID
ORDER BY 'RunCount'
/*
RunCount	AvgSec
6	        5
*/


select * 
FROM dbo.ExecutionLog
WHERE ReportID = 'C2CCE83E-74C8-4F06-BB27-2E473514C6BF'


where TimeDataRetrieval+TimeProcessing+TimeRendering > 10000

WHERE ReportID = 'C1252DB6-D3BE-4828-AF65-8BA6AD918BDF'


select * from dbo.Catalog
where ItemID in ('CAFFB203-68DC-457C-BE2A-8FF8E96BF17A','C2CCE83E-74C8-4F06-BB27-2E473514C6BF')
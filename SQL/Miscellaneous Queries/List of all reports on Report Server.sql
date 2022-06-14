-- List of all reports on Report Server
USE [ReportServer]
GO
SELECT
       Name 'ReportName',
       [Path]
       --,[Description]
FROM [dbo].[Catalog]
WHERE [Type] = 2
    and [Path] LIKE '/Speedway/%'
	-- exclude Departments already verified
	and [Path] NOT LIKE '%Accounting%'
	and [Path] NOT LIKE '%Engineering%'
	and [Path] NOT LIKE '%HR%'
	and [Path] NOT LIKE '%Marketing%'
	and [Path] NOT LIKE '%MRR%'
	and [Path] NOT LIKE '%PRS%'
	and [Path] <> '/Speedway/Returns/Returns Metrics'
ORDER BY [Path], Name




/Speedway/Warehouse - Receiving/Receiving Processing Times
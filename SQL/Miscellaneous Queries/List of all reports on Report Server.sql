-- List of all reports on Report Server
USE [ReportServer]
GO
SELECT
       Name 'ReportName',
       [Path]
       --,[Description]
FROM [dbo].[Catalog]
WHERE [Type] = 2
    and [Path] NOT LIKE '/Deployment/%'
ORDER BY [Path], Name





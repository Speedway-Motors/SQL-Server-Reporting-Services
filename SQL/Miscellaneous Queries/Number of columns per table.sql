-- Number of columns per table
DECLARE @threshold INT;
SET @threshold = 30; -- tables with X or more columns

;WITH cte AS
(
  SELECT [object_id], COUNT(*) [Columns]
    FROM sys.columns
    GROUP BY [object_id]
    HAVING COUNT(*) > @threshold
    --HAVING COUNT(*) < @threshold
   
)
SELECT 
	 s.[name] + N'.' + t.[name] [Table],
	 c.[Columns]
  FROM cte c
   INNER JOIN sys.tables t ON c.[object_id] = t.[object_id]
   INNER JOIN sys.schemas s ON t.[schema_id] = s.[schema_id]
WHERE t.[name] LIKE 'tbl%'
  ORDER BY c.[Columns] DESC;

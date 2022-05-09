-- Count of fields per table
SELECT [Schema] = s.name
    , [Table] = t.name
    , number = COUNT(*)
FROM sys.columns c
INNER JOIN sys.tables t ON c.object_id = t.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.name, s.name
order by COUNT(*) desc
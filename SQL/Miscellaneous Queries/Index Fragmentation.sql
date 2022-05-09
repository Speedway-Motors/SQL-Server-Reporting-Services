-- Index Fragmentation

-- DWSTAGING1.[SMI Reporting] runtime 5-7 mins
-- takes about 5-6 mins to run on DWSTAGING1.[SMI Reporting] 
-- takes about 30 secs to run on DWSTAGING1.[AFCOReporting] 
SELECT ps.database_id, ps.OBJECT_ID, ps.index_id, 
    b.name, b.type_desc, b.is_primary_key, 
    b.is_unique_constraint, b.is_disabled, b.allow_row_locks, b.allow_page_locks,
    ps.avg_fragmentation_in_percent, 
    CONVERT(VARCHAR(10), getdate(), 10) AS  'DateRun'
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ps
    INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID
                               AND ps.index_id = b.index_id
WHERE ps.database_id = 6 --DB_ID()     select db_id('SMI Reporting')
ORDER BY ps.avg_fragmentation_in_percent desc

/* NOTES:
    - fragmentation in nonclustered indexes isn’t as much of a concern as fragmentation in the clustered index
    
*/
-- select * from sys.indexes


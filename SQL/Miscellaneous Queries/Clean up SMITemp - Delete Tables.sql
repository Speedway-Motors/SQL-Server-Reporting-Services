-- Clean up SMITemp - Delete Tables
-- SMITemp has 521 tables taking 76GB of storage as of 07-16-20

SELECT @@SPID as 'Current SPID' -- 129 

-- DROP TABLE #temp
        CREATE TABLE #temp (
           table_name sysname ,
           row_count INT,
           reserved_size VARCHAR(50),
           data_size VARCHAR(50),
           index_size VARCHAR(50),
           unused_size VARCHAR(50))
        SET NOCOUNT ON
        INSERT #temp
        EXEC sp_MSforeachtable 'sp_spaceused ''?'''

     
SELECT a.table_name                                     sTableName,
        a.row_count                                      sRowCount,
Cast(replace(a.data_size,' KB','') as INT)              KB,        
(Cast(replace(a.data_size,' KB','') as DEC (8,0))/1024) MB, -- 1024 KB = 1 MB
DateAdd(day, DateDiff(day, 0, GETDATE()), 0)            dtDate
FROM #temp a
    INNER JOIN INFORMATION_SCHEMA.COLUMNS b ON a.table_name collate database_default = b.table_name collate database_default
WHERE   a.table_name NOT like '%ASC%'
GROUP BY a.table_name, a.row_count, a.data_size 
ORDER BY  (Cast(replace(a.data_size,' KB','') as DEC (8,0))/1024) desc

SELECT * FROM #temp
WHERE table_name NOT like '%PJC%'
    AND table_name NOT like '%CCC%'
    AND table_name like '%ASC%' -- 327 as of 
    --AND table_name NOT like '%ALB%'
    --table_name like '%Refeed%'
ORDER BY table_name -- row_count DESC



DROP TABLE [###]
GO
DROP TABLE [###]
GO
DROP TABLE [###]


TRUNCATE TABLE [###]

/* TABLE PJC_tblSKUSnapshotPopBySQLDB is HUGE!  
It is populated daily by SSA job SmiJob_Populate_PJC_tblSKUSnapshotPopBySQLDB and takes about 20-30 mins to run
-- disabled the job 7-22-20
*/

SET ROWCOUNT 0
-- currently has data from 18197 to 19197
DELETE FROM PJC_tblSKUSnapshotPopBySQLDB_COPY
where ixDate < 19098 -- 100 day max
-- remove data from 19097 and back
 

select distinct  top 50000  ixSKU from PJC_tblSKUSnapshotPopBySQLDB_COPY
WHERE ixSKU NOT like '%UP%'
and iFIFOQuantity = 0
order by ixSKU 

BEGIN TRAN
DELETE FROM PJC_tblSKUSnapshotPopBySQLDB_COPY
WHERE ixSKU between  'SUITCASE' AND 'TRANSPORT' 
ROLLBACK 25548250

SELECT DISTINCT ixSKU  FROM PJC_tblSKUSnapshotPopBySQLDB_COPY

SELECT * FROM PJC_tblSKUSnapshotPopBySQLDB_COPY
WHERE ixSKU between 'UP124540' AND 'UP4215' 

select ixDate, count(*)
from PJC_tblSKUSnapshotPopBySQLDB
group by ixDate
order by ixDate

select distinct ixDate 
from PJC_tblSKUSnapshotPopBySQLDB 
order by ixDate

select top 10 * from PJC_tblSKUSnapshotPopBySQLDB_COPY





/******** tables with NO PKs **********
SELECT SCHEMA_NAME(schema_id) AS SchemaName,name AS TableName
FROM sys.tables
WHERE OBJECTPROPERTY(OBJECT_ID,'TableHasPrimaryKey') = 0
and name like 'tbl%'
ORDER BY SchemaName, TableName;
*****************************************/

/******** MY current SPIDs *************
select session_id, program_name, status, memory_usage, total_elapsed_time, reads, row_count
from sys.dm_exec_sessions 
where nt_user_name = 'pjcrews' 
      and session_id != @@spid -- excludes current SPID
***************************************/




select count(*) from tblSKUTransaction -- 18M
select count(*) from tblSnapshotSKU    -- 24M
select count(*) from tblOrderLine      -- 16M
select count(*) from tblOrderLine
where iOrdinality is NULL              -- 8,132,489




--set rowcount 10000

select O.ixOrder, count(OL.ixSKU) LICount
INTO PJC_SingleItemOrders
from tblOrder O 
   join tblOrderLine OL on O.ixOrder = OL.ixOrder
where OL.iOrdinality is NULL
group by O.ixOrder
having count(OL.ixSKU) = 1 -- 815,000




update tblOrderLine
set iOrdinality = 1
where iOrdinality is NUll
and exists (select O.ixOrder, count(OL.ixSKU)
               from tblOrder O 
                  join tblOrderLine OL on O.ixOrder = OL.ixOrder
               where OL.iOrdinality is NULL
               group by O.ixOrder
               having count(OL.ixSKU) = 1) -- 815,000






select datepart(year,O.dtOrderDate) Yr,
count(O.ixOrder) OrdCount
from tblOrder O
   join tblOrderLine OL on O.ixOrder = OL.ixOrder
where OL.iOrdinality is NULL
--and O.dtOrderDate between '12/01/2010' and '12/31/2010'
group by datepart(year,O.dtOrderDate)
--having count(OL.ixSKU) = 1 -- 815,000


select * from tblOrder where dtOrderDate is NULL


select datepart(year,O.dtOrderDate) Yr,
count(O.ixOrder) OrdCount
from tblOrder O
group by datepart(year,O.dtOrderDate)






select * from sys.dm_exec_sessions 






sp_who2
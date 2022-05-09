-- Re-Enable indexes

-- find disabled indexes
select * 
from sys.indexes 
where is_disabled = 1


-- re-enable indexes
-- this will cause them to REBUILD so be sure to PAUSE the feeds


--ALTER INDEX [<index name.] ON [<schema>].[<tablename>] REBUILD 

-- example
ALTER INDEX [IX_tblOrder_iShipMethod_dtOrderDate_Include] ON dbo.[tblOrder] REBUILD 


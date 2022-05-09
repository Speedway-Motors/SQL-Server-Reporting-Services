USE [SMI Reporting]

SELECT o.name AS "Table Name", i.rowcnt AS "Row Count"
FROM sysobjects o, sysindexes i
WHERE i.id = o.id
AND indid IN(0,1)
AND o.name LIKE 'tbl%'
ORDER BY i.rowcnt DESC

--The following line adds up all the rowcount results and places
--the final result into a seperate column (below the first resulting table)
COMPUTE SUM(i.rowcnt); --Added by James_DBA

GO

/*
DB              Tot Records     as of
[SMI Reporting] 266,072,338     10-23-2013
[AFCOReporting]  62,286,531     10-23-2013

*/
-- Count of tables in a DB
SELECT @@servername 'Server Name   ', TABLE_CATALOG 'Database Name', TABLE_TYPE 'Table Type  ' , COUNT(*) 'Qty', CONVERT(VARCHAR, GETDATE(), 102)  AS 'As Of'
FROM INFORMATION_SCHEMA.TABLES 
-- WHERE table_type = 'base table' 
GROUP BY TABLE_CATALOG, TABLE_TYPE

/*
Server Name   	Database Name	Table Type  Qty	As Of
=============   =============   ==========  === ==========
LNK-DW1	        SMI Reporting	BASE TABLE	129	2017.09.07
LNK-DW1	        SMI Reporting	VIEW	     92	2017.09.07
LNK-DW1	        AFCOReporting	BASE TABLE	 75	2017.09.07
LNK-DW1	        AFCOReporting	VIEW	     33	2017.09.07

LNK-DW1	        SMI Reporting	BASE TABLE	119	2017.06.08
LNK-DW1	        SMI Reporting	VIEW	     91	2017.06.08
LNK-DWSTAGING1	SMI Reporting	BASE TABLE	134	2017.06.08
LNK-DWSTAGING1	SMI Reporting	VIEW	    194	2017.06.08

LNK-DW1	        AFCOReporting	BASE TABLE	 73	2017.06.08
LNK-DW1	        AFCOReporting	VIEW	     30	2017.06.08
LNK-DWSTAGING1	AFCOReporting	BASE TABLE	 79	2017.06.08
LNK-DWSTAGING1	AFCOReporting	VIEW	     85	2017.06.08
*/

SELECT * from INFORMATION_SCHEMA.TABLES 


SELECT @@servername


-- # of records per table
SELECT T.name AS [TABLE NAME], 
       I.rows AS [ROWCOUNT] 
FROM   sys.tables AS T 
       INNER JOIN sys.sysindexes AS I ON T.object_id = I.id 
                                        AND I.indid < 2 
ORDER  BY I.rows DESC 



-- # of records in a DB
SELECT SUM(I.rows) TotalRecords
FROM   sys.tables AS T 
       INNER JOIN sys.sysindexes AS I ON T.object_id = I.id 
                                        AND I.indid < 2 
                                        
                                        
                                        
                                        
/*                              Tot             BASE
Server Name     Database Name   Records         Tables  VIEWS   As Of
===========     =============   ============    ======  =====   ==========
LNK-DW1	        AFCOReporting   156,709,837      75      33     2017.09.07
LNK-DW1	        SMI Reporting   643,719,720     129      92     2017.09.07
                                ===========     ======  =====
                                800m            204     125
*/
-- Compare COLLATION

SELECT col.name, col.collation_name
FROM sys.columns col
WHERE object_id = OBJECT_ID('tblDoorEvent')
   or object_id = OBJECT_ID('tblDoorEventArchive')
   or object_id = OBJECT_ID('tblDoorEventArchive010114to041414')
   or object_id = OBJECT_ID('tblDoorEventArchive')
 ORDER BY col.name      
      
SELECT CONVERT (varchar, SERVERPROPERTY('collation')) 'Server Collation';      

SELECT name 'DB', collation_name FROM sys.databases where name = 'SMI Reporting';




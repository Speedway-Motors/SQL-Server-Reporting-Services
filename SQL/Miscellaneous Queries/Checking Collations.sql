/* Find Collation of SQL Server Database */
SELECT DATABASEPROPERTYEX('AFCOTemp', 'Collation')
GO

/* Find Collation of SQL Server Database Table Column */
USE AFCOTemp -- DB YOU ARE CHECKING THE FIELD COLLATIONS OF

GO

SELECT name, collation_name
FROM sys.columns
WHERE OBJECT_ID IN (SELECT OBJECT_ID
FROM sys.objects
WHERE type = 'U'
and collation_name is NOT NULL)
order by collation_name


select top 10 * from sys.columns




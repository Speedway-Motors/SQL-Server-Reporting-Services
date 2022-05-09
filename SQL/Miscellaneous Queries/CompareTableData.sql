SET NOCOUNT ON;
DECLARE @Table1_FullName VARCHAR(500) = 'AdventureWorks2012.HumanResources.Employee' --Database then schema then table name (In case of linked server use server name first then all other listed object names)
DECLARE @Table2_FullName VARCHAR(500) = 'AdventureWorksDW2012.dbo.Employee' --Database then schema then table name (In case of linked server use server name first then all other listed object names)

--DECLARE @ColToDisplay  VARCHAR(500) = 'BUSINESSENTITYID' --Comma separated list of columns to display as a comparison result

--Column list will be taken from first table

DECLARE @IsIdentityToCompare BIT  = 1 --Indicate whether to compare identity column if any exists
DECLARE @ColListToExclude VARCHAR(2000) = '' --Comma separated List of columns to exclude from comparison list columns



DECLARE @TableName VARCHAR(256) = ''
SELECT @TableName = REVERSE(SUBSTRING(REVERSE(@Table1_FullName), 0, CHARINDEX('.', REVERSE(@Table1_FullName) + '.')))
--SELECT @TableName
DECLARE @SchemaName VARCHAR(256) = REVERSE(STUFF(REVERSE(@Table1_FullName), 1, LEN(@TableName) + 1, ''))
SELECT @SchemaName = REVERSE(SUBSTRING(REVERSE(@SchemaName), 0, CHARINDEX('.', REVERSE(@SchemaName) + '.')))
--SELECT @SchemaName



DECLARE @tmpExcludeColumns TABLE
(
	Val VARCHAR(MAX)
)

;WITH CTE AS
(
      SELECT CAST(LEFT(@ColListToExclude, CHARINDEX(',', @ColListToExclude + ',') - 1) AS VARCHAR(MAX)) AS Val
                  ,CAST(STUFF(@ColListToExclude, 1, CHARINDEX(',', @ColListToExclude + ','), '') AS VARCHAR(MAX)) AS RecVal
      UNION ALL
      SELECT CAST(LEFT(RecVal, CHARINDEX(',', RecVal + ',') - 1) AS VARCHAR(MAX)) AS Val
                  ,CAST(STUFF(RecVal, 1, CHARINDEX(',', RecVal + ','), '') AS VARCHAR(MAX)) AS RecVal FROM CTE
      WHERE RecVal > ''
)
INSERT INTO @tmpExcludeColumns
SELECT Val FROM CTE 
OPTION(MAXRECURSION 32767) --MAX RECURSION


DECLARE @JoinClause VARCHAR(4000) = ''

SELECT @JoinClause = @JoinClause + ' AND tbl1.' + COALESCE(SC.NAME, '') + ' = tbl2.' + COALESCE(SC.NAME, '') + CHAR(13)
FROM SYS.columns SC
INNER JOIN SYS.tables ST ON SC.object_id = ST.object_id
INNER JOIN SYS.schemas SCH ON SCH.schema_id = ST.schema_id
WHERE ST.NAME = @TableName AND SCH.name = @SchemaName
AND ((@IsIdentityToCompare = 1) OR (@IsIdentityToCompare = 0 AND SC.is_identity = 0))
AND SC.name NOT IN (SELECT Val FROM @tmpExcludeColumns)
ORDER BY SC.NAME

SELECT @JoinClause = STUFF(@JoinClause, 1, LEN(' AND '), '')
--SELECT @JoinClause

DECLARE @WhereClause VARCHAR(4000) = ''

SELECT @WhereClause = @WhereClause + --' OR tbl2.' + COALESCE(SC.NAME, '') + ' IS NULL ' + CHAR(13)
' OR tbl1.' + COALESCE(SC.NAME, '') + ' IS NULL OR tbl2.' + COALESCE(SC.NAME, '') + ' IS NULL ' + CHAR(13)
FROM SYS.columns SC
INNER JOIN SYS.tables ST ON SC.object_id = ST.object_id
INNER JOIN SYS.schemas SCH ON SCH.schema_id = ST.schema_id
WHERE ST.NAME = @TableName AND SCH.name = @SchemaName
AND ((@IsIdentityToCompare = 1) OR (@IsIdentityToCompare = 0 AND SC.is_identity = 0))
AND SC.name NOT IN (SELECT Val FROM @tmpExcludeColumns)
ORDER BY SC.NAME

--PRINT @WhereClause

SELECT @WhereClause = ' WHERE ' + STUFF(@WhereClause, 1, LEN(' AND '), '')


DECLARE @ColToDisplayStmt VARCHAR(2000) = ''

SELECT @ColToDisplayStmt = @ColToDisplayStmt + ', tbl1.' + + COALESCE(SC.NAME, '') + ', tbl2.' + COALESCE(SC.NAME, '') + CHAR(13)
FROM SYS.columns SC
INNER JOIN SYS.tables ST ON SC.object_id = ST.object_id
INNER JOIN SYS.schemas SCH ON SCH.schema_id = ST.schema_id
WHERE ST.NAME = @TableName AND SCH.name = @SchemaName
AND ((@IsIdentityToCompare = 1) OR (@IsIdentityToCompare = 0 AND SC.is_identity = 0))
AND SC.name NOT IN (SELECT Val FROM @tmpExcludeColumns)
--ORDER BY SC.NAME

SELECT @ColToDisplayStmt = STUFF(@ColToDisplayStmt, 1, LEN(', '), '')



DECLARE @SQLStatement VARCHAR(8000) = ''

SET @SQLStatement = 'SELECT ISNULL(tbl1.TableName, tbl2.TableName) AS TableName, ISNULL(tbl1.RowSEQ, tbl2.RowSEQ) AS RowSEQ, ' + @ColToDisplayStmt +
' FROM (SELECT ''Table 1 '' AS TableName, ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS RowSEQ, * FROM ' + @Table1_FullName + ') AS tbl1 
FULL JOIN (SELECT ''Table 2 '' AS TableName, ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS RowSEQ, * FROM ' 
+ @Table2_FullName + ') AS tbl2 ON ' + @JoinClause + @WhereClause
+ ' ORDER BY RowSEQ, TableName, ' + @ColToDisplayStmt

PRINT @SQLStatement

EXEC (@SQLStatement)
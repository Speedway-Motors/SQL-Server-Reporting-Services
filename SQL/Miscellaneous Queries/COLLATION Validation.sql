-- COLLATION validation

-- TABLES with incorrect collation
SELECT
	distinct [TABLE_NAME] = OBJECT_NAME([id])
FROM syscolumns
WHERE
	collation <> 'SQL_Latin1_General_CP1_CS_AS' AND
	collation IS NOT NULL AND
	OBJECTPROPERTY([id], N'IsUserTable')=1
	
	

-- TABLES & FIELDS with incorrect collation
SELECT
	[TABLE_NAME] = OBJECT_NAME([id]),
	[COLUMN_NAME] = [name]	
FROM syscolumns
WHERE
	collation <> 'SQL_Latin1_General_CP1_CS_AS' AND
	collation IS NOT NULL AND
	OBJECTPROPERTY([id], N'IsUserTable')=1


-- DB Levels
-- Check the database that was just changed.  The COLLATION_NAME should be SQL_Latin1_General_CP1_CS_AS and the
-- COMPATIBILITY_LEVEL should be 100 (90 for SQL Server 2008 R2).

-- This script should be executed after all of the collation change scripts are executed
-- and the first result set should have zero records.
SELECT
	[DATABASE_NAME] = [name],
	[COLLATION_NAME] = [collation_name],
	[COMPATIBILITY_LEVEL] = [compatibility_level],
	[ACCESS_MODE] = user_access_desc,
	[STATE] = state_desc,
	[recovery_model] = recovery_model_desc
FROM sys.databases
WHERE owner_sid<>0x01



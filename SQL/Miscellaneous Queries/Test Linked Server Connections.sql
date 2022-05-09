-- Test Linked Server Connections
-- http://www.sqlservercentral.com/scripts/Dynamic+SQL/115206/

DECLARE @Cursor CURSOR
DECLARE @ServerName NVARCHAR(128)
DECLARE @ServerID INT
DECLARE @SQL VARCHAR(MAX)

--Create temp table to store results
IF object_id(N'tempdb..##LinkedServers') IS NOT NULL
	DROP TABLE ##LinkedServers

CREATE TABLE ##LinkedServers
	([LinkedServerID] INT IDENTITY(1,1) NOT NULL,
	[Name] SYSNAME NULL,
	[ProvName] NVARCHAR(128) NULL,
	[Product] NVARCHAR(128) NULL,
	[DataSource] NVARCHAR(4000) NULL,
	[ProvString] NVARCHAR(4000) NULL,
	[Location] NVARCHAR(4000) NULL,
	[Cat] SYSNAME NULL
	)

--Get list of linked servers from system proc
INSERT INTO ##LinkedServers
EXEC [sys].sp_linkedservers

--Add tested field to result set
ALTER TABLE ##LinkedServers ADD [TestSuccess] BIT

--Cursor over list of linked servers testing each
SET @Cursor = CURSOR FOR
						SELECT [LinkedServerID],
							   [Name]
						FROM ##LinkedServers
OPEN @Cursor
FETCH NEXT FROM @Cursor INTO
							@ServerID,
							@ServerName

WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @SQL = 
	'BEGIN TRY
		EXEC sp_testlinkedserver [' + @ServerName + ']
		UPDATE ##LinkedServers
		SET	[TestSuccess] = 1
		WHERE [LinkedServerID] = ' + CAST(@ServerID AS VARCHAR) + '
	 END TRY
	 BEGIN CATCH
		UPDATE ##LinkedServers
		SET	[TestSuccess] = 0
		WHERE [LinkedServerID] = ' + CAST(@ServerID AS VARCHAR) + '
	END CATCH
	'
	
	EXEC(@SQL)
	FETCH NEXT FROM @Cursor INTO
								@ServerID,
								@ServerName
END

--Return results
SELECT  getdate() 'As of     ',
        [Name] AS 'LinkedServerName',
	    [Product],
	    [TestSuccess] 
FROM ##LinkedServers
ORDER BY [TestSuccess], [Name]

DROP TABLE ##LinkedServers
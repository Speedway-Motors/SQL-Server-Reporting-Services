USE [ErrorLogging]

-- select * from sys.database_files --   to see file names

GO
DBCC SHRINKFILE (N'ErrorLogging_log' , 0, TRUNCATEONLY)
GO




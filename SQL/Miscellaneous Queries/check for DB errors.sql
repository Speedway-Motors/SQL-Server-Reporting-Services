-- check for DB errors

USE [Util]
                                                        -- manually ran for each on DW1 6-27-16
EXEC spUtil_CheckForDatabaseErrors AFCOReporting        -- 2:20
EXEC spUtil_CheckForDatabaseErrors AFCOTemp             -- 0:01
EXEC spUtil_CheckForDatabaseErrors ErrorLogging         -- 0:01
EXEC spUtil_CheckForDatabaseErrors fogbugz              -- 2:40
EXEC spUtil_CheckForDatabaseErrors fogbugz_Test_delete  -- 0:02
EXEC spUtil_CheckForDatabaseErrors ReportServer         -- 0:04
EXEC spUtil_CheckForDatabaseErrors ReportServer12       -- 0:02
EXEC spUtil_CheckForDatabaseErrors ReportServer12TempDB -- 0:01
EXEC spUtil_CheckForDatabaseErrors ReportServerTempDB   -- 0:01
EXEC spUtil_CheckForDatabaseErrors [SMI Reporting]      --14:02
EXEC spUtil_CheckForDatabaseErrors SMIArchive           -- 0:22
EXEC spUtil_CheckForDatabaseErrors SMIDW                -- 0:01
EXEC spUtil_CheckForDatabaseErrors SMIReportingLiveRecover -- 0:07
EXEC spUtil_CheckForDatabaseErrors SMITemp              -- 0:47
EXEC spUtil_CheckForDatabaseErrors SyncDatabase         -- 0:01
EXEC spUtil_CheckForDatabaseErrors TempSmiReporting     --12:13 
EXEC spUtil_CheckForDatabaseErrors Util                 -- 0:01
EXEC spUtil_CheckForDatabaseErrors WebInfo              -- 0:01
                                                          =====
                                                          32:48


select * from sysnames
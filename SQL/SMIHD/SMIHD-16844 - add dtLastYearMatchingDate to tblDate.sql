-- SMIHD-16844 - add dtLastYearMatchingDate to tblDate

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 64

/*  TABLE: tblDate
    CHANGES TO BE MADE: add dtLastYearMatchingDate varchar(10) (NULL ALLOWED)
*/

/* steps as of 2019.09.19

STEP    WHERE	        ACTION
=== ===============     =======================================================
1	LNK-SQL-LIVE-1	    BACKUP tables to be modified to SMIArchive
2	LNK-SQL-LIVE-1	    DISABLE SSA job "SMIJob_AwsExportData"
3	dw.speedway2.com	DISABLE SSA job "JobAwsImportData"
4	dw.speedway2.com	Script & drop any affexted indexes in SMIReportingRawData
5	dw.speedway2.com	Add to/Alter the corresponding table in SMiReportingRawData (Schema is Transfer)
6	dw.speedway2.com	Rebuild any affected indexes in SMiReportingRawData
7	LNK-SQL-LIVE-1	    Script & drop any affected indexes in ChangeLog_smiReporting
8	LNK-SQL-LIVE-1	    Add to/Alter corresponding table in ChangeLog_smiReporting (Schema is dbo)
9	LNK-SQL-LIVE-1	    Rebuild any affected indexes in ChangeLog_smiReporting
10	SOP	                PAUSE feeds to SMI/AFCO Reporting
11	LNK-SQL-LIVE-1	    Script & drop any affected indexes in SMI/AFCO Reporting
12	LNK-SQL-LIVE-1	    Add/Alter the column in the corresponding table in SMI/AFCO Reporting  (Schema is dbo)
13	LNK-SQL-LIVE-1	    Rebuild any affected indexes in SMI/AFCO Reporting
14	LNK-SQL-LIVE-1	    apply script changes to the appropriate stored procedure(s) (usually spUpdate<tablename>)
15	SOP	                RESUME feeds to SMI/AFCO Reporting
16	SOP             	manually push records to test feeds (before resuming feeds if possible)
17	LNK-SQL-LIVE-1	    verify records pushed updated as expected in SMI/AFCO Reporting 
18	LNK-SQL-LIVE-1	    RE-ENABLE SSA job "SMIJob_AwsExportData"
19	dw.speedway2.com	RE-ENABLE SSA job "JobAwsImportData"
20	dw.speedway2.com	VERIFY updates in SMI Reporting are making their way to corresponding AWS tables
21	SOP	                Verify no error codes are tripping

*/


/*************************************************************************************************************/
/******    STEP 1) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0

/*************************************************************************************************************/
/******   STEP 2) DISABLE SSA job "JobAwsImportData"   ON    [dw.speedway2.com].SMiReportingRawData    *******/


/*************************************************************************************************************/
/******    STEP 3) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblDate_20200220 from [SMI Reporting].dbo.tblDate      --    19,017
select * into [SMIArchive].dbo.BU_AFCO_tblDate_20200220 from [AFCOReporting].dbo.tblDate --     15,360

-- DROP TABLE [SMIArchive].dbo.BU_tblDate_20200207
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblDate_20200207


/******    Copy & Paste detailed code at end of script to a session ON [dw.speedway2.com].SMiReportingRawData
    STEP 2) DISABLE SSA job "JobAwsImportData"                           ON dw.speedway2.com
    STEP 4) Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com
    STEP 5) Add to/Alter corresponding table in SMiReportingRawData      ON dw.speedway2.com
    STEP 6) Rebuild any affected indexes in in SMiReportingRawData       ON dw.speedway2.com                
    STEP 19) RE-ENABLE SSA job "JobAwsImportData"
    STEP 20) VERIFY updates in SMI Reporting are making their way to corresponding AWS tables
    */


/*************************************************************************************************************/
/******    STEP 7)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 8)	Add the column to the corresponding table in ChangeLog_smiReportingRawData         *******/
/******            (Schema is dbo)                                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

-- SMI REPORTING

BEGIN TRANSACTION   -- 37 sec
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblDate ADD
    dtLastYearMatchingDate datetime
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblDate SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



/*************************************************************************************************************/
/******    STEP 9)	Rebuild any affected indexes in ChangeLog_smiReporting                             *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A

/*************************************************************************************************************/
/******    STEP 10) PAUSE feeds to SMI/AFCO Reporting                                                   *******/
/******    SOP                                                                                         *******/



/*************************************************************************************************************/
/******    STEP 11) Script & drop any affected indexes in SMI/AFCO Reporting                            *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A



/*************************************************************************************************************/
/******    STEP 12) Add the column to the SMI/AFCO Reporting tables                                    *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

-- SMI
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [SMI Reporting].dbo.tblDate ADD
    dtLastYearMatchingDate  datetime
GO
ALTER TABLE [SMI Reporting].dbo.tblDate SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

-- SELECT TOP 1 * FROM dbo.tblDate

-- AFCO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [AFCOReporting].dbo.tblDate ADD
    dtLastYearMatchingDate datetime
GO
ALTER TABLE [AFCOReporting].dbo.tblDate SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



/*************************************************************************************************************/
/******    STEP 13) Rebuild any affected indexes in SMI/AFCO Reporting                                 *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A


/*************************************************************************************************************/
/******    STEP 14) apply script changes to the appropriate stored procedure(s)                        *******/
/******            (usually spUpdate<tablename>)                                                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 2/7/2020 10:07:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdateSKU] 

n/a






USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 2/7/2020 10:12:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdateSKU] 



    n/a






/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT ixSKU, dtLastYearMatchingDate ,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblDate 
        where ixSKU in ('')
            -- dtLastYearMatchingDate  is NOT NULL
        order by ixSKU, dtLastYearMatchingDate 
                                        
        /*
*/


    --AFCO TEST DATA
        SELECT ixSKU, dtLastYearMatchingDate ,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblDate 
        where ixSKU in ('')
            -- dtLastYearMatchingDate  is NOT NULL
        order by ixSKU, dtLastYearMatchingDate 
/*
*/

SELECT * FROM tblTime where ixTime = 

/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT  ixSKU, dtLastYearMatchingDate ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblDate 
        where --ixOrder in ( '8464588-1', '8827980')
            dtLastYearMatchingDate  is NOT NULL
        order by ixSKU, dtLastYearMatchingDate  desc
                                        
        /*
        ixOrder	dtLastYearMatchingDate 	LastSOPUpdate	TimeLastSOPUpdate
        9390500	35511	2020.01.28	39575
        */


        SELECT  dtLastYearMatchingDate, count(*) 'SKUCnt'
        from [SMI Reporting].dbo.tblDate 
        where --ixOrder in ( '8464588-1', '8827980')
            dtLastYearMatchingDate  is NOT NULL
        GROUP BY dtLastYearMatchingDate
        ORDER BY dtLastYearMatchingDate




       /*********   AFCO TEST DATA  *********/
        SELECT  ixSKU, dtLastYearMatchingDate ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblDate 
        where --ixOrder in ( '8464588-1', '8827980')
            dtLastYearMatchingDate  is NOT NULL
        order by ixSKU, dtLastYearMatchingDate  desc
        /*
        ixOrder	dtLastYearMatchingDate 	LastSOPUpdate	TimeLastSOPUpdate

        */

        

        SELECT  dtLastYearMatchingDate, count(*) 'SKUCnt'
        from [AFCOReporting].dbo.tblDate 
        where --ixOrder in ( '8464588-1', '8827980')
            dtLastYearMatchingDate  is NOT NULL
        GROUP BY dtLastYearMatchingDate
        ORDER BY dtLastYearMatchingDate

/*************************************************************************************************************/
/******    STEP 17) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES



/*************************************************************************************************************/
/******    18) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************
    STEP 19) RE-ENABLE SSA job "JobAwsImportData"                       ON dw.speedway2.com                 
    STEP 20) Verify SMI Reporting updates are making their way to AWS   ON dw.speedway2.com                 */


/*************************************************************************************************************/
/******    STEP 21)	final check on SMI Reporting to make sure no error codes are tripping              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/ 

    -- ERROR CODE to check on
    select * from tblErrorCode where sDescription like '%tblDate%'
    --  1163	Failure to update tblDate.

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1163'
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-09-20	1082

*/

SELECT dtLastYearMatchingDate , FORMAT(count(*),'###,###') 'SKUcount'
FROM tblDate
-- WHERE dtLastYearMatchingDate  is NOT NULL
GROUP BY dtLastYearMatchingDate 
order by dtLastYearMatchingDate 




select * from tblDate

select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate <  '01/01/1984' -- works
union
select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate between '01/01/1986' and '01/01/1989'
union
select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate between '01/01/1992' and '01/01/1995'
union
select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate between '01/01/1997' and '01/01/2001'
union
select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate between '01/01/2003' and '01/01/2006'
union
select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate between '01/01/2008' and '01/01/2014'
union
select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate >= '01/01/2016'-- and '01/01/2014'


select ixDate, dtDate--, dbo.PrevYrsEquivDate (D.dtDate,1)
from tblDate D
where D.dtDate between '01/01/1984' and '12/31/1985'
    OR D.dtDate between '01/02/1990' and '12/31/1991'
    OR D.dtDate between '01/02/1996' and '12/31/1996'
    OR D.dtDate between '01/02/2001' and '12/31/2002'
    OR D.dtDate between '01/02/2006' and '12/31/2007'
    OR D.dtDate between '01/02/2014' and '12/31/2015'



select ixDate, dtDate, dbo.PrevYrsEquivDate (D.dtDate,1)
--FORMAT (dbo.PrevYrsEquivDate (D.dtDate,1),'yyyy-MM-dd') as'NewDate'
from tblDate D
WHERE D.dtDate >=  '01/09/2016' -- works




SELECT dbo.PrevYrsEquivDate (GETDATE())






SET ROWCOUNT 0

BEGIN TRAN

        UPDATE tblDate
        SET dtLastYearMatchingDate = 'NA'
        WHERE dtLastYearMatchingDate is NULL
            and flgDeletedFromSOP = 0

ROLLBACK TRAN






SELECT dtLastYearMatchingDate , FORMAT(count(*),'###,###') 'BOXcount'
FROM [SMI Reporting].dbo.tblDate 
WHERE flgDeletedFromSOP = 0 
   -- and dtLastYearMatchingDate  is NOT NULL
GROUP BY dtLastYearMatchingDate 
order by dtLastYearMatchingDate
/*
sPackage
Type	SKUcount    @1:26
NULL	11,170
BOX	    218
ENV	    7
NA	    461,596
NEW	    2
SLAPR	3,955
*/

select ixSKU, dtCreateDate from tblDate
where ixSKU NOT IN (select ixSKU from tblSnapshotSKU where ixDate = 19031)
and flgDeletedFromSOP = 0
order by dtCreateDate

BEGIN TRAN

    UPDATE tblDate
    set dtLastYearMatchingDate = NULL
    where ixSKU between 'UP119850' and 'UP119875'


ROLLBACK TRAN


select * from tblDate where flgDeletedFromSOP = 0 
    and dtLastYearMatchingDate  is NULL



select ixSKU, dtLastYearMatchingDate ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
from tblDate
where ixSKU in ('103A184B1SS','10620231','10620231XHD','10640015','10640017','10680100LWN','10680101NP','10680103N','10680104N','10680120N','10680144-S-NA-Y','10680184NDP','10680184NDPU','10680185NDP','10680202N','10680205','106802051','10680249N','1068026810','10680283NDP','10680404FAN','10681164-S-NA-N','1132070','1132276','113253','113345','113550','113594','113673','113679','113681','113696','113709','113856','113913','113996')

select * from tblTime where ixTime = 39738



SELECT * FROM [SMITemp].dbo.PJC_TEMP_SLAPR_SKUs SS-- 3,954    816 missing
    join tblDate S on S.ixSKU = SS.ixSKU
where S.dtLastYearMatchingDate is NULL



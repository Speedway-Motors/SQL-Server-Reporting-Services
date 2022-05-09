-- SMIHD-19379 - add 8 fields to tblDate 

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 92

/*  TABLE: tblDate
    CHANGES TO BE MADE: add ixCancellationReasonCode field to tblDate
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

select * into [SMIArchive].dbo.BU_tblDate_20201216 from [SMI Reporting].dbo.tblDate      --   7,863,047
select * into [SMIArchive].dbo.BU_AFCO_tblDate_20201216 from [AFCOReporting].dbo.tblDate --     17,195

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
    iOperationalPeriod tinyint,
    iOperationalYear    smallint,
    iDayOfOperationalPeriod smallint,
    dtLastYearMatchingOperationalDate datetime,
    dtRolling28DayStart datetime,
    dtRolling28DayEnd   datetime,
    dtRolling7DayStart  datetime,
    dtRolling7DayEnd    datetime
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
    iOperationalPeriod tinyint,
    iOperationalYear    smallint,
    iDayOfOperationalPeriod smallint,
    dtLastYearMatchingOperationalDate datetime,
    dtRolling28DayStart datetime,
    dtRolling28DayEnd   datetime,
    dtRolling7DayStart  datetime,
    dtRolling7DayEnd    datetime
GO
ALTER TABLE [SMI Reporting].dbo.tblDate SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

-- SELECT TOP 1 * FROM dbo.tblDateLocation

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
    iOperationalPeriod tinyint,
    iOperationalYear    smallint,
    iDayOfOperationalPeriod smallint,
    dtLastYearMatchingOperationalDate datetime,
    dtRolling28DayStart datetime,
    dtRolling28DayEnd   datetime,
    dtRolling7DayStart  datetime,
    dtRolling7DayEnd    datetime
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

  N/A

/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

select distinct ixSKU from tblSKUTransaction
where ixDate = 19276
and ixTime between 29220 and 29820 -- 8:07 to 8:17

select * from tblTime where chTime = '08:17:00'
select top 10 * from tblSKUTransaction

    --SMI TEST DATA
        SELECT ixOrder, ixCancellationReasonCode, sCanceledReason,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblDate S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder  in ('9940478','9903472','9903572','9980376','9530526-1','9783777-1','9943073','9604973-1','9905479','9930370-1','9944377','9944475','9983271','9906576','9379372-1','9876277-1','9984275','9907578','9523272-1','9643374-1','9908375','9524873','9985470','9926179-1','9850972-1','9855579-1','9986370','9986379','9871577','9948474','9987377','9493371-2','9987476','9949473','9911176','9950673','9989074','9065170-1','9835876','9067474-1','9136555-1','9915275','9626950-1','9706378-1','9923177-1','9992479','9631175-1','9954276','9565178-1','9916375','9993377','9993473','9810377-1','9994277','9917573','9917576','9917670','9626976-1','9995073','9450475-1','9918678','9671878-1','9646170-1','9660371-1','9996179','9832275-1','9794673-1','9344970-1','9651177-1','9441675-1','9050678-1','9998276','9929378-1','9884177','9922574','9863772-1','9809572','9821979-1','9450166-1','9782077-1','9353476-1','9957436-1','9009674-1','9965377','9106378-1','9777871-1','9431771-1','9445974-1','9967472','9890977','9733761-1','9439072-1','9853677','9627875-1','9934077-1','9816678','9970575','8934892','9972275','9972378','9972470','9942170-1','9896773','9254958-1','9202774-1','9974570','9961371-1','9936477','9975270','9975275','9975472','9015151-1','9389270-1','9822574','9861371','9570774-1','9038571-1','9382376-1','9977277','9139879-1','9811378-1','9940376')
        ORDER BY dtDateLastSOPUpdate, T.chTime
            
    --AFCO TEST DATA
        SELECT ixOrder, ixCancellationReasonCode, sCanceledReason,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblDate S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder  in ('910529-1','913559-1','913450-1')
        ORDER BY dtDateLastSOPUpdate, T.chTime


/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT ixOrder, ixCancellationReasonCode,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblDate S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixCancellationReasonCode is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime


       /*********   AFCO TEST DATA  *********/
        SELECT ixOrder, ixCancellationReasonCode,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblDate S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixCancellationReasonCode is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime

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
    --  1141	Failure to update tblDate	SQLDB

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1141'
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-09-20	1082
    SMI Reporting	10-08-19	2009

*/

select ixDate, iOperationalPeriod, iOperationalYear,  iDayOfOperationalPeriod from tblDate
where ixDate = 19361

BEGIN TRAN

    update tblDate
    set iOperationalPeriod = 1,
        iOperationalYear = 2021,
        iDayOfOperationalPeriod = 1
    where ixDate = 19361

ROLLBACK TRAN







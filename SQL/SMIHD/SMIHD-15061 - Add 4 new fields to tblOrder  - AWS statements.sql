-- SMIHD-15061 - Add 4 new fields to tblOrder  - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 119 


/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "JobAwsImportData"       ON dw.speedway2.com                        *******/
/******                                                                                                *******/

    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 0



/*************************************************************************************************************/
/******    STEP 4)	Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com   *******/

            N/A



/*************************************************************************************************************/
/******    STEP 5) Add/alter corresponding table in SMiReportingRawData        ON dw.speedway2.com     *******/
/******           (Schema is Transfer)                                                                 *******/


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
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder ADD
    ixOptimalShipLocation tinyint NULL,
    ixMasterOrderNumber varchar(32) NULL,
	flgSplitOrder tinyint NULL,
    flgBackorder  tinyint NULL
GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/*************************************************************************************************************/
/******    STEP 6) Rebuild any affected indexes in in SMiReportingRawData       ON dw.speedway2.com    *******/

       N/A

/*************************************************************************************************************/
/******    19) RE-ENABLE SSA job "JobAwsImportData"                                                    *******/
/******    dw.speedway2.com                                                                            *******/
    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 20)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com                                                                            *******/
                                                                         
        --SMI TEST DATA

       SELECT ixOrder, ixPrimaryShipLocation, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder,  -- 9:36
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from dbo.tblOrder where ixMasterOrderNumber is NOT NULL
        /*
                ixOrder	    iLength	iWidth	iHeight	DateLastSOPUpdate   TimeLastSOPUpdate
        BEFORE  465AC4004	13.0	7.0	    1.0	    2019.05.16          25760
        AFTER   465AC4004	13.6	7.7	    1.8	    2019.06.18	        54633
        */
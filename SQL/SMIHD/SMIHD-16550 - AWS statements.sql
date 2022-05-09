--  SMIHD-16550 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 111 


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


BEGIN TRANSACTION   -- 50 sec
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
    ixShippedTime int NULL

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

        SELECT  ixSKU, ixShippedTime,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblOrder 
        where --ixOrder in ( '8464588-1', '8827980')
            ixShippedTime is NOT NULL
          --  sTrackingNumber = 'XXX'
        order by ixSKU, ixShippedTime

        /*                              dBox    Last
        sTrackingNumber	    ixOrder	    Weight	SOPUpdate	TimeLastSOPUpdate
        1Z6353580354548088	8464588-1	NULL	2019.10.23	47573
        1Z6353580354548097	8464588-1	NULL	2019.10.23	47573
        1Z6353580354548104	8464588-1	NULL	2019.10.23	47443
        1Z6353580354548113	8464588-1	NULL	2019.10.23	47443
        1Z6353580354546982	8827980	    NULL	2019.10.23	41738
        1Z6353580354546991	8827980	    NULL	2019.10.23	41713
        1Z6353580354547007	8827980	    NULL	2019.10.23	41712
        */


                SELECT  ixOrder, ixShippedTime,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from dbo.tblOrder 
        where --ixOrder in ( '8464588-1', '8827980')
            ixShippedTime is NOT NULL
          --  sTrackingNumber = 'XXX'
        order by ixOrder, ixShippedTime desc

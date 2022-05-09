--  SMIHD-18235 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 75 


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
ALTER TABLE [SMiReportingRawData].[Transfer].tblSKU ADD
    sBattery varchar(10),
    sLiquid varchar(10),
    sLimitedQuantity varchar(10),
    sSDS varchar(10)

GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblSKU SET (LOCK_ESCALATION = TABLE)
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

       SELECT ixSKU, sBattery, sLiquid, sLimitedQuantity, sSDS,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from dbo.tblSKU 
        where  sBattery is NOT NULL
            or sLiquid  is NOT NULL
            or sLimitedQuantity is NOT NULL
            or sSDS is NOT NULL
        order by ixSKU

       SELECT count(ixSKU)
        from dbo.tblSKU 
        where flgDeletedFromSOP = 0
        and ( sBattery is NULL
            or sLiquid  is NULL
            or sLimitedQuantity is NULL -- 383k @3:33
            or sSDS is NULL             -- 133k @4:41
            )




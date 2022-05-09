-- SMIHD-21426 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 109 
EXEC sp_blockinfo  
EXEC [Util].dbo.usp_who5 X,NULL,NULL,NULL,NULL 


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
ALTER TABLE [SMiReportingRawData].[Transfer].tblCreditMemoMaster ADD
    mMarketplaceSellingFee money

GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


-- ROLLBACK TRAN



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
        SELECT ixSKU, sCARBSubclass, sCARBEONumber,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblCreditMemoMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixSKU in ('376443513','282242916','92620850')
        ORDER BY dtDateLastSOPUpdate, T.chTime




-- SMIHD-25170 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 133
 
/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "JobAwsImportData"       ON dw.speedway2.com                        *******/
/******                                                                                                *******/

    exec [msdb].dbo.sp_update_job @job_name = 'SmiJob_AwsImportData', @enabled = 0



/*************************************************************************************************************/
/******    STEP 4)	Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com   *******/

            N/A



/*************************************************************************************************************/
/******    STEP 5) Add/alter corresponding table in SMiReportingRawData        ON dw.speedway2.com     *******/
/******           (Schema is Transfer)                                                                 *******/


BEGIN TRANSACTION   -- 50-247 sec
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
ALTER TABLE [DW].[Transfer].tblVendorSKU ADD
	mLandedCost money,
	mTariffCost money,
	mContainerUnitCost money

GO
ALTER TABLE [DW].[Transfer].tblVendorSKU SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


-- ROLLBACK TRAN



/*************************************************************************************************************/
/******    STEP 6) Rebuild any affected indexes in in SMiReportingRawData       ON dw.speedway2.com    *******/

       N/A

/*************************************************************************************************************/
/******    19) RE-ENABLE SSA job "JobAwsImportData"                                                    *******/
/******    dw.speedway2.com                                                                            *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SmiJob_AwsImportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 20)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com                                                                            *******/
                                                                         

    --SMI TEST DATA
        SELECT ixVendor, ixSKU,iOrdinality, mLandedCost, mTariffCost, mContainerUnitCost
        FROM tblVendorSKU
        WHERE mLandedCost is NOT NULL
			or mTariffCost is NOT NULL
			or mContainerUnitCost is NOT NULL






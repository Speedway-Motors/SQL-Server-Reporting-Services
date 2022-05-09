--  SMIHD-16844 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 99 


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
ALTER TABLE [SMiReportingRawData].[Transfer].tblDate ADD
    dtLastYearMatchingDate datetime

GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblDate SET (LOCK_ESCALATION = TABLE)
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

        SELECT  ixSKU, dtLastYearMatchingDate,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from dbo.tblDate 
        where --ixOrder in ( '8464588-1', '8827980')
            dtLastYearMatchingDate is NOT NULL
          --  sTrackingNumber = 'XXX'
        order by ixSKU, dtLastYearMatchingDate

        /*                             
2
        */



SELECT dtLastYearMatchingDate , FORMAT(count(*),'###,###') 'SKUcount' 
FROM tblDate
WHERE flgDeletedFromSOP = 0 
-- and dtLastYearMatchingDate  is NOT NULL
GROUP BY dtLastYearMatchingDate 
order by dtLastYearMatchingDate 
/*
sPackage
Type	SKUcount        
======  ========    
BOX	    218     @2-12-2020 10:00
ENV	    7
NA	    461,663
NEW	    41
SLAPR	3,981



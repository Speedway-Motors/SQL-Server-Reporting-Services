--  SMIHD-17478 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 73 


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
ALTER TABLE [SMiReportingRawData].[Transfer].tblPackage ADD
    ixSuggestedBoxSKU  varchar(30),
    dFinalBillingWeight decimal(10,3)

GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblPackage SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder DROP Column
    ixSuggestedBoxSKU,
    dFinalBillingWeight

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
        SELECT sTrackingNumber, ixOrder, ixBoxSKU,  ixSuggestedBoxSKU, dFinalBillingWeight, ixShipDate, flgReplaced, flgCanceled,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from dbo.tblPackage 
        where --ixOrder in ('')
             ixSuggestedBoxSKU  is NOT NULL
             or dFinalBillingWeight is NOT NULL
        order by sTrackingNumber, ixOrder 

        /*                             
2
        */



SELECT sShippingInstructions , FORMAT(count(*),'###,###') 'SKUcount' 
FROM tblOrder
WHERE flgDeletedFromSOP = 0 
-- and sShippingInstructions  is NOT NULL
GROUP BY sShippingInstructions 
order by sShippingInstructions 
/*
sPackage
Type	SKUcount        
======  ========    
BOX	    218     @2-12-2020 10:00
ENV	    7
NA	    461,663
NEW	    41
SLAPR	3,981





select count(*) 
from dbo.tblOrder
--where ixOrderDate = 19107

where ixOrder in ('48739','48734','48654','48654','48578','48575','48555','48541','48538','48528','48496','48496','48492','48421','48413','48394','48356','48355','48342','48302')

select top 30 ixOrder, ixOrderTime
from tblOrder
where ixOrderDate = 19107
and ixOrderTime >= 48000
order by ixOrderTime desc

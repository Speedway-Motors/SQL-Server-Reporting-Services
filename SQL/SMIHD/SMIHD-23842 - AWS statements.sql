-- SMIHD-23842 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 73 

 
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
ALTER TABLE [DW].[Transfer].tblOrder ADD
    sDivision varchar(15)

GO
ALTER TABLE [DW].[Transfer].tblOrder SET (LOCK_ESCALATION = TABLE)
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
        SELECT ixOrder, sDivision,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder in ('11049203','10994697') -- ('948139','945157')
        ORDER BY dtDateLastSOPUpdate, T.chTime

		-- checked 10:03


select sDivision, FORMAT(count(*),'###,###') 'OrdCnt'
from tblOrder
group by sDivision
/*	SMI
Div		Orders
=====	=========
NULL	9,272,697
EMI		4
SMI		11,396
*/
											
SELECT FORMAT(count(*),'###,###') 'OrdCnt'  -- 8,980,865 @6:37
FROM tblOrder								-- 
WHERE sDivision IS NULL						-- 
											-- 

											-- 8,500,000 GOAL @6:37
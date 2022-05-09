-- SMIHD-20689 - tblHoldCodeAuditHistory AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 53

/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "JobAwsImportData"       ON dw.speedway2.com                        *******/

    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 0

        -- run  "DC - sub08 AWS Staging Record Count" to keep an eye on the AWS queue size


/*************************************************************************************************************/
/******    STEP 7) modify the varchar columns to nvarchar       ON dw.speedway2.com                    *******/

    SELECT * FROM tblHoldCodeAuditHistory

    -- After the synonym shows up on AWS, modify the varchar columns to nvarchar using the SSMS designer
    -- The new table will be located in Transfer.<TableName> in DW
    -- Do NOT alter the sAwsObjectCode(1-5) fields (RON WILL ALTER THOSE LATER)



/*************************************************************************************************************/
/******    STEP 10) run the job JobAwsImportData manually        ON dw.speedway2.com                   *******/

        -- WON"T POPULATE YET but should run with no errors



/*************************************************************************************************************/
/******    STEP 11) RE-ENABLE SSA job "JobAwsImportData"                                                *******/
/******    dw.speedway2.com                                                                            *******/
    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 1

    -- VERIFY STEP 11 COMPLETED!  
    -- Check job history to see if the job successfully ran at least once since being re-enabled.
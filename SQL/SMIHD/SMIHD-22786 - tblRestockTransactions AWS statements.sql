-- SMIHD-22786 - tblRestockTransactions AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 73

/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "JobAwsImportData"       ON dw.speedway2.com                        *******/

    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 0



/*************************************************************************************************************/
/******    STEP 6) modify the varchar columns to nvarchar       ON dw.speedway2.com                    *******/

    -- After the synonym shows up on AWS, modify the varchar columns to nvarchar using the SSMS designer
    -- The new table will be located in Transfer.<TableName> in DW
    -- Do not alter the sAwsObjectCode(1-4) fields



/*************************************************************************************************************/
/******    STEP 8) run the job JobAwsImportData manually        ON dw.speedway2.com                    *******/

        -- WON"T POPULATE YET but should run with no errors



/*************************************************************************************************************/
/******    STEP 9) RE-ENABLE SSA job "JobAwsImportData"                                                *******/
/******    dw.speedway2.com                                                                            *******/
    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 1

    -- VERIFY STEP 9 COMPLETED!  
    -- Check job history to see if the job successfully ran at least once since being re-enabled.
-- SMIHD-22786 - Create tblRestockTransactions
-- LNK-SQL-LIVE-1

SELECT @@SPID as 'Current SPID' -- 123

/*************************************************************************************************************/
/******    STEP 1) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0


/*************************************************************************************************************/
/******    STEP 3) Build the table in [SMI Reporting]                                                  *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

        USE [SMI Reporting]
        GO

        /****** Object:  Table [dbo].[tblRestockTransactions]    Script Date: 10/13/2021 8:36:37 AM ******/
        SET ANSI_NULLS ON
        GO

        SET QUOTED_IDENTIFIER ON
        GO

        CREATE TABLE [dbo].[tblRestockTransactions](
	        [ixOrder] [varchar](10) NOT NULL,
	        [iOrdinality] [smallint] NOT NULL,
	        [sCIDRestockType] [varchar](10) NULL,
	        [sReceivingRoutingCode] [varchar](10) NULL,
	        [dtCreated] [datetime] NULL,
	        [ixCreatedUser] [varchar](10) NULL,
	        [dtLastChanged] [datetime] NULL,
	        [ixLastChangedUser] [varchar](15) NULL,
	        [ixSKU] [varchar](30) NULL,
	        [iQuantityRequested] [int] NULL,
	        [iQuantityPulled] [int] NULL,
	        [sPullType] [varchar](10) NULL,
	        [ixFromLocation] [tinyint] NULL,
	        [ixToLocation] [tinyint] NULL,
	        [sCID] [varchar](15) NULL,
	        [sPullStatus] [varchar](5) NULL,
	        [flgArchived] [tinyint] NULL,
	        [dtDateLastSOPUpdate] [datetime] NULL,
	        [ixTimeLastSOPUpdate] [int] NULL,
         CONSTRAINT [PK_tblRestockTransactions_1] PRIMARY KEY NONCLUSTERED 
        (
	        [ixOrder] ASC,
	        [iOrdinality] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
        GO






/*************************************************************************************************************/
/******    STEP 4) Add the new table to [SMI Reporting].dbo.tblAwsQueueTypeReference                   *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    
    -- Just use the SSMS edit functionality (follow the pattern for previous tables).
    -- This adds all the triggers and everything needed on lnk-sql-live-1



/*************************************************************************************************************/
/******    STEP 5) exec spCreateAwsQueueTriggers 0                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec spCreateAwsQueueTriggers 0 -- @     Rows

    -- This creates everything needed on the datapile.
    -- the job that creates the synonyms runs every 15 minutes
    -- Verify the synonym shows up on AWS.



/*************************************************************************************************************/
/******    STEP 7) exec sp_<TableName>_InitialFeed_tblAwsQueueStage                                     ******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec sp_tblRestockTransactions_InitialFeed_tblAwsQueueStage 'tblRestockTransactions'
    		
    -- Run for each table if creating more than 1


/*************************************************************************************************************/
/******    10) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


    -- VERIFY STEP 10 COMPLETED!  
    -- Check job history to see if the job successfully ran at least once since being re-enabled.


--      DC - sub08 AWS Staging Record Count    152,508 records @1:25



SELECT distinct sError
FROM tblErrorLogMaster
where ixErrorCode = 1227
and dtDate >= '10/13/2021'




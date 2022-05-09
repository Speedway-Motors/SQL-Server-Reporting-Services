-- SMIHD-20689 - Create tblHoldCodeAuditHistory
-- LNK-SQL-LIVE-1

SELECT @@SPID as 'Current SPID' -- 54

/*************************************************************************************************************/
/******    STEP 1) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0


   
/*************************************************************************************************************/
/******    STEP 3) Build the table in [SMI Reporting]                                                  *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

        USE [SMI Reporting]
        GO

        /****** Object:  Table [dbo].[tblHoldCodeAuditHistory]    Script Date: 10/13/2021 8:36:37 AM ******/
        SET ANSI_NULLS ON
        GO

        SET QUOTED_IDENTIFIER ON
        GO

        CREATE TABLE [dbo].[tblHoldCodeAuditHistory](
	        [ixOrder] [varchar](10) NOT NULL,
	        [iOrdinality] [smallint] NOT NULL,
            [ixTransactionDate] [smallint] NULL,
            [ixTransactionTime] [int] NULL,
            [sUser] [varchar](15) NULL,             -- #5
            [sProgramFlag] [varchar](15) NULL,
            [sPaymentMethod] [varchar](15) NULL,
            [sHoldCode] [varchar](15) NULL,
            [sAuthResponseShortDescription] [varchar](120) NULL,
            [sHoldReason] [varchar](50) NULL,       -- #10
            [sReleaseComment1] [varchar](50) NULL,
            [sReleaseComment2] [varchar](50) NULL,
            [sReleaseComment3] [varchar](50) NULL,
            [ixOriginalOrder] [varchar](10) NULL,
            [dtDateLastSOPUpdate] [datetime] NULL,  -- #15
	        [ixTimeLastSOPUpdate] [int] NULL,
         CONSTRAINT [PK_tblHoldCodeAuditHistory_1] PRIMARY KEY NONCLUSTERED 
        (
	        [ixOrder] ASC,
	        [iOrdinality] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
        GO



/*************************************************************************************************************/
/******    STEP 4) Add the new stored proc to update the new table                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

        USE [SMI Reporting]
        GO

        /****** Object:  StoredProcedure [dbo].[spUpdateHoldCodeAuditHistory]    Script Date: 10/14/2021 9:44:47 AM ******/
        SET ANSI_NULLS ON
        GO

        SET QUOTED_IDENTIFIER ON
        GO

        CREATE PROCEDURE [dbo].[spUpdateHoldCodeAuditHistory]
	        @ixOrder varchar(10),
	        @iOrdinality smallint,
            @ixTransactionDate smallint,
            @ixTransactionTime int,
            @sUser varchar(15),             -- #5
            @sProgramFlag varchar(15),
            @sPaymentMethod varchar(15),
            @sHoldCode varchar(15),
            @sAuthResponseShortDescription varchar(120),
            @sHoldReason varchar(50),       -- #10
            @sReleaseComment1 varchar(50),
            @sReleaseComment2 varchar(50),
            @sReleaseComment3 varchar(50),
            @ixOriginalOrder varchar(10)
            --@dtDateLastSOPUpdate datetime,

        AS
        /*
              EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                        @Field1='ixOrder'               ,@Value1=@ixOrder, 
                        @Field2='iOrdinality'           ,@Value2=@iOrdinality,
                        @Field3='sUser'                 ,@Value3=@sUser,
                        @Field4='sHoldCode'             ,@Value4=@sHoldCode, 
                        @Field5='PROC CALLED' ,@Value5='TESTING - NOT necessarily an error'     
        */  
        -- SET DEADLOCK_PRIORITY LOW --see if it will  help with that Tableau refresh transaction deadlock errors

        if exists (select * from tblHoldCodeAuditHistory where ixOrder = @ixOrder and iOrdinality = @iOrdinality)
            BEGIN
                BEGIN TRY
	                update tblHoldCodeAuditHistory set
                        ixOrder = @ixOrder,
                        ixTransactionDate = @ixTransactionDate,
                        ixTransactionTime = @ixTransactionTime,
                        sUser = @sUser,             -- #5
                        sProgramFlag = @sProgramFlag,
                        sPaymentMethod = @sPaymentMethod,
                        sHoldCode = @sHoldCode,
                        sAuthResponseShortDescription = @sAuthResponseShortDescription,
                        sHoldReason = @sHoldReason,       -- #10
                        sReleaseComment1 = @sReleaseComment1,
                        sReleaseComment2 = @sReleaseComment2,
                        sReleaseComment3 = @sReleaseComment3,
                        ixOriginalOrder = @ixOriginalOrder,
                        dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,getdate())), -- #15
                        ixTimeLastSOPUpdate = dbo.GetCurrentixTime ()
                        where ixOrder = @ixOrder and iOrdinality = @iOrdinality
                    END TRY
	
	            BEGIN CATCH
                    EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                        @Field1='ixOrder'               ,@Value1=@ixOrder, 
                        @Field2='iOrdinality'           ,@Value2=@iOrdinality,
                        @Field3='sUser'                 ,@Value3=@sUser,
                        @Field4='sHoldCode'             ,@Value4=@sHoldCode, 
                        @Field5='ixOriginalOrder '      ,@Value5=@ixOriginalOrder 
                END CATCH 
            END               	

        ELSE
	        BEGIN
	            BEGIN TRY
		            insert tblHoldCodeAuditHistory 
                    (ixOrder, iOrdinality, ixTransactionDate, ixTransactionTime, sUser,
                    sProgramFlag, sPaymentMethod, sHoldCode, sAuthResponseShortDescription, sHoldReason,
                    sReleaseComment1, sReleaseComment2, sReleaseComment3, ixOriginalOrder, dtDateLastSOPUpdate,ixTimeLastSOPUpdate)
		            values                                                                                                                                  
			        (@ixOrder, @iOrdinality, @ixTransactionDate, @ixTransactionTime, @sUser,
                    @sProgramFlag, @sPaymentMethod, @sHoldCode, @sAuthResponseShortDescription, @sHoldReason,
                    @sReleaseComment1, @sReleaseComment2, @sReleaseComment3, @ixOriginalOrder,  DATEADD(dd,0,DATEDIFF(dd,0,getdate())), dbo.GetCurrentixTime ())
	        END TRY
	            BEGIN CATCH
                    EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                        @Field1='ixOrder'               ,@Value1=@ixOrder, 
                        @Field2='iOrdinality'           ,@Value2=@iOrdinality,
                        @Field3='sUser'                 ,@Value3=@sUser,
                        @Field4='sHoldCode'             ,@Value4=@sHoldCode, 
                        @Field5='ixOriginalOrder '      ,@Value5=@ixOriginalOrder 
                END CATCH 
         end
        GO





/*************************************************************************************************************/
/******    STEP 5 Add the new table to [SMI Reporting].dbo.tblAwsQueueTypeReference                   *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    
    -- Just use the SSMS edit functionality (follow the pattern for previous tables).
    -- This adds all the triggers and everything needed on lnk-sql-live-1



/*************************************************************************************************************/
/******    STEP 6) exec spCreateAwsQueueTriggers 0                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec spCreateAwsQueueTriggers 0 -- @     Rows

    -- This creates everything needed on the datapile.
    -- the job that creates the synonyms runs every 15 minutes
    -- Verify the synonym shows up on AWS.



/*************************************************************************************************************/
/******    STEP 8) exec sp_<TableName>_InitialFeed_tblAwsQueueStage                                     ******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec sp_tblHoldCodeAuditHistory_InitialFeed_tblAwsQueueStage 'tblHoldCodeAuditHistory'
    		
    -- Run for each table if creating more than 1

/*************************************************************************************************************/
/******    STEP 9) add the new error code info to tblErrorLogMaster                                   ******/
/******    LNK-SQL-LIVE-1     
                                                                         *******/
    -- manually edit the table and add new info
    ixErrorCode = 1228
    sDescription = 'Failure to update tblHoldCodeAuditHistory'


/*************************************************************************************************************/
/******    11) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


    -- VERIFY STEP 11 COMPLETED!  
    -- Check job history to see if the job successfully ran at least once since being re-enabled.


--      DC - sub08 AWS Staging Record Count    152,508 records @1:25


SELECT *
FROM tblHoldCodeAuditHistory
WHERE ixTimeLastSOPUpdate >  44537
order by ixTimeLastSOPUpdate
    --ixTransactionDate, ixTransactionTime
-- 90 before 19646, 998 =  19646 
-- ixTimeLastSOPUpdate 42950-43853
-- 1 day refeed 44286 to 44537 1179 records    4.6 rec/sec

SELECT *
FROM tblHoldCodeAuditHistory
order by ixTimeLastSOPUpdate

32066-34500  125,037 -- 2,434 = 51 rec/sec

select top 1000 ixOrder 
from tblHoldCodeAuditHistory
order by newid()

45202-45222 1,227 -- 61 rec/sec

select * from tblTime where chTime like '09:35%'

where ixOrder = '10342863'


SELECT * FROM [AFCOReporting].dbo.tblHoldCodeAuditHistory

SELECT * -- distinct sError
FROM tblErrorLogMaster
where ixErrorCode = 1228
-- and dtDate >= '10/13/2021'

dtDateLastSOPUpdate	ixTimeLastSOPUpdate
2021-10-14      	40796


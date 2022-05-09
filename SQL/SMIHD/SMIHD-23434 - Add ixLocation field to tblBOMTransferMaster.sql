-- SMIHD-23434 - Add ixLocation field to tblBOMTransferMaster

SELECT @@SPID as 'Current SPID' -- 114

/*  TABLE: tblBOMTransferMaster
    CHANGES TO BE MADE: add ixLocation field to tblBOMTransferMaster
*/

/* steps as of 2019.09.19

STEP    WHERE	        ACTION
=== ===============     =======================================================
1	LNK-SQL-LIVE-1	    BACKUP tables to be modified to SMIArchive
2	LNK-SQL-LIVE-1	    DISABLE SSA job "SMIJob_AwsExportData"
3	dw.speedway2.com	DISABLE SSA job "JobAwsImportData"
4	dw.speedway2.com	Script & drop any affexted indexes in SMIReportingRawData
5	dw.speedway2.com	Add to/Alter the corresponding table in SMiReportingRawData (Schema is Transfer)
6	dw.speedway2.com	Rebuild any affected indexes in SMiReportingRawData
7	LNK-SQL-LIVE-1	    Script & drop any affected indexes in ChangeLog_smiReporting
8	LNK-SQL-LIVE-1	    Add to/Alter corresponding table in ChangeLog_smiReporting (Schema is dbo)
9	LNK-SQL-LIVE-1	    Rebuild any affected indexes in ChangeLog_smiReporting
10	SOP	                PAUSE feeds to SMI/AFCO Reporting
11	LNK-SQL-LIVE-1	    Script & drop any affected indexes in SMI/AFCO Reporting
12	LNK-SQL-LIVE-1	    Add/Alter the column in the corresponding table in SMI/AFCO Reporting  (Schema is dbo)
13	LNK-SQL-LIVE-1	    Rebuild any affected indexes in SMI/AFCO Reporting
14	LNK-SQL-LIVE-1	    apply script changes to the appropriate stored procedure(s) (usually spUpdate<tablename>)
15	SOP	                RESUME feeds to SMI/AFCO Reporting
16	SOP             	manually push records to test feeds (before resuming feeds if possible)
17	LNK-SQL-LIVE-1	    verify records pushed updated as expected in SMI/AFCO Reporting 
18	LNK-SQL-LIVE-1	    RE-ENABLE SSA job "SMIJob_AwsExportData"
19	dw.speedway2.com	RE-ENABLE SSA job "JobAwsImportData"
20	dw.speedway2.com	VERIFY updates in SMI Reporting are making their way to corresponding AWS tables
21	SOP	                Verify no error codes are tripping

*/


/*************************************************************************************************************/
/******    STEP 1) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0



/*************************************************************************************************************/
/******    STEP 3) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblBOMTransferMaster_20220104 from [SMI Reporting].dbo.tblBOMTransferMaster      --   117,234
select * into [SMIArchive].dbo.BU_AFCO_tblBOMTransferMaster_20220104 from [AFCOReporting].dbo.tblBOMTransferMaster --   305,225

-- DROP TABLE [SMIArchive].dbo.BU_tblBOMTransferMaster_20220104
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblBOMTransferMaster_20220104

/*************************************************************************************************************/
/******    STEP 7)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 8)	Add the column to the corresponding table in ChangeLog_smiReportingRawData         *******/
/******            (Schema is dbo)                                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

-- SMI REPORTING

BEGIN TRANSACTION   -- 37 sec
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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblBOMTransferMaster ADD
    ixLocation tinyint
GO  
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblBOMTransferMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

/*************************************************************************************************************/
/******    STEP 9)	Rebuild any affected indexes in ChangeLog_smiReporting                             *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A

/*************************************************************************************************************/
/******    STEP 10) PAUSE feeds to SMI/AFCO Reporting                                                   *******/
/******    SOP                                                                                         *******/



/*************************************************************************************************************/
/******    STEP 11) Script & drop any affected indexes in SMI/AFCO Reporting                            *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A



/*************************************************************************************************************/
/******    STEP 12) Add the column to the SMI/AFCO Reporting tables                                    *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

-- SMI
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [SMI Reporting].dbo.tblBOMTransferMaster ADD
    ixLocation tinyint
GO
ALTER TABLE [SMI Reporting].dbo.tblBOMTransferMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

 -- SELECT TOP 1 * FROM dbo.tblBOMTransferMasterLocation

-- AFCO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [AFCOReporting].dbo.tblBOMTransferMaster ADD
    ixLocation tinyint
GO
ALTER TABLE [AFCOReporting].dbo.tblBOMTransferMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


/*************************************************************************************************************/
/******    STEP 13) Rebuild any affected indexes in SMI/AFCO Reporting                                 *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A


/*************************************************************************************************************/
/******    STEP 14) apply script changes to the appropriate stored procedure(s)                        *******/
/******            (usually spUpdate<tablename>)                                                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateBOMTransferMaster]    Script Date: 1/3/2022 3:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateBOMTransferMaster]
	@ixTransferNumber varchar(20),
	@ixFinishedSKU varchar(30),
	@iQuantity smallint,
	@iCompletedQuantity smallint,
	@flgReverseBOM tinyint,
	@ixCreateDate smallint,
	@ixDueDate smallint,
	@dtCanceledDate datetime,
	@flgClosed tinyint,
	@iOpenQuantity smallint,
	@iReleasedQuantity smallint,
	@ixCreator varchar(10),
	@ixStartDate smallint,
	@ixPrintedDate smallint,
    @ixLocation tinyint
AS
if exists (select * from tblBOMTransferMaster where ixTransferNumber = @ixTransferNumber)
    BEGIN
        BEGIN TRY
	        update tblBOMTransferMaster set
		        ixFinishedSKU = @ixFinishedSKU,
		        iQuantity = @iQuantity,
		        iCompletedQuantity = @iCompletedQuantity,
		        flgReverseBOM = @flgReverseBOM,
		        ixCreateDate = @ixCreateDate,
		        ixDueDate = @ixDueDate,
		        dtCanceledDate = @dtCanceledDate,
		        flgClosed = @flgClosed,
		        iOpenQuantity = @iOpenQuantity,
		        iReleasedQuantity = @iReleasedQuantity,
		        dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())),
		        ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
		        ixCreator = @ixCreator,
		        ixStartDate = @ixStartDate,
                ixLocation = @ixLocation
		        where ixTransferNumber = @ixTransferNumber
	    END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixTransferNumber'      ,@Value1=@ixTransferNumber, 
                @Field2='ixFinishedSKU'         ,@Value2=@ixFinishedSKU,
                @Field3='iQuantity'             ,@Value3=@iQuantity,
                @Field4='iCompletedQuantity'    ,@Value4=@iCompletedQuantity, 
                @Field5='ixLocation'            ,@Value5=@ixLocation   	
	    END CATCH
    END
ELSE
	BEGIN
	    BEGIN TRY
		    insert
			    tblBOMTransferMaster (ixTransferNumber, ixFinishedSKU, iQuantity, iCompletedQuantity, 
			    flgReverseBOM, ixCreateDate, ixDueDate, dtCanceledDate, flgClosed, iOpenQuantity, iReleasedQuantity,
			    dtDateLastSOPUpdate, ixTimeLastSOPUpdate,
			    ixCreator, ixStartDate, ixPrintedDate, ixLocation)
		    values
			    (@ixTransferNumber, @ixFinishedSKU, @iQuantity, @iCompletedQuantity, 
			     @flgReverseBOM, @ixCreateDate, @ixDueDate, @dtCanceledDate, @flgClosed, @iOpenQuantity, @iReleasedQuantity,
			     DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())), dbo.GetCurrentixTime(),
			     @ixCreator, @ixStartDate, @ixPrintedDate, @ixLocation
			     )
			 
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixTransferNumber'      ,@Value1=@ixTransferNumber, 
                @Field2='ixFinishedSKU'         ,@Value2=@ixFinishedSKU,
                @Field3='iQuantity'             ,@Value3=@iQuantity,
                @Field4='iCompletedQuantity'    ,@Value4=@iCompletedQuantity, 
                @Field5='ixLocation'            ,@Value5=@ixLocation     	
	    END CATCH			     
	END




USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateBOMTransferMaster]    Script Date: 1/3/2022 3:32:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateBOMTransferMaster]
	@ixTransferNumber varchar(20),
	@ixFinishedSKU varchar(30),
	@iQuantity smallint,
	@iCompletedQuantity smallint,
	@flgReverseBOM tinyint,
	@ixCreateDate smallint,
	@ixDueDate smallint,
	@dtCanceledDate datetime,
	@flgClosed tinyint,
	@iOpenQuantity smallint,
	@iReleasedQuantity smallint,
	@ixCreator varchar(10),
	@ixStartDate smallint,
	@ixPrintedDate smallint,
    @ixLocation tinyint
	
AS
if exists (select * from tblBOMTransferMaster where ixTransferNumber = @ixTransferNumber)
    BEGIN
        BEGIN TRY
	        update tblBOMTransferMaster set
		        ixFinishedSKU = @ixFinishedSKU,
		        iQuantity = @iQuantity,
		        iCompletedQuantity = @iCompletedQuantity,
		        flgReverseBOM = @flgReverseBOM,
		        ixCreateDate = @ixCreateDate,
		        ixDueDate = @ixDueDate,
		        dtCanceledDate = @dtCanceledDate,
		        flgClosed = @flgClosed,
		        iOpenQuantity = @iOpenQuantity,
		        iReleasedQuantity = @iReleasedQuantity,
		        dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())),
		        ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
		        ixCreator = @ixCreator,
		        ixStartDate = @ixStartDate,
		        ixPrintedDate = @ixPrintedDate,
                ixLocation = @ixLocation
		        where ixTransferNumber = @ixTransferNumber
	    END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixTransferNumber'       ,@Value1=@ixTransferNumber, 
                @Field2='ixFinishedSKU'         ,@Value2=@ixFinishedSKU,
                @Field3='iQuantity' ,@Value3=@iQuantity,
                @Field4='iCompletedQuantity'   ,@Value4=@iCompletedQuantity, 
                @Field5='ixLocation' ,@Value5=@ixLocation    	
	    END CATCH
    END
ELSE
	BEGIN
	    BEGIN TRY
		    insert
			    tblBOMTransferMaster (ixTransferNumber, ixFinishedSKU, iQuantity, iCompletedQuantity, 
			    flgReverseBOM, ixCreateDate, ixDueDate, dtCanceledDate, flgClosed, iOpenQuantity, iReleasedQuantity,
			    dtDateLastSOPUpdate, ixTimeLastSOPUpdate,
			    ixCreator, ixStartDate, ixPrintedDate, ixLocation)
		    values
			    (@ixTransferNumber, @ixFinishedSKU, @iQuantity, @iCompletedQuantity, 
			     @flgReverseBOM, @ixCreateDate, @ixDueDate, @dtCanceledDate, @flgClosed, @iOpenQuantity, @iReleasedQuantity,
			     DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())), dbo.GetCurrentixTime(),
			     @ixCreator, @ixStartDate, @ixPrintedDate, @ixLocation
			     )
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixTransferNumber'       ,@Value1=@ixTransferNumber, 
                @Field2='ixFinishedSKU'         ,@Value2=@ixFinishedSKU,
                @Field3='iQuantity' ,@Value3=@iQuantity,
                @Field4='iCompletedQuantity'   ,@Value4=@iCompletedQuantity, 
                @Field5='ixLocation' ,@Value5=@ixLocation    	
	    END CATCH			     
	END





/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/


    --SMI TEST DATA
        SELECT ixTransferNumber, ixLocation,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblBOMTransferMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixTransferNumber in ('152637-1','8789-1')
        ORDER BY dtDateLastSOPUpdate, T.chTime

        SELECT ixTransferNumber, ixLocation,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblBOMTransferMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixTransferNumber is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime
                    
    --AFCO TEST DATA
        SELECT ixTransferNumber, ixLocation,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblBOMTransferMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixTransferNumber in ('12267-1','314137-1')
        ORDER BY dtDateLastSOPUpdate, T.chTime

        SELECT ixTransferNumber, ixLocation,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblBOMTransferMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixTransferNumber is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime


/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/
                                                                                                        
        SELECT ixCreditMemo, ixSKU, ixLocation,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblBOMTransferMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixLocation is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime

        SELECT ixCreditMemo, ixLocation, ixSKU,  FORMAT(count(*),'###,###') 'SKUCnt'
        FROM tblBOMTransferMaster
        WHERE ixLocation is NOT NULL
        GROUP BY ixLocation
        ORDER BY ixLocation
        /*
        PCQ SKUCnt
        A	4
        B	2
        C	20
        */



       /*********   AFCO TEST DATA  *********/
        SELECT ixCreditMemo, ixSKU, ixLocation,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblBOMTransferMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixLocation is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime



/*************************************************************************************************************/
/******    STEP 17) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES



/*************************************************************************************************************/
/******    18) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************
    STEP 19) RE-ENABLE SSA job "JobAwsImportData"                       ON dw.speedway2.com                 
    STEP 20) Verify SMI Reporting updates are making their way to AWS   ON dw.speedway2.com                 */


/*************************************************************************************************************/
/******    STEP 21)	final check on SMI Reporting to make sure no error codes are tripping              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/ 

    -- ERROR CODE to check on
    select * from tblErrorCode where sDescription like '%tblBOMTransferMaster%'
    --  1142	Failure to update tblBOMTransferMaster

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1142'
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-09-20	1082
    SMI Reporting	10-08-19	2009

*/



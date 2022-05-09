-- SMIHD-18892 - add iDCMinQty and iDCMaxQty fields to tblSKULocation

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 103

/*  TABLE: tblSKULocation
    CHANGES TO BE MADE: add 4 SDS fields to tblSKULocation
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
/******   STEP 2) DISABLE SSA job "JobAwsImportData"   ON    [dw.speedway2.com].SMiReportingRawData    *******/


/*************************************************************************************************************/
/******    STEP 3) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblSKULocation_20201009 from [SMI Reporting].dbo.tblSKULocation      --   1,980,204
select * into [SMIArchive].dbo.BU_AFCO_tblSKULocation_20201009 from [AFCOReporting].dbo.tblSKULocation --      76,757

-- DROP TABLE [SMIArchive].dbo.BU_tblSKULocation_20200207
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblSKULocation_20200207


/******    Copy & Paste detailed code at end of script to a session ON [dw.speedway2.com].SMiReportingRawData
    STEP 2) DISABLE SSA job "JobAwsImportData"                           ON dw.speedway2.com
    STEP 4) Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com
    STEP 5) Add to/Alter corresponding table in SMiReportingRawData      ON dw.speedway2.com
    STEP 6) Rebuild any affected indexes in in SMiReportingRawData       ON dw.speedway2.com                
    STEP 19) RE-ENABLE SSA job "JobAwsImportData"
    STEP 20) VERIFY updates in SMI Reporting are making their way to corresponding AWS tables
    */


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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblSKULocation ADD
    iDCMinQty int ,
    iDCMaxQty int
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblSKULocation SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE [SMI Reporting].dbo.tblSKULocation ADD
        iDCMinQty int ,
        iDCMaxQty int
GO
ALTER TABLE [SMI Reporting].dbo.tblSKULocation SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

-- SELECT TOP 1 * FROM dbo.tblSKULocationLocation

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
ALTER TABLE [AFCOReporting].dbo.tblSKULocation ADD
    iDCMinQty int ,
    iDCMaxQty int
GO
ALTER TABLE [AFCOReporting].dbo.tblSKULocation SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateSKULocation]    Script Date: 10/8/2020 4:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateSKULocation]
	@ixSKU varchar(30),
	@ixLocation tinyint,
	@iQOS int,
	@iQAV int,
	@iQC int,
	@iQCB int,
	@iQCBOM int,
	@iQCXFER int,
	@iPickingBinMin int,
	@iPickingBinMax int,
	@iCartonQuantity int,
	@sPickingBin varchar(25),
    @iDCMinQty int ,
    @iDCMaxQty int
AS

SET DEADLOCK_PRIORITY LOW -- switched to low 7-10-17 to see if it will  help with that Tableau refresh transaction deadlock errors

if exists (select * from tblSKULocation where ixSKU = @ixSKU and ixLocation = @ixLocation)
    BEGIN
                --EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
                --@Field1='ixSKU',        @Value1=@ixSKU, 
                --@Field2='ixLocation',   @Value2=@ixLocation,
                --@Field3='iQOS',         @Value3=@iQOS,
                --@Field4='iQAV',         @Value4=@iQAV, 
                --@Field5='TEST',         @Value5='PROC CALLED - update'
	BEGIN try
	-- added to prevent extra result sets from interfering with SELECT statements.
	-- SET NOCOUNT ON; -- REMOVED 8-6-14....     added 6-30-14 by PJC to see if there was any impact on SOP feed performance
	update tblSKULocation set
		iQOS = @iQOS,
		iQAV = @iQAV,
		iQC = @iQC,
		iQCB = @iQCB,
		iQCBOM = @iQCBOM,
		iQCXFER = @iQCXFER,
		iPickingBinMax = @iPickingBinMax,
		iPickingBinMin = @iPickingBinMin,
		iCartonQuantity = @iCartonQuantity,
		sPickingBin = @sPickingBin,
		dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())),
		ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
		dtStockedOut = (CASE WHEN iQAV > 0 and @iQAV <=0 THEN GETDATE()
		                     WHEN iQAV <= 0 and @iQAV <=0 THEN dtStockedOut -- leaves the orig date if QAV is still <= 0
		                ELSE NULL
		                END),
        iDCMinQty = @iDCMinQty,
        iDCMaxQty = @iDCMaxQty                        	
                        		
		where ixSKU = @ixSKU and ixLocation = @ixLocation
	end try
	 BEGIN CATCH
                EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
                @Field1='ixSKU',        @Value1=@ixSKU, 
                @Field2='ixLocation',   @Value2=@ixLocation,
                @Field3='iQOS',         @Value3=@iQOS,
                @Field4='iDCMinQty',    @Value4=@iDCMinQty, 
                @Field5='iDCMaxQty',    @Value5=@iDCMaxQty
        END CATCH
END
else
    begin       
                --    EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
                --@Field1='ixSKU',        @Value1=@ixSKU, 
                --@Field2='ixLocation',   @Value2=@ixLocation,
                --@Field3='iQOS',         @Value3=@iQOS,
                --@Field4='iQAV',         @Value4=@iQAV, 
                --@Field5='TEST',         @Value5='PROC CALLED - insert'
		    begin try
		    insert 
			    tblSKULocation (ixSKU, ixLocation, iQOS, iQAV, iQC, iQCB, iQCBOM, iQCXFER,iPickingBinMax, iPickingBinMin, iCartonQuantity, sPickingBin,
			                    dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
			                    dtStockedOut,iDCMinQty,iDCMaxQty)
		    values
			    (@ixSKU, @ixLocation, @iQOS, @iQAV, @iQC, @iQCB, @iQCBOM, @iQCXFER,@iPickingBinMax, @iPickingBinMin, @iCartonQuantity, @sPickingBin,
			      DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())), dbo.GetCurrentixTime(), 
			      NULL, @iDCMinQty, @iDCMaxQty) 	
		    end TRY 
	        BEGIN CATCH
                    EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
                    @Field1='ixSKU',        @Value1=@ixSKU, 
                    @Field2='ixLocation',   @Value2=@ixLocation,
                    @Field3='iQOS',         @Value3=@iQOS,
                    @Field4='iDCMinQty',    @Value4=@iDCMinQty, 
                    @Field5='iDCMaxQty',    @Value5=@iDCMaxQty
            END CATCH
	    end





USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKULocation]    Script Date: 10/8/2020 4:39:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateSKULocation]
	@ixSKU varchar(30),
	@ixLocation tinyint,
	@iQOS int,
	@iQAV int,
	@iQC int,
	@iQCB int,
	@iQCBOM int,
	@iQCXFER int,
	@iPickingBinMin int,
	@iPickingBinMax int,
	@iCartonQuantity int,
	@sPickingBin varchar(25),
    @iDCMinQty int ,
    @iDCMaxQty int
AS
if exists (select * from tblSKULocation where ixSKU = @ixSKU and ixLocation = @ixLocation)
    BEGIN
                --EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
                --@Field1='ixSKU',        @Value1=@ixSKU, 
                --@Field2='ixLocation',   @Value2=@ixLocation,
                --@Field3='iQOS',         @Value3=@iQOS,
                --@Field4='iQAV',         @Value4=@iQAV, 
                --@Field5='TEST',         @Value5='PROC CALLED - update'
	BEGIN try
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	update tblSKULocation set
		iQOS = @iQOS,
		iQAV = @iQAV,
		iQC = @iQC,
		iQCB = @iQCB,
		iQCBOM = @iQCBOM,
		iQCXFER = @iQCXFER,
		iPickingBinMax = @iPickingBinMax,
		iPickingBinMin = @iPickingBinMin,
		iCartonQuantity = @iCartonQuantity,
		sPickingBin = @sPickingBin,
		dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())),
		ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
        iDCMinQty = @iDCMinQty,
        iDCMaxQty = @iDCMaxQty        		
		where ixSKU = @ixSKU and ixLocation = @ixLocation
	
    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	end try
	 BEGIN CATCH
            EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
            @Field1='ixSKU',        @Value1=@ixSKU, 
            @Field2='ixLocation',   @Value2=@ixLocation,
            @Field3='iQOS',         @Value3=@iQOS,
            @Field4='iDCMinQty',    @Value4=@iDCMinQty, 
            @Field5='iDCMaxQty',    @Value5=@iDCMaxQty
        END CATCH
END
else
    begin
                --    EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
                --@Field1='ixSKU',        @Value1=@ixSKU, 
                --@Field2='ixLocation',   @Value2=@ixLocation,
                --@Field3='iQOS',         @Value3=@iQOS,
                --@Field4='iQAV',         @Value4=@iQAV, 
                --@Field5='TEST',         @Value5='PROC CALLED - insert'
		    begin try
		    insert 
			    tblSKULocation (ixSKU, ixLocation, iQOS, iQAV, iQC, iQCB, iQCBOM, iQCXFER,iPickingBinMax, iPickingBinMin, iCartonQuantity, sPickingBin,
			                    dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
                                iDCMinQty, iDCMaxQty) 
		    values
			    (@ixSKU, @ixLocation, @iQOS, @iQAV, @iQC, @iQCB, @iQCBOM, @iQCXFER,@iPickingBinMax, @iPickingBinMin, @iCartonQuantity, @sPickingBin,
			      DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())), dbo.GetCurrentixTime(),
                  @iDCMinQty, @iDCMaxQty)
		    end TRY 
	        BEGIN CATCH
                EXEC Log_ProcedureCall  @ObjectID = @@PROCID, 
                @Field1='ixSKU',        @Value1=@ixSKU, 
                @Field2='ixLocation',   @Value2=@ixLocation,
                @Field3='iQOS',         @Value3=@iQOS,
                @Field4='iDCMinQty',    @Value4=@iDCMinQty, 
                @Field5='iDCMaxQty',    @Value5=@iDCMaxQty
            END CATCH
	    end





/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

FEEDS WERE LIVE 8:13-8:15 THERE WERE ISSUES AND THEY WERE PAUSED AGAIN
REFEED ANY SKUS WITH TRANSACTIONS DURING THAT TIME LATEER.

select distinct ixSKU from tblSKUTransaction
where ixDate = 19276
and ixTime between 29220 and 29820 -- 8:07 to 8:17

select * from tblTime where chTime = '08:17:00'
select top 10 * from tblSKUTransaction

    --SMI TEST DATA
        SELECT ixSKU, ixLocation, iDCMinQty, iDCMaxQty,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblSKULocation S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixSKU  in ('91029012.P')
        ORDER BY dtDateLastSOPUpdate, T.chTime

    --AFCO TEST DATA
        SELECT ixSKU, ixLocation, iDCMinQty, iDCMaxQty,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblSKULocation S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixSKU  in ('9101021')
        ORDER BY dtDateLastSOPUpdate, T.chTime


/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT ixSKU, ixLocation, iDCMinQty, iDCMaxQty,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblSKULocation S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE iDCMinQty is NOT NULL
            OR iDCMaxQty is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime


       /*********   AFCO TEST DATA  *********/
        SELECT ixSKU, ixLocation, iDCMinQty, iDCMaxQty,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblSKULocation S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE iDCMinQty is NOT NULL
            OR iDCMaxQty is NOT NULL
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
    select * from tblErrorCode where sDescription like '%tblSKULocation%'
    --  1126	Failure to update tblSKULocation	SQLDB

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1126'
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-09-20	1082
    SMI Reporting	10-08-19	2009

*/



SELECT ixSKU, mPriceLevel1,
    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
    T.chTime 'SOPFeedTime'
FROM tblSKU S
    left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
WHERE ixSKU  in ('91002003')
ORDER BY dtDateLastSOPUpdate, T.chTime

-- SMIHD-21426 - add mMarketplaceSellingFee to tblCreditMemoMaster

SELECT @@SPID as 'Current SPID' -- 156

/*  TABLE: tblCreditMemoMaster
    CHANGES TO BE MADE: add mMarketplaceSellingFee field to tblCreditMemoMaster
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

select * into [SMIArchive].dbo.BU_tblCreditMemoMaster_20210615 from [SMI Reporting].dbo.tblCreditMemoMaster      --   647,628
select * into [SMIArchive].dbo.BU_AFCO_tblCreditMemoMaster_20210615 from [AFCOReporting].dbo.tblCreditMemoMaster --    26,588

-- DROP TABLE [SMIArchive].dbo.BU_tblCreditMemoMaster_20200714
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblCreditMemoMaster_20200714


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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblCreditMemoMaster ADD
    mMarketplaceSellingFee money
GO  
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE [SMI Reporting].dbo.tblCreditMemoMaster ADD
    mMarketplaceSellingFee money
GO
ALTER TABLE [SMI Reporting].dbo.tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN


-- SELECT TOP 1 * FROM dbo.tblCreditMemoMasterLocation

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
ALTER TABLE [AFCOReporting].dbo.tblCreditMemoMaster ADD
    mMarketplaceSellingFee money
GO
ALTER TABLE [AFCOReporting].dbo.tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateCreditMemo]    Script Date: 6/15/2021 8:30:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateCreditMemo]
	@ixCreditMemo varchar(10),
	@ixCustomer varchar(10),
	@ixOrder varchar(10),
	@ixCreateDate smallint,
	@sOrderChannel varchar(10),
	@mMerchandise smallmoney,
	@sMemoType varchar(10),
	@dtCreateDate varchar(8),
	@mMerchandiseCost varchar(10),
	@ixOrderTaker varchar(10),
	@mShipping money,
	@mTax money,
	@mRestockFee money,
	@flgCanceled tinyint,
	@sMethodOfPayment varchar(15),
	@sMemoTransactionType varchar(15),
    @sBusinessUnit varchar(12),
    @flgCounter tinyint,
    @mMerchandiseReturnedCost money,
    @mMarketplaceSellingFee money
AS
if exists (select * from tblCreditMemoMaster where ixCreditMemo = @ixCreditMemo)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	update tblCreditMemoMaster set
		ixCustomer = @ixCustomer,
		ixOrder = @ixOrder,
		ixCreateDate = @ixCreateDate,
		sOrderChannel = @sOrderChannel,
		mMerchandise = @mMerchandise,
		sMemoType = @sMemoType,
		dtCreateDate = @dtCreateDate,
		mMerchandiseCost = @mMerchandiseCost,
		ixOrderTaker = @ixOrderTaker,
		mShipping = @mShipping,
		mTax = @mTax,
		mRestockFee = @mRestockFee,
		flgCanceled = @flgCanceled,
		sMethodOfPayment = @sMethodOfPayment,
		dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),
		ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
		sMemoTransactionType = @sMemoTransactionType,
        ixBusinessUnit = (CASE WHEN @sBusinessUnit IS NULL THEN NULL
                                 ELSE COALESCE((Select ixBusinessUnit
                                                From tblBusinessUnit
                                                where sBusinessUnit = @sBusinessUnit)
                                          ,112)
                                 END),
        flgCounter = @flgCounter,
        mMerchandiseReturnedCost = @mMerchandiseReturnedCost,
        mMarketplaceSellingFee = @mMarketplaceSellingFee
		where ixCreditMemo = @ixCreditMemo
	
    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END
else
	begin
		    insert 
			    tblCreditMemoMaster (ixCreditMemo, ixCustomer, ixOrder, ixCreateDate, sOrderChannel, mMerchandise, sMemoType, dtCreateDate, 
			                         mMerchandiseCost, ixOrderTaker, mShipping, mTax, mRestockFee, flgCanceled, sMethodOfPayment,
			                         dtDateLastSOPUpdate, ixTimeLastSOPUpdate, sMemoTransactionType,
                                     ixBusinessUnit, flgCounter, mMerchandiseReturnedCost, mMarketplaceSellingFee)
		    values
			    (@ixCreditMemo, @ixCustomer, @ixOrder, @ixCreateDate, @sOrderChannel, @mMerchandise, @sMemoType, @dtCreateDate, @mMerchandiseCost, 
			     @ixOrderTaker, @mShipping, @mTax, @mRestockFee, @flgCanceled, @sMethodOfPayment, DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), 
			     dbo.GetCurrentixTime(), @sMemoTransactionType,
                 COALESCE((Select ixBusinessUnit From tblBusinessUnit where sBusinessUnit = @sBusinessUnit),112),
			     @flgCounter, @mMerchandiseReturnedCost, @mMarketplaceSellingFee)

    END








USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateCreditMemo]    Script Date: 6/15/2021 8:33:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateCreditMemo]
	@ixCreditMemo varchar(10),
	@ixCustomer varchar(10),
	@ixOrder varchar(10),
	@ixCreateDate smallint,
	@sOrderChannel varchar(10),
	@mMerchandise smallmoney,
	@sMemoType varchar(10),
	@dtCreateDate varchar(8),
	@mMerchandiseCost varchar(10),
	@ixOrderTaker varchar(10),
	@mShipping money,
	@mTax money,
	@mRestockFee money,
	@flgCanceled tinyint,
	@sMethodOfPayment varchar(15),
	@sMemoTransactionType varchar(15),
    @sBusinessUnit varchar(12),
    @flgCounter tinyint,
    @mMerchandiseReturnedCost money,
    @mMarketplaceSellingFee money
AS
if exists (select * from tblCreditMemoMaster where ixCreditMemo = @ixCreditMemo)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	update tblCreditMemoMaster set
		ixCustomer = @ixCustomer,
		ixOrder = @ixOrder,
		ixCreateDate = @ixCreateDate,
		sOrderChannel = @sOrderChannel,
		mMerchandise = @mMerchandise,
		sMemoType = @sMemoType,
		dtCreateDate = @dtCreateDate,
		mMerchandiseCost = @mMerchandiseCost,
		ixOrderTaker = @ixOrderTaker,
		mShipping = @mShipping,
		mTax = @mTax,
		mRestockFee = @mRestockFee,
		flgCanceled = @flgCanceled,
		sMethodOfPayment = @sMethodOfPayment,
		dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),
		ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
		sMemoTransactionType = @sMemoTransactionType,
        ixBusinessUnit = (CASE WHEN @sBusinessUnit IS NULL THEN NULL
                                 ELSE COALESCE((Select ixBusinessUnit
                                                From tblBusinessUnit
                                                where sBusinessUnit = @sBusinessUnit)
                                          ,112)
                                 END),
        flgCounter = @flgCounter,
        mMerchandiseReturnedCost = @mMerchandiseReturnedCost,
        mMarketplaceSellingFee = @mMarketplaceSellingFee
		where ixCreditMemo = @ixCreditMemo
	
    -- Insert statements for procedure here
END
else
	begin
		insert 
			tblCreditMemoMaster (ixCreditMemo, ixCustomer, ixOrder, ixCreateDate, sOrderChannel, mMerchandise, sMemoType, dtCreateDate, 
			                     mMerchandiseCost, ixOrderTaker, mShipping, mTax, mRestockFee, flgCanceled, sMethodOfPayment,
			                     dtDateLastSOPUpdate, ixTimeLastSOPUpdate, sMemoTransactionType,
                                 ixBusinessUnit, flgCounter, mMerchandiseReturnedCost, mMarketplaceSellingFee)
		values
			(@ixCreditMemo, @ixCustomer, @ixOrder, @ixCreateDate, @sOrderChannel, @mMerchandise, @sMemoType, @dtCreateDate, @mMerchandiseCost, 
			 @ixOrderTaker, @mShipping, @mTax, @mRestockFee, @flgCanceled, @sMethodOfPayment, DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), 
			 dbo.GetCurrentixTime(), @sMemoTransactionType,
             COALESCE((Select ixBusinessUnit From tblBusinessUnit where sBusinessUnit = @sBusinessUnit),112),
			 @flgCounter, @mMerchandiseReturnedCost, @mMarketplaceSellingFee)
	end






/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/


    --SMI TEST DATA
        SELECT ixCreditMemo, mMarketplaceSellingFee, 
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblCreditMemoMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixCreditMemo in ('C-602976','C-743053') -- C-602976 (27.37) & C-743053 (17.78) for SMI.
        ORDER BY dtDateLastSOPUpdate, T.chTime
/*
ixCreditMemo	mMarketplaceSellingFee	SOPFeedDate	SOPFeedTime
C-602976	    NULL	                2021.01.21	13:58:57  
C-743053	    NULL	                2021.01.22	14:56:25  
*/
            
    --AFCO TEST DATA
        SELECT ixCreditMemo, mMarketplaceSellingFee, 
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblCreditMemoMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixCreditMemo in ('C-26650','F-5429') -- C-26650 (0) and F-5429 (0) for AFCO.
        ORDER BY dtDateLastSOPUpdate, T.chTime
/*
ixCreditMemo	mMarketplaceSellingFee	SOPFeedDate	SOPFeedTime
F-5429	        NULL	                2019.10.16	09:39:43  
C-26650	        NULL	                2020.12.29	07:50:19  
*/


/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP          
                                                                               *******/
        SELECT ixCreditMemo, mMarketplaceSellingFee, 
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblCreditMemoMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE mMarketplaceSellingFee is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime


       /*********   AFCO TEST DATA  *********/
        SELECT ixCreditMemo, mMarketplaceSellingFee, 
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblCreditMemoMaster S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE mMarketplaceSellingFee is NOT NULL
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
    select * from tblErrorCode where sDescription like '%tblCreditMemoMaster%'
    --  1147	Failure to update tblCreditMemoMaster

    -- ERROR CODE feeds are DELAYED by at least 30 mins
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1147'
      and dtDate >=  DATEADD(month, -100, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	10-22-19	4
    SMI Reporting	10-21-19	1
    SMI Reporting	04-12-19	161

*/


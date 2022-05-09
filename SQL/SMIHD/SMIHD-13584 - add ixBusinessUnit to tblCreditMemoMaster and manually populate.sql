-- SMIHD-13584 - add ixBusinessUnit to tblCreditMemoMaster and manually populate

-- RENAME THIS TEMPLATE using the appropriate Jira Case #

-- SELECT @@SPID as 'Current SPID' -- 94

/* CHANGES TO BE MADE

   add the following field to tblCreditMemoMaster
    sBusinessUnit - varchar(12) - (NULL allowed)
    
   ALLOWED VALUES:
    
*/

/* steps as of 9-18-2018

STEP    WHERE	        ACTION
=== ===============     =======================================================
1   LNK-SQL-LIVE-1      Back-up tables to be modified to SMIArchive
2	LNK-SQL-LIVE-1	    DISABLE SSA job "SMIJob_AwsExportData"
3	dw.speedway2.com	Script & drop any affected indexes in in SMiReportingRawData
4	dw.speedway2.com	Add/Alter the column in the corresponding table in SMiReportingRawData (Schema is Transfer)
5	dw.speedway2.com	Rebuild any affected indexes in in SMiReportingRawData
6	LNK-SQL-LIVE-1	    Script & drop any affected indexes in ChangeLog_smiReporting
7	LNK-SQL-LIVE-1	    Add the column to the corresponding table in ChangeLog_smiReporting (Schema is dbo)
8	LNK-SQL-LIVE-1	    Rebuild any affected indexes in ChangeLog_smiReporting
9	SOP	                PAUSE feeds to SMI/AFCO Reporting
10	LNK-SQL-LIVE-1	    Script & drop any affected indexes in SMI/AFCO Reporting
11	LNK-SQL-LIVE-1	    Add/Alter the column in the corresponding table in SMI/AFCO Reporting  (Schema is dbo)
12	LNK-SQL-LIVE-1	    Rebuild any affected indexes in SMI/AFCO Reporting
13	LNK-SQL-LIVE-1	    apply script changes to the appropriate stored procedure(s) (usually spUpdate<tablename>)
14	SOP	                RESUME feeds to SMI/AFCO Reporting
15	SOP	                manually push records to test feeds
16	LNK-SQL-LIVE-1	    verify records pushed updated as expected in SMI/AFCO Reporting 
17	LNK-SQL-LIVE-1	    RE-ENABLE SSA job "SMIJob_AwsExportData"
18	dw.speedway2.com	verify updates in SMI Reporting are making their way to corresponding AWS tables
*/

/*************************************************************************************************************/
/******    STEP 1) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblCreditMemoMaster_20190411 from [SMI Reporting].dbo.tblCreditMemoMaster      --   616,437
select * into [SMIArchive].dbo.BU_AFCO_tblCreditMemoMaster_20190411 from [AFCOReporting].dbo.tblCreditMemoMaster --    24,140



/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0


/*************************************************************************************************************/
/******    STEP 3) DISABLE SSA job "JobAwsImportData"                                                  *******/
/******    dw.speedway2.com                                                                            *******/
    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 0


/*************************************************************************************************************/
/******    STEP 4)	Script & drop any affected indexes in in SMiReportingRawData                       *******/
/******    dw.speedway2.com                                                                            *******/

            N/A



/*************************************************************************************************************/
/******    STEP 5) Add the column to the corresponding table in SMiReportingRawData                    *******/
/******           (Schema is Transfer)                                                                 *******/
/******    dw.speedway2.com                                                                            *******/

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
ALTER TABLE [SMiReportingRawData].[Transfer].tblCreditMemoMaster ADD
	ixBusinessUnit int NULL
GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/*************************************************************************************************************/
/******    STEP 6) Rebuild any affected indexes in in SMiReportingRawData                              *******/
/******    dw.speedway2.com                                                                            *******/

            N/A




/*************************************************************************************************************/
/******    STEP 7)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 8)	Add the column to the corresponding table in ChangeLog_smiReportingRawData         *******/
/******            (Schema is dbo)                                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/


BEGIN TRANSACTION
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
	ixBusinessUnit int NULL
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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCreditMemoMaster ADD
	ixBusinessUnit int NULL
GO
ALTER TABLE dbo.tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- ROLLBACK TRAN

-- SELECT TOP 1 * FROM dbo.tblCreditMemoMaster

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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCreditMemoMaster ADD
	ixBusinessUnit int NULL
GO
ALTER TABLE dbo.tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateCreditMemo]    Script Date: 5/20/2019 11:33:44 AM ******/
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
    @sBusinessUnit varchar(12)
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
                                 END)
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
                                 ixBusinessUnit)
		values
			(@ixCreditMemo, @ixCustomer, @ixOrder, @ixCreateDate, @sOrderChannel, @mMerchandise, @sMemoType, @dtCreateDate, @mMerchandiseCost, 
			 @ixOrderTaker, @mShipping, @mTax, @mRestockFee, @flgCanceled, @sMethodOfPayment, DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), 
			 dbo.GetCurrentixTime(), @sMemoTransactionType,
             COALESCE((Select ixBusinessUnit From tblBusinessUnit where sBusinessUnit = @sBusinessUnit),112)
			 )
	end







USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateCreditMemo]    Script Date: 5/20/2019 11:37:42 AM ******/
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
    @sBusinessunit varchar(12)
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
                                 END)
		where ixCreditMemo = @ixCreditMemo
END
else
	begin
		insert 
			tblCreditMemoMaster (ixCreditMemo, ixCustomer, ixOrder, ixCreateDate, sOrderChannel, mMerchandise, sMemoType, dtCreateDate, 
			                     mMerchandiseCost, ixOrderTaker, mShipping, mTax, mRestockFee, flgCanceled, sMethodOfPayment, dtDateLastSOPUpdate,
			                     ixTimeLastSOPUpdate, sMemoTransactionType, ixBusinessUnit)
		values
			(@ixCreditMemo, @ixCustomer, @ixOrder, @ixCreateDate, @sOrderChannel, @mMerchandise, @sMemoType, @dtCreateDate, @mMerchandiseCost, 
			 @ixOrderTaker, @mShipping, @mTax, @mRestockFee, @flgCanceled, @sMethodOfPayment, DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),
			 dbo.GetCurrentixTime(), @sMemoTransactionType,
             COALESCE((Select ixBusinessUnit From tblBusinessUnit where sBusinessUnit = @sBusinessUnit),112)
			 )
	end





/*************************************************************************************************************/
/******    STEP 15) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES


/*************************************************************************************************************/
/******    STEP 16) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT * from tblCreditMemoMaster where ixBusinessUnit is NOT NULL
        
        SELECT ixOrder, ixBusinessUnit
        FROM tblCreditMemoMaster 
        WHERE ixBusinessUnit is NOT null
        --and len(ixInvoiceDate) < 4
        order by ixBusinessUnit  --newid()


        SELECT  ixOrder, ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblCreditMemoMaster
        WHERE ixOrder in ('8774142','8145752')
        order by ixOrder  --newid()
        /*
        ixOrder	ixBusinessUnit	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
        8145752	NULL	2019-04-11 00:00:00.000	37510
        8774142	112	    2019-04-11 00:00:00.000	38207
*/
        SELECT * FROM tblTime where ixTime = 38131 -- 10:25:10  

        SELECT top 10 ixOrder, ixBusinessUnit
        FROM tblCreditMemoMaster 
        WHERE ixInvoiceDate is NOT null
        --and len(ixInvoiceDate) < 4
        order by newid()

         

    --AFCO TEST DATA
        SELECT ixOrder, ixBusinessUnit
        FROM tblCreditMemoMaster 
        WHERE ixInvoiceDate is NOT null
        --and len(ixInvoiceDate) < 4
        order by ixBusinessUnit  --newid()


        SELECT  ixOrder, ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblCreditMemoMaster
        WHERE ixOrder in ('860112','859106')
        order by ixOrder  --newid()

        SELECT  ixOrder, ixBusinessUnit
        FROM tblCreditMemoMaster
        WHERE ixOrder in ('860112','859106')
        order by ixOrder  --newid()


        select * from tblBusinessUnit



/*************************************************************************************************************/
/******    STEP 17) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        -- get test records                                                                     
        SELECT top 10 ixCreditMemo, ixOrder, ixBusinessUnit,  dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblCreditMemoMaster
      --  WHERE ixInvoiceDate is NOT null
        WHERE ixCreditMemo in ('F-6732','C-15645','C-3637','C-10742','C-8879','C-11205','C-10914','C-19871','F-20694','C-3914')
        ORDER BY newid()


        select chTime from tblTime where ixTime = 26959

        SELECT ixInvoiceDate

        SELECT ixBusinessUnit, count(*)
        FROM tblCreditMemoMaster
        GROUP BY ixBusinessUnit
        ORDER BY ixBusinessUnit

        SELECT *
        FROM tblCreditMemoMaster
        where ixCreditMemo in ('C-617524','C-617518')
        /*
        ixBusinessUnit	sBusinessUnit
        101	ICS
        102	INT
        103	EMP
        104	PRS
        105	MRR
        106	RETLNK
        107	WEB
        108	GS
        109	MKT
        110	PHONE
        111	RETTOL
        112	UK
        */

        SELECT dtCreateDate
        FROM tblCreditMemoMaster
        order by dtCreateDate

        SELECT TOP 



/*************************************************************************************************************/
/******    18) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************/
/******    19) RE-ENABLE SSA job "JobAwsImportData"                                                    *******/
/******    dw.speedway2.com                                                                            *******/
    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 20)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com                                                                            *******/
                                                                         

    -- -- Check the state of AWS feeds
    -- select top (5) * from tblAwsBatch order by 1 desc
    -- select top 5 * from tblAwsQueue order by 1 desc
    select 'UnprocessedOnDestination',* 
    from [DW.SPEEDWAY2.com].SMIReportingRawData.dbo.[tblAwsBulkTransferData]   btd 
    where dtEndProcessTimeUtc is null;

                                                                            
        SELECT ixBusinessUnit, count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblCreditMemoMaster
        where ixBusinessUnit is NOT NULL
        GROUP BY ixBusinessUnit

        
        SELECT top 10 ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblCreditMemoMaster
        order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

        SELECT count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblCreditMemoMaster
        where ixBusinessUnit is NOT NULL

      

        SELECT  ixOrder, ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblCreditMemoMaster
        WHERE ixOrder in ('8774142','8145752')
        order by ixOrder  --newid()

/*************************************************************************************************************/
/******    STEP 21)	final check on SMI Reporting to make sure no error codes are tripping              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/ 

    -- ERROR CODE to check on
    select * from tblErrorCode where sDescription like '%tblCreditMemoMaster%'
    --  1147	Failure to update tblCreditMemoMaster

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1147'
      and dtDate >=  DATEADD(month, -2, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	04-12-19	161
    SMI Reporting	04-11-19	240



    
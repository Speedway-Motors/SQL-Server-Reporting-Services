-- SMIHD-15290 and SMIHD-15395 - add flgCounter and mMerchandiseReturnedCost to tblCreditMemoMaster

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 76

/*  TABLE: tblCreditMemoMaster
    CHANGES TO BE MADE: add flgCounter tinying (NULL ALLOWED)
                            mMerchandiseReturnedCost 

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

select * into [SMIArchive].dbo.BU_tblCreditMemoMaster_20191014 from [SMI Reporting].dbo.tblCreditMemoMaster      --    640,020
select * into [SMIArchive].dbo.BU_AFCO_tblCreditMemoMaster_20191014 from [AFCOReporting].dbo.tblCreditMemoMaster --     25,413

-- DROP TABLE [SMIArchive].dbo.BU_tblCreditMemoMaster_20190920
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblCreditMemoMaster_20190920


/******    Copy & Paste detailed code at end of script to a session ON [dw.speedway2.com].SMiReportingRawData
    STEP 2) DISABLE SSA job "JobAwsImportData"                           ON dw.speedway2.com
    STEP 4) Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com
    STEP 5) Add to/Alter corresponding table in SMiReportingRawData      ON dw.speedway2.com
    STEP 6) Rebuild any affected indexes in in SMiReportingRawData       ON dw.speedway2.com                */


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
    flgCounter tinyint NULL,
    mMerchandiseReturnedCost money

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
    flgCounter tinyint NULL,
    mMerchandiseReturnedCost money
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
ALTER TABLE [AFCOReporting].dbo.tblCreditMemoMaster ADD
    flgCounter tinyint NULL,
    mMerchandiseReturnedCost money
GO
ALTER TABLE[AFCOReporting].dbo.tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateCreditMemo]    Script Date: 10/14/2019 10:52:01 AM ******/
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
    @mMerchandiseReturnedCost money
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
        mMerchandiseReturnedCost = @mMerchandiseReturnedCost
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
                                 ixBusinessUnit, flgCounter, mMerchandiseReturnedCost)
		values
			(@ixCreditMemo, @ixCustomer, @ixOrder, @ixCreateDate, @sOrderChannel, @mMerchandise, @sMemoType, @dtCreateDate, @mMerchandiseCost, 
			 @ixOrderTaker, @mShipping, @mTax, @mRestockFee, @flgCanceled, @sMethodOfPayment, DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), 
			 dbo.GetCurrentixTime(), @sMemoTransactionType,
             COALESCE((Select ixBusinessUnit From tblBusinessUnit where sBusinessUnit = @sBusinessUnit),112),
			 @flgCounter, @mMerchandiseReturnedCost)
	end






USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateCreditMemo]    Script Date: 10/14/2019 10:52:01 AM ******/
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
    @mMerchandiseReturnedCost money
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
        mMerchandiseReturnedCost = @mMerchandiseReturnedCost
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
                                 ixBusinessUnit, flgCounter, mMerchandiseReturnedCost)
		values
			(@ixCreditMemo, @ixCustomer, @ixOrder, @ixCreateDate, @sOrderChannel, @mMerchandise, @sMemoType, @dtCreateDate, @mMerchandiseCost, 
			 @ixOrderTaker, @mShipping, @mTax, @mRestockFee, @flgCanceled, @sMethodOfPayment, DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), 
			 dbo.GetCurrentixTime(), @sMemoTransactionType,
             COALESCE((Select ixBusinessUnit From tblBusinessUnit where sBusinessUnit = @sBusinessUnit),112),
			 @flgCounter, @mMerchandiseReturnedCost)
	end





/*************************************************************************************************************/
/******    STEP 15) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES


/*************************************************************************************************************/
/******    STEP 16) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT ixCreditMemo, mMerchandiseCost , mMerchandiseReturnedCost, flgCounter,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblCreditMemoMaster 
        where mMerchandiseReturnedCost is NOT NULL
            OR flgCounter is NOT NULL
                                        
        /*
        ixCreditMemo	mMerchandiseCost	mMerchandiseReturnedCost	flgCounter	LastSOPUpdate	TimeLastSOPUpdate
        C-133657	    25.50	            34.00	                    0	        2019.10.14	51078
        */

         

    --AFCO TEST DATA
        SELECT ixCreditMemo, mMerchandiseCost , mMerchandiseReturnedCost, flgCounter,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblCreditMemoMaster 
        where mMerchandiseReturnedCost is NOT NULL
            OR flgCounter is NOT NULL



/*************************************************************************************************************/
/******    STEP 17) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        --SMI TEST DATA
        SELECT *,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblCreditMemoMaster where ixMasterOrderNumber is NOT NULL

        --AFCO TEST DATA
        SELECT ixOrder, ixPrimaryShipLocation, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblCreditMemoMaster where ixMasterOrderNumber is NOT NULL




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
    --  1141	Failure to update tblCreditMemoMaster

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1141'
      and dtDate >=  DATEADD(month, -5, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	04-12-19	161
    SMI Reporting	04-11-19	240



    select * from tblErrorCode
    order by ixErrorCode desc




/*************************************************************************************************************/
/**********************         Run all code below on DW.SPEEDWAY2.COM          ******************************/
/**********************                     steps 3-6,19,20                     ******************************/
/*************************************************************************************************************/


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
    flgCounter tinyint NULL,
    mMerchandiseReturnedCost money

GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblCreditMemoMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




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
        SELECT ixOrder, iLength, iWidth, iHeight, 
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        FROM [Transfer].tblCreditMemoMaster 
        WHERE ixOrder = '465AC4004'
        /*
                ixOrder	    iLength	iWidth	iHeight	DateLastSOPUpdate   TimeLastSOPUpdate
        BEFORE  465AC4004	13.0	7.0	    1.0	    2019.05.16          25760
        AFTER   465AC4004	13.6	7.7	    1.8	    2019.06.18	        54633
        */




*/


SELECT TOP 22052
ixCreditMemo, ixCreateDate, mMerchandiseCost , mMerchandiseReturnedCost, ixBusinessUnit, flgCounter,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
from tblCreditMemoMaster 
where  -- mMerchandiseReturnedCost is NULL -- 489,427   256k @10-18 10:00

   -- flgCounter is NULL
  --  AND  < '10/16/2019'
   ixBusinessUnit is NULL -- 428,165
order by dtDateLastSOPUpdate --dtDateLastSOPUpdate desc -- 15765-13896

SELECT ixBusinessUnit, FORMAT(count(*),'###,###') 'CMcount'
from tblCreditMemoMaster
where ixCreateDate < 17897
group by ixBusinessUnit

SELECT ixBusinessUnit, FORMAT(count(*),'###,###') 'CMcount'
from tblCreditMemoMaster
where dtDateLastSOPUpdate is NULL
group by ixBusinessUnit



SELECT D.iYear, FORMAT(count(*),'###,###') 'CMcount'
--ixCreditMemo, ixCreateDate, mMerchandiseCost , mMerchandiseReturnedCost, ixBusinessUnit, flgCounter,
--        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
from tblCreditMemoMaster CMM
    left join tblDate D on CMM.ixCreateDate = D.ixDate
where ixBusinessUnit is NULL -- 428,165
group by D.iYear
order by D.iYear desc


SELECT D.iYear,FORMAT(count(O.ixOrder),'###,###') 'Orders'
from tblOrder O
        left join tblDate D on O.ixOrderDate = D.ixDate
group by D.iYear
order by D.iYear desc

select ixOrder -- 153
from tblOrder
where ixOrderDate < 13881

BEGIN TRAN

DELeTE FROM tblOrderLine
where ixOrder in ('1','63719','63864','64823','65851','65792','67149','71205','11383','72216','7323','75020','75265','76586','79117','80545','5719','5654','5875','26826','6491','6670','7167','08264','8339','51163','1139','12258','14458','14666','17030','18889','19677','20673','20785','21161','240859','242195','246033','249734','257520','316694','327910','349436','357655-1','380884-1','445130','455839-1','497851','515896-1','537012','554597-1','596510','632594','645675-1','660038','734021-1','739505','751316','761169','805520','839271','839699','842727','850368','853226','853367','859428','859437','859441','859438','859446','859435','859450','859439','859712','864547','877888','907974','910398','911464','912022','929358','930420','931214','932152','935461','936939','942149','942521','942883','943480','943723','950053','1066057','1066144','1129815','1178924','1189037-1','1247334','1294351','1296085','1333753','1392618','1392622','1395063-1','1402941','1404537-1','1404884','1404887','1404935-1','1437394','1441133','1445152','1445792-1','1494951','1505987','1542212','1571722','1572033-2','1571883','1607970','1649517','1661224','1678266','1719958','1720413-1','1726318','1788404','1790930','1810482-1','1812523-1','1812525','1813619','1822763','1868361','1888816','1897354','1898640-1','1915800-1','1927898','1943139-1','1979591-1','2061977-1','2081024-1','2098594','2108876','2110524','2120488','2120631','2183520-1','2225586','2249239')

ROLLBACK TRAN


BEGIN TRAN

DELeTE FROM tblOrder
where ixOrder in ('1','63719','63864','64823','65851','65792','67149','71205','11383','72216','7323','75020','75265','76586','79117','80545','5719','5654','5875','26826','6491','6670','7167','08264','8339','51163','1139','12258','14458','14666','17030','18889','19677','20673','20785','21161','240859','242195','246033','249734','257520','316694','327910','349436','357655-1','380884-1','445130','455839-1','497851','515896-1','537012','554597-1','596510','632594','645675-1','660038','734021-1','739505','751316','761169','805520','839271','839699','842727','850368','853226','853367','859428','859437','859441','859438','859446','859435','859450','859439','859712','864547','877888','907974','910398','911464','912022','929358','930420','931214','932152','935461','936939','942149','942521','942883','943480','943723','950053','1066057','1066144','1129815','1178924','1189037-1','1247334','1294351','1296085','1333753','1392618','1392622','1395063-1','1402941','1404537-1','1404884','1404887','1404935-1','1437394','1441133','1445152','1445792-1','1494951','1505987','1542212','1571722','1572033-2','1571883','1607970','1649517','1661224','1678266','1719958','1720413-1','1726318','1788404','1790930','1810482-1','1812523-1','1812525','1813619','1822763','1868361','1888816','1897354','1898640-1','1915800-1','1927898','1943139-1','1979591-1','2061977-1','2081024-1','2098594','2108876','2110524','2120488','2120631','2183520-1','2225586','2249239')

ROLLBACK TRAN



SELECT CMD.* 
into [SMIArchive].dbo.tblCreditMemoDetailArchive
FROM tblCreditMemoDetail CMD
left join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
where CMM.ixCreateDate < 13881	--01/01/2006

select *
into [SMIArchive].dbo.BU_tblCreditMemoDetail20191021
from tblCreditMemoDetail

BEGIN TRAN

DELETE FROM tblCreditMemoDetail 
WHERE ixCreditMemo in (select ixCreditMemo from [SMIArchive].dbo.tblCreditMemoDetailArchive)

ROLLBACK TRAN



SELECT CMM.* 
into [SMIArchive].dbo.tblCreditMemoMasterArchive -- 142,625
FROM tblCreditMemoMaster CMM
where CMM.ixCreateDate < 13881	--01/01/2006

select *
into [SMIArchive].dbo.BU_tblCreditMemoMaster20191021
from tblCreditMemoMaster

select count(*) from [SMIArchive].dbo.tblCreditMemoMasterArchive  640949

BEGIN TRAN

DELETE FROM tblCreditMemoMaster 
WHERE ixCreditMemo in (select ixCreditMemo from [SMIArchive].dbo.tblCreditMemoMasterArchive)

ROLLBACK TRAN

order by dtDateLastSOPUpdate --dtDateLastSOPUpdate desc -- 15765-13896



select * from tblTime where ixTime =44309

select * from tblDate where ixDate = 17897 -- 12-21-17
/*
18917	10/16/2019

18629	01/01/2019

18264	01/01/2018
17899	01/01/2017
17533	01/01/2016
17168	01/01/2015

15342	01/01/2010

14227   12/13/2006

13881	01/01/2006
*/
BEGIN TRAN

UPDATE tblCreditMemoMaster
set flgCounter = 0
where flgCounter IS NULL

ROLLBACK TRAN


select iYear, ixBusinessUnit, FORMAT(count(*),'###,###') CMcount
from tblCreditMemoMaster CMM
left join tblDate D on D.ixDate = CMM.ixCreateDate
where ixBusinessUnit is not NULL
group by iYear, ixBusinessUnit
order by iYear, ixBusinessUnit


select 

flgCounter and mMerchandiseReturnedCost
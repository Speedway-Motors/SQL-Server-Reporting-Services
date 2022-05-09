-- SMIHD-13505 - add  Invoice Date field to tblOrder

-- RENAME THIS TEMPLATE using the appropriate Jira Case #

/* CHANGES TO BE MADE

   add the following field to tblOrder
    ixInvoiceDate datatype - Int (NULL allowed)
    dtInvoiceDate datatype - datetime (NULL allowed)

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

select * into [SMIArchive].dbo.BU_tblOrder_20190402 from [SMI Reporting].dbo.tblOrder      --   6,375,093
select * into [SMIArchive].dbo.BU_AFCO_tblOrder_20190502 from [AFCOReporting].dbo.tblOrder --     399,655



/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0




/*************************************************************************************************************/
/******    STEP 3)	Script & drop any affected indexes in in SMiReportingRawData                       *******/
/******    dw.speedway2.com                                                                            *******/

            N/A



/*************************************************************************************************************/
/******    STEP 4) Add the column to the corresponding table in SMiReportingRawData                    *******/
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
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder ADD
	ixInvoiceDate int NULL,
    dtInvoiceDate datetime NULL
GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/*************************************************************************************************************/
/******    STEP 5) Rebuild any affected indexes in in SMiReportingRawData                              *******/
/******    dw.speedway2.com                                                                            *******/

            N/A




/*************************************************************************************************************/
/******    STEP 6)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 7)	Add the column to the corresponding table in ChangeLog_smiReportingRawData         *******/
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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrder ADD
	ixInvoiceDate int NULL,
    dtInvoiceDate datetime NULL
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/*************************************************************************************************************/
/******    STEP 8)	Rebuild any affected indexes in ChangeLog_smiReporting                             *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A



/*************************************************************************************************************/
/******    STEP 9) PAUSE feeds to SMI/AFCO Reporting                                                   *******/
/******    SOP                                                                                         *******/



/*************************************************************************************************************/
/******    STEP 10) Script & drop any affected indexes in SMI/AFCO Reporting                            *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A




/*************************************************************************************************************/
/******    STEP 11) Add the column to the SMI/AFCO Reporting tables                                    *******/
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
ALTER TABLE dbo.tblOrder ADD
	ixInvoiceDate int NULL,
    dtInvoiceDate datetime NULL
GO
ALTER TABLE dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- ROLLBACK TRAN



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
ALTER TABLE dbo.tblOrder ADD
	ixInvoiceDate int NULL,
    dtInvoiceDate datetime NULL
GO
ALTER TABLE dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





/*************************************************************************************************************/
/******    STEP 12) Rebuild any affected indexes in SMI/AFCO Reporting                                 *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A




/*************************************************************************************************************/
/******    STEP 13) apply script changes to the appropriate stored procedure(s)                        *******/
/******            (usually spUpdate<tablename>)                                                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 2/26/2019 2:55:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateOrder]
	@ixOrder varchar(10),
	@ixCustomer int,
	@ixOrderDate smallint,
	@sShipToCity varchar(25),
	@sShipToState varchar(20),
	@sShipToZip varchar(15),
	@sOrderType varchar(20),
	@sOrderChannel varchar(20),
	@sShipToCountry varchar(30),
	@ixShippedDate smallint,
	@iShipMethod smallint,
	@sSourceCodeGiven varchar(15),
	@sMatchbackSourceCode varchar(15),
	@sMethodOfPayment varchar(15),
	@sOrderTaker varchar(10),
	@sPromoApplied varchar(10),
	@mMerchandise money,
	@mShipping money,
	@mTax money,
	@mCredits money,
	@sOrderStatus varchar(15),
	@flgIsBackorder tinyint,
	@mMerchandiseCost money,
	@dtOrderDate datetime,
	@dtShippedDate datetime,
	@ixAccountManager varchar(10),
	@ixOrderTime integer,
	@mPromoDiscount money,
	@ixAuthorizationStatus varchar(15),
	@ixOrderType varchar(20), 
	@mPublishedShipping money,
	@sOptimalShipOrigination varchar(50),
	@sCanceledReason varchar(50),
	@ixCanceledBy varchar(10),
	@mAmountPaid money,
	@flgPrinted tinyint,
	@ixAuthorizationDate int,
	@ixAuthorizationTime int,
	@flgIsResidentialAddress tinyint,
	@sWebOrderID varchar(10),
	@sPhone varchar(25),
	@dtHoldUntilDate datetime,
	@flgDeviceType varchar(20),
	@sUserAgent varchar(500),
	@dtAuthorizationDate datetime,
	@sAttributedCompany varchar(15),
	@mBrokerage money,
	@mDisbursement money,
	@mVAT money,
	@mPST money,-- 50
	@mDuty money,
	@mTransactionFee money,
	@ixPrimaryShipLocation tinyint,
	@ixPrintPrimaryTrailer varchar(5),
	@ixPrintSecondaryTrailer varchar(5),
    @iTotalOrderLines int,
    @iTotalTangibleLines int,
    @iTotalShippedPackages int,
    @ixCustomerType varchar(10),
    @sShipToCOLine varchar(255), -- 60th parameter
    @sShipToStreetAddress1 varchar(255),
    @sShipToStreetAddress2 varchar(255),
    @ixQuote varchar(10),
    @ixConvertedOrder varchar(10),
    @sShipToName varchar(65),
    @sShipToEmailAddress varchar(65),
    @ixGuaranteeDelivery int,
    @dtGuaranteedDelivery datetime,
    @flgGuaranteedDeliveryPromised tinyint,
    @ixLastPackageDeliveryLocal int,-- 70th parameter
    @dtLastPackageDeliveryLocal datetime,
    @flgDeliveryPromiseMet tinyint,
    @mTaxableAmount money,
    @sCreditCardLast4Digits varchar(4),
    @ixInvoiceDate int,
    @dtInvoiceDate datetime -- 76th parameter


AS

SET DEADLOCK_PRIORITY 0 -- 0 = Medium priority -- switched to low 7-5-17 to see if it will  help with that Tableau refresh transaction deadlock errors
   /*
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixCustomer'         ,@Value2=@ixCustomer,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate'   ,@Value4=@ixInvoiceDate, 
                @Field5='PROC CALLED-ORDER UPDATED' ,@Value5='TESTING - NOT an error'
    */         
if exists (select * from tblOrder where ixOrder = @ixOrder)

    BEGIN
        BEGIN TRY
	        update tblOrder set
		        ixCustomer = @ixCustomer,
		        ixOrderDate = @ixOrderDate,
		        sShipToCity = @sShipToCity,
		        sShipToState = @sShipToState,
		        sShipToZip = @sShipToZip,
		        sOrderType = @sOrderType,
		        sOrderChannel = @sOrderChannel,
		        sShipToCountry = @sShipToCountry,
		        ixShippedDate = @ixShippedDate,
		        iShipMethod = @iShipMethod,
		        sSourceCodeGiven = @sSourceCodeGiven,
		        sMatchbackSourceCode = @sMatchbackSourceCode,
		        sMethodOfPayment = @sMethodOfPayment,
		        sOrderTaker = @sOrderTaker,
		        sPromoApplied = @sPromoApplied,
		        mMerchandise = @mMerchandise,
		        mShipping = @mShipping,
		        mTax = @mTax,
		        mCredits = @mCredits,
		        sOrderStatus = @sOrderStatus,
		        flgIsBackorder = @flgIsBackorder,
		        mMerchandiseCost = @mMerchandiseCost,
		        dtOrderDate = @dtOrderDate,
		        dtShippedDate = @dtShippedDate,
		        ixAccountManager = @ixAccountManager,
		        ixOrderTime = @ixOrderTime,
		        mPromoDiscount = @mPromoDiscount,
		        ixAuthorizationStatus = @ixAuthorizationStatus,
		        ixOrderType = @ixOrderType,
		        mPublishedShipping = @mPublishedShipping,
		        sOptimalShipOrigination = @sOptimalShipOrigination,
		        sCanceledReason = @sCanceledReason,
		        ixCanceledBy = @ixCanceledBy,
		        mAmountPaid = @mAmountPaid,
		        flgPrinted = @flgPrinted,
		        ixAuthorizationDate = @ixAuthorizationDate,
		        ixAuthorizationTime = @ixAuthorizationTime,
		        flgIsResidentialAddress = @flgIsResidentialAddress,
		        sWebOrderID = @sWebOrderID,
		        sPhone = @sPhone,
		        dtHoldUntilDate = @dtHoldUntilDate,
		        flgDeviceType = (Case when @sUserAgent like '%ANDROID%' -- case statement added per CCC's request
		                                or @sUserAgent like '%IOS%' 
		                                or @sUserAgent like '%IPAD%' 
		                                or @sUserAgent like '%IPHONE%' 
		                              THEN 'MOBILEDETECTED'
		                         else @flgDeviceType
		                         end),
		        sUserAgent = @sUserAgent,
		        dtAuthorizationDate = @dtAuthorizationDate,
                dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,getdate())),
                ixTimeLastSOPUpdate = dbo.GetCurrentixTime (),
                sAttributedCompany = @sAttributedCompany,
                mBrokerage = @mBrokerage,
	            mDisbursement = @mDisbursement,
	            mVAT = @mVAT,
	            mPST = @mPST,
	            mDuty = @mDuty,
	            mTransactionFee = @mTransactionFee,
	            ixPrimaryShipLocation = @ixPrimaryShipLocation,
				ixPrintPrimaryTrailer = @ixPrintPrimaryTrailer,
				ixPrintSecondaryTrailer = @ixPrintSecondaryTrailer,
				iTotalOrderLines = @iTotalOrderLines,
                iTotalTangibleLines = @iTotalTangibleLines,
                iTotalShippedPackages = @iTotalShippedPackages,
                ixCustomerType = @ixCustomerType,
                sShipToCOLine = @sShipToCOLine,
                sShipToStreetAddress1 = @sShipToStreetAddress1,
                sShipToStreetAddress2 = @sShipToStreetAddress2,
                ixQuote = @ixQuote,
                ixConvertedOrder = @ixConvertedOrder,
                sShipToName = @sShipToName,
                sShipToEmailAddress = @sShipToEmailAddress,
                ixGuaranteeDelivery = @ixGuaranteeDelivery,
                dtGuaranteedDelivery = @dtGuaranteedDelivery,
                flgGuaranteedDeliveryPromised = @flgGuaranteedDeliveryPromised,
                ixLastPackageDeliveryLocal = @ixLastPackageDeliveryLocal,
                dtLastPackageDeliveryLocal = @dtLastPackageDeliveryLocal,
                flgDeliveryPromiseMet = @flgDeliveryPromiseMet,
                mTaxableAmount = @mTaxableAmount,
                sCreditCardLast4Digits = @sCreditCardLast4Digits,
                ixInvoiceDate = @ixInvoiceDate,
                dtInvoiceDate = @dtInvoiceDate
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixCustomer'         ,@Value2=@ixCustomer,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate'   ,@Value4=@ixInvoiceDate,
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH 
    END               	

ELSE
	BEGIN
	    BEGIN TRY
		    insert 
			    tblOrder (ixOrder, ixCustomer, ixOrderDate, sShipToCity, sShipToState, sShipToZip, sOrderType, sOrderChannel, sShipToCountry, ixShippedDate, iShipMethod, sSourceCodeGiven, sMatchbackSourceCode, sMethodOfPayment, sOrderTaker, sPromoApplied, mMerchandise, mShipping, mTax, mCredits, sOrderStatus, flgIsBackorder, mMerchandiseCost, dtOrderDate, dtShippedDate, 
			    ixAccountManager, ixOrderTime, mPromoDiscount, ixAuthorizationStatus, ixOrderType, mPublishedShipping, sOptimalShipOrigination, sCanceledReason, ixCanceledBy, mAmountPaid, flgPrinted, ixAuthorizationDate, ixAuthorizationTime, flgIsResidentialAddress 
			    ,sWebOrderID, sPhone, dtHoldUntilDate, flgDeviceType, sUserAgent, dtAuthorizationDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate,
			    sAttributedCompany, mBrokerage,mDisbursement,mVAT,mPST,mDuty,mTransactionFee,ixPrimaryShipLocation, ixPrintPrimaryTrailer,ixPrintSecondaryTrailer,
			    iTotalOrderLines,iTotalTangibleLines,iTotalShippedPackages, ixCustomerType, sShipToCOLine,sShipToStreetAddress1,sShipToStreetAddress2,ixQuote,ixConvertedOrder,
			    sShipToName, sShipToEmailAddress ,ixGuaranteeDelivery,dtGuaranteedDelivery, 
			    flgGuaranteedDeliveryPromised, ixLastPackageDeliveryLocal, dtLastPackageDeliveryLocal, flgDeliveryPromiseMet, mTaxableAmount,sCreditCardLast4Digits, ixInvoiceDate, dtInvoiceDate)
		    values
			    (@ixOrder, @ixCustomer, @ixOrderDate, @sShipToCity, @sShipToState, @sShipToZip, @sOrderType, @sOrderChannel, @sShipToCountry, @ixShippedDate, @iShipMethod, @sSourceCodeGiven, @sMatchbackSourceCode, @sMethodOfPayment, @sOrderTaker, @sPromoApplied, @mMerchandise, @mShipping, @mTax, @mCredits, @sOrderStatus, @flgIsBackorder, @mMerchandiseCost, @dtOrderDate, @dtShippedDate, 
			    @ixAccountManager, @ixOrderTime, @mPromoDiscount, @ixAuthorizationStatus, @ixOrderType, @mPublishedShipping, @sOptimalShipOrigination, @sCanceledReason, @ixCanceledBy, @mAmountPaid, @flgPrinted, @ixAuthorizationDate, @ixAuthorizationTime, @flgIsResidentialAddress
			    , @sWebOrderID, @sPhone, @dtHoldUntilDate, 	        
			    (Case when @sUserAgent like '%ANDROID%' -- case statement added per CCC's request
		                                or @sUserAgent like '%IOS%' 
		                                or @sUserAgent like '%IPAD%' 
		                                or @sUserAgent like '%IPHONE%' 
		                              THEN 'MOBILEDETECTED'
		                         else @flgDeviceType
		                         end), 
		         @sUserAgent, @dtAuthorizationDate,
            DATEADD(dd,0,DATEDIFF(dd,0,getdate())), 
            dbo.GetCurrentixTime (),
                @sAttributedCompany, @mBrokerage, @mDisbursement, @mVAT, @mPST, @mDuty, @mTransactionFee,@ixPrimaryShipLocation, @ixPrintPrimaryTrailer,@ixPrintSecondaryTrailer,
			    @iTotalOrderLines,@iTotalTangibleLines,@iTotalShippedPackages, @ixCustomerType,
			    @sShipToCOLine,@sShipToStreetAddress1,@sShipToStreetAddress2, @ixQuote,@ixConvertedOrder,
		        @sShipToName, @sShipToEmailAddress,@ixGuaranteeDelivery, @dtGuaranteedDelivery, 
		        @flgGuaranteedDeliveryPromised, @ixLastPackageDeliveryLocal, @dtLastPackageDeliveryLocal, @flgDeliveryPromiseMet, @mTaxableAmount, @sCreditCardLast4Digits, @ixInvoiceDate, @dtInvoiceDate)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixCustomer'         ,@Value2=@ixCustomer,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate'   ,@Value4=@ixInvoiceDate, 
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END








USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 1/24/2019 2:21:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************* [AFCO Reporting] **************/
ALTER PROCEDURE [dbo].[spUpdateOrder]
	@ixOrder varchar(10),
	@ixCustomer int,
	@ixOrderDate smallint,
	@sShipToCity varchar(25),
	@sShipToState varchar(20),
	@sShipToZip varchar(15),
	@sOrderType varchar(20),
	@sOrderChannel varchar(20),
	@sShipToCountry varchar(30),
	@ixShippedDate smallint,
	@iShipMethod smallint,
	@sSourceCodeGiven varchar(15),
	@sMatchbackSourceCode varchar(15),
	@sMethodOfPayment varchar(15),
	@sOrderTaker varchar(10),
	@sPromoApplied varchar(10),
	@mMerchandise money,
	@mShipping money,
	@mTax money,
	@mCredits money,
	@sOrderStatus varchar(15),
	@flgIsBackorder tinyint,
	@mMerchandiseCost money,
	@dtOrderDate datetime,
	@dtShippedDate datetime,
	@ixAccountManager varchar(10),
	@ixOrderTime integer,
	@mPromoDiscount money,
	@ixAuthorizationStatus varchar(15),
	@ixOrderType varchar(20), 
	@mPublishedShipping money,
	@sOptimalShipOrigination varchar(50),
	@sCanceledReason varchar(50),
	@ixCanceledBy varchar(10),
	@mAmountPaid money,
	@flgPrinted tinyint,
	@ixAuthorizationDate int,
	@ixAuthorizationTime int,
	@flgIsResidentialAddress tinyint,
	@sWebOrderID varchar(10),
	@sPhone varchar(25),
	@dtHoldUntilDate datetime,
	@flgDeviceType varchar(20),
	@sUserAgent varchar(500),
	@dtAuthorizationDate datetime,
	@sAttributedCompany varchar(15),
	@mBrokerage money,
	@mDisbursement money,
	@mVAT money,
	@mPST money,
	@mDuty money,
	@mTransactionFee money,
	@ixPrimaryShipLocation tinyint,
	@ixPrintPrimaryTrailer varchar(5),
	@ixPrintSecondaryTrailer varchar(5),
    @iTotalOrderLines int,
    @iTotalTangibleLines int,
    @iTotalShippedPackages int,
    @ixCustomerType varchar(10),
    @sShipToCOLine varchar(255),
    @sShipToStreetAddress1 varchar(255),
    @sShipToStreetAddress2 varchar(255),
    @ixQuote varchar(10),
    @ixConvertedOrder varchar(10),
    @sShipToName varchar(65),
    @sShipToEmailAddress varchar(65),
    @ixGuaranteeDelivery int,
    @dtGuaranteedDelivery datetime,
    @flgGuaranteedDeliveryPromised tinyint,
    @ixLastPackageDeliveryLocal int,
    @dtLastPackageDeliveryLocal datetime,
    @flgDeliveryPromiseMet tinyint,
    @mTaxableAmount money, 
    @sCreditCardLast4Digits varchar(4),
    @ixInvoiceDate int,
    @dtInvoiceDate datetime
	
AS
    /*
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixCustomer'         ,@Value2=@ixCustomer,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate'   ,@Value4=@ixInvoiceDate, , 
                @Field5='PROC CALLED-ORDER UPDATED' ,@Value5='TESTING - NOT an error'
     */          
if exists (select * from tblOrder where ixOrder = @ixOrder)

    BEGIN
        BEGIN TRY
	        update tblOrder set
		        ixCustomer = @ixCustomer,
		        ixOrderDate = @ixOrderDate,
		        sShipToCity = @sShipToCity,
		        sShipToState = @sShipToState,
		        sShipToZip = @sShipToZip,
		        sOrderType = @sOrderType,
		        sOrderChannel = @sOrderChannel,
		        sShipToCountry = @sShipToCountry,
		        ixShippedDate = @ixShippedDate,
		        iShipMethod = @iShipMethod,
		        sSourceCodeGiven = @sSourceCodeGiven,
		        sMatchbackSourceCode = @sMatchbackSourceCode,
		        sMethodOfPayment = @sMethodOfPayment,
		        sOrderTaker = @sOrderTaker,
		        sPromoApplied = @sPromoApplied,
		        mMerchandise = @mMerchandise,
		        mShipping = @mShipping,
		        mTax = @mTax,
		        mCredits = @mCredits,
		        sOrderStatus = @sOrderStatus,
		        flgIsBackorder = @flgIsBackorder,
		        mMerchandiseCost = @mMerchandiseCost,
		        dtOrderDate = @dtOrderDate,
		        dtShippedDate = @dtShippedDate,
		        ixAccountManager = @ixAccountManager,
		        ixOrderTime = @ixOrderTime,
		        mPromoDiscount = @mPromoDiscount,
		        ixAuthorizationStatus = @ixAuthorizationStatus,
		        ixOrderType = @ixOrderType,
		        mPublishedShipping = @mPublishedShipping,
		        sOptimalShipOrigination = @sOptimalShipOrigination,
		        sCanceledReason = @sCanceledReason,
		        ixCanceledBy = @ixCanceledBy,
		        mAmountPaid = @mAmountPaid,
		        flgPrinted = @flgPrinted,
		        ixAuthorizationDate = @ixAuthorizationDate,
		        ixAuthorizationTime = @ixAuthorizationTime,
		        flgIsResidentialAddress = @flgIsResidentialAddress,
		        sWebOrderID = @sWebOrderID,
		        sPhone = @sPhone,
		        dtHoldUntilDate = @dtHoldUntilDate,
		        flgDeviceType = (Case when @sUserAgent like '%ANDROID%' -- case statement added per CCC's request
		                                or @sUserAgent like '%IOS%' 
		                                or @sUserAgent like '%IPAD%' 
		                                or @sUserAgent like '%IPHONE%' 
		                              THEN 'MOBILEDETECTED'
		                         else @flgDeviceType
		                         end),
		        sUserAgent = @sUserAgent,
		        dtAuthorizationDate = @dtAuthorizationDate,
                dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,getdate())),
                ixTimeLastSOPUpdate = dbo.GetCurrentixTime (),
                sAttributedCompany = @sAttributedCompany,
                mBrokerage = @mBrokerage,
	            mDisbursement = @mDisbursement,
	            mVAT = @mVAT,
	            mPST = @mPST,
	            mDuty = @mDuty,
	            mTransactionFee = @mTransactionFee,
	            ixPrimaryShipLocation = @ixPrimaryShipLocation,
				ixPrintPrimaryTrailer = @ixPrintPrimaryTrailer,
				ixPrintSecondaryTrailer = @ixPrintSecondaryTrailer,
				iTotalOrderLines = @iTotalOrderLines,
                iTotalTangibleLines = @iTotalTangibleLines,
                iTotalShippedPackages = @iTotalShippedPackages,
                ixCustomerType = @ixCustomerType,
                sShipToCOLine = @sShipToCOLine,
                sShipToStreetAddress1 = @sShipToStreetAddress1,
                sShipToStreetAddress2 = @sShipToStreetAddress2,
                ixQuote = @ixQuote,
                ixConvertedOrder = @ixConvertedOrder,
                sShipToName = @sShipToName,
                sShipToEmailAddress = @sShipToEmailAddress,
                ixGuaranteeDelivery = @ixGuaranteeDelivery,
                dtGuaranteedDelivery = @dtGuaranteedDelivery,
                flgGuaranteedDeliveryPromised = @flgGuaranteedDeliveryPromised,
                ixLastPackageDeliveryLocal = @ixLastPackageDeliveryLocal,
                dtLastPackageDeliveryLocal = @dtLastPackageDeliveryLocal,
                flgDeliveryPromiseMet = @flgDeliveryPromiseMet,
                mTaxableAmount = @mTaxableAmount,
                sCreditCardLast4Digits = @sCreditCardLast4Digits,
                ixInvoiceDate = @ixInvoiceDate,
                dtInvoiceDate = @dtInvoiceDate
                
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixCustomer'         ,@Value2=@ixCustomer,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate'   ,@Value4=@ixInvoiceDate,
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH 
    END               	

ELSE
	BEGIN
	    BEGIN TRY
		    insert 
			    tblOrder (ixOrder, ixCustomer, ixOrderDate, sShipToCity, sShipToState, sShipToZip, sOrderType, sOrderChannel, sShipToCountry, ixShippedDate, iShipMethod, sSourceCodeGiven, sMatchbackSourceCode, sMethodOfPayment, sOrderTaker, sPromoApplied, mMerchandise, mShipping, mTax, mCredits, sOrderStatus, flgIsBackorder, mMerchandiseCost, dtOrderDate, dtShippedDate, 
			    ixAccountManager, ixOrderTime, mPromoDiscount, ixAuthorizationStatus, ixOrderType, mPublishedShipping, sOptimalShipOrigination, sCanceledReason, ixCanceledBy, mAmountPaid, flgPrinted, ixAuthorizationDate, ixAuthorizationTime, flgIsResidentialAddress 
			    ,sWebOrderID, sPhone, dtHoldUntilDate, flgDeviceType, sUserAgent, dtAuthorizationDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate,
			    sAttributedCompany, mBrokerage,mDisbursement,mVAT,mPST,mDuty,mTransactionFee,ixPrimaryShipLocation, ixPrintPrimaryTrailer,ixPrintSecondaryTrailer,
			    iTotalOrderLines,iTotalTangibleLines,iTotalShippedPackages, ixCustomerType, sShipToCOLine,sShipToStreetAddress1,sShipToStreetAddress2,ixQuote,ixConvertedOrder,
			    sShipToName, sShipToEmailAddress ,ixGuaranteeDelivery,dtGuaranteedDelivery, 
			    flgGuaranteedDeliveryPromised, ixLastPackageDeliveryLocal, dtLastPackageDeliveryLocal, flgDeliveryPromiseMet, mTaxableAmount ,sCreditCardLast4Digits, ixInvoiceDate, dtInvoiceDate)
		    values
			    (@ixOrder, @ixCustomer, @ixOrderDate, @sShipToCity, @sShipToState, @sShipToZip, @sOrderType, @sOrderChannel, @sShipToCountry, @ixShippedDate, @iShipMethod, @sSourceCodeGiven, @sMatchbackSourceCode, @sMethodOfPayment, @sOrderTaker, @sPromoApplied, @mMerchandise, @mShipping, @mTax, @mCredits, @sOrderStatus, @flgIsBackorder, @mMerchandiseCost, @dtOrderDate, @dtShippedDate, 
			    @ixAccountManager, @ixOrderTime, @mPromoDiscount, @ixAuthorizationStatus, @ixOrderType, @mPublishedShipping, @sOptimalShipOrigination, @sCanceledReason, @ixCanceledBy, @mAmountPaid, @flgPrinted, @ixAuthorizationDate, @ixAuthorizationTime, @flgIsResidentialAddress
			    , @sWebOrderID, @sPhone, @dtHoldUntilDate, 	        
			    (Case when @sUserAgent like '%ANDROID%' -- case statement added per CCC's request
		                                or @sUserAgent like '%IOS%' 
		                                or @sUserAgent like '%IPAD%' 
		                                or @sUserAgent like '%IPHONE%' 
		                              THEN 'MOBILEDETECTED'
		                         else @flgDeviceType
		                         end), 
		         @sUserAgent, @dtAuthorizationDate,
            DATEADD(dd,0,DATEDIFF(dd,0,getdate())), 
            dbo.GetCurrentixTime (),
                @sAttributedCompany, @mBrokerage, @mDisbursement, @mVAT, @mPST, @mDuty, @mTransactionFee,@ixPrimaryShipLocation, @ixPrintPrimaryTrailer,@ixPrintSecondaryTrailer,
			    @iTotalOrderLines,@iTotalTangibleLines,@iTotalShippedPackages, @ixCustomerType,
			    @sShipToCOLine,@sShipToStreetAddress1,@sShipToStreetAddress2, @ixQuote,@ixConvertedOrder,
		        @sShipToName, @sShipToEmailAddress,@ixGuaranteeDelivery, @dtGuaranteedDelivery, 
		        @flgGuaranteedDeliveryPromised, @ixLastPackageDeliveryLocal, @dtLastPackageDeliveryLocal, @flgDeliveryPromiseMet, @mTaxableAmount, @sCreditCardLast4Digits, @ixInvoiceDate, @dtInvoiceDate)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixCustomer'         ,@Value2=@ixCustomer,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate'   ,@Value4=@ixInvoiceDate,   
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END


/*************************************************************************************************************/
/******    STEP 14) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES


/*************************************************************************************************************/
/******    STEP 14) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT ixOrder, ixInvoiceDate, dtInvoiceDate
        FROM tblOrder 
        WHERE ixInvoiceDate is NOT null
        --and len(ixInvoiceDate) < 4
        order by ixInvoiceDate, dtInvoiceDate  --newid()


        SELECT  ixOrder, ixInvoiceDate, dtInvoiceDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblOrder
        WHERE ixOrder in ('8930749','8941841')
        order by ixOrder  --newid()


        SELECT top 10 ixOrder, ixInvoiceDate, dtInvoiceDate
        FROM tblOrder 
        WHERE ixInvoiceDate is NOT null
        --and len(ixInvoiceDate) < 4
        order by newid()

          

    --AFCO TEST DATA
        SELECT ixOrder, ixInvoiceDate, dtInvoiceDate
        FROM tblOrder 
        WHERE ixInvoiceDate is NOT null
        --and len(ixInvoiceDate) < 4
        order by ixInvoiceDate, dtInvoiceDate  --newid()

        SELECT  ixOrder, ixInvoiceDate, dtInvoiceDate
        FROM tblOrder
        WHERE ixOrder = '8124742'
        order by ixOrder  --newid()






/*************************************************************************************************************/
/******    STEP 15) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        -- get test records                                                                     
        SELECT top 10 ixOrder, ixInvoiceDate, dtInvoiceDate,  dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblOrder
        WHERE ixInvoiceDate is NOT null
        ORDER BY newid()


        select chTime from tblTime where ixTime = 26959

        SELECT ixInvoiceDate



/*************************************************************************************************************/
/******    17) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 17)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com                                                                            *******/
                                                                         
        SELECT ixInvoiceDate, count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
        where ixInvoiceDate is NOT NULL
        GROUP BY ixInvoiceDate



        SELECT top 10 ixCustomer, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
        order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

        SELECT count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
        where ixInvoiceDate is NOT NULL
        and sOrderStatus = 'Shipped'
        and dtShippedDate between '12/28/2018' and '04/01/2019'
      

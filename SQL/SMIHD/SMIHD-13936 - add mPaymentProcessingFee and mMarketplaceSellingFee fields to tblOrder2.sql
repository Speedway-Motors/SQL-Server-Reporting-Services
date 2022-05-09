-- SMIHD-13936 - add mPaymentProcessingFee and mMarketplaceSellingFee fields to tblOrder

-- RENAME THIS TEMPLATE using the appropriate Jira Case #

-- SELECT @@SPID as 'Current SPID' -- 103

/* CHANGES TO BE MADE

   add the following field to tblOrder
    mPaymentProcessingFee - money - (NULL allowed)
    mMarketplaceSellingFee - money - (NULL allowed)
    
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

select * into [SMIArchive].dbo.BU_tblOrder_20190524 from [SMI Reporting].dbo.tblOrder      --   6,509,399
select * into [SMIArchive].dbo.BU_AFCO_tblOrder_20190524 from [AFCOReporting].dbo.tblOrder --     407,209



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
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder ADD
	mPaymentProcessingFee money NULL,
    mMarketplaceSellingFee money NULL
GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrder ADD
	mPaymentProcessingFee money NULL,
    mMarketplaceSellingFee money NULL
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.tblOrder ADD
		mPaymentProcessingFee money NULL,
    mMarketplaceSellingFee money NULL
GO
ALTER TABLE dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- ROLLBACK TRAN

-- SELECT TOP 1 * FROM dbo.tblOrder

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
		mPaymentProcessingFee money NULL,
    mMarketplaceSellingFee money NULL
GO
ALTER TABLE dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 5/23/2019 5:04:29 PM ******/
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
    @ixInvoiceDate int,     -- 75th parameter
    @dtInvoiceDate datetime,
    @sBusinessUnit varchar(12)
    -- mPaymentProcessingFee -- calculated.  @ not needed
    -- mMarketplaceSellingFee -- calculated.  @ not needed
	
AS
    /*  EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit'         ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='sBusinessUnit'   ,@Value4=@sBusinessUnit, 
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
                dtInvoiceDate = @dtInvoiceDate,
                ixBusinessUnit = (CASE WHEN @sBusinessUnit IS NULL THEN NULL
                                 ELSE COALESCE((Select ixBusinessUnit
                                                From tblBusinessUnit
                                                where sBusinessUnit = @sBusinessUnit)
                                          ,112)
                                 END),
                mPaymentProcessingFee = (CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN 
                                          (CASE WHEN sMethodOfPayment= 'VISA' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'AMEX' then 0.03 *(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'DISCOVER' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'MASTERCARD' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PP-AUCTION' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PAYPAL' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                                end)
                                ELSE 0
                                end), -- mPaymentProcessingFee
                 mMarketplaceSellingFee = (CASE WHEN sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping+mTax-mCredits)
                                                        WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                        WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end)  -- mMarketplaceSellingFee
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate' ,@Value4=@ixInvoiceDate,
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
			    flgGuaranteedDeliveryPromised, ixLastPackageDeliveryLocal, dtLastPackageDeliveryLocal, flgDeliveryPromiseMet, mTaxableAmount ,sCreditCardLast4Digits, ixInvoiceDate, dtInvoiceDate, 
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee)
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
		        @flgGuaranteedDeliveryPromised, @ixLastPackageDeliveryLocal, @dtLastPackageDeliveryLocal, @flgDeliveryPromiseMet, @mTaxableAmount, @sCreditCardLast4Digits, @ixInvoiceDate, @dtInvoiceDate,
                (CASE WHEN @sBusinessUnit IS NULL THEN NULL
                                 ELSE COALESCE((Select ixBusinessUnit
                                                From tblBusinessUnit
                                                where sBusinessUnit = @sBusinessUnit)
                                          ,112)
                                 END),-- ixBusinessUnit
                (CASE WHEN @sOrderStatus = 'Shipped' 
                        AND (@mMerchandise+@mShipping+@mTax-@mCredits) > 0 THEN 
                                          (CASE WHEN @sMethodOfPayment= 'VISA' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'AMEX' THEN 0.03 *(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'DISCOVER' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'MASTERCARD' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'PP-AUCTION' THEN 0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'PAYPAL' THEN 0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                else 0 
                                                end)
                                ELSE 0
                                end),-- mPaymentProcessingFee
                (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven = 'WALMART' THEN 0.12*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end)-- mMarketplaceSellingFee
                )
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate' ,@Value4=@ixInvoiceDate,   
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END












USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 5/24/2019 9:48:43 AM ******/
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
    @dtInvoiceDate datetime,
    @sBusinessUnit varchar(12)
    -- mPaymentProcessingFee -- calculated.  @ not needed
    -- mMarketplaceSellingFee -- calculated.  @ not needed	
AS
    /*
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate' ,@Value4=@ixInvoiceDate,
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
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
                dtInvoiceDate = @dtInvoiceDate,
                ixBusinessUnit = (CASE WHEN @sBusinessUnit IS NULL THEN NULL
                                 ELSE COALESCE((Select ixBusinessUnit
                                                From tblBusinessUnit
                                                where sBusinessUnit = @sBusinessUnit)
                                          ,112)
                                 END),
                mPaymentProcessingFee = (CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN 
                                          (CASE WHEN sMethodOfPayment= 'VISA' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'AMEX' then 0.03 *(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'DISCOVER' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'MASTERCARD' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PP-AUCTION' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PAYPAL' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                                end)
                                ELSE 0
                                end), -- mPaymentProcessingFee
                 mMarketplaceSellingFee = (CASE WHEN sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping+mTax-mCredits)
                                                        WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                        WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end)  -- mMarketplaceSellingFee
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate' ,@Value4=@ixInvoiceDate,
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
			    flgGuaranteedDeliveryPromised, ixLastPackageDeliveryLocal, dtLastPackageDeliveryLocal, flgDeliveryPromiseMet, mTaxableAmount ,sCreditCardLast4Digits, ixInvoiceDate, dtInvoiceDate, 
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee)
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
		        @flgGuaranteedDeliveryPromised, @ixLastPackageDeliveryLocal, @dtLastPackageDeliveryLocal, @flgDeliveryPromiseMet, @mTaxableAmount, @sCreditCardLast4Digits, @ixInvoiceDate, @dtInvoiceDate,
                (CASE WHEN @sBusinessUnit IS NULL THEN NULL
                                 ELSE COALESCE((Select ixBusinessUnit
                                                From tblBusinessUnit
                                                where sBusinessUnit = @sBusinessUnit)
                                          ,112)
                                 END),-- ixBusinessUnit
                (CASE WHEN @sOrderStatus = 'Shipped' 
                        AND (@mMerchandise+@mShipping+@mTax-@mCredits) > 0 THEN 
                                          (CASE WHEN @sMethodOfPayment= 'VISA' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'AMEX' THEN 0.03 *(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'DISCOVER' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'MASTERCARD' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'PP-AUCTION' THEN 0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'PAYPAL' THEN 0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                else 0 
                                                end)
                                ELSE 0
                                end),-- mPaymentProcessingFee
                (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven = 'WALMART' THEN 0.12*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end)-- mMarketplaceSellingFee
                )
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixInvoiceDate' ,@Value4=@ixInvoiceDate,
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END


/*************************************************************************************************************/
/******    STEP 15) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES


/*************************************************************************************************************/
/******    STEP 16) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT * from tblOrder where ixBusinessUnit is NOT NULL
        
        SELECT ixOrder, ixBusinessUnit
        FROM tblOrder 
        WHERE ixBusinessUnit is NOT null
        --and len(ixInvoiceDate) < 4
        order by ixBusinessUnit  --newid()


        SELECT  ixOrder, ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblOrder
        WHERE ixOrder in ('8774142','8145752')
        order by ixOrder  --newid()
        /*
        ixOrder	ixBusinessUnit	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
        8145752	NULL	2019-04-11 00:00:00.000	37510
        8774142	112	    2019-04-11 00:00:00.000	38207
*/
        SELECT * FROM tblTime where ixTime = 38131 -- 10:25:10  

        SELECT top 10 ixOrder, ixBusinessUnit
        FROM tblOrder 
        WHERE ixInvoiceDate is NOT null
        --and len(ixInvoiceDate) < 4
        order by newid()

         

    --AFCO TEST DATA
        SELECT ixOrder, ixBusinessUnit
        FROM tblOrder 
        WHERE ixInvoiceDate is NOT null
        --and len(ixInvoiceDate) < 4
        order by ixBusinessUnit  --newid()


        SELECT  ixOrder, ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblOrder
        WHERE ixOrder in ('860112','859106')
        order by ixOrder  --newid()

        SELECT  ixOrder, ixBusinessUnit
        FROM tblOrder
        WHERE ixOrder in ('860112','859106')
        order by ixOrder  --newid()


        select * from tblBusinessUnit


        SELECT * FROM tblOrder where dtShippedDate = '04/01/2019'



/*************************************************************************************************************/
/******    STEP 17) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        -- get test records                                                                     
        SELECT top 10 ixCreditMemo, ixOrder, ixBusinessUnit,  dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblOrder
      --  WHERE ixInvoiceDate is NOT null
        WHERE ixCreditMemo in ('F-6732','C-15645','C-3637','C-10742','C-8879','C-11205','C-10914','C-19871','F-20694','C-3914')
        ORDER BY newid()


        select chTime from tblTime where ixTime = 26959

        SELECT ixInvoiceDate

        SELECT ixBusinessUnit, count(*)
        FROM tblOrder
        GROUP BY ixBusinessUnit
        ORDER BY ixBusinessUnit

        SELECT *
        FROM tblOrder
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
        FROM tblOrder
        order by dtCreateDate

        SELECT ixOrder, sOrderStatus, sSourceCodeGiven, sMethodOfPayment, (mMerchandise+mShipping+mTax-mCredits) 'TotCharge',
    mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate
        FROM tblOrder
        WHERE dtShippedDate = '04/01/2019'

        SELECT ixOrder, sOrderStatus, sSourceCodeGiven, sMethodOfPayment, (mMerchandise+mShipping+mTax-mCredits) 'TotCharge',
    mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate
        FROM tblOrder
        WHERE ixOrder in ('8177763') --('8860941','8862942','8863845','8874946','8893948','8900440','8900441','8903443','8903444','8903547')
        ORDER BY ixOrder
        /*                                      Tot     Processing MP
        ixOrder	SCGiven	sMOP        Charge	    Fee	    SellingFee	    dtDateLastSOPUpdate
        8860941	Shipped	AMAZON	AMAZON	99.99	0.00	11.9988	2019-05-24 00:00:00.000
        8862942	Shipped	2190	VISA	1797.97	37.7574	0.00	2019-05-24 00:00:00.000
        8863845	Shipped	EC	VISA	21.39	0.4492	0.00	2019-05-24 00:00:00.000
        8874946	Shipped	CUST-SERV	MASTERCARD	59.99	1.2598	0.00	2019-05-24 00:00:00.000
        8893948	Shipped	AMAZONPRIME	AMAZON	188.83	0.00	0.00	2019-05-24 00:00:00.000
        8900440	Shipped	EBAY	PP-AUCTION	57.62	1.1236	4.0334	2019-05-24 00:00:00.000
        8900441	Shipped	EBAY	PP-AUCTION	269.99	5.2648	18.8993	2019-05-24 00:00:00.000
        8903443	Shipped	2190	PAYPAL	35.36	0.6895	0.00	2019-05-24 00:00:00.000
        8903444	Shipped	2190	PAYPAL	24.31	0.474	0.00	2019-05-24 00:00:00.000
        8903547	Shipped	EC	DISCOVER	321.74	6.7565	0.00	2019-05-24 00:00:00.000

        8860941	Shipped	AMAZON	AMAZON	99.99	0.00	11.9988	2019-05-24 00:00:00.000
        8862942	Shipped	2190	VISA	1797.97	37.7574	0.00	2019-05-24 00:00:00.000
        8863845	Shipped	EC	VISA	21.39	0.4492	0.00	2019-05-24 00:00:00.000
        8874946	Shipped	CUST-SERV	MASTERCARD	59.99	1.2598	0.00	2019-05-24 00:00:00.000
        8893948	Shipped	AMAZONPRIME	AMAZON	188.83	0.00	22.6596	2019-05-24 00:00:00.000
        8900440	Shipped	EBAY	PP-AUCTION	57.62	1.1236	4.0334	2019-05-24 00:00:00.000
        8900441	Shipped	EBAY	PP-AUCTION	269.99	5.2648	18.8993	2019-05-24 00:00:00.000
        8903443	Shipped	2190	PAYPAL	35.36	0.6895	0.00	2019-05-24 00:00:00.000
        8903444	Shipped	2190	PAYPAL	24.31	0.474	0.00	2019-05-24 00:00:00.000
        8903547	Shipped	EC	DISCOVER	321.74	6.7565	0.00	2019-05-24 00:00:00.000


*/
        SELECT ixOrder, sOrderStatus, sSourceCodeGiven, sMethodOfPayment, (mMerchandise+mShipping+mTax-mCredits) 'TotCharge',
             mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, dtShippedDate
        FROM tblOrder
        WHERE dtDateLastSOPUpdate = '05/24/2019' and ixTimeLastSOPUpdate > = 40740

        ORDER BY ixTimeLastSOPUpdate desc

        select * from tblTime where chTime like '11:19:00%' -- 40740
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
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
        where ixBusinessUnit is NOT NULL
        GROUP BY ixBusinessUnit

        
        SELECT top 10 ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
        order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

        SELECT count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
        where ixBusinessUnit is NOT NULL

      

        SELECT  ixOrder, ixBusinessUnit, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
        WHERE ixOrder in ('8774142','8145752')
        order by ixOrder  --newid()

           select count(*)
           from tblOrder
           where mPaymentProcessingFee is NOT NULL -- 1,728

           select r.ixAwsQueueTypeReference, format(count(*),'###,###,###') as 'CntInStagingQueue', r.sTableName
from tblAwsQueueStage q (nolock) 
    inner join tblAwsQueueTypeReference r on q.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
group by r.ixAwsQueueTypeReference, r.sTableName
   HAVING COUNT(*) > 10 -- more than X recoords in the queue    -- 9k@15:25
order by count(*) desc, sTableName
/*
ixAws
Queue   CntIn
Type    Staging
Ref	    Queue	sTableName
======  ======= =============================
6	    4,638	tblOrderLine
5	    736 	tblOrder
78	    693 	tblOrderRouting
84	    539	    tblPODetail
4	    28	    tblCustomer
11	    12	    tblBin
*/



/*************************************************************************************************************/
/******    STEP 21)	final check on SMI Reporting to make sure no error codes are tripping              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/ 

    -- ERROR CODE to check on
    select * from tblErrorCode where sDescription like '%tblOrder%'
    --  1141	Failure to update tblOrder

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1141'
      and dtDate >=  DATEADD(month, -2, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	04-12-19	161
    SMI Reporting	04-11-19	240



    select * from tblErrorCode
    order by ixErrorCode desc


    SELECT @@SPID as 'Current SPID' -- 121 
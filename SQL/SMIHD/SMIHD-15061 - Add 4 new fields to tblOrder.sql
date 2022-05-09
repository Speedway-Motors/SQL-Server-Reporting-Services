-- SMIHD-15061 - Add 4 new fields to tblOrder

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 69

/* 
    CHANGES TO BE MADE: add ixMasterOrderNumber, ixOptimalShipLocation, flgSplitOrder, flgBackorder
    ALLOWED VALUES:
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

select * into [SMIArchive].dbo.BU_tblOrder_20190924 from [SMI Reporting].dbo.tblOrder      --    6768895
select * into [SMIArchive].dbo.BU_AFCO_tblOrder_20190924 from [AFCOReporting].dbo.tblOrder --     412335

-- DROP TABLE [SMIArchive].dbo.BU_tblOrder_20190920
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblOrder_20190920


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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrder ADD
    ixOptimalShipLocation tinyint NULL,
    ixMasterOrderNumber varchar(32) NULL,
	flgSplitOrder tinyint NULL,
    flgBackorder  tinyint NULL
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
    ixOptimalShipLocation tinyint NULL,
    ixMasterOrderNumber varchar(32) NULL,
	flgSplitOrder tinyint NULL,
    flgBackorder  tinyint NULL
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
    ixOptimalShipLocation tinyint NULL,
    ixMasterOrderNumber varchar(32) NULL,
	flgSplitOrder tinyint NULL,
    flgBackorder  tinyint NULL
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
    @sBusinessUnit varchar(12),
    -- mPaymentProcessingFee -- calculated.  @ not needed
    -- mMarketplaceSellingFee -- calculated.  @ not needed
    @flgHighPriority tinyint,
    @ixOptimalShipLocation tinyint,
    @ixMasterOrderNumber varchar(32),
	@flgSplitOrder tinyint,
    @flgBackorder  tinyint
	
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
                                      end),  -- mMarketplaceSellingFee,
                flgHighPriority = @flgHighPriority,
                ixOptimalShipLocation = @ixOptimalShipLocation,
                ixMasterOrderNumber = @ixMasterOrderNumber,
	            flgSplitOrder = @flgSplitOrder,
                flgBackorder = @flgBackorder                                      
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
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee, flgHighPriority, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder)
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
                                      end),-- mMarketplaceSellingFee
                @flgHighPriority, @ixOptimalShipLocation, @ixMasterOrderNumber, @flgSplitOrder, @flgBackorder)
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
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 9/19/2019 4:57:07 PM ******/
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
    @sBusinessUnit varchar(12),
    -- mPaymentProcessingFee -- calculated.  @ not needed
    -- mMarketplaceSellingFee -- calculated.  @ not needed	
    @flgHighPriority tinyint,
    @ixOptimalShipLocation tinyint,
    @ixMasterOrderNumber varchar(32),
	@flgSplitOrder tinyint,
    @flgBackorder  tinyint
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
                                      end),  -- mMarketplaceSellingFee
                flgHighPriority = @flgHighPriority,
                ixOptimalShipLocation = @ixOptimalShipLocation,
                ixMasterOrderNumber = @ixMasterOrderNumber,
	            flgSplitOrder = @flgSplitOrder,
                flgBackorder = @flgBackorder    
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
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee, flgHighPriority, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder)
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
                                      end),-- mMarketplaceSellingFee
                 @flgHighPriority, @ixOptimalShipLocation, @ixMasterOrderNumber, @flgSplitOrder, @flgBackorder)
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
        SELECT ixOrder, ixPrimaryShipLocation, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblOrder where ixMasterOrderNumber is NOT NULL
        /*
        ixOrder	iLength	iWidth	iHeight	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
        465AC4004	13.6	7.7	1.8	2019-06-18 00:00:00.000	54633
        */

         

    --AFCO TEST DATA
        SELECT ixOrder, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from tblOrder where ixMasterOrderNumber is NOT NULL



/*************************************************************************************************************/
/******    STEP 17) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        --SMI TEST DATA
        SELECT ixOrder, ixPrimaryShipLocation, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblOrder where ixMasterOrderNumber is NOT NULL

        --AFCO TEST DATA
        SELECT ixOrder, ixPrimaryShipLocation, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblOrder where ixMasterOrderNumber is NOT NULL




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
    select * from tblErrorCode where sDescription like '%tblOrder%'
    --  1141	Failure to update tblOrder

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
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder ADD
    ixOptimalShipLocation tinyint NULL,
    ixMasterOrderNumber varchar(32) NULL,
	flgSplitOrder tinyint NULL,
    flgBackorder  tinyint NULL
GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblOrder SET (LOCK_ESCALATION = TABLE)
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
        FROM [Transfer].tblOrder 
        WHERE ixOrder = '465AC4004'
        /*
                ixOrder	    iLength	iWidth	iHeight	DateLastSOPUpdate   TimeLastSOPUpdate
        BEFORE  465AC4004	13.0	7.0	    1.0	    2019.05.16          25760
        AFTER   465AC4004	13.6	7.7	    1.8	    2019.06.18	        54633
        */
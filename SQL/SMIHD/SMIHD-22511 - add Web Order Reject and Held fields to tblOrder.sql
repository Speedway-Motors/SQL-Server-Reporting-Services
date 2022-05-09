-- SMIHD-22511 - add Web Order Reject and Held fields to tblOrder

SELECT @@SPID as 'Current SPID' -- 75

/*  TABLE: tblOrder
    CHANGES TO BE MADE: add dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser

        steps as of 2021.09.10

STEP  WHERE             ACTION
=== ===============     =======================================================
1	LNK-SQL-LIVE-1	    DISABLE SSA job "SMIJob_AwsExportData"
2	dw.speedway2.com	DISABLE SSA job "JobAwsImportData"
3	LNK-SQL-LIVE-1	    BACKUP tables to be modified to SMIArchive
4	dw.speedway2.com	Script & drop any affexted indexes in SMIReportingRawData
5	dw.speedway2.com	Add to/Alter the corresponding table in [SMiReportingRawData].[Transfer].
6	dw.speedway2.com	Rebuild any affected indexes in SMiReportingRawData
7	LNK-SQL-LIVE-1	    Script & drop any affected indexes in ChangeLog_smiReporting
8	LNK-SQL-LIVE-1	    Add to/Alter corresponding table in [ChangeLog_smiReportingRawData].dbo.
9	LNK-SQL-LIVE-1	    Rebuild any affected indexes in ChangeLog_smiReporting
10	SOP	                PAUSE feeds to SMI/AFCO Reporting
11	LNK-SQL-LIVE-1	    Script & drop any affected indexes in SMI/AFCO Reporting
12	LNK-SQL-LIVE-1	    Add/Alter the column in the corresponding table in [SMI Reporting].dbo.
13	LNK-SQL-LIVE-1	    Rebuild any affected indexes in SMI/AFCO Reporting
14	LNK-SQL-LIVE-1	    "apply script changes to the appropriate stored procedure(s) (usually spUpdate<tablename>)"
15	SOP	                manually push records to test feeds (before resuming feeds if possible)
16	LNK-SQL-LIVE-1	    verify records pushed updated as expected in SMI/AFCO Reporting 
17	SOP	                RESUME feeds to SMI/AFCO Reporting
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
/******    STEP 2) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblOrder_20210910 from [SMI Reporting].dbo.tblOrder      --   519,611
select * into [SMIArchive].dbo.BU_AFCO_tblOrder_20210910 from [AFCOReporting].dbo.tblOrder --    79,115

-- DROP TABLE [SMIArchive].dbo.BU_tblOrder_20200207
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblOrder_20200207

/*************************************************************************************************************/
/******   STEP 3) DISABLE SSA job "JobAwsImportData"   ON    [dw.speedway2.com].SMiReportingRawData    *******/


-- STEPS 4-6 ON AWS script


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
    dtWebRejectReleaseDate datetime,
    ixWebRejectReleaseTime int,
    sWebRejectReleaseUser varchar(10),
    dtWebHeldReleaseDate datetime,
    ixWebHeldReleaseTime int,
    sWebHeldReleaseUser varchar(10)
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
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [SMI Reporting].dbo.tblOrder ADD
    dtWebRejectReleaseDate datetime,
    ixWebRejectReleaseTime int,
    sWebRejectReleaseUser varchar(10),
    dtWebHeldReleaseDate datetime,
    ixWebHeldReleaseTime int,
    sWebHeldReleaseUser varchar(10)
GO
ALTER TABLE [SMI Reporting].dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN


-- SELECT TOP 1 * FROM dbo.tblOrderLocation

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
ALTER TABLE [AFCOReporting].dbo.tblOrder ADD
    dtWebRejectReleaseDate datetime,
    ixWebRejectReleaseTime int,
    sWebRejectReleaseUser varchar(10),
    dtWebHeldReleaseDate datetime,
    ixWebHeldReleaseTime int,
    sWebHeldReleaseUser varchar(10)
GO
ALTER TABLE [AFCOReporting].dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 9/9/2021 4:30:44 PM ******/
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
    @mMarketplaceSellingFee money,
    @flgHighPriority tinyint,
    @ixOptimalShipLocation tinyint,
    @ixMasterOrderNumber varchar(32),
	@flgSplitOrder tinyint,
    @flgBackorder  tinyint,
    @ixShippedTime int,
	@sShippingInstructions varchar(50),
    @ixCancellationReasonCode int,
    @dtWebRejectReleaseDate datetime,
    @ixWebRejectReleaseTime int,
    @sWebRejectReleaseUser varchar(10),
    @dtWebHeldReleaseDate datetime,
    @ixWebHeldReleaseTime int,
    @sWebHeldReleaseUser varchar(10)
AS /*
      EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit'         ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='ixCancellationReasonCode'   ,@Value4=@ixCancellationReasonCode, 
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
                mPaymentProcessingFee = (CASE WHEN @sOrderStatus = 'Shipped' AND (@mMerchandise+@mShipping+@mTax-@mCredits) > 0 THEN   -- WHEN fees change update in BOTH locations in this proc
                                          (CASE WHEN @sMethodOfPayment= 'VISA' then 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)  -- Payment Processing fees update 6-20-2019
                                                WHEN @sMethodOfPayment= 'AMEX' then 0.0335 *(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'DISCOVER' then 0.0211*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'MASTERCARD' then 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment in ('PP-AUCTION','EBAYPAY') then (CASE WHEN @dtOrderdate < '10/18/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                              --WHEN @dtOrderdate < '06/01/21' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                              WHEN @dtOrderdate < '08/01/20' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                               else 0 -- per SMIHD-22299
                                                                                          end)
                                                WHEN @sMethodOfPayment= 'PAYPAL' then (CASE WHEN @dtOrderdate < '10/10/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                            else (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15 -- corrected per SMIHD-22245
                                                                                          -- else .30 -- per SMIHD-21461
                                                                                      end)
                                                else 0 
                                                end)
                                ELSE 0
                                end), -- mPaymentProcessingFee
              /*   mMarketplaceSellingFee = (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN @sSourceCodeGiven like '%EBAY%' then 0.07*(@mMerchandise+@mShipping)
                                                        WHEN @sSourceCodeGiven like 'AMAZON%' then 0.12*(@mMerchandise+@mShipping)
                                                        WHEN @sSourceCodeGiven = 'WALMART' then 0.12*(@mMerchandise+@mShipping)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end),  -- mMarketplaceSellingFee,
                */
                mMarketplaceSellingFee = @mMarketplaceSellingFee,
                flgHighPriority = @flgHighPriority,
                ixOptimalShipLocation = @ixOptimalShipLocation,
                ixMasterOrderNumber = @ixMasterOrderNumber,
	            flgSplitOrder = @flgSplitOrder,
                flgBackorder = @flgBackorder,
                ixShippedTime = @ixShippedTime,
                sShippingInstructions = @sShippingInstructions,
                ixCancellationReasonCode = @ixCancellationReasonCode,     
                dtWebRejectReleaseDate = @dtWebRejectReleaseDate,
                ixWebRejectReleaseTime = @ixWebRejectReleaseTime,
                sWebRejectReleaseUser = @sWebRejectReleaseUser,
                dtWebHeldReleaseDate = @dtWebHeldReleaseDate,
                ixWebHeldReleaseTime = @ixWebHeldReleaseTime,
                sWebHeldReleaseUser = @sWebHeldReleaseUser                   
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixCancellationReasonCode'   ,@Value4=@ixCancellationReasonCode, 
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
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee, flgHighPriority, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder, ixShippedTime, sShippingInstructions,
                ixCancellationReasonCode, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser)
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
                                          (CASE WHEN @sMethodOfPayment= 'VISA' THEN 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'AMEX' THEN 0.0335 *(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'DISCOVER' THEN 0.0211*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'MASTERCARD' THEN 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment in ('PP-AUCTION','EBAYPAY') then (CASE WHEN @dtOrderdate < '10/18/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                        --WHEN @dtOrderdate < '06/01/21' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                              WHEN @dtOrderdate < '08/01/20' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                               else 0 -- per SMIHD-22299
                                                                                          end)
                                                WHEN @sMethodOfPayment= 'PAYPAL' then (CASE WHEN @dtOrderdate < '10/10/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                            else (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15 -- corrected per SMIHD-22245
                                                                                          -- else .30 -- per SMIHD-21461
                                                                                      end)
                                                else 0 
                                                end)
                                ELSE 0
                                end),-- mPaymentProcessingFee
                /*(CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven = 'WALMART' THEN 0.12*(@mMerchandise+@mShipping)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end),-- mMarketplaceSellingFee
                */
                @mMarketplaceSellingFee,
                @flgHighPriority, @ixOptimalShipLocation, @ixMasterOrderNumber, @flgSplitOrder, @flgBackorder, @ixShippedTime, @sShippingInstructions,
                @ixCancellationReasonCode, @dtWebRejectReleaseDate, @ixWebRejectReleaseTime, @sWebRejectReleaseUser, @dtWebHeldReleaseDate, @ixWebHeldReleaseTime, @sWebHeldReleaseUser)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixCancellationReasonCode'   ,@Value4=@ixCancellationReasonCode,  
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END












USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 9/9/2021 4:38:32 PM ******/
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
    @mMarketplaceSellingFee money, -- calculated.  @ not needed	
    @flgHighPriority tinyint,
    @ixOptimalShipLocation tinyint,
    @ixMasterOrderNumber varchar(32),
	@flgSplitOrder tinyint,
    @flgBackorder  tinyint,
    @ixShippedTime int,
	@sShippingInstructions varchar(50),
    @ixCancellationReasonCode int,
    @dtWebRejectReleaseDate datetime,
    @ixWebRejectReleaseTime int,
    @sWebRejectReleaseUser varchar(10),
    @dtWebHeldReleaseDate datetime,
    @ixWebHeldReleaseTime int,
    @sWebHeldReleaseUser varchar(10)
AS
   /*
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixCancellationReasonCode'   ,@Value4=@ixCancellationReasonCode,
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
                mPaymentProcessingFee = (CASE WHEN @sOrderStatus = 'Shipped' AND (@mMerchandise+@mShipping+@mTax-@mCredits) > 0 THEN   -- WHEN fees change update in BOTH locations in this proc
                                          (CASE WHEN @sMethodOfPayment= 'VISA' then 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)  -- Payment Processing fees update 6-20-2019
                                                WHEN @sMethodOfPayment= 'AMEX' then 0.0335 *(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'DISCOVER' then 0.0211*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'MASTERCARD' then 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment in ('PP-AUCTION','EBAYPAY') then (CASE WHEN @dtOrderdate < '10/18/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                              --WHEN @dtOrderdate < '06/01/21' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                              WHEN @dtOrderdate < '08/01/20' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                               else 0 -- per SMIHD-22299
                                                                                          end)
                                                WHEN @sMethodOfPayment= 'PAYPAL' then (CASE WHEN @dtOrderdate < '10/10/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                            WHEN @dtOrderdate < '06/01/21' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                           else .30 -- per SMIHD-21461
                                                                                      end)
                                                else 0 
                                                end)
                                ELSE 0
                                end), -- mPaymentProcessingFee
                 mMarketplaceSellingFee = @mMarketplaceSellingFee,
/*                 mMarketplaceSellingFee = (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN @sSourceCodeGiven like '%EBAY%' then 0.07*(@mMerchandise+@mShipping)
                                                        WHEN @sSourceCodeGiven like 'AMAZON%' then 0.12*(@mMerchandise+@mShipping)
                                                        WHEN @sSourceCodeGiven = 'WALMART' then 0.12*(@mMerchandise+@mShipping)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end),  -- mMarketplaceSellingFee,
*/
                flgHighPriority = @flgHighPriority,
                ixOptimalShipLocation = @ixOptimalShipLocation,
                ixMasterOrderNumber = @ixMasterOrderNumber,
	            flgSplitOrder = @flgSplitOrder,
                flgBackorder = @flgBackorder,
                ixShippedTime = @ixShippedTime,
                sShippingInstructions = @sShippingInstructions,
                ixCancellationReasonCode = @ixCancellationReasonCode,     
                dtWebRejectReleaseDate = @dtWebRejectReleaseDate,
                ixWebRejectReleaseTime = @ixWebRejectReleaseTime,
                sWebRejectReleaseUser = @sWebRejectReleaseUser,
                dtWebHeldReleaseDate = @dtWebHeldReleaseDate,
                ixWebHeldReleaseTime = @ixWebHeldReleaseTime,
                sWebHeldReleaseUser = @sWebHeldReleaseUser          
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixCancellationReasonCode'   ,@Value4=@ixCancellationReasonCode,
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
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee, flgHighPriority, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder, ixShippedTime, sShippingInstructions,
                ixCancellationReasonCode, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser)
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
                                          (CASE WHEN @sMethodOfPayment= 'VISA' THEN 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'AMEX' THEN 0.0335 *(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'DISCOVER' THEN 0.0211*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'MASTERCARD' THEN 0.0207*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment in ('PP-AUCTION','EBAYPAY') then (CASE WHEN @dtOrderdate < '10/18/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                        --WHEN @dtOrderdate < '06/01/21' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                                              WHEN @dtOrderdate < '08/01/20' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                               else 0 -- per SMIHD-22299
                                                                                          end)
                                                WHEN @sMethodOfPayment= 'PAYPAL' then (CASE WHEN @dtOrderdate < '10/10/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                            WHEN @dtOrderdate < '06/01/21' then (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                           else .30 -- per SMIHD-21461
                                                                                      end)
                                                else 0 
                                                end)
                                ELSE 0
                                end),-- mPaymentProcessingFee
                @mMarketplaceSellingFee,
                /*(CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven = 'WALMART' THEN 0.12*(@mMerchandise+@mShipping)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end),-- mMarketplaceSellingFee
                */
                 @flgHighPriority, @ixOptimalShipLocation, @ixMasterOrderNumber, @flgSplitOrder, @flgBackorder, @ixShippedTime,@sShippingInstructions,
                 @ixCancellationReasonCode, @dtWebRejectReleaseDate, @ixWebRejectReleaseTime, @sWebRejectReleaseUser, @dtWebHeldReleaseDate, @ixWebHeldReleaseTime, @sWebHeldReleaseUser)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='ixCancellationReasonCode'   ,@Value4=@ixCancellationReasonCode,
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END





/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/


    --SMI TEST DATA
        SELECT ixOrder, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder in (####)
        ORDER BY dtDateLastSOPUpdate, T.chTime
            
    --AFCO TEST DATA
        SELECT ixOrder, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder in (####)
        ORDER BY dtDateLastSOPUpdate, T.chTime


/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
        
        /*********   SMI TEST DATA       *******/
        SELECT ixOrder, dtOrderDate, S.ixOrderTime , dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE dtWebRejectReleaseDate is NOT NULL
            or ixWebRejectReleaseTime is NOT NULL
            or sWebRejectReleaseUser is NOT NULL
            or dtWebHeldReleaseDate is NOT NULL
            or ixWebHeldReleaseTime is NOT NULL
            or sWebHeldReleaseUser is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime

        
        SELECT ixOrder, dtOrderDate, S.ixOrderTime   ,dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder in ('10280961','10300265','10335669')

        SELECT ixOrder, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder in ('10280961','10300265','10335669')

        SELECT ixOrder, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [SMI Reporting].dbo.tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE dtDateLastSOPUpdate = '09/10/2021'
            and ixTimeLastSOPUpdate >= 44400 -- 938601

       /*********   AFCO TEST DATA  *********/
        SELECT ixOrder, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE dtWebRejectReleaseDate is NOT NULL
            or ixWebRejectReleaseTime is NOT NULL
            or sWebRejectReleaseUser is NOT NULL
            or dtWebHeldReleaseDate is NOT NULL
            or ixWebHeldReleaseTime is NOT NULL
            or sWebHeldReleaseUser is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime

                SELECT ixOrder, dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE dtDateLastSOPUpdate = '09/10/2021'
            and ixTimeLastSOPUpdate >= 44400 -- 938601

select * from tblTime where chTime like '12:18:%'

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
    select * from tblErrorCode where sDescription like '%tblOrder%'
    --  1141	Failure to update tblOrder

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1141'
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	05-21-21	4
    SMI Reporting	02-04-21	2

*/



        SELECT ixOrder, dtOrderDate, S.ixOrderTime , dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        INTO #WebRejOrHeld
        FROM tblOrder S
            left join tblTime T on S.ixOrderTime = T.ixTime
        WHERE dtWebRejectReleaseDate is NOT NULL
            or ixWebRejectReleaseTime is NOT NULL
            or sWebRejectReleaseUser is NOT NULL
            or dtWebHeldReleaseDate is NOT NULL
            or ixWebHeldReleaseTime is NOT NULL
            or sWebHeldReleaseUser is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime


select ixOrder, dtOrderDate, ixOrderTime, dtWebRejectReleaseDate, ixWebRejectReleaseTime,
    (ixWebRejectReleaseTime-ixOrderTime) 'Delay'
from #WebRejOrHeld
where dtWebRejectReleaseDate is NOT NULL -- 788
and dtOrderDate = dtWebRejectReleaseDate -- 615
order by (ixWebRejectReleaseTime-ixOrderTime)




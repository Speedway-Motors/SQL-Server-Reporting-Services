-- SMIHD-17297 - add sShippingInstructions to tblOrder

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 110

/*  TABLE: tblOrder
    CHANGES TO BE MADE: add sShippingInstructions varchar(50) (NULL ALLOWED)
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

select * into [SMIArchive].dbo.BU_tblOrder_20200220 from [SMI Reporting].dbo.tblOrder      --    7,135,906
select * into [SMIArchive].dbo.BU_AFCO_tblOrder_20200220 from [AFCOReporting].dbo.tblOrder --     432,764

-- DROP TABLE [SMIArchive].dbo.BU_tblOrder_20200207
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblOrder_20200207


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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrder ADD
    sShippingInstructions varchar(50)
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
    sShippingInstructions  varchar(50)
GO
ALTER TABLE [SMI Reporting].dbo.tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

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
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [AFCOReporting].dbo.tblOrder ADD
    sShippingInstructions varchar(50)
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
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 4/1/2020 1:02:07 PM ******/
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
    @flgBackorder  tinyint,
    @ixShippedTime int,
	@sShippingInstructions varchar(50)
AS /*
      EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit'         ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate' ,@Value3=@dtOrderDate,
                @Field4='sShippingInstructions'   ,@Value4=@sShippingInstructions, 
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
                                                WHEN @sMethodOfPayment= 'PP-AUCTION' then (CASE WHEN @dtOrderdate < '10/18/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                               else (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                          end)
                                                WHEN @sMethodOfPayment= 'PAYPAL' then (CASE WHEN @dtOrderdate < '10/10/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                           else (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                      end)
                                                else 0 
                                                end)
                                ELSE 0
                                end), -- mPaymentProcessingFee
                 mMarketplaceSellingFee = (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN @sSourceCodeGiven like '%EBAY%' then 0.07*(@mMerchandise+@mShipping)
                                                        WHEN @sSourceCodeGiven like 'AMAZON%' then 0.12*(@mMerchandise+@mShipping)
                                                        WHEN @sSourceCodeGiven = 'WALMART' then 0.12*(@mMerchandise+@mShipping)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end),  -- mMarketplaceSellingFee,
                flgHighPriority = @flgHighPriority,
                ixOptimalShipLocation = @ixOptimalShipLocation,
                ixMasterOrderNumber = @ixMasterOrderNumber,
	            flgSplitOrder = @flgSplitOrder,
                flgBackorder = @flgBackorder,
                ixShippedTime = @ixShippedTime,
                sShippingInstructions = @sShippingInstructions                           
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='sShippingInstructions'   ,@Value4=@sShippingInstructions, 
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
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee, flgHighPriority, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder, ixShippedTime, sShippingInstructions)
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
                                                WHEN @sMethodOfPayment= 'PP-AUCTION' then (CASE WHEN @dtOrderdate < '10/18/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                               else (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                          end)
                                                WHEN @sMethodOfPayment= 'PAYPAL' then (CASE WHEN @dtOrderdate < '10/10/19'  then(0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                           else (0.0180*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                                                      end)
                                                else 0 
                                                end)
                                ELSE 0
                                end),-- mPaymentProcessingFee
                (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven = 'WALMART' THEN 0.12*(@mMerchandise+@mShipping)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end),-- mMarketplaceSellingFee
                @flgHighPriority, @ixOptimalShipLocation, @ixMasterOrderNumber, @flgSplitOrder, @flgBackorder, @ixShippedTime, @sShippingInstructions)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='sShippingInstructions'   ,@Value4=@sShippingInstructions,  
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END








USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 4/1/2020 1:06:23 PM ******/
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
    @flgBackorder  tinyint,
    @ixShippedTime int,
	@sShippingInstructions varchar(50)
AS
   /*
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='sShippingInstructions'   ,@Value4=@sShippingInstructions,
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
                 mPaymentProcessingFee = (CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN   -- WHEN fees change update in BOTH locations in this proc
                                          (CASE WHEN sMethodOfPayment= 'VISA' then 0.0207*(mMerchandise+mShipping+mTax-mCredits)  -- Payment Processing fees update 6-20-2019
                                                WHEN sMethodOfPayment= 'AMEX' then 0.0335 *(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'DISCOVER' then 0.0211*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'MASTERCARD' then 0.0207*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PP-AUCTION' then (0.0195*(mMerchandise+mShipping+mTax-mCredits))+.15
                                                WHEN sMethodOfPayment= 'PAYPAL' then (0.0195*(mMerchandise+mShipping+mTax-mCredits))+.15
                                                else 0 
                                                end)
                                ELSE 0
                                end), -- mPaymentProcessingFee
                 mMarketplaceSellingFee = (CASE WHEN sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping)
                                                        WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping)
                                                        WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end),  -- mMarketplaceSellingFee,
                flgHighPriority = @flgHighPriority,
                ixOptimalShipLocation = @ixOptimalShipLocation,
                ixMasterOrderNumber = @ixMasterOrderNumber,
	            flgSplitOrder = @flgSplitOrder,
                flgBackorder = @flgBackorder,
                ixShippedTime = @ixShippedTime,
                sShippingInstructions = @sShippingInstructions 
                where ixOrder = @ixOrder
            END TRY

	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='sShippingInstructions'   ,@Value4=@sShippingInstructions,
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
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee, flgHighPriority, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder, ixShippedTime, sShippingInstructions)
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
                                                WHEN @sMethodOfPayment= 'PP-AUCTION' THEN (0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                WHEN @sMethodOfPayment= 'PAYPAL' THEN (0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits))+.15
                                                else 0 
                                                end)
                                ELSE 0
                                end),-- mPaymentProcessingFee
                (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping)
                                                WHEN @sSourceCodeGiven = 'WALMART' THEN 0.12*(@mMerchandise+@mShipping)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end),-- mMarketplaceSellingFee
                 @flgHighPriority, @ixOptimalShipLocation, @ixMasterOrderNumber, @flgSplitOrder, @flgBackorder, @ixShippedTime,@sShippingInstructions)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='sBusinessUnit' ,@Value2=@sBusinessUnit,
                @Field3='dtOrderDate'   ,@Value3=@dtOrderDate,
                @Field4='sShippingInstructions'   ,@Value4=@sShippingInstructions,
                @Field5='sOrderChannel' ,@Value5=@sOrderChannel
        END CATCH          
	END









/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT ixOrder, sShippingInstructions  ,sOrderStatus, iShipMethod,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblOrder 
        where --ixOrder in ('')
             sShippingInstructions  is NOT NULL
        order by ixOrder, sShippingInstructions 



        SELECT sShippingInstructions, sOrderTaker, count(ixOrder) 'Orders'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblOrder 
        where --ixOrder in ('')
             sShippingInstructions in ('0','1','2','3','4','5','6','7','8','9','NONE','Y','N')
        group by sShippingInstructions, sOrderTaker
        having count(ixOrder) > 20
        order by sOrderTaker


        order by sOrderTaker
        
                                                
        SELECT sShippingInstructions, count(*) 'OrderCount'
                 --   FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblOrder 
        where --ixOrder in ('')
             sShippingInstructions  is NOT NULL
        group by sShippingInstructions
        order by  count(*) desc

    --AFCO TEST DATA
        SELECT ixOrder, sShippingInstructions  ,sOrderStatus,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblOrder 
        where --ixOrder in ('')
             sShippingInstructions  is NOT NULL
        order by ixOrder, sShippingInstructions 


        SELECT sShippingInstructions, count(*) 'OrderCount'
                 --   FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblOrder 
        where --ixOrder in ('')
             sShippingInstructions  is NOT NULL
        group by sShippingInstructions
        order by  count(*) desc
/*
select * from tblEmployee where ixEmployee = 'JJM'

*/

SELECT * FROM tblTime where ixTime = 

/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT  ixOrder, sShippingInstructions ,sOrderStatus,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblOrder 
        where --ixOrder in ( '8464588-1', '8827980')
            sShippingInstructions  is NOT NULL
        order by ixOrder, sShippingInstructions  desc
                                        
        /*
        ixOrder	sShippingInstructions 	LastSOPUpdate	TimeLastSOPUpdate
        9390500	35511	2020.01.28	39575
        */


        SELECT  sShippingInstructions, count(*) 'SKUCnt'
        from [SMI Reporting].dbo.tblOrder 
        where --ixOrder in ( '8464588-1', '8827980')
            sShippingInstructions  is NOT NULL
        GROUP BY sShippingInstructions
        ORDER BY sShippingInstructions




       /*********   AFCO TEST DATA  *********/
        SELECT  ixOrder, sShippingInstructions ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblOrder 
        where --ixOrder in ( '8464588-1', '8827980')
            sShippingInstructions  is NOT NULL
        order by ixOrder, sShippingInstructions  desc
        /*
        ixOrder	sShippingInstructions 	LastSOPUpdate	TimeLastSOPUpdate

        */

        

        SELECT  sShippingInstructions, count(*) 'SKUCnt'
        from [AFCOReporting].dbo.tblOrder 
        where --ixOrder in ( '8464588-1', '8827980')
            sShippingInstructions  is NOT NULL
        GROUP BY sShippingInstructions
        ORDER BY sShippingInstructions

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
    --  1141	Failure to update tblOrder.

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1141'
      and dtDate >=  DATEADD(month, -11, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-28-20	3
    SMI Reporting	05-20-19	1

*/

SELECT sShippingInstructions , FORMAT(count(*),'###,###') 'ORDERcount'
FROM tblOrder
-- WHERE sShippingInstructions  is NOT NULL
GROUP BY sShippingInstructions 
order by sShippingInstructions 












SELECT sShippingInstructions , FORMAT(count(*),'###,###') 'BOXcount'
FROM [SMI Reporting].dbo.tblOrder 
WHERE flgDeletedFromSOP = 0 
   -- and sShippingInstructions  is NOT NULL
GROUP BY sShippingInstructions 
order by sShippingInstructions
/*
sPackage
Type	SKUcount    @1:26
NULL	11,170
BOX	    218
ENV	    7
NA	    461,596
NEW	    2
SLAPR	3,955
*/

select ixOrder, dtCreateDate from tblOrder
where ixOrder NOT IN (select ixOrder from tblSnapshotSKU where ixDate = 19031)
and flgDeletedFromSOP = 0
order by dtCreateDate

BEGIN TRAN

    UPDATE tblOrder
    set sShippingInstructions = NULL
    where ixOrder between 'UP119850' and 'UP119875'


ROLLBACK TRAN


select * from tblOrder where flgDeletedFromSOP = 0 
    and sShippingInstructions  is NULL



select ixOrder, sShippingInstructions ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
from tblOrder
where ixOrder in ('103A184B1SS','10620231','10620231XHD','10640015','10640017','10680100LWN','10680101NP','10680103N','10680104N','10680120N','10680144-S-NA-Y','10680184NDP','10680184NDPU','10680185NDP','10680202N','10680205','106802051','10680249N','1068026810','10680283NDP','10680404FAN','10681164-S-NA-N','1132070','1132276','113253','113345','113550','113594','113673','113679','113681','113696','113709','113856','113913','113996')

select * from tblTime where ixTime = 39738





USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 10/18/2021 4:39:49 PM ******/
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
                mPaymentProcessingFee = (CASE WHEN ixOrderDate > 18994 THEN --	'01/01/2020' 
                                            (CASE WHEN @sOrderStatus = 'Shipped' AND (@mMerchandise+@mShipping+@mTax-@mCredits) > 0 THEN   -- WHEN fees change update in BOTH locations in this proc
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
                (CASE WHEN ixOrderDate > 18994 THEN --	'01/01/2020' 
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







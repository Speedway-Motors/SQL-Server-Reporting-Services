-- SMIHD-14895 - Adjust Marketplace Fee and Payment Processing Fee Calcs Stored on tblOrder

/**** PRE & POST TOTALS so Alaina can verify Tableau updated ********/

    -- PaymentProcessingFee
    select sMethodOfPayment, FORMAT(sum(mPaymentProcessingFee),'###,###.##') TotPmtProcFee
    from tblOrder O
        left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    where sMethodOfPayment in ('PP-AUCTION','PAYPAL')
        and dtInvoiceDate between '01/01/2018' and '12/31/2018' --  <-- Change date to previous day
    group by sMethodOfPayment
    order by sMethodOfPayment
    /*
    BEFORE UPDATES
    sMethodOfPayment	TotPmtProcFee
    PAYPAL	            285,656.52
    PP-AUCTION	        232,324.44

    AFTER UPDATES       
                        TotPmtProcFee
    PAYPAL	            298,554.03
    PP-AUCTION	        249,192.29
    */



    -- MarketplaceSellingFee
    select count(O.ixOrder) 'OrderCount', BU.sBusinessUnit, FORMAT(sum(mMarketplaceSellingFee),'###,###.##') TotMPSellingFee
    from tblOrder O
        left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    where dtInvoiceDate between '01/01/2018' and '12/31/2018'--  <-- Change date to previous day
    and (sSourceCodeGiven like '%EBAY%'
         or sSourceCodeGiven like 'AMAZON%'
         or sSourceCodeGiven = 'WALMART')
    and BU.sBusinessUnit = 'MKT'
    group by BU.sBusinessUnit
    order by BU.sBusinessUnit
    /*
    BEFORE UPDATES
    OrderCount	sBusinessUnit	TotMPSellingFee
    160,613	    MKT	            1,351,205.49

    AFTER UPDATES
    OrderCount	sBusinessUnit	TotMPSellingFee
    160613	    MKT	            1,343,307.66

    */


/****   PREP AND TABLE UPDATES  ******/
-- Prep table that the updates will populate from 
-- DROP TABLE #NEW_PaymentProcess_and_MPSelling_Fees
SELECT O.ixOrder, O.sSourceCodeGiven, O.sMethodOfPayment, O.mMarketplaceSellingFee, O.mPaymentProcessingFee, -- 249,133
    (CASE WHEN sOrderStatus = 'Shipped' THEN 
                (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping)
                    WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping)
                    WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping)
                    else mMarketplaceSellingFee 
                end)
        ELSE mMarketplaceSellingFee
    end) 'NEWMarketplaceSellingFee',
    (CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN   
                                              (CASE WHEN sMethodOfPayment= 'PP-AUCTION' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)+.15
                                                    WHEN sMethodOfPayment= 'PAYPAL' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)+.15
                                                    else mPaymentProcessingFee 
                                                    end) 
                                               ELSE mPaymentProcessingFee
    end)'NEWPaymentProcessingFee'
    , O.sOrderStatus
into #NEW_PaymentProcess_and_MPSelling_Fees
FROM tblOrder O
WHERE dtInvoiceDate between '01/01/2018' and '12/31/2018'
    AND ((sSourceCodeGiven like '%EBAY%'
            or sSourceCodeGiven like 'AMAZON%'
            or sSourceCodeGiven = 'WALMART'
          )
         OR
         sMethodOfPayment in ('PP-AUCTION','PAYPAL')
         )


-- REMOVE records if new calculations don't change the values
DELETE from #NEW_PaymentProcess_and_MPSelling_Fees
where mPaymentProcessingFee = NEWPaymentProcessingFee -- 41,213
    and mMarketplaceSellingFee = NEWMarketplaceSellingFee

SELECT COUNT(*)
FROM #NEW_PaymentProcess_and_MPSelling_Fees
SELECT TOP 42000 * from #NEW_PaymentProcess_and_MPSelling_Fees where ixOrder > '8574922' order by ixOrder


--Summary of before and after values
-- both totals decrease approx $48k
select FORMAT(count(ixOrder),'###,###.##') 'OrderCount',
      FORMAT(SUM(mPaymentProcessingFee),'###,###.##') 'OrigPPfee',
      FORMAT(SUM(NEWPaymentProcessingFee),'###,###.##') 'NewPPfee',
      FORMAT(SUM(mMarketplaceSellingFee),'###,###.##') 'OrigMPSfee',
      FORMAT(SUM(NEWMarketplaceSellingFee),'###,###.##') 'NewMPSfee'
from #NEW_PaymentProcess_and_MPSelling_Fees
where ixOrder between '7000071' and '8999929' -- entire batch
    -- ixOrder between '7000071' and '7427595' -- batch 1 42k
    -- ixOrder between '7427596'   and '7783785' -- batch 2 42k
    -- ixOrder between '7783786' and '8138905' -- batch 3 42k
    -- ixOrder between '8138906' and '8574922' -- batch 4 42k
  --  ixOrder between '8574923' and '8999929' -- batch 5of5 39,920
/*
OrderCount  OrigPPfee	NewPPfee	OrigMPSfee	NewMPSfee
207,920	    518,095.28	547,861.52  907,859.39  899,895.13

batch1
132,686.98	118,033.32	290,961.38	    277,485.09  -- batch 1
131,360.84	119,116.72	295,347.52	    281,965.94  -- batch 2    
*/

select FORMAT(SUM(mPaymentProcessingFee),'###,###.##') 'TotPPfee',
     FORMAT(SUM(mMarketplaceSellingFee),'###,###.##') 'TotMPSfee'
from tblOrder
where -- ixOrder < '8575968'  -- batch 1
    --ixOrder between '8301572'   and '8575968' -- batch 2
    -- ixOrder between '8575969' and '8850000' -- batch 3
     ixOrder >'8850001' -- batch 4 of 4

/*
TotPPfee	    TotMPSfee
21,914,527.15	3,631,607.1  -- batch 1
818,423.21	    556,576.03  -- batch 2
811,568.71	    556,605.38  -- batch 3
454,418.52	    300,360.44  -- batch 4
*/


select ixOrder from #NEW_PaymentProcess_and_MPSelling_Fees
where ixOrder = '8000564'
/*
NEWMarketplaceSellingFee	NEWPaymentProcessingFee
13.999300	4.25455500
*/

select ixOrder, sSourceCodeGiven, sMethodOfPayment, mMarketplaceSellingFee, mPaymentProcessingFee
from tblOrder
where ixOrder = '8000564'
/*  BEFORE UPDATE
ixOrder	sSourceCodeGiven	sMethodOfPayment	mMarketplaceSellingFee	mPaymentProcessingFee
8000564	EBAY	            PP-AUCTION	        14.7343	                5.2623

AFTER 
8000564	EBAY	            PP-AUCTION	        13.9993	                4.2546
*/

-- backup tblOrder
--SELECT * INTO [SMIArchive].dbo.BU_tblOrder_20190829 from tblOrder -- 6,721,632



BEGIN TRAN

    update O
    set O.mMarketplaceSellingFee = NF.NEWMarketplaceSellingFee,
       mPaymentProcessingFee = NF.NEWPaymentProcessingFee
    from tblOrder O
     join #NEW_PaymentProcess_and_MPSelling_Fees NF on O.ixOrder = NF.ixOrder 
    WHERE 
    -- O.ixOrder between '7000071' and '7427595' -- batch 1 42k     @10:03
    -- O.ixOrder between '7427596'   and '7783785' -- batch 2 42k   @10:16
    -- O.ixOrder between '7783786' and '8138905' -- batch 3 42k     @10:30
    -- O.ixOrder between '8138906' and '8574922' -- batch 4 42k     @10:47
      O.ixOrder between '8574923' and '8999929' -- batch 5of5 39,920 @10:51

ROLLBACK TRAN


/* single order update test
BEGIN TRAN

    update O
    set O.mMarketplaceSellingFee = 14.7343,
       mPaymentProcessingFee =5.2623
    from tblOrder O
    WHERE O.ixOrder = '8000564'

ROLLBACK TRAN



select * from #NEW_PaymentProcess_and_MPSelling_Fees
where mPaymentProcessingFee = NEWPaymentProcessingFee -- 131,003
and mMarketplaceSellingFee = NEWMarketplaceSellingFee
ORDER BY mPaymentProcessingFee

 -- datatype money goes up to 4 decimal places e.g. 5.1017
select distinct mPaymentProcessingFee
from tblOrder
order by mPaymentProcessingFee


select * from tblBusinessUnit
/*  Business
BU	Unit    Description
=== ===     ============
101	ICS	    Inter-company sale
102	INT	    Intra-company sale
103	EMP	    Employee
104	PRS	    Pro Racer
105	MRR	    Mr Roadster
106	RETLNK	Retail, Lincoln
107	WEB	    Website
108	GS	    Garage Sale
109	MKT	    Marketplaces
110	PHONE	CX Orders
111	RETTOL	Retail, Tolleson
112	UK	    Unknown
*/

*/




USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrder]    Script Date: 8/28/2019 2:12:36 PM ******/
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
    @flgHighPriority tinyint
	
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
                flgHighPriority = @flgHighPriority                                        
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
                ixBusinessUnit, mPaymentProcessingFee, mMarketplaceSellingFee, flgHighPriority)
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
                @flgHighPriority)
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










-- AWS Queue
-- DROP TABLE #RefillAWSQueue
select ixOrder into #RefillAWSQueue from #NEW_PaymentProcess_and_MPSelling_Fees -- 175,719

INSERT INTO #RefillAWSQueue
select ixOrder from tblOrder    -- 9,075
where dtDateLastSOPUpdate >= '08/27/2019' -- 184,783
AND ixOrder NOT IN (select ixOrder from #RefillAWSQueue)

select count(*) from #RefillAWSQueue

select * from #RefillAWSQueue
order by ixOrder

select count(*) from #RefillAWSQueue
WHERE 
ixOrder between '0' and '8263155' -- 49000
 ixOrder between '8263156' and '8528838' -- 48000
 ixOrder between '8528839' and '8791961' -- 47000
 ixOrder between '8791962' and 'Q1940292' -- 40794

 BEGIN TRAN

update O
set O.ixOrder = RF.ixOrder
from  tblOrder O
 join #RefillAWSQueue RF on O.ixOrder = RF.ixOrder
WHERE RF.ixOrder 
--between '0' and '8263155' --'8263155' -- 2:37
--between '8263156' and '8528838' -- 48000 -- 2:50
-- between '8528839' and '8791961' -- 47000 -- 3:02
between '8791962' and 'Q1940292' -- 40794 -- 3:11


 ROLLBACK TRAN


 update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX



 update O
set O.ixOrder = RF.ixOrder
from  tblOrder O
 join #RefillAWSQueue RF on O.ixOrder = RF.ixOrder







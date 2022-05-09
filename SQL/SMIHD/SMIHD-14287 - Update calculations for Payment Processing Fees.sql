-- SMIHD-14287 - Update calculations for Payment Processing Fees

-- BACKUP THE DATA
SELECT * into [SMIArchive].dbo.BU_tblOrder_20190620 -- 6,572,365
FROM tblOrder

SELECT * into [SMIArchive].dbo.BU_AFCO_tblOrder_20190620 -- 6,572,365
FROM [AFCOReporting].dbo.tblOrder


-- BEFORE & AFTER results
-- run on AWS also to cofirm all updates made it there (verified)
SELECT FORMAT(SUM(mPaymentProcessingFee),'$###,###.####') 'TotProcessingFees', FORMAT(COUNT(*),'###,###') 'OrderCnt'
FROM tblOrder O
WHERE dtInvoiceDate between '03/30/2019' and '06/20/2019'  -- 667901.0126
    AND mPaymentProcessingFee > 0
/*  
             SMI
TotProcessing
Fees	        Updates OrderCnt
=============   ======= ========
$667,901.2512   BEFORE  156,483
$706,098.6767	AFTER   156,483


             AFCO
TotProcessing
Fees	        Updates OrderCnt
=============   ======= ========
$55,274.1509	BEFORE  3,923
$57,090.0289	AFTER   3,923
*/


-- small test batch first
SELECT SUM(mPaymentProcessingFee) TotProcessingFees, COUNT(*) Orders
FROM tblOrder O
WHERE dtInvoiceDate between '03/30/2019' and '04/01/2019'  -- 667901.0126
    AND mPaymentProcessingFee > 0
/*
TotProcessing
Fees	                     Orders
$25,523.9008  BEFORE UPDATES 6,108    
$27,116.2649  AFTER UPDATES  6,108
*/



-- how many total records need to be updated?
SELECT COUNT(*) -- SUM(mPaymentProcessingFee) TotalProcessingFee
FROM tblOrder O
WHERE dtInvoiceDate between '03/30/2019' and '06/20/2019'  -- $667,901.1219     184,597
    AND mPaymentProcessingFee > 0 -- 156,483

-- manually pushing the orders to refresh from SOP would take approx 44 hours from SOP.
-- will need to updated the fees manually with SQL



-- TABLE UPDATES
BEGIN TRANSACTION

    UPDATE tblOrder
        SET mPaymentProcessingFee =
                (CASE WHEN sMethodOfPayment= 'VISA' then 0.0207*(mMerchandise+mShipping+mTax-mCredits)  -- Payment Processing fees update 6-20-2019
                    WHEN sMethodOfPayment= 'AMEX' then 0.0335 *(mMerchandise+mShipping+mTax-mCredits)
                    WHEN sMethodOfPayment= 'DISCOVER' then 0.0211*(mMerchandise+mShipping+mTax-mCredits)
                    WHEN sMethodOfPayment= 'MASTERCARD' then 0.0207*(mMerchandise+mShipping+mTax-mCredits)
                    WHEN sMethodOfPayment= 'PP-AUCTION' then 0.0250*(mMerchandise+mShipping+mTax-mCredits)
                    WHEN sMethodOfPayment= 'PAYPAL' then 0.0250*(mMerchandise+mShipping+mTax-mCredits)
                    else 0 
                    end)
        WHERE sOrderStatus = 'Shipped' 
            AND (mMerchandise+mShipping+mTax-mCredits) > 0  
            AND dtInvoiceDate between '03/30/2019' and '06/20/2019'--'06/20/2019'   6,108
            AND mPaymentProcessingFee > 0

ROLLBACK TRAN




-- VERIFYING PRECENTAGES AFTER UPDATES
SELECT sMethodOfPayment 'MoPayment '
    , FORMAT(SUM(mMerchandise+mShipping+mTax-mCredits),'$###,###.#0') 'Sales'
    , FORMAT(SUM(mPaymentProcessingFee),'$###,###.#0') 'TotProcFees'
FROM tblOrder 
WHERE sOrderStatus = 'Shipped' 
        AND (mMerchandise+mShipping+mTax-mCredits) > 0  
        AND dtInvoiceDate between '03/30/2019' and '06/20/2019'--'06/20/2019'   6,108
        AND mPaymentProcessingFee > 0
GROUP BY sMethodOfPayment
/*      SMI
                                            % works 
MoPayment   Sales	         Tot Proc fee	out to
==========  ==============   ============   =======
AMEX	    $ 1,106,937.36 	 $ 37,082.41 	0.0335 
DISCOVER	$ 1,106,723.27 	 $ 23,351.87 	0.0211
MASTERCARD	$ 7,006,214.35 	 $145,028.73 	0.0207
PAYPAL	    $ 4,439,090.57 	 $110,977.95 	0.0250
PP-AUCTION	$ 2,992,981.44 	 $ 74,825.07 	0.0250
VISA	    $15,209,297.63 	 $314,832.65 	0.0207



        AFCO
                                           % works
MoPayment   Sales	        Tot Proc fee   out to
==========  ==============  ============   =======
AMEX	    $  508,642.80	$17,039.54      0.0335
DISCOVER	$   43,114.40	$   909.71      0.0211
MASTERCARD	$  507,656.22	$10,508.49      0.0207
PP-AUCTION	$  102,105.52	$ 2,552.65      0.0250
VISA	    $1,259,886.18	$26,079.65      0.0207

*/




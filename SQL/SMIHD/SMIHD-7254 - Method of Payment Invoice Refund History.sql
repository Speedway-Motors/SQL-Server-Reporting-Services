-- SMIHD-7254 - Method of Payment Invoice Refund History
select ixOrder, mCredits, mMerchandise, mShipping, mTax
from tblOrder
where ixShippedDate >= 17899 -- '01/01/2017'
and mShipping > 0
and mCredits > 0
and mTax > 0
/*
ixOrder	mCredits	mMerchandise	mPromoDiscount	mPublishedShipping	mShipping	mTax
6438732	101.99	    511.97	        NULL	        22.78	            123.31	    0.00
6549234	39.98	    106.90	        NULL	        59.86	            79.03	    0.00


ixOrder	mCredits	mMerchandise	mShipping	mTax
7859816	134.80	    64.99	        10.80	    5.31
7355517	50.00	    68.93	        9.35	    5.48
*/


-- DISTINCT LIST OF PAYMENT METHODS for Orders AND Credit Memos
    SELECT  distinct sMethodOfPayment
    FROM tblCreditMemoMaster
    WHERE dtCreateDate >= '04/14/2017' 

UNION

    SELECT distinct sMethodOfPayment
    FROM tblOrder
    WHERE dtShippedDate > = '04/17/2017'
    order by sMethodOfPayment
    /*
    sMethodOfPayment
    ACCTS RCVBL
    AMAZON
    AMEX
    CASH
    CHECK
    COD
    DISCOVER
    MASTERCARD
    MERCH EXCHANGE
    MONEY ORDER
    PAYPAL
    PP-AUCTION
    VISA
    */

DECLARE @StartDate datetime,        @EndDate datetime,      @MethodOfPayment varchar(15)
SELECT  @StartDate = '04/01/17',    @EndDate = '04/07/17', @MethodOfPayment = 'CHECK'  


    SELECT O.dtShippedDate 'OrderShippedCMCreated', 
        O.ixCustomer, O.ixOrder, '' as 'ixCreditMemo', 
        O.sOrderChannel, O.sMethodOfPayment, 
        O.mMerchandise+O.mShipping+O.mTax-O.mCredits 'TotAmount'  -- confirmed this calc is the Total Amount that appears on the SOP order screen
    FROM tblOrder O
    WHERE O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between @StartDate and @EndDate 
        and O.sMethodOfPayment in (@MethodOfPayment)
UNION
    SELECT CMM.dtCreateDate 'OrderShippedCMCreated', 
        CMM.ixCustomer, CMM.ixOrder,  CMM.ixCreditMemo, 
        CMM.sOrderChannel, CMM.sMethodOfPayment, 
        mMerchandise+mShipping+mTax+mRestockFee 'TotAmount' -- waiting for JJM to verify calc
    FROM tblCreditMemoMaster CMM
    WHERE CMM.flgCanceled = 0 
        and CMM.dtCreateDate between @StartDate and @EndDate
        and CMM.sMethodOfPayment in (@MethodOfPayment)
    
    
    
    
-- EXAMPLE CM's so Jerry can verify Total calc.    
select CMM.dtCreateDate 'ActionDate', CMM.ixCustomer, CMM.ixOrder,  CMM.ixCreditMemo, CMM.sOrderChannel, CMM.sMethodOfPayment, 
mMerchandise 'Merch', mShipping 'Shipping', mTax 'Tax', mRestockFee 'RestockFee',
mMerchandise+mShipping+mTax+mRestockFee 'TotAmount'
from tblCreditMemoMaster CMM
where flgCanceled = 0 
    and dtCreateDate  >= '04/02/2017' 
   -- and mMerchandise <> 0
  --  and mShipping <> 0 -- always negative
    --and mTax <> 0 -- always negative
  --  and mRestockFee < 0  -- neg or pos.
order by ixCreditMemo desc


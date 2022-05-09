-- SMIHD-8948 - add Customer Number parameter to Credit Memo Returns and Adjustments report

/* Credit Memo Returns and Adjustments.rdl
    ver 17.43.1

DECLARE @StartDate datetime,        @EndDate datetime,      @Customer varchar(10)
SELECT  @StartDate = '01/01/14',    @EndDate = '10/26/17',  @Customer = 359650 --'1222360'   -- cust 1222360             OR 359650 (4 yr range)
*/

SELECT CMM.dtCreateDate
     , CMM.ixCreditMemo
     , CMM.ixOrder AS OrigOrder
     , O.iShipMethod As OrigShipMethod
     , CMM.sMemoTransactionType AS MemoType
     , CMM.ixOrderTaker AS CreditedBy
     , ISNULL(O.sOrderChannel, CMM.sOrderChannel) AS OrderChannel 
     , C.ixCustomerType AS CustomerFlag
     , CMM.ixCustomer
     , CMM.mMerchandise 
     , O.mMerchandise AS OrigOrderMerch
     , CMM.mRestockFee
     , O.mCredits
     , CMM.mShipping
     , O.mShipping AS OrigOrderShip
     , CMM.mTax
     , O.mTax AS OrigOrderTax
     --Add all fields above together in report as subtotal 
     , CMM.sMethodOfPayment AS RefundMethod
     --, CMD.sReasonCode -- Per JJM exclude because detail level data would require grouping and wanted flat
     --, CMD.sReturnType -- Per JJM exclude because detail level data would require grouping and wanted flat
FROM tblCreditMemoMaster CMM 
--LEFT JOIN tblCreditMemoDetail CMD ON CMD.ixCreditMemo = CMM.ixCreditMemo
LEFT JOIN tblOrder O ON O.ixOrder = CMM.ixOrder
LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer
WHERE dtCreateDate BETWEEN @StartDate AND @EndDate --'08/01/13' AND '08/06/13' 
  AND flgCanceled = 0 
  AND (@Customer is NULL
       OR        
       CMM.ixCustomer = @Customer
       )
 -- AND CMM.sMemoTransactionType IN (@MemoType) -- 'Return'
--  AND ISNULL(O.sOrderChannel, CMM.sOrderChannel) IN (@OrderChannel) -- 'PHONE'
ORDER BY dtCreateDate
       , OrigOrder
       , MemoType  
       
/*       
       CMM - varchar(10)
       O - int
       C - int
       
*/       
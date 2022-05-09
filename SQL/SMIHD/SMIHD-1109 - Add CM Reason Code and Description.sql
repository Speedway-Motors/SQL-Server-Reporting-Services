-- SMIHD-1109 Add CM Reason Code and Description
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
 -- AND CMM.sMemoTransactionType IN (@MemoType) -- 'Return'
--  AND ISNULL(O.sOrderChannel, CMM.sOrderChannel) IN (@OrderChannel) -- 'PHONE'
ORDER BY dtCreateDate
       , OrigOrder
       , MemoType  
       
       
       
select * from tblCreditMemoDetail
where sReasonCode is NOT NULL

select CMD.ixCreditMemo, COUNT(distinct CMD.sReasonCode)
from tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
where CMM.ixCreateDate >= 17168 -- YTD 18K+ CMs... approx 800 have multiple Reson codes
group by CMD.ixCreditMemo
order by COUNT(distinct sReasonCode) desc     
/*
C-402393	4
C-402012	4
C-398999	4
C-400272	4
C-415930	4
C-411376	3
*/

select distinct ixReasonCode, sDescription 
from tblCreditMemoReasonCode
where ixReasonCode in (select sReasonCode from tblCreditMemoDetail where ixCreditMemo = @CreditMemo)
order by ixReasonCode



Select * from tblCreditMemoReasonCode
order by LEN(sDescription) desc
/*
Sub check for credit slip
OVERCHRG - OTU PROMO
Dual Meth of Payment
Won't work as plannd
Clearance Insuffecnt
Parts to Small/Short
Chgd Mind/Didnt Want
OE err-PRICING WRONG
Mis-Ordered by Cust
Related items missg
OE err-WRONG PARTS
*/
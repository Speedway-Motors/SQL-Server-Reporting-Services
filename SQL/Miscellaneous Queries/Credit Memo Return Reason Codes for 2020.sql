-- Credit Memo Return Reason Codes for 2020

select * from tblCreditMemoMaster 

select * from tblCreditMemoDetail

select * from tblCreditMemoReasonCode


 

select CMM.ixOrderTaker, CMD.sReasonCode  --80,537  -- 1,591 same take as original order <2%
from tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
    left join tblOrder O on CMM.ixOrder = O.ixOrder
where CMM.ixCreateDate between 18994 and 19359 -- 1/120-12/31/20
    and CMM.flgCanceled = 0
        and CMD.sReasonCode is NOT NULL
    and CMM.ixOrderTaker = O.sOrderTaker 
    and CMM.ixOrder is NOT NULL


SELECT CMRC.ixReasonCode, CMRC.sDescription 'RCDescription',  SUM(CMD.mExtendedPrice) 'Merch$',
    count(CMD.ixCreditMemoLine) 'CMLines' --83,222  -- 1,355 same take as original order <2%
FROM tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
    left join tblOrder O on CMM.ixOrder = O.ixOrder
    left join tblCreditMemoReasonCode CMRC on CMD.sReasonCode = CMRC.ixReasonCode
WHERE CMM.ixCreateDate between 18994 and 19359 -- 1/120-12/31/20
    and CMM.flgCanceled = 0
    and CMD.sReasonCode is NOT NULL
GROUP BY CMRC.ixReasonCode, CMRC.sDescription
ORDER BY count(CMD.ixCreditMemoLine) desc


select --CMM.ixOrderTaker 'CMCreator', --O.sOrderTaker, 
    CMRC.ixReasonCode, CMRC.sDescription 'RCDescription', count(CMD.ixCreditMemoLine) 'CMLines', SUM(CMD.mExtendedPrice) 'ExtMerchPrice' --83,222  -- 1,355 same take as original order <2%
from tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
   -- left join tblOrder O on CMM.ixOrder = O.ixOrder
    left join tblCreditMemoReasonCode CMRC on CMD.sReasonCode = CMRC.ixReasonCode
where CMM.ixCreateDate between 18994 and 19359 -- 1/1/20-12/31/20
    and CMM.flgCanceled = 0
    and CMD.sReasonCode is NOT NULL
group by --CMM.ixOrderTaker, --O.sOrderTaker, 
    CMRC.ixReasonCode, CMRC.sDescription
order by count(CMD.ixCreditMemoLine) desc


select FORMAT(SUM(CMM.mMerchandise),'###,###') 'MerchCredit$'--, BU.sBusinessUnit
    -- sMemoType, CMM.ixBusinessUnit  SHOULD Exhchanges & Refunds be counted
   -- sMemoTransactionType
from tblCreditMemoMaster CMM
    --left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
    left join tblOrder O on CMM.ixOrder = O.ixOrder
    left join tblBusinessUnit BU on BU.ixBusinessUnit = CMM.ixBusinessUnit
    --left join tblCreditMemoReasonCode CMRC on CMD.sReasonCode = CMRC.ixReasonCode
where CMM.ixCreateDate between 18994 and 19359 -- 1/1120-12/31/20
    and CMM.flgCanceled = 1
 --   and CMM.sMemoTransactionType = 'Return' -- exluding 'Adjustments'
--GROUP BY  BU.sBusinessUnit
/*
MerchCredit$	sMemoType
3,539,547	    Exchange
7,678,828	    Refund
*/
175M 7.7M

tblCreditMemoMaster.flgCanceled







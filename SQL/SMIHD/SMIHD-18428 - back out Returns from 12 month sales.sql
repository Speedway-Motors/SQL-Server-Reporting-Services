-- SMIHD-18428 - back out Returns from 12 month sales
select * from tblCreditMemoReasonCode
where sDescription is NOT NULL


select sReturnType, FORMAT(count(*),'###,###') 'CMs'
from tblCreditMemoDetail
where ixCreditMemo >= 'C-632771'  -- created 8/18/19 or later
and  ixSKU = '91064022'
group by sReturnType


Return
Type	CMs
====    ===
DAM	34
DEF	5
GSL	22
NAW	1
REG	173
RTV	9

select * 
from tblCreditMemoMaster
where dtCreateDate >= '08/18/2019'
order by ixCreditMemo

-- 12 Month returns  for example SKU
select CMM.ixCreditMemo 'CM#', CMM.ixOrder 'Order#', FORMAT(CMM.dtCreateDate,'MM/dd/yyyy') 'CMCreated', 
    CMM.sMemoType 'MemoType', CMM.sMemoTransactionType 'TrnsactionType',
    CMD.ixSKU 'SKU', CMD.iQuantityReturned 'QtyReturned', CMD.iQuantityCredited 'QtyCredited', CMD.sReturnType 'ReturnType',
    CMRC.ixReasonCode, CMRC.sDescription 'ResonCodeDescription'
from tblCreditMemoDetail CMD
    left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
    left join tblCreditMemoReasonCode CMRC on CMRC.ixReasonCode = CMD.sReasonCode
where CMM.dtCreateDate between '08/18/2019' and '08/17/2020'  --ixCreditMemo >= 'C-632771'  -- created 8/18/19 or later
    and CMM.flgCanceled = 0
    and  ixSKU = '91064022'
group by sReturnType

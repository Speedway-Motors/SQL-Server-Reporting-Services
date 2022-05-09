-- Credit Memo Return Reasons past 12 months

select CMRC.ixReasonCode, CMRC.sDescription, COUNT(CMD.ixSKU) 'CMLines'
from tblCreditMemoDetail CMD
    left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
    left join tblCreditMemoReasonCode CMRC on CMD.sReasonCode = CMRC.ixReasonCode
where CMM.ixCreateDate between 18867 and 19232 --  '08/27/19' and '08/26/20'
and CMM.flgCanceled = 0
GROUP BY CMRC.ixReasonCode, CMRC.sDescription
ORDER BY CMRC.sDescription

-- select * from tblCreditMemoReasonCode
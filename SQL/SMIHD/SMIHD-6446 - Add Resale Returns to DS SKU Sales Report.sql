-- SMIHD-6446 - Add Resale Returns to DS SKU Sales Report

SELECT * 
FROM tblCreditMemoDetail CMD
join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
where CMM.dtCreateDate >= '03/22/11'
and CMD.ixSKU = '96656001'


/*
qty credited (not qty reshelfed) that have a type of 'REG', 'NAW' or 'PND'. Does that help?
*/
-- Resale Returns
SELECT CMD.ixSKU, 
    SUM(CMD.iQuantityCredited) 'ResaleReturns12Mo'
FROM tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
    join vwDropshipOnlySKU DS on DS.ixSKU = CMD.ixSKU
where CMM.dtCreateDate >= DATEADD(yy, -1, getdate()) -- 1 yr ago
    and CMM.flgCanceled = 0
    and CMD.sReturnType in ('REG','NAW','PND')
group by CMD.ixSKU
--order by SUM(CMD.iQuantityCredited) desc
/*
Qty
Credited	ixSKU
10	        278D58DN5
5	        83512011711RD
4	        3258460
*/

SELECT DATEADD(yy, -1, getdate())

SELECT CMM.dtCreateDate, CMD.*
FROM tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
    join vwDropshipOnlySKU DS on DS.ixSKU = CMD.ixSKU
where CMM.dtCreateDate >= '01/01/18'
    and CMD.sReturnType in ('REG','NAW','PND')
    and CMD.ixSKU in ('83512011711RD','3258460')
order by CMD.ixSKU, CMM.dtCreateDate

SELECT CMD.sReasonCode, CMD.sReturnType
    , CMRC.sDescription
    ,  SUM(CMD.iQuantityCredited) 'QtyCredited'
    , SUM(CMD.iQuantityReturned) 'QtyReturned'
FROM tblCreditMemoDetail CMD
join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
join tblCreditMemoReasonCode CMRC on CMRC.ixReasonCode = CMD.sReasonCode
join vwDropshipOnlySKU DS on DS.ixSKU = CMD.ixSKU
where CMM.dtCreateDate >= '03/23/17'
group by CMD.sReasonCode, CMD.sReturnType  , CMRC.sDescription
order by  SUM(CMD.iQuantityCredited) desc

having SUM(CMD.iQuantityCredited) = 100
order by SUM(CMD.iQuantityCredited) desc



/***  
-- for CMD table, both of the Extended Values are working correctly

select ixCreditMemo, iQuantityCredited, mUnitCost, mExtendedCost  -- 0
from tblCreditMemoDetail
where mExtendedCost <> (iQuantityCredited * mUnitCost)

select ixCreditMemo, iQuantityCredited, mUnitPrice, mExtendedPrice -- 0
from tblCreditMemoDetail
where mExtendedPrice <> (iQuantityCredited * mUnitPrice)

*/
select CMM.ixCreditMemo,
    CMM.sMemoType,
    CMM.dtCreateDate,
    NULL,
    CMM.mMerchandise        Merch,
    SUM(CMD.mExtendedPrice) DetailExtPrice,  
    NULL,
    SUM(CMD.mExtendedCost)  DetailExtCost,      
    CMM.mMerchandiseCost    MerchCost
FROM tblCreditMemoMaster CMM
    LEFT JOIN tblCreditMemoDetail CMD ON CMD.ixCreditMemo = CMM.ixCreditMemo
GROUP BY CMM.ixCreditMemo, CMM.sMemoType, CMM.dtCreateDate, CMM.mMerchandise, CMM.mMerchandiseCost 
ORDER BY CMM.dtCreateDate DESC  
-- AFCO 7,880 CREDIT MEMOS


select CMM.ixCreditMemo,
    CMM.sMemoType,
    CMM.dtCreateDate,
    CMM.flgCanceled,    
    NULL,
    CMM.mMerchandise        Merch,
    SUM(CMD.mExtendedPrice) DetailExtPrice,  
    NULL,
    SUM(CMD.mExtendedCost)  DetailExtCost,      
    CMM.mMerchandiseCost    MerchCost
FROM tblCreditMemoMaster CMM
    LEFT JOIN tblCreditMemoDetail CMD ON CMD.ixCreditMemo = CMM.ixCreditMemo
--where ixCustomer = '10890'
GROUP BY CMM.ixCreditMemo, CMM.sMemoType, CMM.dtCreateDate,     CMM.flgCanceled,CMM.mMerchandise, CMM.mMerchandiseCost 
HAVING CMM.mMerchandise - SUM(CMD.mExtendedPrice) < -.01 -- Detail goes to 3 decimals... Master only goes to 2 decimals!
    OR CMM.mMerchandise - SUM(CMD.mExtendedPrice) > .01
ORDER BY     CMM.flgCanceled
-- AFCO 7,880 CREDIT MEMOS
-- 134 the Merch calcs do not match

-- 111 for cust# 10890


select CMM.ixCreditMemo,
    CMM.ixCustomer,
    CMM.sMemoType,
    CMM.dtCreateDate,
    NULL,
    CMM.mMerchandise        Merch,
    COUNT(ixSKU)            SKUcount,
    SUM(CMD.mExtendedPrice) DetailExtPrice,  
    NULL,
    SUM(CMD.mExtendedCost)  DetailExtCost,      
    CMM.mMerchandiseCost    MerchCost
FROM tblCreditMemoMaster CMM
    LEFT JOIN tblCreditMemoDetail CMD ON CMD.ixCreditMemo = CMM.ixCreditMemo
GROUP BY CMM.ixCreditMemo, CMM.ixCustomer, CMM.sMemoType, CMM.dtCreateDate, CMM.mMerchandise, CMM.mMerchandiseCost 
HAVING SUM(CMD.mExtendedCost) <> CMM.mMerchandiseCost
ORDER BY COUNT(ixSKU) -- CMM.dtCreateDate DESC  
-- AFCO 7,880 CREDIT MEMOS
-- 2,194 COST calcs do not match %22
--     0 NOW






   

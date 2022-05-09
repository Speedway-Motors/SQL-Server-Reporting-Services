/*
Case 14698 - New Report: Credit Memos by Reason


-- select top 10 * from tblCreditMemoMaster where ixCreditMemo = 'C-305315'

ixCreditMemo	ixCustomer	ixOrder	ixCreateDate	sOrderChannel	mMerchandise	sMemoType	dtCreateDate	mMerchandiseCost	ixOrderTaker	mShipping	mTax	mRestockFee	flgCanceled
C-305315	    836901	    4609270	16255	        WEB	            447.98	        Exchange	2012-07-02      348.29	            EDC	            0.00	    0.00	0.00	    0

-- select * from tblCreditMemoDetail where ixCreditMemo = 'C-305315'

ixCreditMemoLine	ixCreditMemo	ixSKU	iQuantityReturned	iQuantityCredited	mUnitPrice	mUnitCost	sReturnType	sReasonCode	mExtendedPrice	mExtendedCost
1	                C-305315	    250205834	1	            1	                169.99	    117.00	    GSL	        43	        169.99	        117.00
2	                C-305315	    91058677	1	            1	                277.99	    231.29	    RTV	        12	        277.99	        231.29
*/



SELECT CMD.ixSKU,
    SKU.sDescription,
    CMM.ixCreditMemo,
    D.dtDate as 'CM Created',
    (CMD.iQuantityReturned * CMD.mUnitPrice) as 'Val for Inv Rtnd',
    -- CO = ?
    CMD.iQuantityReturned as 'Qty Rtn',
    CMD.iQuantityCredited as 'Qty Credited',
    (CMD.iQuantityCredited * CMD.mUnitPrice) as '$ Credit to Cust',
    CMD.sReasonCode,
    CMRC.sDescription as 'Reason',
    CMM.ixOrderTaker as 'Order Taker',
    CMD.sReturnType as 'Type'
FROM tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo    
    left join tblSKU SKU on SKU.ixSKU = CMD.ixSKU
    left join tblDate D on D.ixDate = CMM.ixCreateDate
    left join tblCreditMemoReasonCode CMRC on CMD.sReasonCode = CMRC.ixReasonCode
WHERE D.dtDate between '07/21/2012' and '07/27/2012'
    and CMM.flgCanceled = 0
ORDER BY CMM.ixCreditMemo    


select * from tblCreditMemoDetail
where mExtendedPrice > (iQuantityReturned * mUnitPrice)    
order by ixCreditMemo desc
    

select CMD.sReasonCode, count(CMD.ixSKU)
from tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
where CMM.flgCanceled = 0
    and CMM.ixCreateDate >= 16072
group by sReasonCode    

    
    
select top 50 * from    tblCreditMemoMaster 
order by ixCreateDate desc
    
    
    
-- SMIHD-18529 - Quick SKU Returns analysis

SELECT S.ixSKU 'SKU', 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    S.mPriceLevel1 'PriceLvl1',
    S.mAverageCost,
    -- 12 month values
    SALES.Sales12Mo,
    SALES.QtySold12Mo,
    RET.QtyCredited,
    RET.QtyReturned,
    RET.ExtReturnsPrice,
    RET.ExtReturnsCost
FROM tblSKU S
    LEFT JOIN (-- 12 Month Sales
                SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    left join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU  
    LEFT JOIN (-- 12 Month Returns
                select CMD.ixSKU, 
                SUM(CMD.iQuantityReturned) 'QtyReturned', 
                SUM(CMD.iQuantityCredited) 'QtyCredited',
                SUM(CMD.mExtendedPrice) 'ExtReturnsPrice',
                SUM(CMD.mExtendedCost) 'ExtReturnsCost'
                from tblCreditMemoDetail CMD
                    left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
                    left join tblCreditMemoReasonCode CMRC on CMD.sReasonCode = CMRC.ixReasonCode
                where CMM.dtCreateDate between DATEADD(yy, -1, getdate()) and getdate() 
                    and CMM.flgCanceled = 0
                GROUP BY CMD.ixSKU
                ) RET on RET.ixSKU = S.ixSKU
WHERE RET.ixSKU is NOT NULL





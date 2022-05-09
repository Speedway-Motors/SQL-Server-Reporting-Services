-- SMIHD-10786 - Credit Memo Details per SKU

SELECT DISTINCT CMD.ixCreditMemo 'CreditMemo',
    O.ixOrder 'Order',
    O.dtShippedDate 'OrderShipped',
    CMM.dtCreateDate 'CMDate',
    --O.dtOrderDate 'OrderDate',
    O.sOrderChannel 'OrderChannel',
    O.sOrderTaker 'OrderTaker',
    --O.ixOrderType -- ALL NULL
    O.sOrderType 'OrderType',
    O.ixCustomerType 'CustType',
    CMD.ixSKU 'SKU',
    S.sBaseIndex 'BaseIndex',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    OL.iQuantity 'QtyOrdered',    --CMD.iQuantityReturned 'QtyReturned', 
    CMD.iQuantityCredited 'QtyCredited', 
    CMD.mUnitPrice 'UnitPrice', CMD.mUnitCost 'UnitCost', CMD.mExtendedPrice 'ExtPrice', CMD.mExtendedCost 'ExtCost',
    CMD.sReturnType 'ReturnType', 
    CMD.sReasonCode 'ReasonCode', 
    CMRC.sDescription 'RCDescription'    --S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart
FROM tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo 
    join tblOrder O on CMM.ixOrder = O.ixOrder
    join tblOrderLine OL on O.ixOrder = OL.ixOrder 
                    and CMD.ixSKU = OL.ixSKU
    join tblSKU S on S.ixSKU = OL.ixSKU
    left join tblCreditMemoReasonCode CMRC on CMRC.ixReasonCode = CMD.sReasonCode
WHERE CMM.ixCreateDate between 18384 and 18390 --	5/1/18 - 5/7/18
    and O.sOrderType <> 'Internal'
    and CMM.flgCanceled = 0
--and CMD.iQuantityReturned <> CMD.iQuantityCredited



SELECT * FROM tblCreditMemoDetail where ixCreditMemo = 'C-557757'
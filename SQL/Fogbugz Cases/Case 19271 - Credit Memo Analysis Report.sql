SELECT CMM.dtCreateDate
     , CMM.ixCreditMemo
     , CMM.ixOrder AS OrigOrder
     , O.iShipMethod As OrigShipMethod
     --Add new field Adjustment/Return Memo Here 
     , CMM.ixOrderTaker
     , ISNULL(CMM.sOrderChannel, O.sOrderChannel) AS OrderChannel 
     , C.ixCustomerType
     , CMM.ixCustomer
     , CMM.mMerchandise
     , CMM.mRestockFee
     , CMM.mShipping
     , CMM.mTax
     --Add all fields above together in report as subtotal 
     , CMM.sMethodOfPayment
     , CMD.sReasonCode
     --Add long description of reason code here 
     , CMD.sReturnType
FROM tblCreditMemoMaster CMM 
LEFT JOIN tblCreditMemoDetail CMD ON CMD.ixCreditMemo = CMM.ixCreditMemo
LEFT JOIN tblOrder O ON O.ixOrder = CMM.ixOrder
LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer
WHERE dtCreateDate BETWEEN '08/01/13' AND '08/06/13' 
  AND flgCanceled = 0 
ORDER BY ixCreditMemo

SELECT CMD.ixSKU
     , S.sDescription AS SKUDescription 
     , COUNT(DISTINCT CMD.ixCreditMemo) AS MemoCount 
     , CMD.ixCreditMemo
     , CMM.dtCreateDate
     , CMD.iQuantityReturned
     , CMD.iQuantityCredited
     , CMD.mExtendedPrice
     , (CASE WHEN OL.flgKitComponent = 1 THEN 'YES'
             ELSE 'NO'
         END) AS flgKitComponent 
     , CMM.sMethodOfPayment
     , CMD.sReasonCode
     , CMRC.sDescription AS ReasonDescription
     , CMM.ixOrderTaker
     , ISNULL(CMM.sOrderChannel, O.sOrderChannel) AS OrderChannel 
     , CMM.sMemoTransactionType
     , CMD.sReturnType
     , C.ixCustomerType
     , C.ixCustomer
     , CMM.ixOrder
     , O.dtOrderDate
     , VS.ixVendor
     , V.sName
FROM tblCreditMemoDetail CMD
LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo
LEFT JOIN tblSKU S ON S.ixSKU = CMD.ixSKU
LEFT JOIN tblCreditMemoReasonCode CMRC ON CMRC.ixReasonCode = CMD.sReasonCode
LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer
LEFT JOIN tblOrder O ON O.ixOrder = CMM.ixOrder
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = CMD.ixSKU AND VS.iOrdinality = 1 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor
LEFT JOIN (SELECT DISTINCT ixOrder 
                , ixSKU 
                , flgKitComponent
           FROM tblOrderLine OL 
          ) OL ON OL.ixOrder = CMM.ixOrder AND OL.ixSKU = CMD.ixSKU
WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate --'01/01/13' AND '09/16/13'
  AND CMM.flgCanceled = 0 
  --AND CMD.ixSKU = '91031904'
  AND CMM.sMemoTransactionType <> 'Adjustment'
 -- AND OL.flgKitComponent = 1
GROUP BY CMD.ixSKU
       , S.sDescription
       , CMD.ixCreditMemo
       , CMM.dtCreateDate
       , CMD.iQuantityReturned
       , CMD.iQuantityCredited
       , CMD.mExtendedPrice
       , (CASE WHEN OL.flgKitComponent = 1 THEN 'YES'
               ELSE 'NO'
         END)
       , CMM.sMethodOfPayment
       , CMD.sReasonCode
       , CMRC.sDescription
       , CMM.ixOrderTaker
       , ISNULL(CMM.sOrderChannel, O.sOrderChannel)
       , CMM.sMemoTransactionType
       , CMD.sReturnType
       , C.ixCustomerType
       , C.ixCustomer
       , CMM.ixOrder
       , O.dtOrderDate
       , VS.ixVendor
       , V.sName
ORDER BY ixCreditMemo


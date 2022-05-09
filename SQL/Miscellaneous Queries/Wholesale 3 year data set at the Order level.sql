-- Wholesale 3 year data set at the Order level
SELECT ixOrder 'Order', ixCustomer 'Cust'
, sShipToCity 'ShipToCity', sShipToState 'ShipToState', sShipToZip 'ShipToZip', sShipToCountry 'ShipToCountry'
, sOrderType 'OrderType' 
, ixCustomerType 'CustType'
, sOrderChannel 'OrderChannel', iShipMethod 'ShipMethod'
--, sSourceCodeGiven, sMatchbackSourceCode
, sMethodOfPayment 'MoP'
, mMerchandise 'Merch'
, mShipping 'SH'
, mPublishedShipping 'PubSH'
, mTax 'Tax'
--, sOrderStatus, flgIsBackorder
, mMerchandiseCost 'MerchCost'
, dtOrderDate 'OrderDate'
, dtShippedDate 'ShippedDate'
, ixAccountManager 'AcctMgr'
--, mPromoDiscount, ixOrderType, sOptimalShipOrigination, sCanceledReason, ixCanceledBy, mAmountPaid, flgPrinted, ixAuthorizationDate, ixAuthorizationTime
-- , flgIsResidentialAddress, sWebOrderID, sPhone, dtHoldUntilDate, flgDeviceType, sUserAgent, dtAuthorizationDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
--, sAttributedCompany, mBrokerage, mDisbursement, mVAT, mPST, mDuty, mTransactionFee, ixPrimaryShipLocation
, iTotalTangibleLines
, iTotalShippedPackages
, ixQuote
FROM tblOrder O
WHERE O.dtOrderDate BETWEEN '11/11/2011' and '11/10/2014' --DATEADD(mm, -24, '10/06/14') AND '10/06/14' 
  AND sOrderType in ('MRR','PRS')
  AND sOrderChannel <> 'INTERNAL' 
  AND sOrderStatus = 'Shipped' --IN ('Shipped', 'Backordered', 'Open') 
ORDER BY ixQuote





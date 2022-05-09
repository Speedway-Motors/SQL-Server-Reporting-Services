-- Tolleson LIVE

SELECT O.ixOrder 'Order#', O.ixMasterOrderNumber 'MasterOrder#',O.sWebOrderID 'WEBOrderID',
    O.flgSplitOrder 'SplitOrder',
    -- O.ixOptimalShipLocation,
    O.ixPrimaryShipLocation 'PrimaryShipLoc',
    O.sOrderStatus 'Status', 
    O.ixAuthorizationStatus 'AuthStatus', 
    FORMAT(O.dtOrderDate,'yyyy.MM.dd') 'OrderDate',
    T1.chTime 'OrderTime(CST)',
    --O.ixOrderTime, 
    O.flgPrinted,
    FORMAT(O.dtShippedDate,'yyyy.MM.dd') 'ShippedDate',
    FORMAT(O.dtInvoiceDate,'yyyy.MM.dd') 'InvoicedDate',
    BU.sBusinessUnit,
    --O.ixBusinessUnit 'BUnit',
    O.iShipMethod, 
O.sOrderType, 
O.sOrderChannel 'Channel',
O.sSourceCodeGiven 'SCGiven', O.sMatchbackSourceCode 'MatchbackSC', 
O.ixCustomer 'Cust#', O.ixCustomerType,
O.mMerchandise 'Merch', O.mShipping 'SH', O.mTax 'Tax', O.mCredits 'Credits', O.mMerchandiseCost 'MerchCost',
O.mPaymentProcessingFee 'PmtProcFee', O.mMarketplaceSellingFee 'MrktpFee',
O.sOrderTaker 'OrderTaker', 
--
O.sShipToState, O.sShipToCountry, O.sMethodOfPayment 'MoP', 
--O.mPublishedShipping, O.ixAuthorizationDate, O.ixAuthorizationTime, O.dtHoldUntilDate, O.flgDeviceType, O.dtAuthorizationDate, 
--O.ixPrintPrimaryTrailer, O.ixPrintSecondaryTrailer, 
--O.iTotalOrderLines, O.iTotalTangibleLines, O.iTotalShippedPackages, 
--O.ixQuote, O.ixConvertedOrder, 
FORMAT(O.dtGuaranteedDelivery,'yyyy.MM.dd') 'GuaranteedDelivery',
O.flgGuaranteedDeliveryPromised,  
O.flgHighPriority,   O.flgBackorder, 
FORMAT(O.dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate',
T2.chTime 'LastSOPUpdateTime'
FROM tblOrder O
   -- LEFT JOIN tblDate D1 on D1.ixDate = 
   LEFT JOIN tblTime T1 on T1.ixTime= O.ixOrderTime
   LEFT JOIN tblTime T2 on T2.ixTime= O.ixTimeLastSOPUpdate
   LEFT JOIN tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE dtOrderDate > '10/03/2019'
    and (ixPrimaryShipLocation = 85 or flgSplitOrder = 1)
    and ixMasterOrderNumber IN (SELECT ixMasterOrderNumber from tblOrder where ixPrimaryShipLocation = 85)
    and O.sOrderStatus NOT IN ('Cancelled')
ORDER BY O.ixOrderTime desc, O.ixMasterOrderNumber


SELECT dtOrderDate, COUNT(O.ixOrder) 'Orders'
FROM tblOrder O
   -- LEFT JOIN tblDate D1 on D1.ixDate = 
   LEFT JOIN tblTime T1 on T1.ixTime= O.ixOrderTime
   LEFT JOIN tblTime T2 on T2.ixTime= O.ixTimeLastSOPUpdate
   LEFT JOIN tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE dtOrderDate > '10/03/2019'
    and (ixPrimaryShipLocation = 85 or flgSplitOrder = 1)
    and ixMasterOrderNumber IN (SELECT ixMasterOrderNumber from tblOrder where ixPrimaryShipLocation = 85)
    and O.sOrderStatus NOT IN ('Cancelled')
GROUP BY dtOrderDate
ORDER BY dtOrderDate


-- select * from tblBusinessUnit

-- SKUs with Inventory
/*
SELECT FORMAT(COUNT(*),'###,###') 'SKUs', FORMAT(getdate(),'yyyy.MM.dd HH:mm') 'AsOf'
FROM tblSKULocation 
WHERE ixLocation = '85'
    and iQAV > 0

SKUs	AsOf
====    =================
3,397	2019.11.12 15:06
568	    2019.10.04 09:44



64,376 for Location 99
*/


/*
-- select * from tblOrder where ixMasterOrderNumber = 'M8798182'
-- select * from tblShipMethod



-- CA orders that did not ship from Tolleson
select O.ixOrder 'Order#', O.ixMasterOrderNumber 'MasterOrder#',O.sWebOrderID 'WEBOrderID',
    O.flgSplitOrder 'SplitOrder',
    -- O.ixOptimalShipLocation,
    O.ixPrimaryShipLocation 'PrimaryShipLoc',
    O.sOrderStatus 'Status', 
    O.ixAuthorizationStatus 'AuthStatus', 
    FORMAT(O.dtOrderDate,'yyyy.MM.dd') 'OrderDate',
    T1.chTime 'OrderTime(CST)',
    --O.ixOrderTime, 
    O.flgPrinted,
    FORMAT(O.dtShippedDate,'yyyy.MM.dd') 'ShippedDate',
    FORMAT(O.dtInvoiceDate,'yyyy.MM.dd') 'InvoicedDate',
    O.ixBusinessUnit 'BUnit',
    O.iShipMethod, 
O.sOrderType, 
O.sOrderChannel 'Channel',
O.sSourceCodeGiven 'SCGiven', O.sMatchbackSourceCode 'MatchbackSC', 
O.ixCustomer 'Cust#', O.ixCustomerType,
O.mMerchandise 'Merch', O.mShipping 'SH', O.mTax 'Tax', O.mCredits 'Credits', O.mMerchandiseCost 'MerchCost',
O.mPaymentProcessingFee 'PmtProcFee', O.mMarketplaceSellingFee 'MrktpFee',
O.sOrderTaker 'OrderTaker', 
--
O.sShipToState, O.sShipToCountry, O.sMethodOfPayment 'MoP', 
--O.mPublishedShipping, O.ixAuthorizationDate, O.ixAuthorizationTime, O.dtHoldUntilDate, O.flgDeviceType, O.dtAuthorizationDate, 
--O.ixPrintPrimaryTrailer, O.ixPrintSecondaryTrailer, 
--O.iTotalOrderLines, O.iTotalTangibleLines, O.iTotalShippedPackages, 
--O.ixQuote, O.ixConvertedOrder, 
FORMAT(O.dtGuaranteedDelivery,'yyyy.MM.dd') 'GuaranteedDelivery',
O.flgGuaranteedDeliveryPromised,  
O.flgHighPriority,   O.flgBackorder, 
FORMAT(O.dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate',
T2.chTime 'LastSOPUpdateTime'
FROM tblOrder O
   -- LEFT JOIN tblDate D1 on D1.ixDate = 
   LEFT JOIN tblTime T1 on T1.ixTime= O.ixOrderTime
   LEFT JOIN tblTime T2 on T2.ixTime= O.ixTimeLastSOPUpdate
where dtOrderDate = '10/01/2019'
    and ixPrimaryShipLocation = 99
    and flgSplitOrder = 0
    and ixMasterOrderNumber NOT IN ('M5543988') -- add logic to exclude spit orders where all orders come from location 99
    and O.sShipToState = 'CA'
    and O.sOrderStatus NOT IN ('Backordered', 'Cancelled','Quote','Cancelled Quote')
    and O.sWebOrderID NOT LIKE 'CA%' -- per RON, not shipping from Loc 85 yet (Brandon is running a test)
    and T1.chTime > '08:18:00'
ORDER BY O.ixOrderTime, O.ixMasterOrderNumber

SELECT OL.ixOrder,OL.ixSKU, OL.iQuantity 'QtyOrdered', SL.iQAV 'Loc85CURRENT_QAV'
FROM tblOrderLine OL
left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation = '85'
where ixOrder in (select O.ixOrder
                  FROM tblOrder O
                    LEFT JOIN tblTime T1 on T1.ixTime= O.ixOrderTime
                  where dtOrderDate = '10/01/2019'
                    and ixPrimaryShipLocation = 99
                    and flgSplitOrder = 0
                    and ixMasterOrderNumber NOT IN ('M5543988') -- add logic to exclude spit orders where all orders come from location 99
                    and O.sShipToState = 'CA'
                    and O.sOrderStatus NOT IN ('Backordered', 'Cancelled','Quote','Cancelled Quote')
                    and O.sWebOrderID NOT LIKE 'CA%' -- per RON, not shipping from Loc 85 yet (Brandon is running a test)
                    and T1.chTime > '08:18:00'
                    )
ORDER BY OL.ixOrder, OL.ixSKU





*/
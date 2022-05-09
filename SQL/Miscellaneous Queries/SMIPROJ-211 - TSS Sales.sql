-- SMIPROJ-211 - TSS Sales
SELECT ixOrder 'Order',
    dtOrderDate 'OrderDate',
    dtShippedDate 'ShippedDate',
    C.ixCustomer 'CustNum',
  --  C.sCustomerType 'CustType',
    mMerchandise 'Merchandise',
    mMerchandiseCost 'MerchCost',
    (mMerchandise - mMerchandiseCost) 'GP'
    --ixPrimaryShipLocation 'PrimaryShipLocation',
    --sOrderStatus 'OrderStatus',
    --sAttributedCompany 'AttributedCompany',
    --sSourceCodeGiven 'SourceCodeGiven',
    --sMatchbackSourceCode,
    --sOrderType 'OrderType',
    --sOrderChannel 'OrderChannel'
FROM vwTrackSideSupportOrder TSS
left join tblCustomer C on C.ixCustomer = TSS.ixCustomer
WHERE --dtShippedDate between @StartDate and @EndDate
    TSS.sOrderStatus = 'Shipped'
    and TSS.sOrderType <> 'Internal'   
ORDER BY dtOrderDate desc



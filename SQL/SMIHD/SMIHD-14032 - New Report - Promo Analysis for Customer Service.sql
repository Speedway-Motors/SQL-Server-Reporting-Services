-- SMIHD-14032 - New Report - Promo Analysis for Customer Service

-- Order info for BKR on orders that have used PromoCode CUSTSVC20
SELECT O.ixOrder 'Order', 
    O.sOrderStatus 'Status', 
    O.ixCustomer 'Customer', 
    O.mMerchandise 'Merch', 
    O.mMerchandiseCost 'MerchCost',
    FORMAT(O.dtOrderDate,'MM/dd/yyyy') 'OrderDate',
    FORMAT(O.dtShippedDate,'MM/dd/yyyy') 'ShippedDate'
FROM tblOrderPromoCodeXref OPCX
    left join tblOrder O on OPCX.ixOrder = O.ixOrder
WHERE OPCX.ixPromoCode = 'CUSTSVC20'
ORDER BY O.dtOrderDate
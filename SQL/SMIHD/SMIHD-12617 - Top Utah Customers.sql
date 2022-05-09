-- SMIHD-12617 - Top Utah Customers

SELECT O.ixCustomer, 
    C.ixCustomerType,
    SUM(O.mMerchandise) 'MerchTotal', 
    COUNT(O.ixOrder) 'OrderCount'
FROM tblOrder O
    LEFT JOIN tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE O.sOrderStatus = 'Shipped'
    and O.dtOrderDate between '01/01/2017' and '12/31/2017'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sShipToState = 'UT'
     --   and O.sOrderChannel <> 'INTERNAL'   --  usually NOT filtered
GROUP BY O.ixCustomer, C.ixCustomerType
ORDER BY SUM(O.mMerchandise) DESC



-- Case 19266 - Analysis - YTD orders with 0 shipping that are not associated with a shipping promo code

-- altered original query because it was returning some orders multiple times (if they had multiple credit memos)
SELECT C.ixCustomer
    , C.ixCustomerType
    , O.ixOrder
    , O.dtShippedDate
    , O.sOrderChannel
    , O.sOrderType
    , SUM(O.mMerchandise) AS Sales
    , SUM(O.mMerchandiseCost) AS Cost
    , SUM(O.mShipping) AS Shipping
    , Credit.mMerchandise AS CreditSales
    , Credit.mMerchandiseCost AS CreditCost
    , Credit.mShipping AS CreditShipping
FROM tblOrder O
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
LEFT JOIN (SELECT ixOrder 
                ,SUM(mMerchandise) mMerchandise
                ,SUM(mMerchandiseCost) mMerchandiseCost
                ,SUM(mShipping) mShipping
            FROM tblCreditMemoMaster 
            WHERE dtCreateDate BETWEEN '01/01/2013' AND '07/15/2013' -- GETDATE() 
                AND flgCanceled = 0
            GROUP BY ixOrder
            ) Credit ON Credit.ixOrder = O.ixOrder
WHERE dtShippedDate BETWEEN '01/01/13' AND '07/15/2013' -- GETDATE() 
    AND O.ixOrder NOT IN (select distinct ixOrder from vwOrderShippingPromoSummary) -- excluding orders with Shipping Promo Codes
    AND O.sOrderStatus = 'Shipped' 
    AND O.mShipping <= 0
    AND O.iShipMethod <> '1'
GROUP BY C.ixCustomer
    , C.ixCustomerType
    , O.ixOrder
    , O.dtShippedDate
    , O.sOrderChannel
    , O.sOrderType
    , Credit.mMerchandise
    , Credit.mMerchandiseCost
    , Credit.mShipping
ORDER BY O.ixOrder




select sum(mMerchandise) SalesYTD
from tblOrder
where dtShippedDate BETWEEN '01/01/13' AND '07/15/2013'
and sOrderStatus = 'Shipped' 


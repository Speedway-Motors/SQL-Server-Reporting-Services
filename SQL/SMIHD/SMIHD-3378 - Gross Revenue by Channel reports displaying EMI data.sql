-- SMIHD-3378 - Gross Revenue by Channel reports displaying EMI data

-- 2015 POTENTIAL EMI Orders that are included in the 2 reports
SELECT 
    EO.ixOrder, EO.ixCustomer, 
    EO.sOrderType, EO.sOrderChannel, 
    EO.iShipMethod, EO.sSourceCodeGiven, EO.sMatchbackSourceCode, 
    EO.sMethodOfPayment, EO.sOrderTaker, 
    EO.mMerchandise, EO.mShipping, EO.mTax, EO.mCredits, EO.sOrderStatus, 
    EO.mMerchandiseCost, EO.dtOrderDate, EO.dtShippedDate, 
    EO.ixAccountManager, 
    EO.sWebOrderID,
    EO.dtAuthorizationDate, 
    EO.sAttributedCompany, 
    EO.ixPrimaryShipLocation, 
    EO.ixCustomerType
from vwEagleOrder EO -- must be a POTENTIAL EAGLE ORDER
    join tblOrder O on EO.ixOrder = O.ixOrder
where O.iShipMethod = 1
    and O.sOrderChannel not IN ('COUNTER', 'INTERNAL')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'  
    and O.dtShippedDate between '01/01/2015' and '12/31/2015'   
    
    
    
SELECT SUM(mMerchandise) Sales2015 -- 333,083.11 Counter P/U sales      1,310,145.92 ALL sales
from vwEagleOrder O
where --O.iShipMethod = 1
--    and O.sOrderChannel not IN ('COUNTER', 'INTERNAL')
    O.sOrderStatus = 'Shipped'
    --and O.sOrderType <> 'Internal'  
    and O.dtShippedDate between '01/01/2015' and '12/31/2015'   
    
    
    
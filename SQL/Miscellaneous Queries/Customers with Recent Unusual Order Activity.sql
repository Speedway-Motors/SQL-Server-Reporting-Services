-- Customers with Recent Unusual Order Activity
SELECT O.ixCustomer, O.ixCustomerType, O.ixOrder, -- 4,931 ROWS
    O.dtOrderDate, O.mMerchandise, O.sMethodOfPayment, O.sOrderChannel,
    O.sShipToCity, O.sShipToState
from tblOrder O
    join (-- customers with >1 order meeting the requirments
            select ixCustomer, COUNT(ixOrder) OrderCount
            from [vwRecentOrderActivity]
            group by ixCustomer
            HAVING COUNT(ixOrder) > 2
            ) QC on O.ixCustomer = QC.ixCustomer
where dtShippedDate >=  DATEADD(dd, -8, getdate())  -- past 8 days
    and O.ixCustomerType NOT IN ('30','32', '35', '40', '44', '45', '46', '80', '82.1') 
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE '%-%'
    and O.ixOrder NOT LIKE 'PC%' 
    and O.ixOrder NOT LIKE 'Q%'
    and O.sMethodOfPayment NOT IN ('CASH','ACCTS RCVBL')
    and O.mMerchandise > 100  

 

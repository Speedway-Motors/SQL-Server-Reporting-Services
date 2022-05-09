select 
    ixOrder         'Order #',
    O.ixCustomer    'Cust #', 
    mMerchandise    'Merch $',
    dtShippedDate   'Shipped',
    ixCustomerType  'Flag'    
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where    O.sOrderStatus = 'Shipped'
    --and O.sOrderType <> 'Internal'
    and O.sOrderChannel = 'INTERNAL'
    and O.mMerchandise > 0 
    and O.dtShippedDate between '01/01/2010' and '12/31/2011'
order by dtShippedDate    



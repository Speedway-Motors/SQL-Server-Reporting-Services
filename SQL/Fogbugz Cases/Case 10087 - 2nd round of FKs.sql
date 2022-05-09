select 
    ixOrder         'Order #',
    ixCustomer      'Cust #', 
    mMerchandise    'Merch $',
    dtShippedDate   'Shipped'
from tblOrder O
where    O.sOrderStatus = 'Shipped'
    --and O.sOrderType <> 'Internal'
    and O.sOrderChannel = 'INTERNAL'
    and O.mMerchandise > 0 
    and O.dtShippedDate between '01/01/2010' and '12/31/2011'
order by dtShippedDate    


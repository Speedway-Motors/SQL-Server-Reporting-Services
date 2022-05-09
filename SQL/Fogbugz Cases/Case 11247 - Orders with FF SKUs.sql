select O.ixOrder,
    O.ixCustomer,
    C.sCustomerFirstName,
    C.sCustomerLastName,
    O.mMerchandise,
    O.mMerchandiseCost,
    OL.ixSKU
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblCustomer C on O.ixCustomer = C.ixCustomer
where OL.ixSKU in ('FF','RULESFF','PROMOFF','CSIFF')
    and O.dtShippedDate >= '01/01/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'


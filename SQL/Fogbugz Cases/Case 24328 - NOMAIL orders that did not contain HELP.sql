-- Case 24328 - NOMAIL orders that did not contain HELP

select OL.ixOrder, O.dtOrderDate, O.dtShippedDate, O.mMerchandise, O.sOrderTaker, O.sOrderChannel, O.sOrderStatus, O.sMethodOfPayment,O.sShipToState
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where ixSKU = 'NOEMAIL'
    and O.dtOrderDate >= '10/22/2013'
    and sOrderStatus = 'Shipped' -- 4,824
    and iTotalTangibleLines > 0
    and OL.ixOrder NOT IN (select distinct OL.ixOrder -- 2,576
                            from tblOrderLine OL
                                join tblOrder O on OL.ixOrder = O.ixOrder
                            where ixSKU = 'HELP'
                                and O.dtOrderDate >= '10/22/2013'
                                and sOrderStatus = 'Shipped') -- 4,824)
                                
order by O.dtOrderDate


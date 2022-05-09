-- count of orders by Promo Code Applied for WEB orders > $124.99 placed between '11/21/11' and '12/02/11' 
select isNULL(sPromoApplied,'None') as 'Promo Applied', count(ixOrder) OrderCount
from tblOrder O
where O.sOrderChannel = 'WEB'
    and O.mMerchandise > 124.99
    and O.sOrderStatus <> 'Cancelled'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.dtOrderDate between '11/21/11' and '12/02/11'
   -- and O.sPromoApplied NOT like
group by O.sPromoApplied
    


select sOrderStatus, count(*)
from tblOrder
where dtOrderDate between '11/21/11' and '12/02/11'
group by sOrderStatus
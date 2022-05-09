
select dtOrderDate, sOrderStatus, FORMAT(COUNT(ixOrder),'###,###') 'Orders'
from tblOrder
where ixOrderDate between 19134 and 19140 -- wed 5/20 to tue 05/26
and sOrderStatus NOT IN ('Cancelled Quote','Quote','Pick Ticket')
group by dtOrderDate, sOrderStatus
order by dtOrderDate, sOrderStatus

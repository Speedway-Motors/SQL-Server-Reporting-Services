-- SMIHD-14952 - Research cancelled order

SELECT sOrderTaker, ixOrder, dtOrderDate, ixCustomer,  sOrderStatus from tblOrder where dtOrderDate < '09/01/2019'
and sOrderTaker = 'KLK1'
and sOrderStatus = 'Cancelled'
order by dtOrderDate desc


SELECT sOrderTaker, ixCanceledBy, ixOrder, dtOrderDate, ixCustomer,  sOrderStatus from tblOrder where dtOrderDate < '09/01/2019'
and ixCanceledBy = 'KLK1'
and sOrderStatus = 'Cancelled'
order by dtOrderDate desc


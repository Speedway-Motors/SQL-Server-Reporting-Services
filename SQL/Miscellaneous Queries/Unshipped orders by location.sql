-- SMIHD-17273 - Unshipped orders by location

select ixPrimaryShipLocation, sOrderStatus, count(*)
from tblOrder
where sOrderStatus NOT IN ('Shipped','Pick Ticket','Quote','Cancelled','Cancelled Quote','unknown')
-- and ixPrimaryShipLocation <> 99
group by ixPrimaryShipLocation, sOrderStatus
order by sOrderStatus, ixPrimaryShipLocation





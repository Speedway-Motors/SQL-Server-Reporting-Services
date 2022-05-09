-- Case 25685 - Qty of orders shipped in 2014 by month by order channel
select D.iMonth, D.sMonth, sOrderChannel, COUNT(ixOrder)
from tblOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
    join tblCustomer C on O.ixCustomer = C.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2014' and '12/31/2014'
   -- and C.sEmailAddress is NOT NULL -- per leslie, count all even if they don't have an email address
group by D.iMonth, D.sMonth, sOrderChannel
order by D.iMonth, sOrderChannel
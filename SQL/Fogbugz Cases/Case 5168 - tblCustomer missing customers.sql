select ixCustomer, count(distinct ixOrder) QTY, max(dtOrderDate)        -- SMI 2581 as of 11-1-10 9:47AM        AFCO 85 as of 11-1-10 9:47AM
from tblOrderLine
where ixCustomer not in (select ixCustomer from tblCustomer)
and flgLineStatus = 'Shipped'
group by ixCustomer
having max(dtOrderDate) > '01/01/2000'
order by count(ixOrder) desc, ixCustomer
-- SMIHD-20097 - AFCO Order Status not updated

SELECT sOrderStatus
from tblOrder 
where ixOrder = '910569'

-- refeed all orders with the status values to make sure they are synched
select ixOrder 
from tblOrder 
where sOrderStatus in ('Open','Backordered','Quote') -- 128  1,175   137

select sOrderStatus, FORMAT(count(*),'###,###') 'OrderCnt'
from tblOrder
where sOrderStatus IN ('Open','Backordered','Quote')
group by sOrderStatus
order by sOrderStatus
/*                          AFTER 
                BEFORE      REFEEDING
sOrderStatus	OrderCnt    OrderCnt
============    ========    ========
Backordered	    1,175        1,045
Open	        128            117  
Quote	        137            137

*/

-- Status should never change on these
select sOrderStatus, count(*)
from tblOrder
where sOrderStatus NOT IN ('Open','Backordered','Shipped')
group by sOrderStatus
order by sOrderStatus
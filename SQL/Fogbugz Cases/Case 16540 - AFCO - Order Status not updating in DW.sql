-- Case 16540 - AFCO - Order Status not updating in DW
select max(dtDateLastSOPUpdate)
from tblOrder
where dtOrderDate = '11/16/2012'

select max(ixTimeLastSOPUpdate)
from tblOrder
where dtOrderDate = '11/15/2012' -- 54048

select * from tblTime where ixTime = 54048






select count(*) OrdCnt, sOrderStatus
from tblOrder
where dtOrderDate = '11/15/2012'
group by sOrderStatus
/* 

BEFORE FEEDS GOT RESTARTED
OrdCnt	sOrderStatus
2	    Backordered
74	    Open
3	    Shipped

AFTER
OrdCnt	sOrderStatus
3	Backordered
1	Cancelled
9	Open
88	Shipped
*/









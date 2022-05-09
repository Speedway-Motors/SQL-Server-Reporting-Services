-- new flgLineStatus for backordered Factory Ship - Backordered FS
select flgLineStatus, COUNT(*)
from tblOrderLine
group by flgLineStatus


Backordered	68,300
Cancelled	39862
Cancelled Quote	6808
fail	20
Lost	2164
Open	1074
Quote	82
Shipped	767975

 'Backordered-FS'
 
 select distinct ixOrder, dtDateLastSOPUpdate
 from tblOrderLine
 where flgLineStatus in ('Lost','fail')
 and dtDateLastSOPUpdate < '04/07/2015'
 order by 
 dtDateLastSOPUpdate desc
 ixOrder
 
select COUNT(distinct ixOrder) from tblOrderLine
where flgLineStatus = 'Backordered'
and ixOrder in (select ixOrder from tblOrder
                    where sOrderStatus in ('Backordered','Open')
                    )

select distinct sOrderStatus from tblOrder

select * from tblOrderLine
where ixOrder = '751410'

select * from tblOrderLine
where ixOrder = '750362'






-- after new values started to populate 
select * from tblOrderLine
where ixOrder = '6990807' and ixSKU ='10613735T'

select distinct ixOrder
--, ixSKU, flgLineStatus
from tblOrderLine
where flgLineStatus = 'Backordered FS'
    1239 SMI
    198 AFCO
    
select ixOrder, ixSKU, flgLineStatus
from tblOrderLine
where ixOrder like 'Q%'
order by flgLineStatus-- = 'Backordered FS'
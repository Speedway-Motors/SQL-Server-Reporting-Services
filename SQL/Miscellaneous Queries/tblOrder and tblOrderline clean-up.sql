-- tblOrder and tblOrderline clean-up
-- Removing Orders prior to 2006

select FORMAT(min(dtOrderDate),'yyyy.MM.dd') 'MinOrderDate', 
    FORMAT(min(dtShippedDate),'yyyy.MM.dd') 'MinShippedDate'
from tblOrder
/*
Min         Min
OrderDate	ShippedDate
2006.01.01	2006.01.03
*/

select FORMAT(count(*),'###,###')
--DELETE
from tblOrderLine
where ixOrder in (select ixOrder from tblOrder where dtShippedDate < '01/01/2006') -- 531 orders

select FORMAT(count(*),'###,###')
--DELETE
from tblOrder
where ixOrder in (select ixOrder from tblOrder where dtShippedDate < '01/01/2006') -- 531 orders

select FORMAT(count(*),'###,###')
--DELETE
from tblOrderLine
where ixOrder in (select ixOrder from tblOrder where dtShippedDate < '01/01/2006')



select FORMAT(count(*),'###,###')
--DELETE
from tblOrder
 where dtOrderDate< '01/01/2006'
and sOrderStatus not in ('Shipped')



select FORMAT(count(*),'###,###')
--DELETE
from tblOrderLine
where ixOrder in 
    (select ixOrder from tblOrder where dtOrderDate< '01/01/2006'
and sOrderStatus not in ('DropShipped','Shipped'))


select datepart(YEAR,dtOrderDate) 'Yr'
, FORMAT(count(*),'###,###')
from tblOrder where dtOrderDate < '01/01/2007'
group by datepart(YEAR,dtOrderDate)
ORDER BY datepart(YEAR,dtOrderDate)

-- 
select datepart(YEAR,dtShippedDate), count(*)
from tblOrder 
where dtOrderDate < '01/01/2006'
--and dtShippedDate < '01/01/2006'
group by datepart(YEAR,dtShippedDate)

select * from tblOrder 
where dtOrderDate < '01/01/2006'
and dtShippedDate < '01/01/2006'


select * from tblOrder 
where dtOrderDate < '01/01/2006'
and dtShippedDate is NULL

select *
-- DELETE 
from tblOrder Line
where dtOrderDate < '01/01/2006'
and dtShippedDate is NULL



select 
--distinct flgLineStatus
FORMAT(count(*),'###,###')
 -- DELETE
from tblOrder--Line
where ixOrder in 
    (select ixOrder from tblOrder 
where dtOrderDate < '01/01/2006'
and dtShippedDate is NULL)



select ixOrder, dtOrderDate, sOrderStatus
from tblOrder 
where  dtShippedDate is NULL
order by dtOrderDate

BEGIN TRAN

    DELETE FROM tblOrder
    where ixOrder in ('229018','827567','66057','770045','1148809','964986','1106007','1164976','432979','8134','695707','63730')

ROLLBACK TRAN

select * 
-- DELETE 
from tblOrder where dtOrderDate is NULL


select 
--distinct flgLineStatus
FORMAT(count(*),'###,###')
--DELETE
from tblOrderLine
where ixOrder in 
    (select ixOrder from tblOrder where dtOrderDate is NULL)
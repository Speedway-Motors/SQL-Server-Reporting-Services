-- WEB vs Web Mobile issue

select flgDeviceType, FORMAT(count(*),'###,###') OrderCount, FORMAT(GETDATE(),'yyyy.MM.dd hh:mm')  'AsOf'
from tblOrder
where dtOrderDate = '12/30/2019'
    and sOrderStatus in ('Shipped','Open')
    and sWebOrderID is NOT NULL
group by flgDeviceType
order by flgDeviceType
/*              Order
flgDeviceType	Count	AsOf
NULL	2,562	2019.12.30 02:43



*/
select ixOrder, sWebOrderID, ixOrderTime, flgDeviceType from tblOrder
where dtOrderDate = '12/31/2019'
    and sOrderStatus in ('Shipped','Open')
    and sWebOrderID is NOT NULL
    --and ixOrderTime > 53580 -- 14:53
order by flgDeviceType desc
141 out of 545
select * from tblTime
where chTime like '14:50:00%'


FORMAT(D.dtDate,'yyyy.MM.dd') as 'Created'
FORMAT(GETDATE(),'yyyy.MM.dd hh:mm')  'AsOf'



-- Dec 2018
select flgDeviceType, FORMAT(count(*),'###,###') OrderCount
from tblOrder
where dtOrderDate between '12/28/2018' and '12/29/2018'
    and sOrderStatus = 'Shipped'
    and sWebOrderID is NOT NULL
group by flgDeviceType
order by flgDeviceType

select dtOrderDate, FORMAT(count(ixOrder),'###,###') WebOrderCount
from tblOrder
where dtOrderDate in('12/27/2018','12/28/2018','12/29/2018','12/27/2019','12/28/2019','12/29/2019')  --,
    and sOrderStatus in ('Shipped','Open')
    and sWebOrderID is NOT NULL
group by dtOrderDate
order by dtOrderDate
 

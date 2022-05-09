select count(ixOrder) BOCount, (datediff(day,dtOrderDate, dtShippedDate)) DaysDelay --
FROM tblOrder
where sOrderChannel <> 'INTERNAL'
  and sOrderStatus = 'Shipped'
  and dtOrderDate between '01/01/2011' and '06/30/2011'
  and ixOrder like '%-%'
GROUP BY (datediff(day,dtOrderDate, dtShippedDate))
order by DaysDelay desc




select D2.dtDate Created,
      D.dtDate Closed,
      R.* 
from tblReceiver R
   join tblDate D on R.ixCloseDate = D.ixDate 
   join tblDate D2 on R.ixCreateDate = D2.ixDate 
where ixReceiver in ('95462','94581','95171','95239','95257','95317','95338','95388','95389','95412')
order by R.ixReceiver

select ixPurchaseOrder on 




select POD.*, D.dtDate FirstRecv
from tblPODetail POD
   join tblDate D on D.ixDate = POD.ixFirstReceivedDate
where ixPO = '73105'

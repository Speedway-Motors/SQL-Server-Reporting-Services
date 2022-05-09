-- All OPEN COUNTER Orders

select ixOrder, dtDateLastSOPUpdate, T.chTime
from tblOrder O -- 59 to 45     
    left join tblTime T on O.ixTimeLastSOPUpdate = T.ixTime
where sOrderStatus = 'Open' -- last pushed 5:40
and iShipMethod = 1
order by dtDateLastSOPUpdate, T.chTime
/*
order
queue   At
======  ====

45,535  5:00
50,160  4:22
47,114  3:45

*/

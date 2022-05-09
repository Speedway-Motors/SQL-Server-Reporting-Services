-- WEB orders placed today
select ixOrder,
    mMerchandise, 
    sMethodOfPayment, 
    sWebOrderID, 
    sOrderChannel, 
    T.chTime 'OrderTime'
from tblOrder O
    join tblTime T on O.ixOrderTime = T.ixTime
where dtOrderDate = '12/23/2013'
    and sWebOrderID is NOT NULL
    --and sOrderChannel = 'WEB'
    and sMethodOfPayment = 'VISA'
    and mMerchandise < 46
    and ixOrderTime > 51900 -- 14:25
order by 'OrderTime' -- mMerchandise
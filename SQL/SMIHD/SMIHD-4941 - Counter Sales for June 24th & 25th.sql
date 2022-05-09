-- SMIHD-4941 - Counter Sales for June 24th & 25th
select ixOrder, mMerchandise, dtOrderDate, T.iHour 'OrderHour', 
--O.dtShippedDate, 
O.sOrderChannel, O.sOrderType
from tblOrder O
join tblTime T on O.ixOrderTime = T.ixTime
where sOrderStatus = 'Shipped'
    AND ixShippedDate in (17709,17708) -- ('06/24/2016','06/25/2016')
    AND ixOrderDate in (17709,17708)
    AND iShipMethod = 1
    AND O.sOrderType <> 'Internal'
    
   
ORDER BY dtOrderDate, T.iHour


-- select * from tblShipMethod


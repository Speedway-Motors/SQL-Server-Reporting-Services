-- Case 1837 - Phone Order Timing Analysis report not returning recent data

-- Count of Orders with Timing Info
select COUNT(*)
from tblOrder O
    join tblOrderTiming OT on O.ixOrder = OT.ixOrder
where O.dtOrderDate = '04/18/2012'  



-- Phone Orders Taken
select count(*) 
from tblOrder O 
where dtOrderDate = '04/18/2012'  
    and O.sOrderChannel = 'PHONE'




-- select count(*) from tblOrderTiming -- 715,267 @4-19-2013
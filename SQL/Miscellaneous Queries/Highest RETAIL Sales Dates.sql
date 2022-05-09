-- Highest RETAIL Sales Dates
SELECT top 10 dtOrderDate, 
    datename(dw,dtOrderDate) 'Day', 
    FORMAT(round(sum(O.mMerchandise), -3),'$###,###') 'Sales'
FROM tblOrder O
WHERE O.sOrderStatus in ('Shipped','Open')
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    -- and O.sOrderType = 'Retail'
    -- and datename(dw,dtOrderDate) NOT IN ('Monday','Tuesday','Wednesday')    
GROUP BY dtOrderDate, datename(dw,dtOrderDate) 
HAVING sum(O.mMerchandise) > 750000
Order by Sales desc
/*
OrderDate	    	Sales
2017-11-27 Monday	817,177
2018-03-12 Monday	743,984
2018-03-05 Monday	727,265
2017-03-27 Monday	712,393
2018-03-26 Monday	708,827

-- counts by Day Of Week
select Weekday, COUNT(*)
from (
        select dtOrderDate, datename(dw,dtOrderDate) as 'Weekday'--, sum(O.mMerchandise) Sales, COUNT(distinct dtOrderDate)
        from tblOrder O
        where     O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
            and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.sOrderType = 'Retail'
        --and datename(dw,dtOrderDate) NOT IN ('Monday','Tuesday','Wednesday')    
        group by dtOrderDate 
        having sum(O.mMerchandise) > 500000
        ) x
group by Weekday
order by COUNT(*) desc


-- counts by Day Of Week
select Weekday, COUNT(*)
from (
        select dtOrderDate, datename(dw,dtOrderDate) as 'Weekday'--, sum(O.mMerchandise) Sales, COUNT(distinct dtOrderDate)
        from tblOrder O
        where     O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
            and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            -- and O.sOrderType = 'Retail'
        --and datename(dw,dtOrderDate) NOT IN ('Monday','Tuesday','Wednesday')    
        group by dtOrderDate 
        having sum(O.mMerchandise) > 600000
        ) x
group by Weekday
order by COUNT(*) desc

-- counts by Day Of Week
select Weekday, COUNT(*)
from (
        select dtOrderDate, datename(dw,dtOrderDate) as 'Weekday'--, sum(O.mMerchandise) Sales, COUNT(distinct dtOrderDate)
        from tblOrder O
        where     O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
            and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            -- and O.sOrderType = 'Retail'
        --and datename(dw,dtOrderDate) NOT IN ('Monday','Tuesday','Wednesday')    
        group by dtOrderDate 
        having sum(O.mMerchandise) > 600000
        ) x
group by Weekday
order by COUNT(*) desc




SELECT iYear 'Year', Weekday, AVG(Sales) 'AvgSales'
FROM (
        select D.iYear, dtOrderDate, datename(dw,dtOrderDate) as 'Weekday', sum(O.mMerchandise) Sales--, COUNT(distinct dtOrderDate)
        from tblOrder O
        join tblDate D on O.ixOrderDate = D.ixDate
        where     O.sOrderStatus = 'Shipped'
           -- and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
            and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            -- and O.sOrderType = 'Retail'
        --and datename(dw,dtOrderDate) NOT IN ('Monday','Tuesday','Wednesday')    
        group by D.iYear, dtOrderDate 
        --having sum(O.mMerchandise) > 600000
        ) x
WHERE dtOrderDate >= '01/01/2013'
GROUP BY iYear, Weekday
ORDER BY iYear, AVG(Sales) desc
/*
2016 FINAL

Monday	48121
Tuesday	434251
Wednesday	377562
Thursday	333897
Friday	294473
Sunday	154877
Saturday	150728


SELECT COUNT(*) from tblOrder
where sOrderStatus = 'Open'

SELECT ixOrder, dtOrderDate, dtDateLastSOPUpdate
from tblOrder
where sOrderStatus = 'Open'
and dtOrderDate between '01/01/2018' and '04/01/2018'
order by dtDateLastSOPUpdate
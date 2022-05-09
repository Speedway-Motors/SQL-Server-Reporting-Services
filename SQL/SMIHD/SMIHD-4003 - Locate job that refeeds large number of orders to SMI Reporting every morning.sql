-- SMIHD-4003 - Locate job that refeeds large number of orders to SMI Reporting every morning
select ixTime, chTime,
SUBSTRING(chTime,1,2) 'Hour'
from tblTime where chTime like '%:00:00'
/*
21600	06:00:00  
25200	07:00:00  
28800	08:00:00  
32400	09:00:00  
*/

select COUNT(iSeq), SUBSTRING(chTime,1,2) 
from tblSKUTransaction ST
left join tblTime T on ST.ixTime = T.ixTime
where ST.ixDate = 17620
group by SUBSTRING(chTime,1,2) 
order by SUBSTRING(chTime,1,2) 

SELECT * from tblTime where ixTime in (21600, 30600)
/*
21600	6	0	0	1	361	21600	25	06:00:00  
30600	8	30	0	3	511	30600	35	08:30:00  
*/

select dtDateLastSOPUpdate, COUNT(ixOrder) 'RecUpdated', SUBSTRING(chTime,1,2) 
from tblOrder O
left join tblTime T on O.ixTimeLastSOPUpdate = T.ixTime
where O.dtDateLastSOPUpdate >= '04/12/16'
--and ixTime between 0 and 21600
group by dtDateLastSOPUpdate, SUBSTRING(chTime,1,2) 
order by dtDateLastSOPUpdate, SUBSTRING(chTime,1,2) 

-- orders refeed before 8:30 that were not placed or shipped in the last 30 days
select ixOrder, dtOrderDate, dtShippedDate, sOrderStatus, sOrderChannel, sOrderType, 
mMerchandise, ixCustomer, dtDateLastSOPUpdate, T.chTime 'TimeLastSOPUpdate'--, COUNT(ixOrder) 'RecUpdated', SUBSTRING(chTime,1,2) 
INTO [SMITemp].dbo.PJC_SMIHD_4003_OrderRefedMorning_2016_0412 -- 4,235
from tblOrder O
    left join tblTime T on O.ixTimeLastSOPUpdate = T.ixTime
where O.dtDateLastSOPUpdate >= '04/12/16'
    and ixTime between 0 and 30600
    and dtOrderDate < '03/12/2016'
    and (dtShippedDate is NULL
       or dtShippedDate < '03/12/2016')
order by T.chTime 
--group by dtDateLastSOPUpdate, SUBSTRING(chTime,1,2) 
--order by dtDateLastSOPUpdate, SUBSTRING(chTime,1,2) 



SELECT * FROM [SMITemp].dbo.PJC_SMIHD_4003_OrderRefedMorning_2016_0412  -- 3,699 cancelled orders. updated between 7:16 and 7:54.  order dates 10/4/16 to 02/29/16
WHERE sOrderStatus IN ('Cancelled')    --     ('Backordered')                381    360 backorders.  updated between 6:50 and 6:55. order dates 12/03/13 to 02/29/16
order by dtOrderDate

4,235 4,188
/* comparing records refed 4/4/16 to ones refed 4/1/16                         04/04/16     04/12/16 */
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD_4003_OrderRefedMorning_2016_0412  -- 3,807        3,699 cancelled orders. updated between 7:16 and 7:54.  order dates 10/4/16 to 02/29/16
    WHERE sOrderStatus IN  ('Cancelled')  -- ('Backordered') --                  381          360 backorders.  updated between 6:50 and 6:55. order dates 12/03/13 to 02/29/16
    order by dtOrderDate

    SELECT * -- 4,101 total orders
    FROM [SMITemp].dbo.PJC_SMIHD_4003_OrderRefedMorning_2016_0404 OLD
        full outer join [SMITemp].dbo.PJC_SMIHD_4003_OrderRefedMorning_2016_0412 NEW on OLD.ixOrder = NEW.ixOrder
    WHERE OLD.ixOrder is NULL
    OR NEW.ixOrder is NULL
    ORDER BY OLD.dtOrderDate    

    -- almost identical list.  records with order dates from 10/4/15-10/6/15 did not refeed confirming the rolling 6 months.



SELECT * from tblOrder
where sOrderStatus = 'Cancelled'
and dtOrderDate >= '12/03/2013'

SELECT sOrderStatus, COUNT(*) from [SMITemp].dbo.PJC_SMIHD_4003_OrderRefedMorning_2016_0401
group by sOrderStatus



select dtDateLastSOPUpdate, COUNT(ixOrder) 'RecUpdated', SUBSTRING(chTime,1,5) 
from tblOrder O
left join tblTime T on O.ixTimeLastSOPUpdate = T.ixTime
where O.dtDateLastSOPUpdate >= '03/21/16'
and ixTime between 18000 and 28800
group by dtDateLastSOPUpdate, SUBSTRING(chTime,1,5) 
order by dtDateLastSOPUpdate, SUBSTRING(chTime,1,5) 


SELECT ixOrder, ixCustomer, dtOrderDate, dtShippedDate
FROM tblOrder O
where O.dtDateLastSOPUpdate = '03/29/16'
and ixTimeLastSOPUpdate between 24900 and 30800 -- 8,333
-- and ixOrder NOT like 'Q%' -- 79
order by dtOrderDate

SELECT sOrderStatus, count(ixOrder) --, ixCustomer, dtOrderDate, dtShippedDate
FROM tblOrder O
where O.dtDateLastSOPUpdate = '03/29/16'
    and ixTimeLastSOPUpdate between 24900 and 30800 -- 6,200
    and ixOrder NOT like 'Q%' -- 79
group by sOrderStatus

SELECT sOrderStatus, count(ixOrder) --, ixCustomer, dtOrderDate, dtShippedDate
FROM tblOrder O
where O.dtDateLastSOPUpdate = '04/29/16'
    and ixTimeLastSOPUpdate between 0 and 30800 -- 6,130
  --  and ixOrder NOT like 'Q%' -- 79
group by sOrderStatus
order by count(ixOrder) desc

SELECT count(ixOrder) --, ixCustomer, dtOrderDate, dtShippedDate
FROM tblOrder O
where O.dtDateLastSOPUpdate = '03/28/16'
    and ixTimeLastSOPUpdate between 24900 and 30800 -- 6,130
    and (dtOrderDate > '03/01/2016'
        or dtShippedDate > =  '03/01/2016')
  --  and ixOrder NOT like 'Q%' -- 79
group by sOrderStatus
order by count(ixOrder) desc


select * from tblTime where ixTime = 30800

SELECT ixCustomerType, count(ixOrder) --, ixCustomer, dtOrderDate, dtShippedDate
FROM tblOrder O
where O.dtDateLastSOPUpdate = '04/29/16'
    and ixTimeLastSOPUpdate between 0 and 30800 -- 6,200
    --and O.dtOrderDate <='03/29/16'
    and ixOrder NOT like 'Q%' -- 79
group by ixCustomerType
order by count(ixOrder) desc
/*
1	277
2	2733
3	3
4	25
6	1410
8	358
9	195
10	83
11	17
12	23
13	48
14	226
15	577
26	10
27	3
32	142
*/
select * from tblShipMethod


order by dtOrderDate

select

2200

select COUNT(*)
from tblOrder where dtShippedDate >= '03/01/2016'

select ixDate, T.chTime, sFeedStatus
from tblSOPFeedLog FL
left join tblTime T on FL.ixTime = T.ixTime
where ixDate > 17606
order by ixDate, FL.ixTime

130000 - 87 
select * from tblDate where dtDate = '03/28/2016' 

1500




SELECT *
FROM tblOrder O
where O.dtDateLastSOPUpdate = '04/28/16'
    AND sOrderStatus = 'Cancelled'
    and ixTimeLastSOPUpdate between 0 and 30800 -- 4,908

select COUNT(iSeq), SUBSTRING(chTime,1,2) 
from tblSKUTransaction ST
left join tblTime T on ST.ixTime = T.ixTime
where ST.ixDate = 17620
group by SUBSTRING(chTime,1,2)  


SELECT COUNT(ixOrder) 'OrdCnt', SUBSTRING(chTime,1,2) 'hour' 
FROM tblOrder O
left join tblTime T on O.ixTimeLastSOPUpdate = T.ixTime
where O.dtDateLastSOPUpdate = '04/28/16'
  --  AND sOrderStatus = 'Cancelled'
    and ixTimeLastSOPUpdate between 0 and 30800 -- 4,908
group by SUBSTRING(chTime,1,2)  
order by SUBSTRING(chTime,1,2)    
/*
1007	06
6263	07
1324	08
*/

SELECT COUNT(ixOrder) 'OrdCnt', SUBSTRING(chTime,1,2) 'hour' 
FROM tblOrder O
left join tblTime T on O.ixTimeLastSOPUpdate = T.ixTime
where O.dtDateLastSOPUpdate = '04/27/16'
  --  AND sOrderStatus = 'Cancelled'
    and ixTimeLastSOPUpdate > 30800 -- 4,908
group by SUBSTRING(chTime,1,2)  
order by SUBSTRING(chTime,1,2)     


select * from tblSOPFeedLog
where dtDate >= '04/27/2016'
order by dtDate, ixTime


sELECT dbo.GetCurrentixTime ()


select * from tblOrder
where ixOrder like '%-%'

select D.iYear, D.sMonth, D.iMonth, COUNT(O.ixOrder) 'Backorders'
from tblOrder O
    join tblDate D on D.ixDate = O.ixOrderDate
where sOrderStatus = 'Backordered'
group by D.iYear, D.sMonth, D.iMonth
order by D.iYear, D.iMonth

select * from tblDate


select * from tblOrderL
where sOrderStatus = 'Backordered'
and dtOrderDate < '01/28/2016'


select * from tblOrder
where dtDateLastSOPUpdate = '04/28/2016'



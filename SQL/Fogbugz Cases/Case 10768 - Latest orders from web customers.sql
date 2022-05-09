select count(distinct sWebOrderID) from PJC_OctWebOrders -- 521

select * from PJC_OctWebOrders

-- GET CUSTOMER #
update PJC_OctWebOrders 
set ixCustomer = B.ixCustomer
from PJC_OctWebOrders A
inner join tblOrder B on A.sWebOrderID = B.sWebOrderID

-- GET DATE ORDERED
update PJC_OctWebOrders 
set dtOrderDate = B.dtOrderDate
from PJC_OctWebOrders A
inner join tblOrder B on A.sWebOrderID = B.sWebOrderID

-- getting most current order for each customer prior to 10-1-11 that was greater than $5
-- drop table PJC_MaxOrdDates
select WO.ixCustomer, B.MaxOrdDate 
into PJC_MaxOrdDates
from PJC_OctWebOrders WO
    left join (select ixCustomer, max(dtOrderDate) MaxOrdDate
               from tblOrder
               where ixCustomer in (select ixCustomer from PJC_OctWebOrders)
                 and mMerchandise > 5
                 and dtOrderDate < '10/01/2011'
                 --and sWebOrderID is NULL
                 and ixOrder not in (select ixOrder from PJC_OctWebOrders
                                     where ixOrder is NOT null)
                 --sWebOrderID not in (select sWebOrderID from PJC_OctWebOrders)
               group by ixCustomer
               ) B on WO.ixCustomer = B.ixCustomer

-- update  MaxPriorOrderDate               
update PJC_OctWebOrders 
set MaxPriorOrderDate = B.MaxOrdDate
from PJC_OctWebOrders A
inner join PJC_MaxOrdDates B on A.ixCustomer = B.ixCustomer    

               
-- ADD GP               
update PJC_OctWebOrders 
set GP = B.mMerchandise - B.mMerchandiseCost
from PJC_OctWebOrders A
inner join tblOrder B on A.sWebOrderID = B.sWebOrderID              







select max(ixCustomer)
from tblOrder
where dtOrderDate = '09/01/2011'


select ixCustomer
from tblCustomer
where dtAccountCreateDate > '09/01/2011'
order by ixCustomer


select count(*) from tblOrder where dtShippedDate = '10/24/2011'


select * from tblPOMaster
where ixPO like 'E%'


select sWebOrderID
from tblOrder
where sOrderChannel in ('WEB') -- ,'EBAY')
AND sWebOrderID is NOT null
order by sWebOrderID

select sOrderChannel, count(*)
from tblOrder
group by sOrderChannel
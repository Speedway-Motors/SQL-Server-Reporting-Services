-- SMIHD-15178 - Reorder analysis for Aaron

/*
 for customers who ordered between two date ranges 
 with orders less than 99 
 what percentage ordered again through yesterday. 
 then compare to the same date ranges last year 
 and see if the percentage was stable or what that looked like in comparison. 
 ORDER CHANNEL = 'PHONE' -- this requirement added 10-8-2019
*/

Range 1: 6/10/19 to 6/23/19             
Range 2: 7/15/19 through 8/8/19 

then the same date periods the previous year. but with the corresponding days vs actual date so it has the same number of mondays etc. 


select * from tblDate where dtDate between '06/10/2019' and '06/23/2019' 
select * from tblDate where dtDate between '06/11/2018' and '06/24/2018'


select * from tblDate where dtDate between '07/15/2019' and '08/08/2019' 
select * from tblDate where dtDate between '07/16/2018' and '08/09/2018'


-- First Batch
-- DROP TABLE #FirstCustBatch
select distinct ixCustomer -- 2,081
into #FirstCustBatch
from tblOrder
where dtOrderDate between '06/10/2019' and '06/23/2019' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and mMerchandise between 0.01 and 98.99

-- DROP TABLE #FirstCustBatchREORDERED
select distinct ixCustomer -- 735             35.3% re-ordered
into #FirstCustBatchREORDERED
from tblOrder
where dtOrderDate between '06/24/2019' and '09/23/2019' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and ixCustomer in (select ixCustomer from #FirstCustBatch)


-- First Batch previous year
-- DROP TABLE #FirstCustBatchPrevYear
select distinct ixCustomer -- 2,434
into #FirstCustBatchPrevYear
from tblOrder
where dtOrderDate between '06/11/2018' and '06/24/2018' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and mMerchandise between 0.01 and 98.99


-- DROP TABLE #FirstCustBatchREORDEREDPrevYear
select distinct ixCustomer -- 562             23.0% re-ordered
into #FirstCustBatchREORDEREDPrevYear
from tblOrder
where dtOrderDate between '06/25/2018' and '09/24/2018' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and ixCustomer in (select ixCustomer from #FirstCustBatch)



/********       Second Batch        ******************/
select * from tblDate where dtDate between '07/15/2019' and '08/08/2019' 
select * from tblDate where dtDate between '07/16/2018' and '08/09/2018'

-- Second Batch
-- DROP TABLE #SecondCustBatch
select distinct ixCustomer -- 3,576
into #SecondCustBatch
from tblOrder
where dtOrderDate between '07/15/2019' and '08/08/2019' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and mMerchandise between 0.01 and 98.99

-- DROP TABLE #SecondCustBatchREORDERED
select distinct ixCustomer -- 777             21.7% re-ordered
into #SecondCustBatchREORDERED
from tblOrder
where dtOrderDate between '08/09/2019' and '09/23/2019' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and ixCustomer in (select ixCustomer from #SecondCustBatch)


-- Second Batch previous year
-- DROP TABLE #SecondCustBatchPrevYear
select distinct ixCustomer -- 4,292
into #SecondCustBatchPrevYear
from tblOrder
where dtOrderDate between '07/16/2018' and '08/09/2018' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and mMerchandise between 0.01 and 98.99


-- DROP TABLE #SecondCustBatchREORDEREDPrevYear
select distinct ixCustomer -- 557             13.0% re-ordered
into #SecondCustBatchREORDEREDPrevYear
from tblOrder
where dtOrderDate between '08/10/2018' and '09/24/2018' 
    and sOrderStatus in ('Shipped', 'Dropshipped', 'Backordered')
    and sOrderType = 'Retail'
    and sOrderChannel = 'PHONE'
    and ixCustomer in (select ixCustomer from #SecondCustBatch)

select distinct C.ixCustomer
-- drop table PJC_12MonthCustomers
into PJC_12MonthCustomers -- 165,369
from tblOrder O
   join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.dtOrderDate >= '8/19/2010'
  and O.mMerchandise > 5
  and O.sOrderChannel <> 'INTERNAL'
  and O.sOrderType <> 'INTERNAL'
  and C.sCustomerType = 'RETAIL'


select distinct C.ixCustomer
-- drop table PJC_24MonthCustomers
into PJC_24MonthCustomers
from tblOrder O
   join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.dtOrderDate >= '8/19/2009' -- 246,762
  and O.mMerchandise > 5
  and O.sOrderChannel <> 'INTERNAL'
  and O.sOrderType <> 'INTERNAL'
  and C.sCustomerType = 'RETAIL'



-- 12 Month Customers with tot lifetime purchases of $10K+
select OneYr.ixCustomer, sum(mMerchandise) -- 4,072
from vwOrderAllHistory OH
   join PJC_12MonthCustomers OneYr on OH.ixCustomer = OneYr.ixCustomer
where sOrderChannel <> 'INTERNAL'
  AND sOrderType <> 'INTERNAL'
group by OneYr.ixCustomer
having sum(mMerchandise) >= 10000
order by sum(mMerchandise) 

-- 12 Month Customers with tot lifetime purchases of $15K+
select OneYr.ixCustomer, sum(mMerchandise) -- 1,796
from vwOrderAllHistory OH
   join PJC_12MonthCustomers OneYr on OH.ixCustomer = OneYr.ixCustomer
where sOrderChannel <> 'INTERNAL'
  AND sOrderType <> 'INTERNAL'
group by OneYr.ixCustomer
having sum(mMerchandise) >= 15000
order by sum(mMerchandise) 

-- 24 Month Customers with tot lifetime purchases of $10K+
select TwoYr.ixCustomer, sum(mMerchandise) -- 4,805
from vwOrderAllHistory OH
   join PJC_24MonthCustomers TwoYr on OH.ixCustomer = TwoYr.ixCustomer
where sOrderChannel <> 'INTERNAL'
  AND sOrderType <> 'INTERNAL'
group by TwoYr.ixCustomer
having sum(mMerchandise) >= 10000
order by sum(mMerchandise) 

-- 24 Month Customers with tot lifetime purchases of $15K+
select TwoYr.ixCustomer, sum(mMerchandise) -- 2,054
from vwOrderAllHistory OH
   join PJC_24MonthCustomers TwoYr on OH.ixCustomer = TwoYr.ixCustomer
where sOrderChannel <> 'INTERNAL'
  AND sOrderType <> 'INTERNAL'
group by TwoYr.ixCustomer
having sum(mMerchandise) >= 15000
order by sum(mMerchandise) 




select sOrderType, count (*)
from tblOrder
where dtShippedDate > '01/01/2008'
  and mMerchandise > 5
  and sOrderChannel <> 'INTERNAL'
group by sOrderType

select sOrderChannel, count (*)
from tblOrder
where dtShippedDate > '01/01/2011'
  and mMerchandise > 5
  and sOrderChannel <> 'INTERNAL'
group by sOrderChannel





/**** PART TWO order projections *****/

-- count of orders >$5 YTD 2011
select count(O.ixOrder) -- 253,499
from tblOrder O
   join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.sOrderStatus = 'Shipped'
  and O.dtShippedDate between '01/01/2011' and '08/18/2011'
  and O.mMerchandise > 5
  and O.sOrderChannel <> 'INTERNAL'
  and O.sOrderType <> 'INTERNAL'
  and C.sCustomerType = 'RETAIL'

-- count of orders >$5 matching YTD 2010
select count(O.ixOrder) -- 225,676
from tblOrder O
   join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.sOrderStatus = 'Shipped'
  and O.dtShippedDate between '01/01/2010' and '08/18/2010'
  and O.mMerchandise > 5
  and O.sOrderChannel <> 'INTERNAL'
  and O.sOrderType <> 'INTERNAL'
  and C.sCustomerType = 'RETAIL'



-- projected order growth from 2010 to 2011 = 12%
select count(ixOrder) -- 324,616
from tblOrder O
   join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.sOrderStatus = 'Shipped'
  and O.dtShippedDate between '01/01/2010' and '12/31/2010'
  and O.mMerchandise > 5
  and O.sOrderChannel <> 'INTERNAL'
  and O.sOrderType <> 'INTERNAL'
  and C.sCustomerType = 'RETAIL'

-- 325,929 * 1.12 = 363569.92 Projected Orders for 2011
-- 365,040 * 1.12 = 408,845 Projected Orders for 2012

-- SMIHD-13374 - Customer Information Request

/*
I would like to compare my results from Responsys to what we have in our data. 
We are trying to build info to create a look alike audience in Facebook.


REQUIREMENTS - customers have purchased 1+ orders that were $200+ (the order level, NOT combined total of multiple orders) within the past 6 months

We do not need to know if they purchased more than once, just if they have purchased at least once in the time frame. Fields I would need in the report are:

•	Customer Number
•	Customer email address (we will not be emailing them directly, only using the data to find 'like' customers)
•	Order Channel (you can include Speedway and any Marketplace orders) - are there multiples
•	Order date - most recent
•	Order total - # of $200+ orders
*/



SELECT COUNT(distinct O.ixCustomer) 'CustCount' -- 49,940   47,109
    -- distinct O.sOrderStatus
FROM tblOrder O
WHERE O.dtOrderDate >= '10/13/2018'
     and O.sOrderType <> 'Internal'
    and O.mMerchandise >= 200
    and O.sOrderStatus in ('Backordered','Open','Shipped') -- 47,457


SELECT distinct O.ixCustomer -- 49,940   47,109
    -- distinct O.sOrderStatus
INTO #QalifyingCustomers    
FROM tblOrder O
WHERE O.dtOrderDate >= '10/13/2018'
     and O.sOrderType <> 'Internal'
    and O.mMerchandise >= 200
    and O.sOrderStatus in ('Backordered','Open','Shipped') -- 47,457


    
SELECT  QC.ixCustomer, C.sEmailAddress,
     max(O.dtOrderDate) 'MostRecentOrder', 
     count(O.ixOrder) 'QualifyingOrders'
--     , FORMAT(SUM(mMerchandise),'$###,###') 'QualifiedSales' 
--      , FORMAT(SUM(mMerchandiseCost),'$###,###') 'MerchCost'
     , SUM(mMerchandise) 'QualifiedSales' 
      , SUM(mMerchandiseCost) 'MerchCost'
/*
    O.dtOrderDate,
    O.mMerchandise
    -- distinct O.sOrderStatus
*/
FROM #QalifyingCustomers QC
    left join tblCustomer C on QC.ixCustomer = C.ixCustomer
    left join tblOrder O on C.ixCustomer = O.ixCustomer
WHERE O.dtOrderDate >= '10/13/2018'
     and O.sOrderType <> 'Internal'
    and O.mMerchandise >= 200
    and O.sOrderStatus in ('Backordered','Open','Shipped') -- 47,457
    and C.sEmailAddress is NOT NULL
GROUP BY QC.ixCustomer,  C.sEmailAddress
--HAVING count(O.ixOrder)
order by   count(O.ixOrder) desc





SELECT C.ixCustomer
    ,C.sEmailAddress
    ,C.
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE O.dtOrderDate >= '10/13/2018'
    and O.mMerchandise >= 200






    select sOrderChannel, count(ixOrder) 'OrderCount'
from tblOrder
where sOrderStatus = 'Shipped'
and dtShippedDate >= '01/01/2019'
and dtOrderDate >= '01/01/2019'
and sOrderType <> 'Internal'
and mMerchandise > 0
group by sOrderChannel
order by sOrderChannel
/*
AMAZON	10935
AUCTION	23420
COUNTER	2267
E-MAIL	125
FAX	106
INTERNAL	27
MAIL	1209
PHONE	33985
WALMART	522
WEB	60932
*/

select sOrderChannel, count(ixOrder) 'OrderCount'
from tblOrder
where sOrderStatus = 'Shipped'
and dtShippedDate >= '01/01/2017'
and dtOrderDate >= '01/01/2017'
and sOrderType <> 'Internal'
and mMerchandise > 0
group by sOrderChannel
order by sOrderChannel



SELECT * FROM tblOrder
where ixCustomer in ('359650')
and dtOrderDate >= '10/14/2018'
and mMerchandise >= 200
and sOrderType <> 'Internal'
order by ixOrder


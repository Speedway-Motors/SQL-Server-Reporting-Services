-- SMIHD-13948 - Customer Information Request 

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

-- LOYALTY BUILDERS Customer Loyalty Groups
    -- DROP TABLE [SMITemp].dbo.SMIHD13669_LB_LoyaltyGroup_20190331
    SELECT FORMAT(COUNT(*),'###,###') 'CustCnt', 
           FORMAT(COUNT(distinct(ixCustomer)),'###,###')'DistCustCnt'
    FROM [SMITemp].dbo.SMIHD13669_LB_LoyaltyGroup_20190331
    /*
    CustCnt	DistCustCnt
    841,240	841,240
    */
    
    SELECT FORMAT(COUNT(C.ixCustomer),'###,###') 'CustCnt'
    from [SMITemp].dbo.SMIHD13669_LB_LoyaltyGroup_20190331 LB
        left join tblCustomer C on LB.ixCustomer = C.ixCustomer
    WHERE C.ixCustomer is NOT NULL  -- 841,240
        and C.flgDeletedFromSOP = 0 -- 841,165



SELECT distinct O.ixCustomer 
    -- distinct O.sOrderStatus
INTO #QalifyingCustomers    
FROM tblOrder O
WHERE O.dtOrderDate >= DATEADD(mm, -6, getdate())  -- 6 months ago
     and O.sOrderType <> 'Internal'
    and O.mMerchandise >= 200
    and O.sOrderStatus in ('Backordered','Open','Shipped') -- 61,829


-- Output for Excel file    
SELECT  QC.ixCustomer, 
    C.sCustomerFirstName,
    C.sCustomerLastName,
    C.sMailToCity,
    C.sMailToState,
    C.sMailToZip,
    C.sDayPhone,
    C.sCellPhone,
    C.sNightPhone,
    C.sEmailAddress, LB.sLoyaltyGroup
     , max(O.dtOrderDate) 'MostRecentOrder' 
     , count(O.ixOrder) 'QualifyingOrders'
     , SUM(mMerchandise) 'QualifiedSales' 
     , SUM(mMerchandiseCost) 'MerchCost'
--     , FORMAT(SUM(mMerchandise),'$###,###') 'QualifiedSales' 
--      , FORMAT(SUM(mMerchandiseCost),'$###,###') 'MerchCost'
FROM #QalifyingCustomers QC
    LEFT JOIN tblCustomer C on QC.ixCustomer = C.ixCustomer
    LEFT JOIN tblOrder O on C.ixCustomer = O.ixCustomer
    LEFT JOIN [SMITemp].dbo.SMIHD13669_LB_LoyaltyGroup_20190331 LB on QC.ixCustomer = LB.ixCustomer
WHERE O.dtOrderDate >= DATEADD(mm, -6, getdate())  -- 6 months ago
     and O.sOrderType <> 'Internal'
    and O.mMerchandise >= 200
    and O.sOrderStatus in ('Backordered','Open','Shipped') 
    and C.sEmailAddress is NOT NULL
    and sMailToCountry is NULL -- US customers
GROUP BY QC.ixCustomer,  C.sCustomerFirstName,
    C.sCustomerLastName,
    C.sMailToCity,
    C.sMailToState,
    C.sMailToZip,
    C.sCellPhone,
    C.sDayPhone,
    C.sNightPhone,
    C.sEmailAddress, LB.sLoyaltyGroup
--HAVING count(O.ixOrder)
ORDER BY count(O.ixOrder) desc
-- Phone, First Name, Last Name, Zip, City, State, Country

DROP TABLE #QalifyingCustomers



SELECT C.ixCustomer
    ,C.sEmailAddress
    ,C.
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE O.dtOrderDate >= DATEADD(mm, -6, getdate())  -- 6 months ago
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


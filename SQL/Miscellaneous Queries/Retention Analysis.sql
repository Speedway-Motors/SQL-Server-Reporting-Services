-- RETENTION ANALYSIS

-- Shipping Speeds 1&2xBuyers vs. Loyalists

-- run on 
-- DROP TABLE #1and2xBuyers2019
select C.ixCustomer, LB.sLoyaltyGroupRaw
into  #1and2xBuyers2019 -- 172,662
from [tng].tblloyaltybuilder_customer LB
left join tblCustomer C on LB.ixWeakSopCustomerNumber = C.ixCustomer
where C.flgDeletedFromSOP = 0
    and C.dtAccountCreateDate between '01/01/2019' and '12/31/2019'
    and LB.sLoyaltyGroupRaw = '1&2xBuyers'
order by LB.sLoyaltyGroupRaw

select C.ixCustomer, LB.sLoyaltyGroupRaw
into  #Loyalists2019 -- 9,451
from [tng].tblloyaltybuilder_customer LB
left join tblCustomer C on LB.ixWeakSopCustomerNumber = C.ixCustomer
where C.flgDeletedFromSOP = 0
    and C.dtAccountCreateDate between '01/01/2019' and '12/31/2019'
    and LB.sLoyaltyGroupRaw = 'Loyalists'
order by LB.sLoyaltyGroupRaw

-- DROP TABLE #Delivered1and2xBuyers2019
SELECT B.ixCustomer, O.ixOrder, O.ixOrderDate, max(P.ixPackageDeliveredLocal) 'DeliverdDate' -- 21,074
into #Delivered1and2xBuyers2019
FROM #1and2xBuyers2019 B
    left join tblOrder O on B.ixCustomer = O.ixCustomer
    left join tblPackage P on O.ixOrder = P.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE '%-%'
    AND P.ixPackageDeliveredLocal is NOT NULL
GROUP BY B.ixCustomer, O.ixOrder, O.ixOrderDate

SELECT COUNT(*) 'Records', SUM(ixOrderDate), SUM(DeliverdDate)
FROM #Delivered1and2xBuyers2019
-- 21074	397178099	397242178
-- AVG = 3.04 days


-- DROP TABLE #Delivered1and2xBuyers2019
SELECT L.ixCustomer, O.ixOrder, O.ixOrderDate, max(P.ixPackageDeliveredLocal) 'DeliverdDate' -- 5,498
into #DeliveredLoyalists2019
FROM #Loyalists2019 L
    left join tblOrder O on L.ixCustomer = O.ixCustomer
    left join tblPackage P on O.ixOrder = P.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE '%-%'
    and O.dtOrderDate < '01/01/2020'
    AND P.ixPackageDeliveredLocal is NOT NULL
GROUP BY L.ixCustomer, O.ixOrder, O.ixOrderDate


SELECT COUNT(*) 'Records', SUM(ixOrderDate), SUM(DeliverdDate)
FROM #DeliveredLoyalists2019
-- 5498	103687848	103704232
-- AVG delivery  = 3.04 days
/*
AVG delivery times for customers that were new in 2019

Days Group
==== ===============    
2.98 Loyalists
3.04 1&2 Time Buyers


*/

 








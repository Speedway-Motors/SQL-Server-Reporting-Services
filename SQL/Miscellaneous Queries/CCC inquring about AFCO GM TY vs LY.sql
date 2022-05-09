-- CCC inquring about AFCO GM TY vs LY

SELECT * from tblCustomer
where ixCustomer in ('50277','15109','46288','50718','10413','36106','13940','27446','51012','51311','50887','10279','50859','46273')




SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '12/31/2015' and '07/18/2016'
    and ixCustomer in (10511, 12410, 26101, 26103, 31173, 34795, 44776,  48398, 48400, 42097)
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer


SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '12/31/2016' and '07/18/2017'
    and ixCustomer in (10511, 12410, 26101, 26103, 31173, 34795, 44776,  48398, 48400, 42097)
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer


-- for 26103, how much of the revenue was between 12/31/15 and 04/15/16?
SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '12/31/2015' and '04/15/2016'
    and ixCustomer = 26103
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer


-- for 10511, how much of the revenue was between 12/31/15 and 04/15/16?
SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '12/31/2015' and '04/15/2016'
    and ixCustomer = 10511
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer

-- for 10511, how much of the revenue was between 12/31/15 and 04/15/16?
SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '04/16/2016' and '07/18/2016'
    and ixCustomer = 10511
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer
/*
ixCustomer	OrdCnt	GrossSales
10511	    214	    1,153,533
*/

-- for 10511, how much of the revenue was between 12/31/15 and 04/15/16?
SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '04/16/2016' and '05/16/2016'
    and ixCustomer = 10511
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer
-- $450,794

SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '05/17/2016' and '06/17/2016'
    and ixCustomer = 10511
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer
-- $335,908

SELECT O.ixCustomer, COUNT(O.ixOrder) OrdCnt, SUM(mMerchandise) GrossSales
from tblOrder O
where dtOrderDate between '06/18/2016' and '07/18/2016'
    and ixCustomer = 10511
    and O.sOrderStatus = 'Shipped'
GROUP BY O.ixCustomer
ORDER BY O.ixCustomer
-- $366,830


orders  Sales
15,369	3,381k
 1,715	2,378k
 
 select * from tblCustomer
 where ixCustomer = 26103
 
  select * from tblCustomer
 where ixCustomer = 10511
 
 
 
 May and Jun
-- SMIHD-4531 - Deltas in DOT vs SOP Flash sales reports

select * from vwDailyOrdersTaken
where dtDate = '05/16/2016'

-- the basic logic behind the orders that are included in vwDailyOrdersTaken
select count(ixOrder), sOrderStatus, sum(O.mMerchandise)
from tblOrder O
where ixOrderDate = 17669
  and O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
  and O.sOrderType <> 'Internal'
group by   sOrderStatus

-- Orders totalled in DOT for 05/16/2016
select ixOrder
into [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT -- 2763
from tblOrder O
where ixOrderDate = 17669
  and O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
  and O.sOrderType <> 'Internal'
group by   ixOrder

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport 
Select COUNT(*), COUNT(distinct(ixOrder))
from [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport 
-- 2780	2780

Select COUNT(*), COUNT(distinct(ixOrder))
from [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT 
-- 2763	2763

SELECT count(FLASH.ixOrder), SUM(O.mMerchandise) Sales
from tblOrder O
 join [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport FLASH on O.ixOrder = FLASH.ixOrder -- 642,649.04
 
SMIHD-4513_BKR.txt -- 2,780
SMIHD-4513_ICE.txt -- 18

SELECT count(FLASH.ixOrder), SUM(O.mMerchandise) Sales
from tblOrder O
    join [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport FLASH on O.ixOrder = FLASH.ixOrder -- 2,780	$642,649.04
 
SELECT count(FLASH.ixOrder), SUM(O.mMerchandise) Sales
from tblOrder O
    join [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT FLASH on O.ixOrder = FLASH.ixOrder -- 2,763	$641,361.73
 
 
 -- Orders in FLASH but not DOT
 SELECT COUNT(FLASH.ixOrder) -- 2745
 FROM [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport FLASH 
 where FLASH.ixOrder NOT IN (SELECT ixOrder from [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT) -- 2,763 in   17 NOT in 
 
         SELECT FLASH.ixOrder -- 2745
         FROM [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport FLASH 
         where FLASH.ixOrder NOT IN (SELECT ixOrder from [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT) -- 2,763 in   17 NOT in 
         /*
        6055976
        6070972
        6071976
        6080976
        6081978
        6088976
        6115079
        6116177
        6120074
        6121170
        6122175
        6123171
        6128175
        6134075
        6135071
        6141176
        6181073
        */
 
 SELECT * from tblOrder where ixOrder in ('6055976','6070972','6071976','6080976','6081978','6088976','6115079','6116177','6120074','6121170','6122175','6123171','6128175','6134075','6135071','6141176','6181073')
   -- 17 orders with Order Type = 'Internal' totalling $1,287.31
 
 
 SELECT COUNT(DOT.ixOrder) -- 2763
 FROM [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT DOT 
 where DOT.ixOrder NOT IN (SELECT ixOrder from [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport) -- 2,763 in   18 NOT in 
 
 SELECT ixOrder --COUNT(DOT.ixOrder) -- 2763
 FROM [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT DOT 
 where DOT.ixOrder IN (SELECT ixOrder from [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport) -- 2,763 in   0 NOT in 
 
 SELECT COUNT(FLASH.ixOrder) 'Orders', SUM(O.mMerchandise) 'Sales'
 --, O.sOrderStatus, 
 , O.sOrderType
 --, O.sOrderChannel
 -- , SUM(O.mCredits) 'Credits'
 FROM [SMITemp].dbo.PJC_SMIHD4513_OrdersInFlashReport FLASH -- $642,649.04
    join tblOrder O on FLASH.ixOrder = O.ixOrder
GROUP BY  --   O.sOrderStatus, 
    O.sOrderType 
    --O.sOrderChannel
ORDER BY O.sOrderType, SUM(O.mMerchandise) DESC
/*
 where FLASH.ixOrder IN (SELECT ixOrder from [SMITemp].dbo.PJC_SMIHD4513_OrdersInDOT) -- $1,287.31   <- 'Internal' Order type



5/16/16 DOT vs FLASH Discrepancy 

$641,361 DOT sales
$614,238 SOP FLASH sales
========
$ 27,123 Delta

            $ 28,451 Internal Order CHANNEL for that day (DOT includes)
            $  1,287 Internal Order TYPE for that day (DOT excludes)

 $614,238 SOP FLASH sales
+$ 28,451 Internal Order CHANNEL (assumption - FLASH is excluding them)
-$  1,287 Internal Order TYPE    (assumption - FLASH is including them)
=========
 $641,402 99.9% match vs the DOT Sales 

*/

 SELECT SUM(O.mMerchandise) 'Sales'
 --, O.sOrderStatus
 , O.sOrderType
 --, O.sOrderChannel
  FROM tblOrder O
WHERE O.dtOrderDate = '05/17/2016'
    and O.sOrderStatus in ('Shipped', 'Backordered')
GROUP BY --O.sOrderStatus, 
    O.sOrderType
    --O.sOrderChannel
ORDER BY O.sOrderType, SUM(O.mMerchandise) DESC



49,012	INTERNAL order Channel
 2,858	Internal order Type
 
 
 /*
05/17/16 DOT vs FLASH Discrepancy 

$591,036 DOT sales
$545,143 SOP FLASH sales
========
$ 45,893 Delta

            $ 49,012 Internal Order CHANNEL for that day (DOT includes)
            $  2,858 Internal Order TYPE for that day (DOT excludes)

 $545,143 SOP FLASH sales
+$ 49,012 Internal Order CHANNEL (assumption - FLASH is excluding them)
-$  2,858 Internal Order TYPE    (assumption - FLASH is including them)
=========
 $591,297 99.9% match vs the DOT Sales 
 */
 
 select O.dtOrderDate, O.sOrderChannel, SUM(O.mMerchandise) Sales
 from tblOrder O
 where O.dtOrderDate >= '05/01/2016'
    and O.sOrderChannel = 'INTERNAL'
    and O.sOrderStatus in ('Shipped', 'Backordered')
 group by O.dtOrderDate, O.sOrderChannel
 order by O.dtOrderDate
 
 select O.dtOrderDate, O.sOrderType, SUM(O.mMerchandise) Sales
 from tblOrder O
 where O.dtOrderDate >= '05/01/2016'
    and O.sOrderType = 'Internal'
    and O.sOrderStatus in ('Shipped', 'Backordered')
 group by O.dtOrderDate, O.sOrderType
 order by O.dtOrderDate
 
 select O.dtOrderDate, ixOrder, sOrderChannel, sOrderType, sOrderTaker, mMerchandise, sOrderStatus
 from tblOrder O
 where sOrderChannel = 'INTERNAL'
 and O.dtOrderDate between '05/16/2016' and '05/17/2016'
 and O.mMerchandise > 0
 and O.sOrderTaker = 'KDL'
 
 select O.dtOrderDate, ixOrder, sOrderChannel, sOrderType, sOrderTaker, mMerchandise, sOrderStatus
 from tblOrder O
 where sOrderChannel = 'INTERNAL'
 and O.sOrderType <> 'Internal'
 and O.sOrderStatus in ('Shipped', 'Backordered') 
 and O.dtOrderDate between '01/01/2016' and '05/17/2016'
 and O.mMerchandise > 0
 and O.sOrderTaker = 'KDL' 
 
 SELECT sOrderTaker, 
 SUM(O.mMerchandise) -- O.dtOrderDate, ixOrder, sOrderChannel, sOrderType, sOrderTaker, mMerchandise, sOrderStatus
 from tblOrder O
 where sOrderChannel = 'INTERNAL'
     and sOrderType <> 'Internal'
     and O.sOrderStatus in ('Shipped', 'Backordered') 
     and O.dtOrderDate between '01/01/2016' and '05/17/2016'
     and O.mMerchandise > 0
 GROUP BY sOrderTaker
 ORDER BY SUM(O.mMerchandise) DESC
 --and O.sOrderTaker = 'KDL' 
 -- YTD $185,434 of which KDL took $105,489



-- internal order channel with a non-internal types
SELECT ixOrder, O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, C.ixCustomerType, 
        dtOrderDate, mMerchandise, sOrderChannel, sOrderType, sOrderTaker
        --, sOrderStatus
 from tblOrder O
    join tblCustomer C on O.ixCustomer = C.ixCustomer
 where O.sOrderStatus in ('Shipped', 'Backordered') 
     and O.dtOrderDate >= '05/31/2015'
     and O.mMerchandise > 0
    -- and sOrderType = 'Internal'
     and(
         (sOrderChannel = 'INTERNAL' and sOrderType <> 'Internal')
         OR 
         (sOrderChannel <> 'INTERNAL' and sOrderType = 'Internal')
         )
order by mMerchandise desc   , O.ixCustomer

           
         
select sOrderChannel, COUNT(*)
from tblOrder O  
where O.sOrderStatus in ('Shipped', 'Backordered') 
     and O.dtOrderDate >= '01/01/2016'
     and O.mMerchandise > 0
     and sOrderType = 'Internal'  
     
     
select dtOrderDate, COUNT(*)
from tblOrder
where dtOrderDate >= '05/27/2016'
group by dtOrderDate
order by dtOrderDate

select ixShippedDate, dtShippedDate, COUNT(*)
from tblOrder
where dtShippedDate >= '05/28/2016'
group by ixShippedDate,dtShippedDate
order by dtShippedDate
/*
17681	2016-05-28 00:00:00.000	557
17682	2016-05-29 00:00:00.000	39

17684	2016-05-31 00:00:00.000	1583    
*/
     
select ixShipDate, COUNT(*)
from tblPackage
where ixShipDate >= 17681
group by ixShipDate
order by ixShipDate     
/*
ixShipDate	
17681	526
17683	1529   - MONDAY
17684	336
*/

select O.ixOrder, P.ixShipDate 'PkgShippedDate', O.ixShippedDate 'OrderShippedDate'
from tblPackage P
    join tblOrder O on P.ixOrder = O.ixOrder
where P.ixShipDate = 17683
and O.ixOrder between '6215977' and '6301370'
order by P.ixOrder

select O.ixOrder, P.ixShipDate 'PkgShippedDate', O.ixShippedDate 'OrderShippedDate' -- YTD 18k don't match, 352,918
from tblPackage P
    join tblOrder O on P.ixOrder = O.ixOrder
where O.dtOrderDate >= 17168 -- 'P.ixShipDate = 17683
--and O.ixOrder between '6215977' and '6301370'
and P.ixShipDate = O.ixShippedDate
order by P.ixOrder


select distinct ixOrder from tblOrder
where ixOrder in (select ixOrder from tblPackage where ixShipDate = 17683)










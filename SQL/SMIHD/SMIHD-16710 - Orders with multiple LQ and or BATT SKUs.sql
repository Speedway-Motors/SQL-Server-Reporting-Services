-- SMIHD-16710 - Orders with multiple LQ and or BATT SKUs

/*
SOP does not currently predict how many boxes an order will ship in at order entry based on LQ and BATT flags. Packing and shipping do. See SMIHD-14406.

Can you produce a report that shows how many orders we shipped in the last 6 months that have the following:
1. Orders that have more one SKU that is flagged LQ
2 Orders that have a SKU(s) flagged as BATT (3480, 3090, 3481, 3091, NOSP & NICD) and a SKU(s) flagged as LQ.
3. Orders that have more than one type of battery(3480, 3090, 3481, 3091, NOSP & NICD)
*/

-- 1. orders with 1+ LQ SKUs
    SELECT --count(Distinct O.ixOrder) 'OrderCnt'
        distinct O.ixOrder
    into #OrdersWithLQ -- 2,580   -- DROP TABLE #OrdersWithLQ
    from tblOrder O
        left join tblOrderLine OL on O.ixOrder = OL.ixOrder
        left join tblSKU S on OL.ixSKU = S.ixSKU
    where O.sOrderStatus = 'Shipped'
        and O.ixShippedDate between 19323	and 19502 --11/25/2020 to 	05/23/2021      -- 544,358 total orders shipped from 11/25/2020 to 05/23/2021
        and OL.ixSKU in (SELECT ixSKU from tblSKU where flgDeletedFromSOP = 0 and sLimitedQuantity = 'LQ')
        and OL.flgLineStatus = 'Shipped' 

-- 2. orders with 1+ LQ BATT SKUs AND a BATT SKU
    SELECT --count(Distinct O.ixOrder) 'OrderCnt'
        distinct O.ixOrder
    from tblOrder O -- 41
        join #OrdersWithLQ LQ on O.ixOrder = LQ.ixOrder
        left join tblOrderLine OL on O.ixOrder = OL.ixOrder
        left join tblSKU S on OL.ixSKU = S.ixSKU
    where O.sOrderStatus = 'Shipped'
        and O.ixShippedDate between 19323	and 19502 --11/25/2020 to 	05/23/2021      -- 544,358    2,675     
        and OL.ixSKU in (SELECT ixSKU from tblSKU where flgDeletedFromSOP = 0 and sBattery in ('3090','3091','3480','3481','NOSP','NICD')) -- 41
        and OL.flgLineStatus = 'Shipped' 

 -- 3.Orders that have more than one type of battery
    SELECT --count(Distinct O.ixOrder) 'OrderCnt'
        O.ixOrder, count(distinct S.sBattery) 'UniqueBATTcnt'
    --into #BATT -- 604
    from tblOrder O
        left join tblOrderLine OL on O.ixOrder = OL.ixOrder
        left join tblSKU S on OL.ixSKU = S.ixSKU
    where O.sOrderStatus = 'Shipped'
        and O.ixShippedDate between 19323	and 19502 --11/25/2020 to 	05/23/2021      -- 544,358    2,675     
        and OL.ixSKU in (SELECT ixSKU from tblSKU where flgDeletedFromSOP = 0 and sBattery in ('3090','3091','3480','3481','NOSP','NICD'))  -- 2 order had 2+ unique battery types
        and OL.flgLineStatus = 'Shipped' 
    group by O.ixOrder
    having count(distinct S.sBattery) > 1
    order by  count(distinct S.sBattery) desc
-- only one order had more than 1 BATT type
/*
ixOrder	    UniqueBATTcnt
10107614	2
*/


SELECT sLiquid, FORMAT(count(*),'###,###') 'SKUcnt'
from tblSKU
where flgDeletedFromSOP = 0
group by sLiquid
/*
sLiquid	SKUcnt
======= =======
DEAD	 34,420
DRY	    480,263
NEW	        341
WET	      1,702
*/

SELECT sBattery, FORMAT(count(*),'###,###')'SKUcnt'
from tblSKU
where flgDeletedFromSOP = 0
group by sBattery
/*
sBattery	SKUcnt
========    =======
3090	    2
3480	    57
3481	    166
DEAD	    34,483
NBAT	    481,111
NEW	        341
NICD	    11
NORG	    231
NOSP	    324
*/

SELECT sLimitedQuantity, FORMAT(count(*),'###,###')'SKUcnt'
from tblSKU
where flgDeletedFromSOP = 0
group by sLimitedQuantity
/*
sLimited
Quantity	SKUcnt
DEAD	    34,518
HAZ	        19
LQ	        551
NEW	        341
NoLQ	    481,297
*/

SELECT COUNT(1) FROM #OrdersWithLQ
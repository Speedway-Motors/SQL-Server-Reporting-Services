-- Logic correction to ixPrintPrimaryTrailer field

select count(*) -- ixOrder 
from tblOrder 
where dtShippedDate >= '03/06/2014' -- start of tracking ixPrintPrimaryTrailer
and sOrderStatus = 'Shipped'
and iShipMethod <> 1
and ixPrintPrimaryTrailer is NOT NULL 
--and dtDateLastSOPUpdate < '09/25/2014'
/* 
since 3/6/14
146K PPTs are NULL
146K PPTs have a value
*/

select ixOrder -- ixOrder 
into PJC_PPTofOrderShippedAfter030614
from tblOrder 
where dtShippedDate > '03/06/2014' -- start of tracking ixPrintPrimaryTrailer
and sOrderStatus = 'Shipped'
and iShipMethod <> 1

and ixPrintPrimaryTrailer is NOT NULL 

select * from tblOrderChannel
select * from tblShipMethod

select min(dtShippedDate) from tblOrder where ixPrintPrimaryTrailer is NOT NULL -- 2014-03-06 00:00:00.000



select ixOrder, ixPrintPrimaryTrailer, ixPrintSecondaryTrailer,
dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblOrder where ixOrder = '5120677'
/*
ixOrder	PPT	    PST	    dtLastSOPUpdate	ixTimeLastSOPUpdate
5120677	NULL	NULL	2014-08-04  v	49019
5120677	FSD	    NULL	2014-09-25      37395
*/




select count(*) from [SMITemp].dbo.PJC_OrdersWithWrongPPTvalues PPT -- 112,107
select count(distinct ixOrder) from [SMITemp].dbo.PJC_OrdersWithWrongPPTvalues -- 112,107

select ixPrintPrimaryTrailer 'PPT'--,ixPrintSecondaryTrailer 'SPT'
, count(O.ixOrder) OrdCnt
from [SMITemp].dbo.PJC_OrdersWithWrongPPTvalues PPT
join tblOrder O on PPT.ixOrder = O.ixOrder
group by ixPrintPrimaryTrailer,ixPrintSecondaryTrailer
/*
-- BEFORE --
PPT         OrdCnt
NULL	    112,107


-- AFTER REFEEDING --
PPT         OrdCnt
BVF	    	158
LFF	    	2510
OMN	    	13325
DEN	    	1109
LNF	    	16456
FSD	    	5056
OMS	    	34319
LPU	    	810
KC	    	1525
FDM	    	10830
EVN	    	1
LNK	    	68
DSM	    	1045
OMH	    	24895
*/

-- FEED PROGRESS
select count(O.ixOrder) --ixPrintPrimaryTrailer 'PPT',ixPrintSecondaryTrailer 'SPT', count(O.ixOrder) OrdCnt
from [SMITemp].dbo.PJC_OrdersWithWrongPPTvalues PPT
join tblOrder O on PPT.ixOrder = O.ixOrder
WHERE O.dtDateLastSOPUpdate = '09/25/2014'
-- 112,107 Tot Records, 
-- kicked off at 10:45 
-- overall feed speed was 7.1 rec/sec.





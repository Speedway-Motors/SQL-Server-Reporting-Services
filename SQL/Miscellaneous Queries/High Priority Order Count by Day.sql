-- HP order count by day
SELECT ixOrderDate, FORMAT(dtOrderDate,'yyyy.MM.dd') 'SOPOrderDate', count(*) 'OrdersFlaggedHP'
FROM tblOrder
WHERE sOrderStatus IN ('Open','Shipped')
	and flgHighPriority = 1 -- 44
	and sSourceCodeGiven in ('AMAZONPRIME','AMAZON','EBAY','WALMART') -- MP orders
	and ixOrderDate >= 19756--	2022.02.08
GROUP BY ixOrderDate, FORMAT(dtOrderDate,'yyyy.MM.dd')
ORDER BY 'SOPOrderDate' desc


-- CURRENT Open Orders flagged HP
select -- ixOrder, 
	ixPrimaryShipLocation 'LOC',  count(*) 'OrdCnt' 
from tblOrder
where sOrderStatus = 'Open' -- 1,065
	and flgHighPriority = 1 -- 44
group by --ixOrder, 
	ixPrimaryShipLocation
order by ixPrimaryShipLocation

LOC	OrdCnt
25	39
47	1
85	25
99	37




select sSourceCodeGiven, flgHighPriority, count(ixOrder) 'Orders'
from tblOrder
where sOrderStatus IN ('Open','Shipped')
	--and flgHighPriority = 1 -- 44
	and sSourceCodeGiven in ('AMAZONPRIME','AMAZON','EBAY','WALMART') -- MP orders
	and ixOrderDate >= 19769	--02/14/2022	
group by sSourceCodeGiven, flgHighPriority
/*
sSource		flg
CodeGiven	HP	Orders
AMAZON		0	251
EBAY		0	188
WALMART		0	7
AMAZON		1	306
EBAY		1	117
WALMART		1	8
*/

select ixOrder, ixOrderDate, dtOrderDate, sOrderStatus, sSourceCodeGiven, flgHighPriority
from tblOrder
where sOrderStatus IN ('Open','Shipped')
	and flgHighPriority = 1 -- 44
	--and sSourceCodeGiven in ('AMAZONPRIME','AMAZON','EBAY','WALMART') -- MP orders
	and ixOrderDate >= 19769	--02/14/2022
order by dtOrderDate desc



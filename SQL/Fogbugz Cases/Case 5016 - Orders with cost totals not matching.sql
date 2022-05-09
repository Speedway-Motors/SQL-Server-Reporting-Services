select tblOrder.mMerchandiseCost,
	--tblOrderLine.ixSKU,
	--tblOrderLine.mCost,
	--tblOrderLine.iQuantity,
	sum(tblOrderLine.mExtendedCost) as derivedCost
from tblOrderLine
	join tblOrder
		on tblOrderLine.ixOrder = tblOrder.ixOrder
where --tblOrderLine.ixOrder = '968963' --and 
group by tblOrder.mMerchandiseCost

HAVING sum(tblOrderLine.mExtendedCost) <> tblOrder.mMerchandiseCost
	--tblOrderLine.ixSKU,
	--tblOrderLine.mCost,
	--tblOrderLine.iQuantity





select O.ixOrder, O.dtOrderDate,O.mMerchandiseCost, -- 0
	sum(OL.mExtendedCost) as derivedCost
from tblOrderLine OL
	join tblOrder O on OL.ixOrder = O.ixOrder
where O.dtOrderDate >= '01/01/2006'
  and OL.flgKitCOmponent = 0
  and OL.flgLineStatus in ('Shipped')
group by O.ixOrder, O.dtOrderDate,O.mMerchandiseCost
HAVING sum(OL.mExtendedCost) <> O.mMerchandiseCost
order by O.dtOrderDate desc

select O.ixOrder, O.dtOrderDate,O.mMerchandiseCost, -- 130604 as of 11-8
	sum(OL.mExtendedCost) as derivedCost
from tblOrderLine OL
	join tblOrder O on OL.ixOrder = O.ixOrder
where O.dtOrderDate < '01/01/2006'
  and OL.flgKitCOmponent = 0
  and OL.flgLineStatus in ('Shipped')
group by O.ixOrder, O.dtOrderDate,O.mMerchandiseCost
HAVING sum(OL.mExtendedCost) <> O.mMerchandiseCost
order by O.dtOrderDate desc




-- drop table PJC_Orders_WO_KitComps
SELECT distinct tblOrder.ixOrder -- 3,694,471
into PJC_Orders_WO_KitComps
from tblOrder
where ixOrder not in (select distinct ixOrder from tblOrderline where tblOrderLine.flgKitComponent = '1') -- 6K
order by tblOrder.ixOrder

select * from PJC_Orders_WO_KitComps


select count(distinct ixOrder) QTY
from tblOrder
where dtOrderDate >= '01/01/2006'


select * from tblOrderLine where ixOrder = '3300392' and  flgKitCOmponent = 0

select mMerchandiseCost from tblOrder where ixOrder = '3300392' --615.70
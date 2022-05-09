select
	OL.ixSKU,
	avg(mCost),
	count(1)
from
	tblOrderLine OL
	left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where
	OL.flgKitComponent = 0
	and OL.flgLineStatus = 'Shipped'
	and OL.dtOrderDate >= '01/01/11'
	and SKU.flgIsKit = 1
group by
	OL.ixSKU
order by
	count(1) desc
	
	
	

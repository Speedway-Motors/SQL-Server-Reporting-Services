select
	OL.ixSKU,
	sum(case when OL.dtOrderDate between '10/01/11' and '10/01/12' then (OL.iQuantity) else 0 end) as '0-12 Qty', 
	sum(case when OL.dtOrderDate between '10/01/11' and '10/01/12' then (OL.mExtendedPrice) else 0 end) as '0-12 Rev',
	sum(case when OL.dtOrderDate between '10/01/11' and '10/01/12' then (OL.mExtendedCost) else 0 end) as '0-12 Cost',
	sum(case when OL.dtOrderDate between '10/01/10' and '10/01/11' then (OL.iQuantity) else 0 end) as '13-24 Qty',
	sum(case when OL.dtOrderDate between '10/01/10' and '10/01/11' then (OL.mExtendedPrice) else 0 end) as '13-24 Rev',
	sum(case when OL.dtOrderDate between '10/01/10' and '10/01/11' then (OL.mExtendedCost) else 0 end) as '13-24 Cost'
from
	tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
where	
	O.sSourceCodeGiven = 'PRS' --change to MRR for MrRoadster
	and OL.flgKitComponent = 0
	and OL.flgLineStatus in ('Shipped', 'Open')
	and OL.dtOrderDate between '10/01/10' and '10/01/12'
	and SKU.flgIntangible = 0
	and O.sOrderChannel <> 'INTERNAL'
group by
	OL.ixSKU
order by
	sum(OL.iQuantity) desc

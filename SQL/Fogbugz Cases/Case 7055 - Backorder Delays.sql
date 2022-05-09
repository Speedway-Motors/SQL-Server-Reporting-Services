/*
select
	V.ixBuyer,
	sum(mExtendedPrice),
	sum(mExtendedCost),
	(sum(mExtendedPrice) - sum(mExtendedCost))/sum(mExtendedPrice)
from
	tblOrderLine OL
	left join tblVendorSKU VS on VS.ixSKU = OL.ixSKU
	left join tblVendor V on VS.ixVendor = V.ixVendor
--	left join tblSKU S on OL.ixSKU = S.ixSKU
where
	OL.dtShippedDate >= '02/01/11'
	and VS.iOrdinality = 1
	and V.ixBuyer is not null
--	and S.flgIsKit = 0
--	and OL.flgKitComponent = '0'
group by
	V.ixBuyer
	--	(OL.iQuantity * S.mPriceLevel1)
order by
	(sum(mExtendedPrice) - sum(mExtendedCost))/sum(mExtendedPrice) desc
*/

select
	O.ixOrder as 'O#',
	O.dtOrderDate as 'OrderDate',
	O.dtShippedDate as 'ShipDate',
	O.ixShippedDate - O.ixOrderDate as 'Delay (days)',
	O.mMerchandise as 'Revenue'
from
	tblOrder O
where
	O.dtShippedDate >= '09/01/10' and O.dtShippedDate <= '03/01/11'
	and O.ixOrder like '%-%'
	and sOrderType <> 'INTERNAL'
order by
	O.ixShippedDate - O.ixOrderDate desc









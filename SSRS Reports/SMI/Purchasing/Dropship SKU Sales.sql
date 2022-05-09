select
	SKU.ixSKU as 'SKU',
	SKU.sDescription as 'Description',
	VSKU.sVendorSKU as 'Vendor SKU',
	SKU.ixPGC as 'PGC',
	SKU.mPriceLevel1 as 'Retail',
	sum(OL.iQuantity) as 'Actual Units Sold',
	sum(OL.mExtendedPrice) as 'Sales',
	sum(OL.mExtendedCost) as 'Cost of Goods'
from
	tblSKU SKU
	left join tblVendorSKU VSKU on SKU.ixSKU = VSKU.ixSKU and iOrdinality = '1'
	left join tblOrderLine OL on SKU.ixSKU = OL.ixSKU
	left join tblOrder O on OL.ixOrder = O.ixOrder
where
	VSKU.ixVendor = '0108' -- @Vendor
	and OL.flgLineStatus in ('Dropshipped')
	and OL.dtOrderDate >=  '06/01/10' -- @start_date
	and OL.dtOrderDate < '07/01/10'  -- @end_date+1
	and O.sOrderType in ('Retail') -- @OrderType
group by
	SKU.ixSKU,
	SKU.sDescription,
	VSKU.sVendorSKU,
	SKU.ixPGC,
	SKU.mPriceLevel1



select distinct ixVendor from tblVendorSKU
order by ixVendor


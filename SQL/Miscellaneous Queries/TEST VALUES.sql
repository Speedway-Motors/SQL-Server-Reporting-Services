select SKU.ixSKU, SKU.sDescription, SKU.mPriceLevel1, VS.ixVendor PrmVendor
from tblSKU SKU
	left join tblVendorSku VS on VS.ixSKU = SKU.ixSKU
where SKU.flgActive = 1
and VS.iOrdinality = 1
order by SKU.mPriceLevel1 desc




select VS.ixVendor Vendor,
	sum(OL.iQuantity * OL.mUnitPrice) Sales
from tblOrderLine OL
	left join tblVendorSku VS on VS.ixSKU = OL.ixSKU
	left join tblOrder O on O.ixOrder = OL.ixOrder	
where O.dtOrderDate >= dateadd(year,-1,getdate()) -- 1 year ago
and O.dtOrderDate < getdate()	-- today
and VS.iOrdinality = 1
and O.sOrderChannel <> 'INTERNAL'
and O.sOrderType <> 'INTERNAL'
group by ixVendor
	having sum(OL.iQuantity * OL.mUnitPrice) > 800000

order by sum(iQuantity * mUnitPrice) desc



select OL.ixSKU,SKU.sDescription,
sum(OL.iQuantity) QTYsold,
VS.ixVendor PrmVendor
from tblOrderLine OL
	left join tblOrder O on O.ixOrder = OL.ixOrder
	left join tblVendorSKU VS on VS.ixSKU = OL.ixSKU
	left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
where O.sOrderChannel <> 'INTERNAL'
	and O.sOrderType <> 'INTERNAL'
	and  O.dtOrderDate >= '08/01/2009'
and O.dtOrderDate < '08/01/2010'
and VS.iOrdinality = 1
group by VS.ixVendor,OL.ixSKU,SKU.sDescription
having sum(OL.iQuantity) > 5000
order by sum(OL.iQuantity)desc
	
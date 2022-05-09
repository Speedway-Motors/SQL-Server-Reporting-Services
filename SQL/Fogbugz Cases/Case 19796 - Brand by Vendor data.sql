-- Case 19796 - Brand by Vendor data
select
	tblVendorSKU.ixVendor,
	tblVendor.sName,
	tblBrand.ixBrand,
	tblBrand.sBrandDescription,
	tblVendorSKU.sVendorSKU,
	tblVendorSKU.iOrdinality,
	tblSKU.ixSKU,
	tblSKU.sDescription,
	tblSKU.sBaseIndex
from tblVendorSKU
	left join tblSKU on tblVendorSKU.ixSKU = tblSKU.ixSKU
	left join tblVendor on tblVendorSKU.ixVendor = tblVendor.ixVendor
	left join tblBrand on tblSKU.ixBrand = tblBrand.ixBrand
where
                tblSKU.flgActive = 1
                and tblSKU.flgDeletedFromSOP = 0
                and sBrandDescription <> 'No Brand Assigned'
group by
	tblVendorSKU.ixVendor,
	tblVendor.sName,
	tblBrand.ixBrand,
	tblBrand.sBrandDescription,
	tblVendorSKU.sVendorSKU,
	tblVendorSKU.iOrdinality,
	tblSKU.ixSKU,
	tblSKU.sDescription,
	tblSKU.sBaseIndex
order by
	tblVendorSKU.ixVendor,
	tblBrand.ixBrand,
	tblVendorSKU.sVendorSKU,
	tblSKU.ixSKU
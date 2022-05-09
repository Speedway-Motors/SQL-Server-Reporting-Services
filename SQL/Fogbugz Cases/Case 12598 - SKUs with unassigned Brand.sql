select
   V.ixVendor  'VendorNum',
   V.sName     'VendorName',
   SKU.ixSKU   'SKU'
--   SKU.ixBrand 'Brand' -- why do we need this if it's always brand 10013 ?
from tblSKU SKU
   join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
   join tblVendor V on VS.ixVendor = V.ixVendor
where SKU.flgActive = 1
and SKU.ixBrand = '10013' -- Brand Not Assigned
and SKU.ixSKU NOT like 'UP%' -- garage sale parts
and V.ixVendor <> '0009' -- Speedway Garage Sale
and VS.iOrdinality = 1
ORDER by V.sName,SKU.ixSKU
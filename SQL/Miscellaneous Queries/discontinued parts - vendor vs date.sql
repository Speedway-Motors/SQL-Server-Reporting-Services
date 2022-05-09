select * from tblVendor
order by ixVendor

select top 10 * from tblSKU
select top 10 * from tblVendorSKU
select top 10 * from tblVendor




select count(distinct ixSKU)
from tblSKU 
where dtDiscontinuedDate < '02/18/2011' -- 19172 discontinued parts


select SKU.ixSKU, SKU.flgActive, SKUM.iQAV, SKUM.iQOS, V.sName PrimaryVendor, SKU.dtDiscontinuedDate DiscontinuedDate
from tblSKU SKU
    join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
    join tblVendor V on VS.ixVendor = V.ixVendor
    join vwSKULocalLocation SKUM on SKUM.ixSKU = SKU.ixSKU
where SKU.dtDiscontinuedDate > GETDATE()
and VS.ixVendor = '9999'
and VS.iOrdinality = 1
order by iQAV, iQOS


select SKU.ixSKU 
from tblSKU SKU
    join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
where VS.ixVendor = '0999'
and VS.iOrdinality = 1    

select * from tblVendorSKU
where ixVendor like '%999%'

select * from tblVendor
where ixVendor like '%999%'
-- Case 25949 - List of Rv SKUs for PV 0009

select S.ixSKU, 
sDescription, 
dtCreateDate 
from tblSKU S
left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
where S.dtCreateDate >= '02/01/2015' -- 28,194
and S.ixPGC = 'Rv'  -- 896
and S.ixSKU like '124%' -- 892
and VS.ixVendor = '0009'










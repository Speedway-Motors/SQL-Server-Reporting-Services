select 
    SKU.ixSKU     AS SpeedwaySKU,
    VS.sVendorSKU AS VendorSKU,
    VS.ixVendor   AS Vendor
from vwSKUMultiLocation SKU
    left join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
where VS.iOrdinality = 1
  AND (flgActive = 1
       OR SKU.iQOS >1 -- this is the sum of QOS for both Lincoln & Booneville
       )
  AND (SKU.sDescription like '%RESIDUAL VALVE, 2 PSI%'
       OR SKU.sBaseIndex = '8352601874' 
       OR VS.ixSKU = '7241-9001')
       
       
SMI '10610355'       

       
'10672419001'       
'7241-9001'     


select 
    SKU.ixSKU     AS SpeedwaySKU,
    VS.sVendorSKU AS VendorSKU,
    VS.ixVendor   AS Vendor
from tblSKU SKU
    left join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
where --VS.iOrdinality = 1
  -- (flgActive = 1
  --     OR SKU.iQOS >1 -- this is the sum of QOS for both Lincoln & Booneville
  --     )
   VS.ixSKU = '7241-9001' 
       
       
       
  AND (SKU.sDescription like '%RESIDUAL VALVE, 2 PSI%'
       OR SKU.sBaseIndex = '8352601874' 
       OR VS.ixSKU = '260-1874')  
SELECT VS.ixSKU 
     , S.sDescription 
     , SL.iQOS 
     , SL.iQAV 
     , S.flgUnitOfMeasure 
     , VWSKU.LYQuantity
FROM tblVendorSKU VS
LEFT JOIN tblSKU S ON S.ixSKU = VS.ixSKU 
LEFT JOIN tblSKULocation SL ON SL.ixSKU = VS.ixSKU AND ixLocation = 99 
LEFT JOIN vwSKUSalesPrev12Months VWSKU ON VWSKU.ixSKU = VS.ixSKU 
WHERE ixVendor = '1089' -- APPLEGATE
  AND S.flgActive = 1 
  AND iOrdinality = 1 
  AND dtDiscontinuedDate > GETDATE()     






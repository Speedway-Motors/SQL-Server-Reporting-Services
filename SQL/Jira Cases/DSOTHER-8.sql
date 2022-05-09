SELECT S.ixSKU AS SpeedwaySKU 
     , S.sDescription 
     , VS.sVendorSKU AS VendorSKU 
     , VS.ixVendor 
     , V.sName 
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU AND VS.iOrdinality = 1 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor 
WHERE S.ixBrand = '10101'
  AND S.flgActive = '1' 
  AND S.flgDeletedFromSOP = '0' 
ORDER BY ixVendor   
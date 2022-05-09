SELECT S.ixSKU AS SMISKU
     , S.sDescription AS SMIDescr
     , V.sName AS PrimaryVendor
     , VS.sVendorSKU AS PVSKU
     , VS.mCost AS PVCost 
     -- Last Vendor Purchased From 
     -- Last Vendor's SKU Purchased From
     , S.mLatestCost AS LastCost 
     , VS.mCost - S.mLatestCost AS DiffInCost     
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor
WHERE VS.iOrdinality = '1' 
  and S.flgActive = '1' 
  and S.flgIntangible = '0' 
  and S.flgDeletedFromSOP = '0'
  and S.ixSKU NOT LIKE 'UP%' 
  and S.flgIsKit = '0' 
  and V.sName NOT IN ('SMITH COLLECTION', 'SPEEDWAY ADVERTISING', 'SPEEDWAY GARAGE SALE', 'DISCONTINUED PARTS')  
ORDER BY DiffInCost DESC
SELECT DISTINCT ixSOPSKU
     , SV.sSKUVariantName
     , B.sBrandName
     , B.ixSOPBrand     
FROM tblskuvariant SV
LEFT JOIN tblskubase SB ON SB.ixSKUBase = SV.ixSKUBase
LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand
WHERE SB.ixProductLine IS NULL
  and SV.flgPublish = 1
  and SB.flgWebActive = 1; 
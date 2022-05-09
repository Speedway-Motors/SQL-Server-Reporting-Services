
SELECT DISTINCT SV.ixSOPSKU AS SKU 
     , SV.sSKUVariantName
FROM tblskuvariant SV 
LEFT JOIN tblskuvariant_application_xref APP ON APP.ixSOPSKU = SV.ixSOPSKU
LEFT JOIN tblproductpageskubase PPSB ON PPSB.ixSKUBase = SV.ixSKUBase
LEFT JOIN tblproductpage PP ON PP.ixProductPage = PPSB.ixProductPage
LEFT JOIN tblskuavailability SA ON SA.ixSKUVariant = SV.ixSKUVariant
LEFT JOIN tblskubase SB ON SB.ixSKUBase = SV.ixSKUBase
LEFT JOIN tblskuvariant_garagesale_xref GS ON GS.ixSKUVariant = SV.ixSKUVariant
LEFT JOIN (SELECT ixSKUVariant  
                , PAV.sValue
           FROM tblskuvariant_productgroup_attribute_value PAV
           WHERE PAV.ixProductgroupAttribute = 490 
           ) PAV ON PAV.ixSKUVariant = SV.ixSKUVariant
WHERE APP.ixSOPSKU IS NULL -- 89199 
   AND GS.ixSKUVariant IS NULL -- 88707
   AND SB.flgWebActive = 1 -- 88701
   AND (PAV.sValue <> 'Yes' OR PAV.sValue IS NULL) -- 68491
   AND SV.flgBackorderable = 1 -- 43722
   AND PP.flgActive = 1 -- 33438 -- ask Ryan if this search is accurate 
   AND SV.iTotalQAV > 0; -- 28555


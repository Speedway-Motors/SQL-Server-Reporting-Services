SELECT DISTINCT ixSOPSKU 
     , SV.sSKUVariantName
     , iTotalQAV
     , flgDiscontinued 
    -- , SB.sSOPName
    -- , ixMarket 
     , SVA.ixProductgroupAttribute
     , SVA.sValue
FROM tblskubasemarket SBM
LEFT JOIN tblskuvariant SV ON SV.ixSKUBase = SBM.ixSKUBase
LEFT JOIN tblskubase SB ON SB.ixSKUBase = SV.ixSKUBase
LEFT JOIN tblskuvariant_productgroup_attribute_value SVA ON SVA.ixSKUVariant = SV.ixSKUVariant
WHERE ixMarket <> 222
  AND (ixProductgroupAttribute = 490 AND SVA.sValue <> 'Yes')      
  AND (UPPER(SB.sSOPName) LIKE '%GARAGE%SALE%'
        OR UPPER(SB.sSOPName) LIKE '%G-SALE%'
        OR UPPER(SV.sSKUVariantName) LIKE '%GARAGE%SALE%'
        OR UPPER(SV.sSKUVariantName) LIKE '%G-SALE%'
       )
  AND SV.iTotalQAV > 0        
ORDER BY iTotalQAV DESC
    ;
    

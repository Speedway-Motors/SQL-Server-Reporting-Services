
SELECT tng.*, 
    SKU.ixSKU, --SKU.ixBrand, 
    SKU.ixProductLine 'SMIReportingProductLine'--, SKU.dtLastTNGUpdate
FROM openquery([TNGREADREPLICA], '
    SELECT DISTINCT SB.ixSOPSKUBase
        ,SV.ixSOPSKU
        ,SV.sSKUVariantName    
      --  ,PL.ixSOPProductLine ''tngProductLine''
      B.sBrandName
    FROM tblskubase SB 
    JOIN tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
    LEFT JOIN tblproductline PL ON PL.ixProductLine = SB.ixProductLine 
    LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand 
 ') tng
 full outer join tblSKU SKU on tng.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
 where (SKU.flgDeletedFromSOP = 0
    OR SKU.flgDeletedFromSOP is NULL)
--and tng.tngProductLine COLLATE SQL_Latin1_General_CP1_CI_AS <> SKU.ixProductLine COLLATE SQL_Latin1_General_CP1_CI_AS  
and (tng.tngProductLine IS NOT NULL
     OR  SKU.ixProductLine IS NOT NULL 
     )
    
ORDER BY tng.tngProductLine, SKU.ixProductLine




 and (
           (SKU.ixProductLine COLLATE SQL_Latin1_General_CP1_CI_AS <> tng.tngProductLine COLLATE SQL_Latin1_General_CP1_CI_AS)-- n ('UP68506','40812774')       
        OR (SKU.ixProductLine is NULL AND tng.tngProductLine is NOT NULL)
        OR (SKU.ixProductLine is NOT NULL AND tng.tngProductLine is NULL)
      )  
    


-- 8,551

-- 6,225 have an SOP PL but tng PL is NULL





SELECT tng.*, 
    SKU.ixSKU, --SKU.ixBrand, 
    SKU.ixProductLine 'SMIReportingProductLine'
FROM openquery([TNGREADREPLICA], '
    SELECT DISTINCT SB.ixSOPSKUBase
        ,SV.ixSOPSKU
        ,SV.sSKUVariantName    
        ,SB.ixProductLine ''tngProductLine''
    --  ,B.ixBrand as ''tngBrand'' -- ixSOPBrand         , *-- 311,537
     -- ,B.sBrandName
    FROM tblskubase SB 
    JOIN tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
    LEFT JOIN tblproductline PL ON PL.ixProductLine = SB.ixProductLine 
    LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand 
 ') tng
 full outer join tblSKU SKU on tng.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
 where (SKU.flgDeletedFromSOP = 0
    OR SKU.flgDeletedFromSOP is NULL)
 AND tng.tngProductLine <> SKU.ixProductLine 
ORDER BY tng.tngProductLine, SKU.ixProductLine


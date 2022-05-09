-- Case 19060 - List of SKUs with Primary and Secondary Vendor
select PV.*,
    SV.SV#,SV.[Secondary Vendor], -- 154,556
    TV.TV#,TV.[Tertiary Vendor]
FROM tblSKU SKU
    FULL JOIN
    ( -- Primary Vendor
        SELECT SKU.ixSKU as 'SKU', 
            SKU.sDescription as 'Description',
            V1.ixVendor as 'PV#',
            V1.sName   as 'Primary Vendor'
        from tblSKU SKU
            join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
            left join tblVendor V1 on VS.ixVendor = V1.ixVendor 
        where VS.iOrdinality = 1   
          and SKU.flgDeletedFromSOP = 0 
    ) PV ON SKU.ixSKU = PV.SKU
    FULL JOIN
    ( -- Secondary Vendor
        SELECT SKU.ixSKU as 'SKU', 
            SKU.sDescription as 'Description',
            V2.ixVendor as 'SV#',
            V2.sName   as 'Secondary Vendor'
        from tblSKU SKU
            join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
            left join tblVendor V2 on VS.ixVendor = V2.ixVendor 
        where VS.iOrdinality = 2   
          and SKU.flgDeletedFromSOP = 0     
    ) SV on SKU.ixSKU = SV.SKU
FULL JOIN
    ( -- Tertiary Vendor
        SELECT SKU.ixSKU as 'SKU', 
            SKU.sDescription as 'Description',
            V2.ixVendor as 'TV#',
            V2.sName   as 'Tertiary Vendor'
        from tblSKU SKU
            join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
            left join tblVendor V2 on VS.ixVendor = V2.ixVendor 
        where VS.iOrdinality = 3   
          and SKU.flgDeletedFromSOP = 0     
    ) TV on SKU.ixSKU = TV.SKU
WHERE SKU.flgDeletedFromSOP = 0
ORDER BY PV.SKU
    








/*   

    
-- SKUs with no Primary Vendor... WTH?
select SKU.ixSKU
from tblSKU SKU
 left join (
            SELECT SKU.ixSKU
            from tblSKU SKU
                join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
                left join tblVendor V1 on VS.ixVendor = V1.ixVendor 
            where VS.iOrdinality = 1   
              and SKU.flgDeletedFromSOP = 0 
            ) PV on SKU.ixSKU = PV.ixSKU
where PV.ixSKU is NULL
and SKU.flgDeletedFromSOP = 0 
 
9189103 -- none 
91691027 -- says 9999 in SOP   
5506687 -- says 9999 in SOP 
*/









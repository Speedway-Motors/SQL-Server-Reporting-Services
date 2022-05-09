-- SEMA
-- checking differences in the values accross the two DB's
-- and how to update


-- simple view on ODS that shows SKU & SEMA values (as they SHOULD appear in SMI Reporting)
[SMI_ODS].dbo.vwSKUSemaValues


-- DIFFERENCES in SEMA data from [SMI_ODS] vs [SMI Reporting]
select isnull(SKU.ixSKU,SSV.ixSKU) ixSKU,
    SKU.sSEMACategory       as 'SKUsSEMACategory',
    SSV.sSEMACategory       as 'ODSsSEMACategory',
    SKU.sSEMASubCategory    as 'SKUsSEMASubCategory',
    SSV.sSEMASubCategory    as 'ODSsSEMASubCategory',
    SKU.sSEMAPart           as 'SKUsSEMAPart',
    SSV.sSEMAPart           as 'ODSsSEMAPart'    
from tblSKU SKU
    full outer join [SMI_ODS].dbo.vwSKUSemaValues SSV on SKU.ixSKU = SSV.ixSKU
where  SKU.sSEMACategory    <> SSV.sSEMACategory
    OR SKU.sSEMASubCategory <> SSV.sSEMASubCategory 
    OR SKU.sSEMAPart        <> SSV.sSEMAPart 
    OR (SKU.sSEMACategory is NULL           and SSV.sSEMACategory is NOT NULL)
    OR (SKU.sSEMACategory is NOT NULL       and SSV.sSEMACategory is NULL)
    OR (SKU.sSEMASubCategory is NULL        and SSV.sSEMASubCategory is NOT NULL)
    OR (SKU.sSEMASubCategory is NOT NULL    and SSV.sSEMASubCategory is NULL)    
    OR (SKU.sSEMAPart is NULL               and SSV.sSEMAPart is NOT NULL)     
    OR (SKU.sSEMAPart is NOT NULL           and SSV.sSEMAPart is NULL)          



-- UPDATE [SMI Reporting].tblSKU  with data that is missing or NOT matching SEMA data in [SMI_ODS]
UPDATE SKU
SET sSEMACategory = SSV.sSEMACategory,
    sSEMASubCategory = SSV.sSEMASubCategory,
    sSEMAPart = SSV.sSEMAPart
FROM tblSKU SKU
    full outer join [SMI_ODS].dbo.vwSKUSemaValues SSV on SKU.ixSKU = SSV.ixSKU
WHERE SKU.ixSKU in (select isnull(SKU.ixSKU,SSV.ixSKU) ixSKU
                    from tblSKU SKU
                        full outer join [SMI_ODS].dbo.vwSKUSemaValues SSV on SKU.ixSKU = SSV.ixSKU
                    where  SKU.sSEMACategory    <> SSV.sSEMACategory
                        OR SKU.sSEMASubCategory <> SSV.sSEMASubCategory 
                        OR SKU.sSEMAPart        <> SSV.sSEMAPart 
                        OR (SKU.sSEMACategory is NULL           and SSV.sSEMACategory is NOT NULL)
                        OR (SKU.sSEMACategory is NOT NULL       and SSV.sSEMACategory is NULL)
                        OR (SKU.sSEMASubCategory is NULL        and SSV.sSEMASubCategory is NOT NULL)
                        OR (SKU.sSEMASubCategory is NOT NULL    and SSV.sSEMASubCategory is NULL)    
                        OR (SKU.sSEMAPart is NULL               and SSV.sSEMAPart is NOT NULL)     
                        OR (SKU.sSEMAPart is NOT NULL           and SSV.sSEMAPart is NULL) 
                     )  




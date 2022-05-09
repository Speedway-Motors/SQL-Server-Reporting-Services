-- SMIHD-12890 - Crate Engine SKUs
SELECT ixSKU 'SKU', ISNULL(sWebDescription, sDescription) 'SKUDescription', --ixPGC, 
    SKU.sSEMACategory 'Category', sSEMASubCategory 'SubCategory', sSEMAPart 'Part', 
    B.ixBrand 'Brand', B.sBrandDescription 'BrandDescription'
FROM [SMI Reporting].dbo.tblSKU SKU
    left join tblBrand B on SKU.ixBrand = B.ixBrand
WHERE (sSEMASubCategory = 'Crate Engines' OR sSEMAPart = 'Crate Engines')
    and SKU.flgDeletedFromSOP = 0 -- 529
    --and flgActive = 0         -- 129    62 are UP
order by ixSKU desc
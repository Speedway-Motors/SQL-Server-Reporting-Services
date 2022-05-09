-- new SKUs with no Merchant assigned
SELECT S.ixSKU, S.sWebDescription, S.mPriceLevel1, dtCreateDate, VS.ixVendor 'PV', V.sName 'PV Name',  
    SL.sPickingBin, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart,
    ixMerchant, ixProposer, ixAnalyst, S.ixBuyer
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
WHERE flgActive = 1
    and flgIntangible = 0
    and dtCreateDate >= '01/01/2019'        -- 23,109
    and S.ixSKU NOT LIKE 'UP%'
    and S.ixSKU NOT LIKE 'AUP%'
    and VS.ixVendor NOT IN ('0009','0999','9999') -- GS, discontinued    -- 12,002    <-- should we exclude BOMs (PV 0001) also?
    and S.mPriceLevel1 > 0 
    and S.ixSKU in (select ixSKU from tblCatalogDetail where ixCatalog = 'WEB.19')
    and S.sWebDescription is NOT NULL
    and SL.iQAV > 0                 -- 1,355 should have merchants
    and S.ixMerchant is NULL        -- 1,351 do NOT have merchants
ORDER BY VS.ixVendor











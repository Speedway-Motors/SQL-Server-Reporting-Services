-- SMIHD-14987 - New Report - Shock BOM Prioritization

SELECT ixSKU, mPriceLevel1, mLatestCost, mAverageCost, ixPGC, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    ixBrand, ixCreator, ixMerchant, 
    flgIsKit, flgMadeToOrder,
    sSEMACategory, sSEMASubCategory, sSEMAPart
FROM tblSKU S
WHERE ixPGC = 'kK'              -- 3,364
    and flgDeletedFromSOP = 0   -- 3,244
    and flgActive = 1           -- 3,179
    and flgIntangible = 0       -- 3,179
    and ixSKU in (select ixFinishedSKU from tblBOMTemplateMaster)   -- 1,172 have templates
   -- and ixSKU in (select ixFinishedSKU from tblBOMTemplateDetail) -- 1,172
    and ixSKU in (select ixFinishedSKU from tblBOMTransferMaster)   --   868 have open BOMs
order by S.sSEMAPart






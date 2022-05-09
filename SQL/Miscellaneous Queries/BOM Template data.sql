-- BOM Template data
/*
SELECT COUNT(*) FROM tblBOMTemplateMaster WHERE flgDeletedFromSOP = 0 -- 12,899 Finished SKUs
SELECT COUNT(*) FROM tblBOMTemplateDetail WHERE flgDeletedFromSOP = 0 -- 75,856 Component SKUs

SELECT TOP 10 * FROM tblBOMTemplateMaster
SELECT TOP 10 * FROM tblBOMTemplateDetail
*/

SELECT TM.ixFinishedSKU, 
    ISNULL(S.sWebDescription, S.sDescription) 'FinishedSKUDescription',
    TD.ixSKU 'SKUComponent', 
    ISNULL(S2.sWebDescription, S2.sDescription) 'SKUComponentDescription',
    TD.iQuantity 'ComponentQty',
    SL.iQAV 'FinishedSKUQAV', 
    SL.iQOS 'FinishedSKUQOS'
FROM tblBOMTemplateMaster TM
    left join tblBOMTemplateDetail TD on TM.ixFinishedSKU = TD.ixFinishedSKU
    left join tblSKU S on S.ixSKU = TM.ixFinishedSKU
    left join tblSKU S2 on S2.ixSKU = TD.ixSKU
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU
                                and SL.ixLocation = 99
WHERE TM.flgDeletedFromSOP = 0  -- 75,856
     and S.flgActive = 1        -- 71,322
     and (SL.iQAV > 0 
          or SL.iQAV > 0)     -- 26,762
ORDER BY TM.ixFinishedSKU, TD.ixSKU



-- SMIHD-4005 - SKUs without Chassis Fitment 


-- vwTng_SKUsWithoutChassisFitment  
-- Pulled data from TNG into a view because the backorderable flag in TNG is actually a combo of flgBackOrderAccpeted and flgMTO.
-- Will need to scrub against tlbSKU.flgBackorderAccepted to filter out SKUs that can no longer be backordered

SELECT V.ixSOPSKU as 'SOPSKU'
    , V.sSKUVariantName as 'WebTitle'
    , V.GarageSale as 'GarageSale'
    , V.BrandName as 'BrandName'
    , V.DrivetrainFitment as 'DrivetrainFitment'
    , V.SEMA1Category as 'SEMA1Cat'
    , V.SEMA2Category as 'SEMA2Cat'
    , V.SEMA3Category as 'SEMA3Cat'
FROM vwTng_SKUsWithoutChassisFitment V    -- 9,326
 join tblSKU S on V.ixSOPSKU  COLLATE SQL_Latin1_General_CP1_CS_AS = S.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS -- 9,324
WHERE S.flgDeletedFromSOP = 0 
    AND S.flgBackorderAccepted = 1



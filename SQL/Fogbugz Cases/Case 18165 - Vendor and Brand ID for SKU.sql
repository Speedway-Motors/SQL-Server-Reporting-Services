SELECT ASD.ixSKU 
     , ASD.iOrder
     , S.ixBrand 
     , V.ixVendor
     , V.sName 
FROM dbo.ASC_18165_AddtlSKUData ASD
LEFT JOIN [SMI Reporting].dbo.tblSKU S ON S.ixSKU = ASD.ixSKU 
LEFT JOIN [SMI Reporting].dbo.tblVendorSKU VS ON VS.ixSKU = ASD.ixSKU 
                                              AND VS.iOrdinality = '1'
LEFT JOIN [SMI Reporting].dbo.tblVendor V ON V.ixVendor = VS.ixVendor
ORDER BY ASD.iOrder



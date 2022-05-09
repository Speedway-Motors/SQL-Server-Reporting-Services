SELECT DISTINCT AAS.ixSKU 
     , VS.ixVendor
     , V.sName
     , LabDetail.Qty AS Dep71LabQty
FROM dbo.ASC_Afco_Assembly_SKUs AAS
LEFT JOIN tblVendorSKU VS ON VS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = AAS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor 
LEFT JOIN (SELECT ixFinishedSKU AS SKU
                , iQuantity AS Qty
		   FROM tblBOMTemplateDetail BTD 
		   WHERE BTD.ixSKU = 'DEP71LAB') LabDetail ON LabDetail.SKU COLLATE SQL_Latin1_General_CP1_CI_AS = AAS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE VS.iOrdinality = '1' -- Primary Vendor 
ORDER BY ixVendor, ixSKU 


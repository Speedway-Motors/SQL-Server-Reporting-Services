-- For each column header (attribute) it needs to be determined what "type" they are. This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 5;

SELECT *
FROM AttributeType; -- Type 2 & 4 will be special types that will take additional steps; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Overall Length' -- measurement/size/length, 5 -- Template ID 34
   OR sTitle = 'Overall Width' -- measurement/size/length, 5 -- Template ID 33
   OR sTitle = 'Overall Height' -- measurement/size/length, 5 -- Template ID 32
   OR sTitle = 'Shaft Diameter' -- measurement/size/length, 5 -- Template ID 56
   OR sTitle = 'Thread Pitch' -- text, 1 -- Template ID 142
   OR sTitle = 'Material Thickness' -- measurement/size/length, 5 -- Template ID 256
   OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31 
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44   
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_linkagemounts;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_linkagemounts
 ADD sColor VARCHAR(25) AFTER ixFinish
,ADD ixColor INT AFTER sColor
,ADD ixUnitId INT AFTER sOverallLength 
,ADD ixUnitId2 INT AFTER sOverallWidth
,ADD ixUnitId3 INT AFTER sOverallHeight
,ADD ixUnitId4 INT AFTER sShaftDiameter
,ADD ixUnitId5 INT AFTER sMaterialThickness 
,ADD ixMaterialType INT AFTER sMaterialType 
,ADD ixFinish INT AFTER sFinish;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_linkagemounts CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_linkagemounts, AttributeDropdownItem
SET tmp.tmp_linkagemounts.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_linkagemounts.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_linkagemounts
WHERE ixMaterialType IS NULL; -- All records updated that had values 

SELECT *
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 31; -- Aluminum // Stainless Steel

UPDATE tmp.tmp_linkagemounts, AttributeDropdownItem
SET tmp.tmp_linkagemounts.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_linkagemounts.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_linkagemounts
WHERE ixFinish IS NULL; -- All records updated that had values -- Black // Black anodized // black // Black powdercoated // polished // BLACK 

SELECT *
FROM AttributeDropdownItem
-- WHERE UPPER(sAttributeDropdownItemText) LIKE '%POWDER%' 
WHERE ixTemplateAttributeId = 44; -- Anodized // Powder Coated // Polished // 

UPDATE tmp.tmp_linkagemounts, AttributeDropdownItem
SET tmp.tmp_linkagemounts.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_linkagemounts.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_linkagemounts
WHERE ixColor IS NULL; -- All records updated that had values

-- No unit values were updated or inserted as they were all NULL 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT LM.ixSOPSKU
     , 31
     , LM.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_linkagemounts LM 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = LM.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT LM.ixSOPSKU
     , 44
     , LM.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_linkagemounts LM 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = LM.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT LM.ixSOPSKU
     , 36
     , LM.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_linkagemounts LM 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = LM.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT LM.ixSOPSKU
     , 325
     , LM.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_linkagemounts LM
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = LM.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT LM.ixSOPSKU
     , 142
     , LM.sThreadPitch
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_linkagemounts LM
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = LM.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_linkagemounts;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491XTCBBG440'

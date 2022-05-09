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
WHERE sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44 
   OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31 
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle = 'Overall Length' -- measurement/size/length, 5 -- Template ID 34
   OR sTitle = 'Arm Length' -- measurement/size/length, 5 -- Template ID 195
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_brakecables;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_brakecables
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixColor INT AFTER sColor
,ADD ixUnitId INT AFTER sOverallLength
,ADD ixUnitId2 INT AFTER sArmLength;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_brakecables CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_brakecables, AttributeDropdownItem
SET tmp.tmp_brakecables.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakecables.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_brakecables
WHERE ixMaterialType IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_brakecables, AttributeDropdownItem
SET tmp.tmp_brakecables.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakecables.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_brakecables
WHERE ixMaterialType IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_brakecables, AttributeDropdownItem
SET tmp.tmp_brakecables.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakecables.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_brakecables
WHERE ixMaterialType IS NULL; -- All records updated that had values 
-- Now the records need to be inserted into the SKU Attribute table 

UPDATE tmp.tmp_brakecables
SET ixUnitId = 6 
WHERE sOverallLength IS NOT NULL; 

UPDATE tmp.tmp_brakecables
SET ixUnitId2 = 6 
WHERE sArmLength IS NOT NULL; 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BC.ixSOPSKU
     , 31
     , BC.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_brakecables BC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BC.ixSOPSKU
     , 36
     , BC.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_brakecables BC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BC.ixSOPSKU
     , 44
     , BC.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_brakecables BC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BC.ixSOPSKU
     , 325
     , BC.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_brakecables BC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BC.ixSOPSKU
     , 34
     , BC.sOverallLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , BC.ixUnitId 
FROM tmp.tmp_brakecables BC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BC.ixSOPSKU
     , 195
     , BC.sArmLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , BC.ixUnitId2 
FROM tmp.tmp_brakecables BC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_brakecables;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491XEHB7011';

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
   OR sTitle = 'Thread Pitch' -- text, 1 -- Template ID 142
   OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31 
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44   
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_rodconnectors;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_rodconnectors
 ADD ixColor INT AFTER sColor
,ADD ixUnitId INT AFTER sOverallLength 
,ADD ixMaterialType INT AFTER sMaterialType 
,ADD ixFinish INT AFTER sFinish;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_rodconnectors CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_rodconnectors, AttributeDropdownItem
SET tmp.tmp_rodconnectors.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_rodconnectors.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_rodconnectors
WHERE ixMaterialType IS NULL; -- All records updated that had values 


UPDATE tmp.tmp_rodconnectors, AttributeDropdownItem
SET tmp.tmp_rodconnectors.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_rodconnectors.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_rodconnectors
WHERE ixFinish IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_rodconnectors, AttributeDropdownItem
SET tmp.tmp_rodconnectors.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_rodconnectors.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_rodconnectors
WHERE ixColor IS NULL; -- All records updated that had values

UPDATE tmp.tmp_rodconnectors
SET ixUnitId = 6
WHERE sOverallLength IS NOT NULL;

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RC.ixSOPSKU
     , 31
     , RC.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_rodconnectors RC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RC.ixSOPSKU
     , 44
     , RC.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_rodconnectors RC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RC.ixSOPSKU
     , 36
     , RC.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_rodconnectors RC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RC.ixSOPSKU
     , 325
     , RC.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_rodconnectors RC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RC.ixSOPSKU
     , 142
     , RC.sThreadPitch
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_rodconnectors RC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RC.ixSOPSKU
     , 34
     , RC.sOverallLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , RC.ixUnitId 
FROM tmp.tmp_rodconnectors RC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_rodconnectors;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491S6996'

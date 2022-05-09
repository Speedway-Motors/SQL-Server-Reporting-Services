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
WHERE sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31 
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44   
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_kickdowns;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_kickdowns
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixColor INT AFTER sColor;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_kickdowns CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_kickdowns, AttributeDropdownItem
SET tmp.tmp_kickdowns.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_kickdowns.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_kickdowns
WHERE ixMaterialType IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_kickdowns, AttributeDropdownItem
SET tmp.tmp_kickdowns.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_kickdowns.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_kickdowns
WHERE ixFinish IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_kickdowns, AttributeDropdownItem
SET tmp.tmp_kickdowns.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_kickdowns.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_kickdowns
WHERE ixColor IS NULL; -- All records updated that had values 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT K.ixSOPSKU
     , 31
     , K.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_kickdowns K
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = K.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT K.ixSOPSKU
     , 36
     , K.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_kickdowns K
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = K.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE ixColor IS NOT NULL;
  
INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT K.ixSOPSKU
     , 44
     , K.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_kickdowns K 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = K.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE K.ixFinish IS NOT NULL;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT K.ixSOPSKU
     , 325
     , K.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_kickdowns K
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = K.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_kickdowns;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491XKD2727HT';
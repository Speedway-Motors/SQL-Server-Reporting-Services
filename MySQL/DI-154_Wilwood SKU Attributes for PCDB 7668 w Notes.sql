 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 7668; -- Wheel Bearing Dust Caps
 
-- For each column header (attribute) it needs to be determined what "type" they are. 
-- This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 6;

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 13;


SELECT *
FROM AttributeType; 
-- Type 2 & 4 will be special types that will take additional steps; 
-- all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Material Type' -- Dropdown box, 4 -- Template ID 31
   OR sTitle = 'Finish' -- Dropdown box, 4 -- Template ID 44
   OR sTitle = 'Weight' -- Weight, 6 -- Template ID 35 -- Unit Id 14
   OR sTitle = 'Rotor Compatibility' -- Dropdown box, 4 -- Template ID 762
   OR sTitle = 'Hub Dimension A' -- Measurement/Size/Length, 5 -- Template ID 771
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_dustcaps;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_dustcaps
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixRotorCompatibility INT AFTER sRotorCompatibility
,ADD ixUnitId1 INT AFTER dWeight
,ADD ixUnitId2 INT AFTER dHubDimension;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_dustcaps CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_dustcaps, AttributeDropdownItem
SET tmp.tmp_dustcaps.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dustcaps.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_dustcaps
WHERE ixMaterialType IS NULL; -- all records with values updated except those containing the listing of 'Moderate'; asked JGO to add 

UPDATE tmp.tmp_dustcaps, AttributeDropdownItem
SET tmp.tmp_dustcaps.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dustcaps.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_dustcaps
WHERE ixFinish IS NULL; -- all records updated after the change below was applied 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 44; -- Changed 'Bare' and 'Plated' to Natural 


UPDATE tmp.tmp_dustcaps, AttributeDropdownItem
SET tmp.tmp_dustcaps.ixRotorCompatibility = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dustcaps.sRotorCompatibility = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 762; 

SELECT *
FROM tmp.tmp_dustcaps
WHERE ixRotorCompatibility IS NULL; -- all records updated after the change was applied 

-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_dustcaps
SET ixUnitId1 = 14
WHERE dWeight IS NOT NULL; 

UPDATE tmp.tmp_dustcaps
SET ixUnitId2 = 6
WHERE dHubDimension IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 
  
-- The 5 parts that do not exist in tblSKUPartAssociation must first be updated (2 already existed)
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DC.ixSOPSKU
     , 7668
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_dustcaps DC;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DC.ixSOPSKU
     , 31
     , DC.ixMaterialType 
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dustcaps DC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DC.ixMaterialType IS NOT NULL; --  6 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DC.ixSOPSKU
     , 44
     , DC.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dustcaps DC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DC.ixFinish IS NOT NULL
  AND DC.ixFinish <> 46; --  6 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DC.ixSOPSKU
     , 762
     , DC.ixRotorCompatibility
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dustcaps DC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DC.ixRotorCompatibility IS NOT NULL; -- 3 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DC.ixSOPSKU
     , 35
     , DC.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , DC.ixUnitId1
FROM tmp.tmp_dustcaps DC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DC.dWeight IS NOT NULL; -- 6 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DC.ixSOPSKU
     , 771
     , DC.dHubDimension
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , DC.ixUnitId2
FROM tmp.tmp_dustcaps DC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DC.dHubDimension IS NOT NULL
   AND DC.dHubDimension <> ' '; --  141 rows affected


   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_dustcaps DC;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8352709498';


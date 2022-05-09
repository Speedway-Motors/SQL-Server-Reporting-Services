 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 11539; -- Axle Hub Flanges
 
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
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_hubflanges;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_hubflanges
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixRotorCompatibility INT AFTER sRotorCompatibility
,ADD ixUnitId1 INT AFTER dWeight;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_hubflanges CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_hubflanges, AttributeDropdownItem
SET tmp.tmp_hubflanges.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubflanges.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_hubflanges
WHERE ixMaterialType IS NULL; -- all records updated 

UPDATE tmp.tmp_hubflanges, AttributeDropdownItem
SET tmp.tmp_hubflanges.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubflanges.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_hubflanges
WHERE ixFinish IS NULL; -- all records updated after the change below was applied 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 44; -- Changed 'Plated' to Natural 


UPDATE tmp.tmp_hubflanges, AttributeDropdownItem
SET tmp.tmp_hubflanges.ixRotorCompatibility = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubflanges.sRotorCompatibility = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 762; 

SELECT *
FROM tmp.tmp_hubflanges
WHERE ixRotorCompatibility IS NULL; -- all records updated 

-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_hubflanges
SET ixUnitId1 = 14
WHERE dWeight IS NOT NULL; 


-- Now the records need to be inserted into the SKU Attribute table 
  
-- The 9 parts that do not exist in tblSKUPartAssociation must first be updated (1 already existed)
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT HF.ixSOPSKU
     , 11539
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_hubflanges HF;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HF.ixSOPSKU
     , 31
     , HF.ixMaterialType 
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubflanges HF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HF.ixMaterialType IS NOT NULL; --  9 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HF.ixSOPSKU
     , 44
     , HF.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubflanges HF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HF.ixFinish IS NOT NULL
  AND HF.ixFinish <> 46; --  9 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HF.ixSOPSKU
     , 762
     , HF.ixRotorCompatibility
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubflanges HF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HF.ixRotorCompatibility IS NOT NULL; -- 3 rows affected

SELECT * FROM SKUAttribute 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_hubflanges) 
   AND SKUAttribute.ixTemplateAttributeId = 762 
   AND SKUAttribute.ixAttributeTypeId = 4; 
   
SELECT * FROM tblSKUPartAssociation WHERE ixSKU = '8352706732';   


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HF.ixSOPSKU
     , 35
     , HF.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HF.ixUnitId1
FROM tmp.tmp_hubflanges HF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HF.dWeight IS NOT NULL; -- 10 rows affected


   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_hubflanges HF;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8352706918';


-- The code below is to fix a double insertion error that happened when creating sku associations 


SELECT ixSKU 
     , COUNT(DISTINCT ixPartTerminologyID) AS Records 
FROM tblSKUPartAssociation
GROUP BY ixSKU 
HAVING COUNT(DISTINCT ixPartTerminologyID) > 1;


SELECT * 
FROM tblSKUPartAssociation
WHERE ixSKU IN ('8352706732', '8352709498', '8353700563');

DELETE 
-- SELECT * 
FROM tblSKUPartAssociation
WHERE tblSKUPartAssociation.ixSKUPartAssociationID IN ('201135', '134984', '97023'); 

SELECT * 
FROM SKUAttribute
WHERE ixSKU IN ('8352706732', '8352709498', '8353700563')
ORDER BY ixSKU, ixTemplateAttributeId;

DELETE 
-- SELECT * 
FROM SKUAttribute 
WHERE ixSKUAttributeId IN ('375524', '734158', '375525', '733971', '733905', '733926', '733915', '733918', '727574', '727543', '727703');


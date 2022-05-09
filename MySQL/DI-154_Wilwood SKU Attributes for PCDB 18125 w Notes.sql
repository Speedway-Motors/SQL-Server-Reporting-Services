 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 18125; -- Disc Brake Rotor Bearing and Seal Kits 

-- For each column header (attribute) it needs to be determined what "type" they are. This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 5;

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 6;


SELECT *
FROM AttributeType; -- Type 2 & 4 will be special types that will take additional steps; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31  
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44           
   OR sTitle = 'Cup OD' -- Measurement/Size/Length, 5 -- Template ID 729 -- UnitId = 6 (inches) 
   OR sTitle = 'Cone ID' -- Measurement/Size/Length, 5 -- Template ID 730 -- UnitId = 6 (inches)    
   OR sTitle = 'Weight' -- weight, 6 -- Template ID 35 -- UnitId = 15 (ounces)        
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_discbrakesealkit;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_discbrakesealkit
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_discbrakesealkit CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_discbrakesealkit, AttributeDropdownItem
SET tmp.tmp_discbrakesealkit.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakesealkit.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31
   AND AttributeDropdownItem.ixAttributeDropdownItemId <> 31; 

SELECT *
FROM tmp.tmp_discbrakesealkit
WHERE ixMaterialType IS NULL; -- all records updated 


UPDATE tmp.tmp_discbrakesealkit, AttributeDropdownItem
SET tmp.tmp_discbrakesealkit.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakesealkit.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_discbrakesealkit
WHERE ixFinish IS NULL; -- all records updated 


-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_discbrakesealkit
 ADD ixUnitID1 INT AFTER dWeight
,ADD ixUnitID2 INT AFTER dCupOD
,ADD ixUnitID3 INT AFTER dConeID;


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_discbrakesealkit
SET ixUnitID1 = 15 
WHERE dWeight IS NOT NULL; 

UPDATE tmp.tmp_discbrakesealkit
SET ixUnitID2 = 6 
WHERE dCupOD IS NOT NULL; 

UPDATE tmp.tmp_discbrakesealkit
SET ixUnitID3 = 6 
WHERE dConeID IS NOT NULL; 


-- Now the records need to be inserted into the SKU Attribute table 

SELECT SA.ixSKU
     , SA.sValue 
     , DB.ixMaterialType
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakesealkit DB ON DB.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakesealkit) 
  AND ixTemplateAttributeId = 31
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DB.ixMaterialType; -- 0 values already existed
 
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DB.ixSOPSKU
     , 31
     , DB.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakesealkit DB
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DB.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DB.ixMaterialType IS NOT NULL
  AND DB.ixMaterialType <> 32; -- 32 rows affected (1 did not have a material type) 
  
  
-- The parts to not exist in tblSKUPartAssociation so that must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DB.ixSOPSKU
     , 18125
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_discbrakesealkit DB;


SELECT SA.ixSKU
     , SA.sValue 
     , DB.ixFinish
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakesealkit DB ON DB.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakesealkit) 
  AND ixTemplateAttributeId = 44
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DB.ixMaterialType; -- 0 values already existed

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DB.ixSOPSKU
     , 44
     , DB.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakesealkit DB
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DB.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DB.ixFinish IS NOT NULL
  AND DB.ixFinish <> 46; -- 31 rows affected (1 did not have a material type)   

  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DB.ixSOPSKU
     , 35
     , DB.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , DB.ixUnitID1  
FROM tmp.tmp_discbrakesealkit DB
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DB.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DB.dWeight IS NOT NULL 
   OR DB.dWeight <> '0.00'; -- 34 values inserted 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DB.ixSOPSKU
     , 729
     , DB.dCupOD
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , DB.ixUnitID2 
FROM tmp.tmp_discbrakesealkit DB
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DB.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DB.dCupOD IS NOT NULL 
   OR DB.dCupOD <> '0.00'; -- 34 values inserted 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DB.ixSOPSKU
     , 730
     , DB.dConeID
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , DB.ixUnitID3 
FROM tmp.tmp_discbrakesealkit DB
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DB.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DB.dConeID IS NOT NULL 
   OR DB.dConeID <> '0.00'; -- 34 values inserted 
   
   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_discbrakesealkit;

SELECT TemplateAttribute.sTitle
     , SA.* 
FROM SKUAttribute SA
LEFT JOIN TemplateAttribute ON TemplateAttribute.ixTemplateAttributeId = SA.ixTemplateAttributeId
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakesealkit)
  AND sTitle = 'Cone ID' ; 


DELETE FROM SKUAttribute
WHERE ixTemplateAttributeId = 730
  AND ixSKU IN ('8353700314', '8353700315', '8353700563', '8353700563', '8353700876', '8353700878', '8353700881', '8353700883'
                   ,'83537010763', '83537011554', '83537011758', '8353701238', '8353701560', '8353702571', '8353703146'
                   ,'8353709245', '8353709537', '8353709545');
-- These were all 0.00 values which makes the data look messy     


DELETE FROM SKUAttribute
WHERE ixTemplateAttributeId = 729
  AND ixSKU IN ('8353700431', '8353700432', '8353700563', '8353700563', '8353700877', '8353700879', '8353700882', '8353700884'
                  , '8353700933', '83537010763', '83537011555', '8353701239', '83537012734', '83537012735', '83537012831'
                  , '8353701561', '8353702609', '8353703147', '8353709537', '8353709542', '8353709545');
-- These were all 0.00 values which makes the data look messy  
                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8353700314';


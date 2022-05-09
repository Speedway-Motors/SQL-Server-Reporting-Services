 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 10293; -- Axle Hub Assemblies
 
-- For each column header (attribute) it needs to be determined what "type" they are. 
-- This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 6;


-- Type 2 & 4 will be special types that will take additional steps; 
-- all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Rotor Compatibility' -- Dropdown box, 4 -- Template ID 762
   OR sTitle = 'Material Type' -- Dropdown box, 4 -- Template ID 31
   OR sTitle = 'Mount Type' -- Dropdown box, 4 -- Template ID 766
   OR sTitle = 'Finish' -- Dropdown box, 4 -- Template ID 44
   OR sTitle = 'Rotor Offset Type' -- Dropdown box, 4 -- Template ID 765
   OR sTitle = 'Adapter Bolt Circles (6-bolt)' -- Dropdown box, 4 -- Template ID 767
   OR sTitle = 'Hub Bolt Circle 1' -- Dropdown box, 4 -- Template ID 769
   OR sTitle = 'Hub Bolt Circle 2' -- Dropdown box, 4 -- Template ID 770   
   OR sTitle = '8 - bolt  type' -- Dropdown box, 4 -- Template ID 768
   OR sTitle = 'Offset' -- Measurement/Size/Length, 5 -- Template ID 233  -- UnitId = 6 
   OR sTitle = 'Stud Diameter' -- Measurement/Size/Length, 5 -- Template ID 133 -- Unit Id = 6
   OR sTitle = 'Stud Diameter 2' -- Measurement/Size/Length, 5 -- Template ID 760  -- Unit Id = 6
   OR sTitle = 'Stud Diameter 3' -- Measurement/Size/Length, 5 -- Template ID 761  -- Unit Id = 6    
   OR sTitle = 'Weight' -- Weight, 6 -- Template ID 35 -- Unit Id = 14  (pounds)  
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_hubassemblies;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_hubassemblies
 ADD ix8BoltType INT AFTER d8BoltType
,ADD ixRotorCompatibility INT AFTER sRotorCompatibility 
,ADD ixMaterialType INT AFTER sMaterialType
,ADD ixMountType INT AFTER sMountType
,ADD ixFinish INT AFTER sFinish
,ADD ixRotorOffsetType INT AFTER sRotorOffsetType
,ADD ixAdapaterBoltCircles INT AFTER sAdaptedBoltCircles
,ADD ixHubBoltCircle1 INT AFTER sHubBoltCircle1
,ADD ixHubBoltCircle2 INT AFTER sHubBoltCircle2
,ADD ixUnitId1 INT AFTER dOffset
,ADD ixUnitId2 INT AFTER dStudDiameter
,ADD ixUnitId3 INT AFTER dStudDiameter2
,ADD ixUnitId4 INT AFTER dStudDiameter3
,ADD ixUnitId5 INT AFTER dWeight;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_hubassemblies CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 

UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ix8BoltType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.d8BoltType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 768; 

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ix8BoltType IS NULL; -- all records that had values updated 


UPDATE tmp.tmp_hubassemblies
SET d8BoltType = '8 x 7.00"'
WHERE d8BoltType = '8 x 7.00';


UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixRotorCompatibility = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sRotorCompatibility = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 762; 

SELECT DISTINCT sRotorCompatibility
FROM tmp.tmp_hubassemblies
WHERE ixRotorCompatibility IS NULL; -- all records that had values updated 

UPDATE tmp.tmp_hubassemblies
SET sRotorCompatibility = '5 x 3.88"'
WHERE sRotorCompatibility = '5 x 3.88';


UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ixMaterialType IS NULL; -- all records updated 


UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixMountType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sMountType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 766; 

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ixMountType IS NULL; -- all records updated 


UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44;  

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ixFinish IS NULL; -- all records updated 


UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixRotorOffsetType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sRotorOffsetType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 765; 

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ixRotorOffsetType IS NULL; -- all records with values updated 


UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixAdapaterBoltCircles = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sAdaptedBoltCircles = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 767; 

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ixAdapaterBoltCircles IS NULL; -- all records with values updated 


UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixHubBoltCircle1 = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sHubBoltCircle1 = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 769; 

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ixHubBoltCircle1 IS NULL; -- all records updated after below changes made 


UPDATE tmp.tmp_hubassemblies
SET sHubBoltCircle1  = '4 x 4.50"'
WHERE sHubBoltCircle1  = '4 x 4.50';



UPDATE tmp.tmp_hubassemblies, AttributeDropdownItem
SET tmp.tmp_hubassemblies.ixHubBoltCircle2 = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hubassemblies.sHubBoltCircle2 = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 770; 

SELECT *
FROM tmp.tmp_hubassemblies
WHERE ixHubBoltCircle2 IS NULL; -- all records updated after below changes made 

UPDATE tmp.tmp_hubassemblies
SET sHubBoltCircle2  = '5 x 5.00"'
WHERE sHubBoltCircle2  = '5 x 5.00';

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 770;


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_hubassemblies
SET ixUnitId1 = 6
WHERE d8BoltType IS NOT NULL; 

UPDATE tmp.tmp_hubassemblies
SET ixUnitId2 = 6 
WHERE dOffset IS NOT NULL;

UPDATE tmp.tmp_hubassemblies
SET ixUnitId3 = 6 
WHERE dStudDiameter IS NOT NULL;

UPDATE tmp.tmp_hubassemblies
SET ixUnitId4 = 6 
WHERE dStudDiameter2 IS NOT NULL;


UPDATE tmp.tmp_hubassemblies
SET ixUnitId5 = 6 
WHERE dStudDiameter3 IS NOT NULL;


UPDATE tmp.tmp_hubassemblies
SET ixUnitId6 = 14
WHERE dWeight IS NOT NULL;


-- Now the records need to be inserted into the SKU Attribute table 

SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_hubassemblies)
  AND ixPartTerminologyID <> 10293; 
  
UPDATE tblSKUPartAssociation
SET ixPartTerminologyID = 10293 
WHERE ixSKUPartAssociationID = 175678;

UPDATE tblSKUPartAssociation
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixSKUPartAssociationID = 175678;

UPDATE tblSKUPartAssociation
SET dtUpdate = NOW()
WHERE ixSKUPartAssociationID = 175678;
  
-- The 64 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT HA.ixSOPSKU
     , 10293
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_hubassemblies HA; 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 768
     , HA.ix8BoltType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ix8BoltType IS NOT NULL; -- 43 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 762
     , HA.ixRotorCompatibility
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixRotorCompatibility IS NOT NULL; -- 43 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 31
     , HA.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixMaterialType IS NOT NULL; -- 65 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 766
     , HA.ixMountType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixMountType IS NOT NULL; -- 65 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 44
     , HA.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixFinish IS NOT NULL; -- 65 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 765
     , HA.ixRotorOffsetType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixRotorOffsetType IS NOT NULL; -- 43 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 767
     , HA.ixAdapaterBoltCircles
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixAdapaterBoltCircles IS NOT NULL; -- 43 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 769
     , HA.ixHubBoltCircle1
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixHubBoltCircle1 IS NOT NULL; -- 65 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 770
     , HA.ixHubBoltCircle2
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.ixHubBoltCircle2 IS NOT NULL; -- 58 rows affected

  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 233
     , HA.dOffset
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HA.ixUnitId2
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.dOffset IS NOT NULL
  AND HA.dOffset <> ' '
  AND HA.dOffset <> 0.00; --  43 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 133
     , HA.dStudDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HA.ixUnitId3
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.dStudDiameter IS NOT NULL
  AND HA.dStudDiameter <> ' '
  AND HA.dStudDiameter <> 0.00; --  65 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 760
     , HA.dStudDiameter2
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HA.ixUnitId4
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.dStudDiameter2 IS NOT NULL
  AND HA.dStudDiameter2 <> ' '
  AND HA.dStudDiameter2 <> 0.00; --  65 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 761
     , HA.dStudDiameter3
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HA.ixUnitId5
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.dStudDiameter3 IS NOT NULL
  AND HA.dStudDiameter3 <> ' '
  AND HA.dStudDiameter3 <> 0.00; --  65 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HA.ixSOPSKU
     , 35
     , HA.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HA.ixUnitId6
FROM tmp.tmp_hubassemblies HA
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HA.dWeight IS NOT NULL
  AND HA.dWeight <> ' '
  AND HA.dWeight <> 0.00; --  65 rows affected  
  
  
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_hubassemblies HA;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '83527010660';


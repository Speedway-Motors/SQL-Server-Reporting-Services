 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 11537; -- Axle Hubs
 
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
FROM tmp.tmp_axlehubs;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_axlehubs
 ADD ix8BoltType INT AFTER s8BoltType
,ADD ixRotorCompatibility INT AFTER sRotorCompatibility 
,ADD ixMaterialType INT AFTER sMaterialType
,ADD ixMountType INT AFTER sMountType
,ADD ixFinish INT AFTER sFinish
,ADD ixRotorOffsetType INT AFTER sRotorOffsetType
,ADD ixAdapterBoltCircles INT AFTER sAdapterBoltCircles
,ADD ixHubBoltCircle1 INT AFTER sHubBoltCircle1
,ADD ixHubBoltCircle2 INT AFTER sHubBoltCircle2
,ADD ixUnitId1 INT AFTER dOffset
,ADD ixUnitId2 INT AFTER dStudDiameter
,ADD ixUnitId3 INT AFTER dStudDiameter2
,ADD ixUnitId4 INT AFTER dStudDiameter3
,ADD ixUnitId5 INT AFTER dWeight;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_axlehubs CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 

UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ix8BoltType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.s8BoltType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 768; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ix8BoltType IS NULL; -- all records that had values updated after the change below was made 


UPDATE tmp.tmp_axlehubs
SET s8BoltType = '8 x 7.00"'
WHERE s8BoltType = '8 x 7.00';


UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixRotorCompatibility = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sRotorCompatibility = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 762; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixRotorCompatibility IS NULL; -- all records that had values updated after the below changes were made 

UPDATE tmp.tmp_axlehubs
SET sRotorCompatibility = '3.37 x 2.28"'
WHERE sRotorCompatibility = '3.37x2.28"';

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 762;



UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixMaterialType IS NULL; -- all records updated 


UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixMountType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sMountType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 766; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixMountType IS NULL; -- all records with values updated 


SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 766;

UPDATE tmp.tmp_axlehubs
SET sMountType = 'Adapter - Dynamic'
WHERE sMountType = 'Adapter-Dynamic';


UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44;  

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixFinish IS NULL; -- all records updated 


UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixRotorOffsetType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sRotorOffsetType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 765; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixRotorOffsetType IS NULL; -- all records with values updated 


SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 765;


UPDATE tmp.tmp_axlehubs
SET sRotorOffsetType = 'STD Offset - Dynamic'
WHERE sRotorOffsetType = 'STD Offset -Dynamic';


UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixAdapterBoltCircles = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sAdapterBoltCircles = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 767; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixAdapterBoltCircles IS NULL; -- all records with values updated 


UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixHubBoltCircle1 = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sHubBoltCircle1 = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 769; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixHubBoltCircle1 IS NULL; -- all records updated after below changes made 


UPDATE tmp.tmp_axlehubs
SET sHubBoltCircle1  = '6 x 5.32"'
WHERE sHubBoltCircle1  = '6 x 5.32';



UPDATE tmp.tmp_axlehubs, AttributeDropdownItem
SET tmp.tmp_axlehubs.ixHubBoltCircle2 = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_axlehubs.sHubBoltCircle2 = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 770; 

SELECT *
FROM tmp.tmp_axlehubs
WHERE ixHubBoltCircle2 IS NULL; -- all records updated after below changes made 

UPDATE tmp.tmp_axlehubs
SET sHubBoltCircle2  = '5 x 4.75"'
WHERE sHubBoltCircle2  = '5 x 4.75';

-- Update all the UnitId values to the correct Unit Type 

UPDATE tmp.tmp_axlehubs
SET ixUnitId1 = 6 
WHERE dOffset IS NOT NULL;

UPDATE tmp.tmp_axlehubs
SET ixUnitId2 = 6 
WHERE dStudDiameter IS NOT NULL;

UPDATE tmp.tmp_axlehubs
SET ixUnitId3 = 6 
WHERE dStudDiameter2 IS NOT NULL;


UPDATE tmp.tmp_axlehubs
SET ixUnitId4 = 6 
WHERE dStudDiameter3 IS NOT NULL;


UPDATE tmp.tmp_axlehubs
SET ixUnitId5 = 14
WHERE dWeight IS NOT NULL;


-- Now the records need to be inserted into the SKU Attribute table 

SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_axlehubs)
  AND ixPartTerminologyID <> 11537; 
  
UPDATE tblSKUPartAssociation
SET ixPartTerminologyID = 11537
WHERE ixSKUPartAssociationID IN (201199, 151315);

UPDATE tblSKUPartAssociation
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixSKUPartAssociationID IN (201199, 151315);

UPDATE tblSKUPartAssociation
SET dtUpdate = NOW()
WHERE ixSKUPartAssociationID IN (201199, 151315);
  
-- The 24 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT AH.ixSOPSKU
     , 11537
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_axlehubs AH; 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 768
     , AH.ix8BoltType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ix8BoltType IS NOT NULL; -- 12 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 762
     , AH.ixRotorCompatibility
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixRotorCompatibility IS NOT NULL; -- 24 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 31
     , AH.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixMaterialType IS NOT NULL; -- 26 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 766
     , AH.ixMountType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixMountType IS NOT NULL; -- 25 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 44
     , AH.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixFinish IS NOT NULL; -- 26 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 765
     , AH.ixRotorOffsetType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixRotorOffsetType IS NOT NULL; -- 19 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 767
     , AH.ixAdapterBoltCircles
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixAdapterBoltCircles IS NOT NULL; -- 8 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 769
     , AH.ixHubBoltCircle1
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixHubBoltCircle1 IS NOT NULL; -- 25 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 770
     , AH.ixHubBoltCircle2
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.ixHubBoltCircle2 IS NOT NULL; -- 3 rows affected

  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 233
     , AH.dOffset
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , AH.ixUnitId1
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.dOffset IS NOT NULL
  AND AH.dOffset <> ' '
  AND AH.dOffset <> 0.00; --  3 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 133
     , AH.dStudDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , AH.ixUnitId2
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.dStudDiameter IS NOT NULL
  AND AH.dStudDiameter <> ' '
  AND AH.dStudDiameter <> 0.00; --  20 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 760
     , AH.dStudDiameter2
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , AH.ixUnitId3
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.dStudDiameter2 IS NOT NULL
  AND AH.dStudDiameter2 <> ' '
  AND AH.dStudDiameter2 <> 0.00; --  20 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 761
     , AH.dStudDiameter3
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , AH.ixUnitId4
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.dStudDiameter3 IS NOT NULL
  AND AH.dStudDiameter3 <> ' '
  AND AH.dStudDiameter3 <> 0.00; --  20 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AH.ixSOPSKU
     , 35
     , AH.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , AH.ixUnitId5
FROM tmp.tmp_axlehubs AH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE AH.dWeight IS NOT NULL
  AND AH.dWeight <> ' '
  AND AH.dWeight <> 0.00; --  26 rows affected  
  
  
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_axlehubs HA;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8352706735BC';


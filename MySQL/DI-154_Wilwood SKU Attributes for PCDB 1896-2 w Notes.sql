 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 1896; -- Disc Brake Rotors
 
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
WHERE sTitle = 'Mount Side' -- Dropdown box, 4 -- Template ID 740
   OR sTitle = 'Material Type' -- Dropdown box, 4 -- Template ID 31
   OR sTitle = 'Rotor Diameter' -- Dropdown box, 4 -- Template ID 261 (inches)
   OR sTitle = 'Vane Count' -- Dropdown box, 4 -- Template ID 741  
   OR sTitle = 'Rotor Construction' -- Dropdown box, 4 -- Template ID 384     
   OR sTitle = 'Rotor Style' -- Dropdown box, 4 -- Template ID 742     
   OR sTitle = 'Finish' -- Dropdown box, 4 -- Template ID 44
   OR sTitle = 'Rotor Hat Bolt Pattern' -- Dropdown box, 4 -- Template ID 413
   OR sTitle = 'Mount Hole Size' -- Measurement/Size/Length, 5 -- Template ID 722  -- UnitId = 6 (inches)  
   OR sTitle = 'Lug ID' -- Measurement/Size/Length, 5 -- Template ID 745  -- UnitId = 6 (inches)  
   OR sTitle = 'Inside Diameter' -- Measurement/Size/Length, 5 -- Template ID 91  -- UnitId = 6 (inches)  
   OR sTitle = 'Offset' -- Measurement/Size/Length, 5 -- Template ID 233  -- UnitId = 6 (inches)  
   OR sTitle = 'Shoe Inside Dimension' -- Measurement/Size/Length, 5 -- Template ID 746  -- UnitId = 6 (inches)  
   OR sTitle = 'Internal Clearance' -- Measurement/Size/Length, 5 -- Template ID 631  -- UnitId = 6 (inches)  
   OR sTitle = 'Face Thickness' -- Measurement/Size/Length, 5 -- Template ID 748  -- UnitId = 6 (inches)    
   OR sTitle = 'Stud Diameter' -- Measurement/Size/Length, 5 -- Template ID 133 -- UnitId = 6 (inches)       
   OR sTitle = 'Rotor Width' -- Measurement/Size/Length, 5 -- Template ID 739 -- UnitId = 6 (inches)  
   OR sTitle = 'Wheel Bolt Circle' -- Text, 1 -- Template ID 747   
   OR sTitle = 'Bedded' -- Yes/No, 2 -- Template ID 743  
   OR sTitle = 'Balanced' -- Yes/No, 2 -- Template ID 744
   OR sTitle = 'Weight' -- Weight, 6 -- Template ID 35 -- Unit Id = 14   
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_dbrotors2;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_dbrotors2
 ADD ixMountSide INT AFTER sMountSide
,ADD ixMaterialType INT AFTER sMaterialType
,ADD ixRotorDiameter INT AFTER sRotorDiameter
,ADD ixVaneCount INT AFTER sVaneCount
,ADD ixRotorConstruction INT AFTER sRotorConstruction
,ADD ixRotorStyle INT AFTER sRotorStyle
,ADD ixFinish INT AFTER sFinish
,ADD ixRotorHatBoltPattern INT AFTER sRotorHatBolt_Pattern
,ADD ixUnitId1 INT AFTER dMountHoleSize
,ADD ixUnitId2 INT AFTER dLugID
,ADD ixUnitId3 INT AFTER dInsideDiameter
,ADD ixUnitId4 INT AFTER dOffset
,ADD ixUnitId5 INT AFTER dShoeInsideDimension
,ADD ixUnitId6 INT AFTER dInternalClearance
,ADD ixUnitId7 INT AFTER dFaceThickness
,ADD ixUnitId8 INT AFTER dStudDiameter
,ADD ixUnitId9 INT AFTER dRotorWidth
,ADD ixUnitId10 INT AFTER dWeight;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_dbrotors2 CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixMountSide = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sMountSide = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 740; 

SELECT *
FROM tmp.tmp_dbrotors2
WHERE ixMountSide IS NULL; -- all records with values updated 


UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_dbrotors2
WHERE ixMaterialType IS NULL; -- all records with values updated 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 31; -- Carbon Steel COME BACK TO THESE AFTER TALK TO JGO


UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixRotorDiameter = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sRotorDiameter = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 261; 

SELECT DISTINCT sRotorDiameter
FROM tmp.tmp_dbrotors2
WHERE ixRotorDiameter IS NULL; -- all records with values updated after the changes below were made 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 261 ORDER BY sAttributeDropdownItemText;
-- 12 / 10 / 10.5 / 11 / 14 / 10.2 / 12.9 / 12.6 / 16 
-- Update to: 10.00 / 10.50 / 10.20 / 11.00 / 12.00 / 12.60 / 12.90 / 14.00 / 16.00 

UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '10.00' WHERE sRotorDiameter = '10'; 
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '11.00' WHERE sRotorDiameter = '11'; 
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '14.00' WHERE sRotorDiameter = '14'; 
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '16.00' WHERE sRotorDiameter = '16'; 
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '10.50' WHERE sRotorDiameter = '10.5'; 
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '12.00' WHERE sRotorDiameter = '12'; 
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '10.20' WHERE sRotorDiameter = '10.2'; 
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '12.60' WHERE sRotorDiameter = '12.6';
UPDATE tmp.tmp_dbrotors2 SET sRotorDiameter = '12.90' WHERE sRotorDiameter = '12.9';


UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixVaneCount = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sVaneCount = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 741; 

SELECT *
FROM tmp.tmp_dbrotors2
WHERE ixVaneCount IS NULL; -- all records with values updated 


UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixRotorConstruction = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sRotorConstruction = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 384; 

SELECT *
FROM tmp.tmp_dbrotors2
WHERE ixRotorConstruction IS NULL; -- all records with values updated 


UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixRotorStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sRotorStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 742; 

SELECT *
FROM tmp.tmp_dbrotors2
WHERE ixRotorStyle IS NULL; -- all records with values updated 


UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44;  -- Plain COME BACK TO THESE AFTER TALK TO JGO

SELECT *
FROM tmp.tmp_dbrotors2
WHERE ixFinish IS NULL; -- all records with values updated 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 44 ORDER BY sAttributeDropdownItemText;

UPDATE tmp.tmp_dbrotors2
SET sFinish = 'Natural' 
WHERE sFinish = 'Plain';

UPDATE tmp.tmp_dbrotors2, AttributeDropdownItem
SET tmp.tmp_dbrotors2.ixRotorHatBoltPattern = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors2.sRotorHatBolt_Pattern = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 413; 

SELECT DISTINCT sRotorHatBolt_Pattern
FROM tmp.tmp_dbrotors2
WHERE ixRotorHatBoltPattern IS NULL
ORDER BY sRotorHatBolt_Pattern; -- all records with values updated after making the changes below 

UPDATE tmp.tmp_dbrotors2
SET sRotorHatBolt_Pattern = '6 x 6.25"'
WHERE sRotorHatBolt_Pattern = '6 x 6.25';

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 413 ORDER BY sAttributeDropdownItemText; 


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_dbrotors2
SET ixUnitId1 = 6
WHERE dMountHoleSize IS NOT NULL; 

UPDATE tmp.tmp_dbrotors2
SET ixUnitId2 = 6
WHERE dLugID IS NOT NULL; 

UPDATE tmp.tmp_dbrotors2
SET ixUnitId3 = 6 
WHERE dInsideDiameter IS NOT NULL;

UPDATE tmp.tmp_dbrotors2
SET ixUnitId4 = 6 
WHERE dOffset IS NOT NULL;

UPDATE tmp.tmp_dbrotors2
SET ixUnitId5 = 6
WHERE dShoeInsideDimension IS NOT NULL; 

UPDATE tmp.tmp_dbrotors2
SET ixUnitId6 = 6
WHERE dInternalClearance IS NOT NULL; 

UPDATE tmp.tmp_dbrotors2
SET ixUnitId7 = 6 
WHERE dFaceThickness IS NOT NULL;

UPDATE tmp.tmp_dbrotors2
SET ixUnitId8 = 6 
WHERE dStudDiameter IS NOT NULL;


UPDATE tmp.tmp_dbrotors2
SET ixUnitId9 = 6 
WHERE dRotorWidth IS NOT NULL;


UPDATE tmp.tmp_dbrotors2
SET ixUnitId10 = 14
WHERE dWeight IS NOT NULL;

-- Update the Yes/No values to Boolean readings 
Update tmp.tmp_dbrotors2
SET sBedded = '1' 
WHERE sBedded = 'Yes';
Update tmp.tmp_dbrotors2
SET sBedded = '0' 
WHERE sBedded = 'No';

Update tmp.tmp_dbrotors2
SET sBalanced = '1' 
WHERE sBalanced = 'Yes';
Update tmp.tmp_dbrotors2
SET sBalanced = '0' 
WHERE sBalanced = 'No';

-- Now the records need to be inserted into the SKU Attribute table 

SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_dbrotors2)
  AND ixPartTerminologyID <> 1896; 
  
-- The 7 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT R.ixSOPSKU
     , 1896
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_dbrotors2 R;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 747
     , R.sWheelBoltCircle
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sWheelBoltCircle IS NOT NULL
  AND R.sWheelBoltCircle <> ' '; --  57 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 743
     , R.sBedded
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sBedded IS NOT NULL; --  195 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 744
     , R.sBalanced
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sBalanced IS NOT NULL; --  195 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 740
     , R.ixMountSide
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixMountSide IS NOT NULL; -- 110 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 31
     , R.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixMaterialType IS NOT NULL; -- 162 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 261
     , R.ixRotorDiameter
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorDiameter IS NOT NULL; -- 164 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 741
     , R.ixVaneCount
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixVaneCount IS NOT NULL; -- 195 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 384
     , R.ixRotorConstruction
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorConstruction IS NOT NULL; -- 164 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 742
     , R.ixRotorStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorStyle IS NOT NULL; -- 195 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 44
     , R.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixFinish IS NOT NULL; -- 164 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 413
     , R.ixRotorHatBoltPattern
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorHatBoltPattern IS NOT NULL; -- 102 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 722
     , R.dMountHoleSize
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId1
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dMountHoleSize IS NOT NULL
  AND R.dMountHoleSize <> ' '
  AND R.dMountHoleSize <> 0.00; --  119 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 745
     , R.dLugID
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId2
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dLugID IS NOT NULL
  AND R.dLugID <> ' '
  AND R.dLugID <> 0.00; --  190 rows affected

   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 91
     , R.dInsideDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId3
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dInsideDiameter IS NOT NULL
  AND R.dInsideDiameter <> ' '
  AND R.dInsideDiameter <> 0.00; --  156 rows affected
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 233
     , R.dOffset
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId4
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dOffset IS NOT NULL
  AND R.dOffset <> ' '
  AND R.dOffset <> 0.00; --  62 rows affected  
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 746
     , R.dShoeInsideDimension
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId5
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dShoeInsideDimension IS NOT NULL
  AND R.dShoeInsideDimension <> ' '
  AND R.dShoeInsideDimension <> 0.00; --  43 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 631
     , R.dInternalClearance
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId6
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dInternalClearance IS NOT NULL
  AND R.dInternalClearance <> ' '
  AND R.dInternalClearance <> 0.00; --  54 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 748
     , R.dFaceThickness
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId7
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dFaceThickness IS NOT NULL
  AND R.dFaceThickness <> ' '
  AND R.dFaceThickness <> 0.00; --  58 rows affected 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 133
     , R.dStudDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId8
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dStudDiameter IS NOT NULL
  AND R.dStudDiameter <> ' '
  AND R.dStudDiameter <> 0.00; --  53 rows affected  
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 739
     , R.dRotorWidth
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId9
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dRotorWidth IS NOT NULL
  AND R.dRotorWidth <> ' '
  AND R.dRotorWidth <> 0.00; --  195 rows affected     
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 35
     , R.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId10
FROM tmp.tmp_dbrotors2 R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dWeight IS NOT NULL
  AND R.dWeight <> ' '
  AND R.dWeight <> 0.00; --  160 rows affected  
  
  
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_dbrotors2 R;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8351600490';


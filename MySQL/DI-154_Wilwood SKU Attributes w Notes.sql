 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 1704; -- Disc Brake Calipers 

-- For each column header (attribute) it needs to be determined what "type" they are. This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 19; -- ixUnitId = 39 (sq. in.) 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 5;

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 6;

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 20;


SELECT *
FROM AttributeType; -- Type 2 & 4 will be special types that will take additional steps; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Caliper Pistons' -- dropdown box, 4 -- Template ID 309
   OR sTitle = 'Rotor Diameter' -- dropdown box, 4 -- Template ID 261 -- UnitId = 6 (inches) 
   OR sTitle = 'Caliper Mounting Type' -- dropdown box, 4 -- Template ID 718 
   OR sTitle = 'Mounting Side' -- dropdown box, 4 -- Template ID 318 
   OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31  
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36        
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44           
   OR sTitle = 'Rotor Thickness' -- Measurement/Size/Length, 5 -- Template ID 377 -- UnitId = 6 (inches) 
   OR sTitle = 'Bore Size' -- Measurement/Size/Length, 5 -- Template ID 147 -- UnitId = 6 (inches)       
   OR sTitle = 'Bore 2 Size' -- Measurement/Size/Length, 5 -- Template ID 719   -- UnitId = 6 (inches) 
   OR sTitle = 'Bore 3 Size' -- Measurement/Size/Length, 5 -- Template ID 720  -- UnitId = 6 (inches)  
   OR sTitle = 'Mount Hole Size' -- Measurement/Size/Length, 5 -- Template ID 722 -- UnitId = 6 (inches)     
   OR sTitle = 'Mounted Height' -- Measurement/Size/Length, 5 -- Template ID 204 -- UnitId = 6 (inches) 
   OR sTitle = 'Centerline of Holes' -- Measurement/Size/Length, 5 -- Template ID 30 -- UnitId = 6 (inches)         
   OR sTitle = 'Weight' -- weight, 6 -- Template ID 35 -- UnitId = 14 (pounds)        
   OR sTitle = 'Thread Pitch' -- text, 1 -- Template ID 142     
   OR sTitle = 'Pad Area' -- area, 19 -- Template ID 723 -- UnitId = 39 (sq. in)    
   OR sTitle = 'Total Piston Area' -- area, 19 -- Template ID 721  -- UnitId = 39 (sq. in)       
   OR sTitle = 'Pad Volume' -- volume, 20 -- Template ID 724    -- UnitId = 49 (cubic in)    
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_discbrakecalipers;


-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_discbrakecalipers
 ADD ixCaliperPistons INT AFTER sCaliperPistons
,ADD ixRotorDiameter INT AFTER sRotorDiameter
,ADD ixCaliperMountingType INT AFTER sCaliperMountingType
,ADD ixMountingSide INT AFTER sMountingSide
,ADD ixMaterialType INT AFTER sMaterialType
,ADD ixColor INT AFTER sColor
,ADD ixFinish INT AFTER sFinish
,ADD ixUnitId1 INT AFTER dRotorThickness
,ADD ixUnitId2 INT AFTER dBoreSize 
,ADD ixUnitId3 INT AFTER dBore2Size 
,ADD ixUnitId4 INT AFTER dBore3Size 
,ADD ixUnitId5 INT AFTER dMountHoleSize
,ADD ixUnitId6 INT AFTER dMountedHeight 
,ADD ixUnitId7 INT AFTER dCenterlineofHoles 
,ADD ixUnitId8 INT AFTER dWeight
,ADD ixUnitId9 INT AFTER dPadArea 
,ADD ixUnitId10 INT AFTER dTotalPistonArea
,ADD ixUnitId11 INT AFTER dPadVolume;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_discbrakecalipers CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_discbrakecalipers, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers.ixCaliperPistons = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers.sCaliperPistons = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 309; 

SELECT *
FROM tmp.tmp_discbrakecalipers
WHERE ixCaliperPistons IS NULL; -- All records updated that had values [7 null]

UPDATE tmp.tmp_discbrakecalipers, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers.ixRotorDiameter = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers.sRotorDiameter = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 261; 

SELECT DISTINCT sRotorDiameter
FROM tmp.tmp_discbrakecalipers
WHERE ixRotorDiameter IS NULL; -- 93 records did not update, 15.00 / 9.00 / 11.20 

-- Check the data 
SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 261 -- 15.00 / 9.00 / 11.20 
ORDER BY sAttributeDropdownItemText;

UPDATE tmp.tmp_discbrakecalipers, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers.ixCaliperMountingType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers.sCaliperMountingType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 718; 

SELECT DISTINCT sRotorDiameter
FROM tmp.tmp_discbrakecalipers
WHERE ixCaliperMountingType IS NULL; -- all records updated 

UPDATE tmp.tmp_discbrakecalipers, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers.ixMountingSide = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers.sMountingSide = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 318; 

SELECT DISTINCT sRotorDiameter
FROM tmp.tmp_discbrakecalipers
WHERE ixMountingSide IS NULL; -- all records updated 

UPDATE tmp.tmp_discbrakecalipers, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_discbrakecalipers
WHERE ixMaterialType IS NULL; -- 4 records did not update, Alum / Steel 

-- Check the data 
SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 31 -- Alum / Steel 
ORDER BY sAttributeDropdownItemText;

UPDATE tmp.tmp_discbrakecalipers, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_discbrakecalipers
WHERE ixColor IS NULL; -- all records updated 

UPDATE tmp.tmp_discbrakecalipers, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_discbrakecalipers
WHERE ixFinish IS NULL; -- 2 records did not update, Silver Powder Coat 

-- Check the data 
SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 44 -- Silver Powder Coat 
ORDER BY sAttributeDropdownItemText;

-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId1 = 6 
WHERE dRotorThickness IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId2 = 6 
WHERE dBoreSize IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId3 = 6 
WHERE dBore2Size IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId4 = 6 
WHERE dBore3Size IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId5 = 6 
WHERE dMountHoleSize IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId6 = 6 
WHERE dMountedHeight IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId7 = 6 
WHERE dCenterlineofHoles IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId8 = 14 
WHERE dWeight IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId9 = 39 
WHERE dPadArea IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId10 = 39
WHERE dTotalPistonArea IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers
SET ixUnitId11 = 49 
WHERE dPadVolume IS NOT NULL; 



-- Now the records need to be inserted into the SKU Attribute table 

SELECT SA.ixSKU
     , SA.sValue 
     , DBC.ixCaliperPistons
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixCreateUser NOT LIKE '%ascrook%'
  AND ixTemplateAttributeId = 309
  AND SA.sValue <> DBC.ixCaliperPistons; -- 40 values already existed

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 309
     , DBC.ixCaliperPistons
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixCaliperPistons IS NOT NULL; -- 410 values inserted 

-- Records were initially failing to insert due to a primary key restraint; 4 SKUs did not yet exist in tblSKUPartAssociation 

SELECT * FROM tmp.tmp_discbrakecalipers
WHERE ixSOPSKU NOT IN (SELECT ixSKU FROM tblSKUPartAssociation);  -- to return the missing SKUs 

INSERT INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
VALUES ('12010112BK', 1704, 'SPEEDWAYMOTORS\\ascrook', NOW());

INSERT INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
VALUES ('83512011571SI', 1704, 'SPEEDWAYMOTORS\\ascrook', NOW());

INSERT INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
VALUES ('83512011573', 1704, 'SPEEDWAYMOTORS\\ascrook', NOW());

INSERT INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
VALUES ('8351208544SI', 1704, 'SPEEDWAYMOTORS\\ascrook', NOW());

-- now re-run insert statement above 

SELECT SA.ixSKU
     , SA.sValue 
     , DBC.ixRotorDiameter
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 261
  AND SA.sValue <> DBC.ixRotorDiameter
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'; -- 40 values already existed

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 261
     , DBC.ixRotorDiameter
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixRotorDiameter IS NOT NULL; -- 416 values inserted 


SELECT SA.ixSKU
     , SA.sValue 
     , DBC.ixCaliperMountingType
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 718
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'; -- 0 values already existed

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 718
     , DBC.ixCaliperMountingType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixCaliperMountingType IS NOT NULL; -- 456 values inserted 

SELECT SA.ixSKU
     , SA.sValue 
     , DBC.ixMountingSide
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 318
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'; -- 0 values already existed

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 318
     , DBC.ixMountingSide
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixMountingSide IS NOT NULL; -- 456 values inserted 

SELECT SA.ixSKU
     , SA.sValue 
     , DBC.ixMaterialType
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 31
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.ixMaterialType; -- 40 values already existed, 2 values did not match 
    
-- 33 vs. 220 = Steel vs. Iron for SKUs 8351208924 and 8351209333 -- per JGO change to 220, Iron
SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 31;  

UPDATE SKUAttribute 
SET sValue = 220 
WHERE ixSKU IN ('8351208924', '8351209333')
  AND ixTemplateAttributeId = 31;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 31
     , DBC.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixMaterialType IS NOT NULL; -- 416 values inserted 

SELECT SA.ixSKU
     , SA.sValue 
     , DBC.ixColor
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 36
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.ixColor; -- 40 values already existed
  
-- 558 vs. 532 = Gray vs. Clear for SKUs 8351201064P, 8351205288, 8351205289, 8351205343, 8351205344, 8351206426, 8351206427 -- per JGO keep at 558, Gray
SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 36;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 36
     , DBC.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixColor IS NOT NULL; -- 418 values inserted 

-- Deletes records where data was null but technically has a placeholder 
DELETE FROM SKUAttribute
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 36
  AND sValue = 36;

SELECT SA.ixSKU
     , SA.sValue 
     , DBC.ixFinish
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 44
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.ixFinish; -- 40 values already existed
  
UPDATE SKUAttribute 
SET sValue = 87 
WHERE ixSKU IN ('8351205288', '8351205289', '8351205343', '8351205344') 
  AND ixTemplateAttributeId = 44; 

UPDATE SKUAttribute 
SET sValue = 333 
WHERE ixSKU IN ('8351201360') 
  AND ixTemplateAttributeId = 44; 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 44
     , DBC.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixFinish IS NOT NULL; -- 416 values inserted 


SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dRotorThickness
     , DBC.ixUnitId1
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 377
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dRotorThickness; -- 40 values already existed
  
UPDATE SKUAttribute 
SET sValue = '1.10' 
WHERE ixSKU = '83512011135' 
  AND ixTemplateAttributeId = 377;
  
UPDATE SKUAttribute 
SET sValue = '1.00' 
WHERE ixSKU IN ( '8351208924', '8351209333') 
  AND ixTemplateAttributeId = 377;  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 377
     , DBC.dRotorThickness
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId1  
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dRotorThickness IS NOT NULL 
   OR DBC.dRotorThickness <> '0.00'; -- 416 values inserted 


SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dBoreSize
     , DBC.ixUnitId2
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 147
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dBoreSize; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 147
     , DBC.dBoreSize
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId2  
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dBoreSize IS NOT NULL 
   OR DBC.dBoreSize <> '0.00'; -- 456 values inserted 

SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dBore2Size
     , DBC.ixUnitId3
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 719
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dBore2Size; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 719
     , DBC.dBore2Size
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId3 
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dBore2Size IS NOT NULL 
   OR DBC.dBore2Size <> '0.00'; -- 456 values inserted 

DELETE  
FROM SKUAttribute 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 719
  AND sValue = '0.00'; -- essentially a non-value stored, 68 rows affected  

SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dBore3Size
     , DBC.ixUnitId4
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 720
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dBore3Size; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 720
     , DBC.dBore3Size
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId4 
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dBore3Size IS NOT NULL 
   OR DBC.dBore3Size <> 0.00; -- 456 values inserted 

DELETE  
FROM SKUAttribute 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 720
  AND sValue = '0.00'; -- essentially a non-value stored, 346 rows affected 


SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dMountHoleSize
     , DBC.ixUnitId5
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 722
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dMountHoleSize; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 722
     , DBC.dMountHoleSize
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId5
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dMountHoleSize IS NOT NULL 
   OR DBC.dMountHoleSize <> 0.00; -- 456 values inserted 
   
SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dMountedHeight
     , DBC.ixUnitId6
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 204
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dMountHoleSize; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 204
     , DBC.dMountedHeight
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId6
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dMountedHeight IS NOT NULL 
   OR DBC.dMountedHeight <> 0.00; -- 456 values inserted    
   
SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dCenterlineofHoles
     , DBC.ixUnitId7
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 30
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dCenterlineofHoles; -- 40 values already existed
  
UPDATE SKUAttribute
SET sValue = '3.28' 
WHERE ixTemplateAttributeId = 30 
  AND ixSKU IN ('8351202498');

UPDATE SKUAttribute
SET sValue = '5.46' 
WHERE ixTemplateAttributeId = 30 
  AND ixSKU IN ('8351208924', '8351209333');
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 30
     , DBC.dCenterlineofHoles
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId7
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dCenterlineofHoles IS NOT NULL 
   OR DBC.dCenterlineofHoles <> 0.00; -- 416 values inserted    
   
SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dWeight
     , DBC.ixUnitId8
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 35
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dWeight; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 35
     , DBC.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId8
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dWeight IS NOT NULL 
   OR DBC.dWeight <> 0.00; -- 456 values inserted       

SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dPadArea
     , DBC.ixUnitId9
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 723
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dPadArea; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 723
     , DBC.dPadArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId9
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dPadArea IS NOT NULL 
   OR DBC.dPadArea <> 0.00; -- 456 values inserted  
   
SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dTotalPistonArea
     , DBC.ixUnitId10
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 721
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dTotalPistonArea; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 721
     , DBC.dTotalPistonArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId10
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dTotalPistonArea IS NOT NULL 
   OR DBC.dTotalPistonArea <> 0.00; -- 456 values inserted     

SELECT SA.ixSKU
     , SA.sValue 
     , SA.ixUnitId
     , DBC.dPadVolume
     , DBC.ixUnitId11
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 724
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dPadVolume; -- 0 values already existed
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 724
     , DBC.dPadVolume
     , 20
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId11
FROM tmp.tmp_discbrakecalipers DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dPadVolume IS NOT NULL 
   OR DBC.dPadVolume <> 0.00; -- 456 values inserted 

SELECT SA.ixSKU
     , SA.sValue 
     , DBC.sThreadPitch
FROM SKUAttribute SA
LEFT JOIN tmp.tmp_discbrakecalipers DBC ON DBC.ixSOPSKU = SA.ixSKU 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakecalipers) 
  AND ixTemplateAttributeId = 142
  AND SA.ixUpdateUser NOT LIKE '%ascrook%'
  AND SA.sValue <> DBC.dPadVolume; -- 2 values already existed
  
UPDATE SKUAttribute
SET sValue = '1/8-27 NPT' 
WHERE ixTemplateAttributeId = 142 
  AND ixSKU IN ('8351202498', '8351203277'); 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 142
     , DBC.sThreadPitch
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.sThreadPitch IS NOT NULL;  -- 454 values inserted 


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_discbrakecalipers
WHERE ixSOPSKU = '8351208924'
ORDER BY ixSOPSKU;

SELECT TemplateAttribute.sTitle
     , SA.* 
FROM SKUAttribute SA
LEFT JOIN TemplateAttribute ON TemplateAttribute.ixTemplateAttributeId = SA.ixTemplateAttributeId
WHERE ixSKU = '8351209333'; 

UPDATE SKUAttribute
SET sValue = '120-9333'
WHERE ixTemplateAttributeId = 325 
  AND ixSKU = '8351209333';
  
UPDATE SKUAttribute
SET sValue = '2.00'
WHERE ixTemplateAttributeId = 283
  AND ixSKU = '8351209333';  

DELETE FROM SKUAttribute
WHERE ixTemplateAttributeId = 34 
  AND ixSKU = '8351209333';
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8351208924';


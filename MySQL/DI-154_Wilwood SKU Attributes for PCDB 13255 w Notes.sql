 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 13255; -- Disc Brake Upgrade Kits
 
-- For each column header (attribute) it needs to be determined what "type" they are. 
-- This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 19;


-- Type 2 & 4 will be special types that will take additional steps; 
-- all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Spindle Type' -- Dropdown box, 4 -- Template ID 654
   OR sTitle = 'Rear End Axle' -- Dropdown box, 4 -- Template ID 789
   OR sTitle = 'Mount Type' -- Dropdown box, 4 -- Template ID 766
   OR sTitle = 'Rotor Diameter' -- Dropdown box, 4 -- Template ID 261
   OR sTitle = 'Caliper Finish' -- Dropdown box, 4 -- Template ID 379
   OR sTitle = 'Caliper Pistons' -- Dropdown box, 4 -- Template ID 309
   OR sTitle = 'Piston Type' -- Dropdown box, 4 -- Template ID 792
   OR sTitle = 'Compound' -- Dropdown box, 4 -- Template ID 749
   OR sTitle = 'Rotor Type' -- Dropdown box, 4 -- Template ID 793
   OR sTitle = 'Rotor Style'  -- Dropdown box, 4 -- Template ID 742  
   OR sTitle = 'Rotor Surface Finish' -- Dropdown box, 4 -- Template ID 794
   OR sTitle = 'Rotor Material Type' -- Dropdown box, 4 -- Template ID 795
   OR sTitle = 'Vane Count' -- Dropdown box, 4 -- Template ID 741
   OR sTitle = 'Rotor Construction' -- Dropdown box, 4 -- Template ID 384
   OR sTitle = 'Hat Type' -- Dropdown box, 4 -- Template ID 796
   OR sTitle = 'Hat Material Type' -- Dropdown box, 4 -- Template ID 797
   OR sTitle = 'Hat Finish' -- Dropdown box, 4 -- Template ID 798
   OR sTitle = 'Caliper Type' -- Text, 1 -- Template ID 791
   OR sTitle = 'Hat Bolt Circle 1' -- Text, 1 -- Template ID 757 
   OR sTitle = 'Hat Bolt Circle 2' -- Text, 1 -- Template ID 758 
   OR sTitle = 'Hat Bolt Circle 3' -- Text, 1 -- Template ID 759      
   OR sTitle = 'Bedded' -- Yes/No, 2 -- Template ID 743
   OR sTitle = 'Balanced'  -- Yes/No, 2 -- Template ID 744   
   OR sTitle = 'Offset' -- Measurement/Size/Length, 5 -- Template ID 233 -- Unit Id = 6
   OR sTitle = 'OE Hub Offset' -- Measurement/Size/Length, 5 -- Template ID 790 -- Unit Id =  6
   OR sTitle = 'Wheel Diameter' -- Measurement/Size/Length, 5 -- Template ID 644 -- Unit Id = 6
   OR sTitle = 'Rotor Width' -- Measurement/Size/Length, 5 -- Template ID 739 -- Unit Id = 6
   OR sTitle = 'Hat Offset Dimension' -- Measurement/Size/Length, 5 -- Template ID 799 -- Unit Id = 6
   OR sTitle = 'Stud Diameter' -- Measurement/Size/Length, 5 -- Template ID 133 -- Unit Id = 6
   OR sTitle = 'Stud Diameter 2' -- Measurement/Size/Length, 5 -- Template ID 760  -- Unit Id = 6
   OR sTitle = 'Stud Diameter 3' -- Measurement/Size/Length, 5 -- Template ID 761  -- Unit Id = 6  
   OR sTitle = 'Total Piston Area' -- Area, 19 -- Template ID 721 -- Unit Id = 39  
   OR sTitle = 'Pad Area' -- Area, 19 -- Template ID 723 -- Unit Id = 39
   OR sTitle = 'Pad Volume' -- Volume, 20 -- Template ID 724 -- Unit Id = 49
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_upgradekits;


SELECT DISTINCT dTotalPistonArea FROM tmp.tmp_upgradekits;
UPDATE tmp.tmp_upgradekits SET dTotalPistonArea = '4.80' WHERE dTotalPistonArea = '4.8';
UPDATE tmp.tmp_upgradekits SET dTotalPistonArea = '5.40' WHERE dTotalPistonArea = '5.4';
UPDATE tmp.tmp_upgradekits SET dTotalPistonArea = '2.40' WHERE dTotalPistonArea = '2.4';
UPDATE tmp.tmp_upgradekits SET dTotalPistonArea = '3.00' WHERE dTotalPistonArea = '3';
UPDATE tmp.tmp_upgradekits SET dTotalPistonArea = '3.90' WHERE dTotalPistonArea = '3.9';
UPDATE tmp.tmp_upgradekits SET dTotalPistonArea = '6.90' WHERE dTotalPistonArea = '6.9';


SELECT DISTINCT dPadArea FROM tmp.tmp_upgradekits;
UPDATE tmp.tmp_upgradekits SET dPadArea = '7.30' WHERE dPadArea = '7.3';
UPDATE tmp.tmp_upgradekits SET dPadArea = '8.20' WHERE dPadArea = '8.2';
UPDATE tmp.tmp_upgradekits SET dPadArea = '13.00' WHERE dPadArea = '13';
UPDATE tmp.tmp_upgradekits SET dPadArea = '3.00' WHERE dPadArea = '3';
UPDATE tmp.tmp_upgradekits SET dPadArea = '11.00' WHERE dPadArea = '11';
UPDATE tmp.tmp_upgradekits SET dPadArea = '4.00' WHERE dPadArea = '4';
UPDATE tmp.tmp_upgradekits SET dPadArea = '5.10' WHERE dPadArea = '5.1';
UPDATE tmp.tmp_upgradekits SET dPadArea = '8.70' WHERE dPadArea = '8.7';


SELECT DISTINCT dRotorWidth FROM tmp.tmp_upgradekits;
UPDATE tmp.tmp_upgradekits SET dRotorWidth = '1.10' WHERE dRotorWidth = '1.1';
UPDATE tmp.tmp_upgradekits SET dRotorWidth = '1.00' WHERE dRotorWidth = '1';

SELECT DISTINCT dHatOffsetDimension FROM tmp.tmp_upgradekits;
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '1.30' WHERE dHatOffsetDimension = '1.3';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '1.50' WHERE dHatOffsetDimension = '1.5';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '2.00' WHERE dHatOffsetDimension = '2';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '3.00' WHERE dHatOffsetDimension = '3';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '1.60' WHERE dHatOffsetDimension = '1.6';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '1.20' WHERE dHatOffsetDimension = '1.2';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '0.60' WHERE dHatOffsetDimension = '0.6';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '0.70' WHERE dHatOffsetDimension = '0.7';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '1.00' WHERE dHatOffsetDimension = '1';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '0.50' WHERE dHatOffsetDimension = '0.5';
UPDATE tmp.tmp_upgradekits SET dHatOffsetDimension = '1.10' WHERE dHatOffsetDimension = '1.1';

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_upgradekits
 ADD ixSpindleType INT AFTER sSpindleType
,ADD ixRearEndAxle INT AFTER sRearEndAxle 
,ADD ixMountType INT AFTER sMountType
,ADD ixRotorDiameter INT AFTER sRotorDiameter
,ADD ixCaliperFinish INT AFTER sCaliperFinish
,ADD ixCaliperPistons INT AFTER sCaliperPistons
,ADD ixPistonType INT AFTER sPistonType
,ADD ixCompound INT AFTER sCompound
,ADD ixRotorType INT AFTER sRotorType
,ADD ixRotorSurfaceFinish INT AFTER sRotorSurfaceFinish
,ADD ixRotorMaterialType INT AFTER sRotorMaterialType
,ADD ixVaneCount INT AFTER sVaneCount
,ADD ixRotorConstruction INT AFTER sRotorConstruction
,ADD ixHatType INT AFTER sHatType
,ADD ixHatMaterialType INT AFTER sHatMaterialType
,ADD ixHatFinish INT AFTER sHatFinish
,ADD ixUnitId1 INT AFTER dOffset
,ADD ixUnitId2 INT AFTER dOEHubOffset
,ADD ixUnitId3 INT AFTER dWheelDiameter
,ADD ixUnitId4 INT AFTER dRotorWidth
,ADD ixUnitId5 INT AFTER dHatOffsetDimension
,ADD ixUnitId6 INT AFTER dStudDiameter
,ADD ixUnitId7 INT AFTER dStudDiameter2
,ADD ixUnitId8 INT AFTER dStudDiameter3
,ADD ixUnitId9 INT AFTER dTotalPistonArea
,ADD ixUnitId10 INT AFTER dPadArea
,ADD ixUnitId11 INT AFTER dPadVolume;


ALTER TABLE tmp.tmp_upgradekits
 ADD ixRotorStyle INT AFTER sRotorStyle;
 
-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_upgradekits CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixSpindleType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sSpindleType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 654; 

SELECT *
FROM tmp.tmp_upgradekits
WHERE ixSpindleType IS NULL; -- 991 rows affected after removing ';' from the end of the listings 

UPDATE tmp.tmp_upgradekits SET sSpindleType = 'Factory Disc Spindle' WHERE sSpindleType = 'Factory Disc Spindle;'; -- 686 rows affected 
UPDATE tmp.tmp_upgradekits SET sSpindleType = 'Factory Drum Spindle' WHERE sSpindleType = 'Factory Drum Spindle ;'; -- 143 rows affected 
UPDATE tmp.tmp_upgradekits SET sSpindleType = 'Drop Spindle' WHERE sSpindleType = 'Drop Spindle;'; -- 40 rows affected 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixRearEndAxle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sRearEndAxle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 789; -- 84 rows affected 

SELECT *
FROM tmp.tmp_upgradekits
WHERE ixRearEndAxle IS NULL
  AND ixRearEndAxle <> ' '; -- all records updated that had values 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixMountType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sMountType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 766; -- 1082 rows affected 

SELECT *
FROM tmp.tmp_upgradekits
WHERE ixMountType IS NULL; -- all records with values updated 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixRotorDiameter  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sRotorDiameter  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 261; -- 645 rows affected; 1071 rows affected after the below changes 

SELECT DISTINCT sRotorDiameter
FROM tmp.tmp_upgradekits
WHERE ixRotorDiameter IS NULL; -- all records with values updated 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 261 ORDER BY sAttributeDropdownItemText; -- 10/11/14/11.3/16/10.5/12/11.28/10.2
-- to update values to: 10.00 11.00 14.00 16.00 10.50 12.00 10.20 
-- to add to db: 11.30 11.28 

UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '10.00' WHERE sRotorDiameter = '10'; 
UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '11.00' WHERE sRotorDiameter = '11'; 
UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '14.00' WHERE sRotorDiameter = '14'; 
UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '16.00' WHERE sRotorDiameter = '16'; 
UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '10.50' WHERE sRotorDiameter = '10.5'; 
UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '12.00' WHERE sRotorDiameter = '12'; 
UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '10.20' WHERE sRotorDiameter = '10.2'; 
UPDATE tmp.tmp_upgradekits SET sRotorDiameter = '11.30' WHERE sRotorDiameter = '11.3';


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixCaliperFinish  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sCaliperFinish  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 379; -- 1082 rows affected

SELECT DISTINCT sCaliperFinish
FROM tmp.tmp_upgradekits
WHERE ixCaliperFinish IS NULL; -- all records with values updated 

UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixCaliperPistons  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sCaliperPistons  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 309; -- 1082 rows affected after the change below was made 

SELECT DISTINCT sCaliperPistons
FROM tmp.tmp_upgradekits
WHERE ixCaliperPistons IS NULL; -- all records with values updated 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 309; 

UPDATE tmp.tmp_upgradekits SET sCaliperPistons = 'Single' WHERE sCaliperPistons = '1'; 
UPDATE tmp.tmp_upgradekits SET sCaliperPistons = 'Two' WHERE sCaliperPistons = '2'; 
UPDATE tmp.tmp_upgradekits SET sCaliperPistons = 'Four' WHERE sCaliperPistons = '4'; 
UPDATE tmp.tmp_upgradekits SET sCaliperPistons = 'Six' WHERE sCaliperPistons = '6'; 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixPistonType  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sPistonType  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 792; -- 1080 rows affected after the change below was made 

SELECT DISTINCT sPistonType
FROM tmp.tmp_upgradekits
WHERE ixPistonType IS NULL; -- all records with values updated 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixCompound  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sCompound  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 749; -- 1076 rows affected after the change below was made 

SELECT DISTINCT sCompound
FROM tmp.tmp_upgradekits
WHERE ixCompound IS NULL; -- all records with values updated 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 749; -- CM - Composi / Polymatrix Q / Polymatrix B
-- update to : PolyMatrix B / PolyMatrix Q / Composite Metallic
UPDATE tmp.tmp_upgradekits SET sCompound = 'Composite Metallic' WHERE sCompound = 'CM - Composi'; 
UPDATE tmp.tmp_upgradekits SET sCompound = 'PolyMatrix Q' WHERE sCompound = 'Polymatrix Q'; 
UPDATE tmp.tmp_upgradekits SET sCompound = 'PolyMatrix B' WHERE sCompound = 'Polymatrix B'; 
UPDATE tmp.tmp_upgradekits SET ixCompound = 1568 WHERE sCompound = 'Composite Me'; 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixRotorType  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sRotorType  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 793; -- 1074 rows affected after the change below was made 

SELECT DISTINCT sRotorType
FROM tmp.tmp_upgradekits
WHERE ixRotorType IS NULL; -- all records with values updated 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 793; -- Drilled Super Alloy Rotor


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixRotorSurfaceFinish  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sRotorSurfaceFinish  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 794; -- 1071 rows affected after the change below was made 

SELECT DISTINCT sRotorSurfaceFinish
FROM tmp.tmp_upgradekits
WHERE ixRotorSurfaceFinish IS NULL; -- all records with values updated 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixRotorMaterialType  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sRotorMaterialType  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 795; -- 1071 rows affected after the change below was made 

SELECT DISTINCT sRotorMaterialType
FROM tmp.tmp_upgradekits
WHERE ixRotorMaterialType IS NULL; -- all records with values updated 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixVaneCount  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sVaneCount  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 741; -- 1071 rows affected after the change below was made 

SELECT DISTINCT sVaneCount
FROM tmp.tmp_upgradekits
WHERE ixVaneCount IS NULL; -- all records with values updated 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixRotorStyle  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sRotorStyle  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 742; -- 1071 rows affected after the change below was made 

SELECT DISTINCT sRotorStyle 
FROM tmp.tmp_upgradekits
WHERE ixRotorStyle  IS NULL; -- all records with values updated 

UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixRotorConstruction  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sRotorConstruction  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 384; -- 1071 rows affected after the change below was made 

SELECT DISTINCT sRotorConstruction
FROM tmp.tmp_upgradekits
WHERE ixRotorConstruction IS NULL; -- all records with values updated 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixHatType  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sHatType  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 796; -- 610 rows affected; 652 rows affected after the change below was made 

SELECT DISTINCT sHatType
FROM tmp.tmp_upgradekits
WHERE ixHatType IS NULL; -- all records with values updated 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 796; 
-- Parking Brake Hat - Standard / Big Brake Dynamic Hat - Short Offset / Drag Hat - Standard / Drag Hat - Shallow Offset
-- update to: Parking Brake Hat- Standard / Big Brake Dynamic Hat- Short Offset / Drag Hat- Standard / Drag Hat- Shallow Offset
UPDATE tmp.tmp_upgradekits SET sHatType = 'Parking Brake Hat- Standard' WHERE sHatType = 'Parking Brake Hat - Standard'; 
UPDATE tmp.tmp_upgradekits SET sHatType = 'Big Brake Dynamic Hat- Short Offset' WHERE sHatType = 'Big Brake Dynamic Hat - Short Offset'; 
UPDATE tmp.tmp_upgradekits SET sHatType = 'Drag Hat- Standard' WHERE sHatType = 'Drag Hat - Standard'; 
UPDATE tmp.tmp_upgradekits SET sHatType = 'Drag Hat- Shallow Offset' WHERE sHatType = 'Drag Hat - Shallow Offset'; 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixHatMaterialType  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sHatMaterialType  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 797; -- 652 rows affected

SELECT DISTINCT sHatMaterialType
FROM tmp.tmp_upgradekits
WHERE ixHatMaterialType IS NULL; -- all records with values updated 


UPDATE tmp.tmp_upgradekits, AttributeDropdownItem
SET tmp.tmp_upgradekits.ixHatFinish  = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_upgradekits.sHatFinish  = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 798; -- 652 rows affected

SELECT DISTINCT sHatFinish
FROM tmp.tmp_upgradekits
WHERE ixHatFinish IS NULL; -- all records with values updated 


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_upgradekits
SET ixUnitId1 = 6
WHERE dOffset IS NOT NULL; 

UPDATE tmp.tmp_upgradekits
SET ixUnitId2 = 6
WHERE dOEHubOffset IS NOT NULL; 

UPDATE tmp.tmp_upgradekits
SET ixUnitId3 = 6
WHERE dWheelDiameter IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId4 = 6
WHERE dRotorWidth IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId5 = 6
WHERE dHatOffsetDimension IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId6 = 6
WHERE dStudDiameter IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId7 = 6
WHERE dStudDiameter2 IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId8 = 6
WHERE dStudDiameter3 IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId9 = 39
WHERE dTotalPistonArea IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId10 = 39
WHERE dPadArea IS NOT NULL;

UPDATE tmp.tmp_upgradekits
SET ixUnitId11 = 49
WHERE dPadVolume IS NOT NULL;

-- Update the Yes/No values to Boolean readings (unless already done in the Excel load such as in this case) 
Update tmp.tmp_upgradekits
SET sBalanceBar = '1' 
WHERE sBalanceBar = 'Yes';
Update tmp.tmp_upgradekits
SET sBalanceBar = '0' 
WHERE sBalanceBar = 'No';

SELECT * FROM tmp.tmp_upgradekits;


-- Now the records need to be inserted into the SKU Attribute table 
  
-- The 1000 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT UK.ixSOPSKU
     , 13255
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_upgradekits UK;


SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_upgradekits); 

UPDATE tblSKUPartAssociation
SET ixPartTerminologyID = 13255
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_upgradekits)
  AND ixSKUPartAssociationID = 171705;

UPDATE tblSKUPartAssociation
SET dtUpdate = NOW()
WHERE ixSKUPartAssociationID = 171705;

UPDATE tblSKUPartAssociation
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixSKUPartAssociationID = 171705;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 791
     , UK.sCaliperType
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.sCaliperType IS NOT NULL
   OR UK.sCaliperType <> ' '; --  1012 rows affected
   
SELECT SA.sValue, UK.sCaliperType
FROM SKUAttribute SA 
LEFT JOIN tmp.tmp_upgradekits UK ON UK.ixSOPSKU = SA.ixSKU 
WHERE SA.ixTemplateAttributeId = 791
  AND ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_upgradekits)
  AND SA.sValue <> UK.sCaliperType; 
  
DELETE
FROM SKUAttribute 
WHERE SKUAttribute.ixTemplateAttributeId = 791 
  AND sValue = ' ';
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 757
     , UK.sHatBoltCircle1
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.sHatBoltCircle1 IS NOT NULL
   OR UK.sHatBoltCircle1 <> ' '; --  1012 rows affected
   
DELETE 
-- SELECT * 
FROM SKUAttribute
WHERE SKUAttribute.ixTemplateAttributeId = 757
   AND sValue = ' ';
   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 758
     , UK.sHatBoltCircle2
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.sHatBoltCircle2 IS NOT NULL
   OR UK.sHatBoltCircle2 <> ' '; --  1012 rows affected
   
DELETE 
-- SELECT * 
FROM SKUAttribute
WHERE SKUAttribute.ixTemplateAttributeId = 758
   AND sValue = ' ';
   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 759
     , UK.sHatBoltCircle3
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.sHatBoltCircle3 IS NOT NULL
   OR UK.sHatBoltCircle3 <> ' '; --  1012 rows affected
   
DELETE 
-- SELECT * 
FROM SKUAttribute
WHERE SKUAttribute.ixTemplateAttributeId = 759
   AND sValue = ' ';   
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 743
     , UK.iBedded
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.iBedded IS NOT NULL; --  1012 rows affected

DELETE
-- SELECT * 
FROM SKUAttribute 
WHERE ixSKU IN ('83514010790', '83514010790BK', '83514010790R', '83514010789', '83514010789BK', '83514010789R', '83514011857', '83514011857BK', '83514011857R',
                '83514012629', '83514012629N', '83514012629R', '83514013029', '83514013029R', '8351408695D', '8351408695DR')
 AND ixTemplateAttributeId = 743                 
; -- These rows were blank in the data and should not have shown as '0' 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 744
     , UK.iBalanced
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.iBalanced IS NOT NULL; --  1012 rows affected


DELETE
-- SELECT * 
FROM SKUAttribute 
WHERE ixSKU IN ('83514010790', '83514010790BK', '83514010790R', '83514010789', '83514010789BK', '83514010789R', '83514011857', '83514011857BK', '83514011857R',
                '83514012629', '83514012629N', '83514012629R', '83514013029', '83514013029R', '8351408695D', '8351408695DR', '83514013476', '83514013476R', '83514013477R')
 AND ixTemplateAttributeId = 744              
; -- These rows were blank in the data and should not have shown as '0' 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 654
     , UK.ixSpindleType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixSpindleType IS NOT NULL; -- 916 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 789
     , UK.ixRearEndAxle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixRearEndAxle IS NOT NULL; -- 84 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 766
     , UK.ixMountType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixMountType IS NOT NULL; -- 1007 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 261
     , UK.ixRotorDiameter
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixRotorDiameter IS NOT NULL; -- 985 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 379
     , UK.ixCaliperFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixCaliperFinish IS NOT NULL; -- 1000 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 309
     , UK.ixCaliperPistons
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixCaliperPistons IS NOT NULL; -- 997 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 792
     , UK.ixPistonType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixPistonType IS NOT NULL; -- 1005 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 749
     , UK.ixCompound
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixCompound IS NOT NULL; -- 1007 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 793
     , UK.ixRotorType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixRotorType IS NOT NULL; -- 999 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 742
     , UK.ixRotorStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixRotorStyle IS NOT NULL; -- 996 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 794
     , UK.ixRotorSurfaceFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixRotorSurfaceFinish IS NOT NULL; -- 996 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 795
     , UK.ixRotorMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixRotorMaterialType IS NOT NULL; -- 996 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 741
     , UK.ixVaneCount
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixVaneCount IS NOT NULL; -- 996 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 384
     , UK.ixRotorConstruction
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixRotorConstruction IS NOT NULL; -- 985 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 796
     , UK.ixHatType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixHatType IS NOT NULL; -- 581 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 797
     , UK.ixHatMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixHatMaterialType IS NOT NULL; -- 581 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 798
     , UK.ixHatFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.ixHatFinish IS NOT NULL; -- 581 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 233
     , UK.dOffset
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId1
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dOffset IS NOT NULL
   AND UK.dOffset <> ' '
   AND UK.dOffset <> 0.00; --  43 rows affected
   
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 790
     , UK.dOEHubOffset
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId2
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dOEHubOffset IS NOT NULL
   AND UK.dOEHubOffset <> ' '
   AND UK.dOEHubOffset <> 0.00; -- 385 rows affected   


   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 644
     , UK.dWheelDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId3
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dWheelDiameter IS NOT NULL
   AND UK.dWheelDiameter <> ' '
   AND UK.dWheelDiameter <> 0.00; -- 995 rows affected   
   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 739
     , UK.dRotorWidth
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId4
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dRotorWidth IS NOT NULL
   AND UK.dRotorWidth <> ' '
   AND UK.dRotorWidth <> 0.00; -- 996 rows affected   
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 799
     , UK.dHatOffsetDimension
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId5
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dHatOffsetDimension IS NOT NULL
   AND UK.dHatOffsetDimension <> ' '
   AND UK.dHatOffsetDimension <> 0.00; -- 581 rows affected   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 133
     , UK.dStudDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId6
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dStudDiameter IS NOT NULL
   AND UK.dStudDiameter <> ' '
   AND UK.dStudDiameter <> 0.00; -- 935 rows affected   

  
SELECT * FROM SKUAttribute
WHERE SKUAttribute.ixTemplateAttributeId = 133 
  AND SKUAttribute.ixAttributeTypeId = 5 
  AND SKUAttribute.ixUnitId = 6 
  AND SKUAttribute.ixCreateUser = 'SPEEDWAYMOTORS\\ascrook'
  AND ixTemplateId = 7017; 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 760
     , UK.dStudDiameter2
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId7
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dStudDiameter2 IS NOT NULL
   AND UK.dStudDiameter2 <> ' '
   AND UK.dStudDiameter2 <> 0.00; -- 605 rows affected     
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 761
     , UK.dStudDiameter3
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId8
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dStudDiameter3 IS NOT NULL
   AND UK.dStudDiameter3 <> ' '
   AND UK.dStudDiameter3 <> 0.00; -- 21 rows affected   
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 721
     , UK.dTotalPistonArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId9
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dTotalPistonArea IS NOT NULL
   AND UK.dTotalPistonArea <> ' '
   AND UK.dTotalPistonArea <> 0.00; -- 1007 rows affected   



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 723
     , UK.dPadArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId10
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dPadArea IS NOT NULL
   AND UK.dPadArea <> ' '
   AND UK.dPadArea <> 0.00; -- 998 rows affected   
   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT UK.ixSOPSKU
     , 724
     , UK.dPadVolume
     , 20
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , UK.ixUnitId11
FROM tmp.tmp_upgradekits UK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = UK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE UK.dPadVolume IS NOT NULL
   AND UK.dPadVolume <> ' '
   AND UK.dPadVolume <> 0.00; -- 1007 rows affected   


   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_upgradekits UK;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8351407149DP';


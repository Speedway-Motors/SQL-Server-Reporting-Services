 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 1896; -- Disc Brake Rotors
 
-- For each column header (attribute) it needs to be determined what "type" they are. 
-- This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 5;

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 20;


SELECT *
FROM AttributeType; 
-- Type 2 & 4 will be special types that will take additional steps; 
-- all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Spindle Type' -- Dropdown box, 4 -- Template ID 654
   OR sTitle = 'Rear End Axle' -- Dropdown box, 4 -- Template ID 789          
   OR sTitle = 'Rotor Diameter' -- Dropdown box, 4 -- Template ID 261 (inches)
   OR sTitle = 'Wheel Diameter' -- Measurement/Size/Length, 5 -- Template ID 644 -- UnitId = 6 (inches)    
   OR sTitle = 'Compound' -- Dropdown box, 4 -- Template ID 749  
   OR sTitle = 'Rotor Type' -- Dropdown box, 4 -- Template ID 793  
   OR sTitle = 'Rotor Style' -- Dropdown box, 4 -- Template ID 742  
   OR sTitle = 'Rotor Surface Finish' -- Dropdown box, 4-- Template ID 794 
   OR sTitle = 'Rotor Material Type' -- Dropdown box, 4 -- Template ID 795 
   OR sTitle = 'Rotor Width' -- Measurement/Size/Length, 5 -- Template ID 739 -- UnitId = 6 (inches)  
   OR sTitle = 'Vane Count' -- Dropdown box, 4 -- Template ID 741  
   OR sTitle = 'Rotor Construction' -- Dropdown box, 4 -- Template ID 384  
   OR sTitle = 'Bedded' -- Yes/No, 2 -- Template ID 743  
   OR sTitle = 'Balanced' -- Yes/No, 2 -- Template ID 744
   OR sTitle = 'Hat Type' -- Dropdown box, 4 -- Template ID 796  
   OR sTitle = 'Hat Material Type' -- Dropdown box, 4 -- Template ID 797
   OR sTitle = 'Hat Finish' -- Dropdown box, 4 -- Template ID 798   
   OR sTitle = 'Hat Offset Dimension' -- Measurement/Size/Length, 5 -- Template ID 799 -- UnitId = 6 (inches)     
   OR sTitle = 'Hat Bolt Circle 1' -- Text, 1 -- Template ID 757    
   OR sTitle = 'Stud Diameter' -- Measurement/Size/Length, 5 -- Template ID 133 -- UnitId = 6 (inches)    
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_dbrotors;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_dbrotors
 ADD ixSpindleType INT AFTER sSpindleType
,ADD ixRearEndAxle INT AFTER sRearEndAxle
-- ,ADD ixRotorDiameter INT AFTER sRotorDiameter
,ADD ixCompound INT AFTER sCompound
,ADD ixRotorType INT AFTER sRotorType
,ADD ixRotorStyle INT AFTER sRotorStyle
,ADD ixRotorSurfaceFinish INT AFTER sRotorSurfaceFinish
,ADD ixRotorMaterialType INT AFTER sRotorMaterialType
,ADD ixVaneCount INT AFTER sVaneCount
,ADD ixRotorConstruction INT AFTER sRotorConstruction
,ADD ixHatType INT AFTER sHatType
,ADD ixHatMaterialType INT AFTER sHatMaterialType
,ADD ixHatFinish INT AFTER sHatFinish
,ADD ixUnitId1 INT AFTER dWheelDiameter
,ADD ixUnitId2 INT AFTER dRotorWidth
,ADD ixUnitId3 INT AFTER dHatOffsetDimension
,ADD ixUnitId4 INT AFTER dStudDiameter;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_dbrotors CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixSpindleType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sSpindleType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 654; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixSpindleType IS NULL; -- all records with values updated 

UPDATE tmp.tmp_dbrotors
SET sSpindleType = 'Factory Disc Spindle' 
WHERE sSpindleType = 'Factory Disc Spindle;';


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixCompound = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sCompound = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 749; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixCompound IS NULL; -- all records updated after the change below was applied 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 749;

UPDATE  tmp.tmp_dbrotors 
SET sCompound = 'ProMatrix' 
WHERE sCompound = 'PM - ProMatrix';


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixRearEndAxle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sRearEndAxle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 789; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixRearEndAxle IS NULL; -- all records with values updated 


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixRotorType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sRotorType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 793; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixRotorType IS NULL; -- all records with values updated 

UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixRotorStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sRotorStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 742; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixRotorStyle IS NULL; -- all records updated 

UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixRotorSurfaceFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sRotorSurfaceFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 794; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixRotorSurfaceFinish IS NULL; -- all records updated 

UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixRotorMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sRotorMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 795; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixRotorMaterialType IS NULL; -- all records updated 


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixVaneCount = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sVaneCount = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 741; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixVaneCount IS NULL; -- all records updated 


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixRotorConstruction = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sRotorConstruction = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 384; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixRotorConstruction IS NULL; -- all records updated 


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixRotorDiameter = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sRototDiameter = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 261; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixRotorDiameter IS NULL; -- all records updated except for 14.00, 13.00, 12.60

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 261 ORDER BY sAttributeDropdownItemText;

UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixHatType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sHatType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 796; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixHatType IS NULL; -- all records updated that had values 


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixHatMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sHatMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 797; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixHatMaterialType IS NULL; -- all records updated that had values 


UPDATE tmp.tmp_dbrotors, AttributeDropdownItem
SET tmp.tmp_dbrotors.ixHatFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotors.sHatFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 798; 

SELECT *
FROM tmp.tmp_dbrotors
WHERE ixHatFinish IS NULL; -- no records updated; need Black E-Coat added to PMS 


SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 798 ORDER BY sAttributeDropdownItemText;



-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_dbrotors
SET ixUnitId1 = 6
WHERE dWheelDiameter IS NOT NULL; 

UPDATE tmp.tmp_dbrotors
SET ixUnitId2 = 6
WHERE dRotorWidth IS NOT NULL; 

UPDATE tmp.tmp_dbrotors
SET ixUnitId3 = 6 
WHERE dHatOffsetDimension IS NOT NULL;

UPDATE tmp.tmp_dbrotors
SET ixUnitId4 = 6 
WHERE dStudDiameter IS NOT NULL;


-- Update the Yes/No values to Boolean readings 
Update tmp.tmp_dbrotors
SET sBedded = '1' 
WHERE sBedded = 'Yes';
Update tmp.tmp_dbrotors
SET sBedded = '0' 
WHERE sBedded = 'No';

Update tmp.tmp_dbrotors
SET sBalanced = '1' 
WHERE sBalanced = 'Yes';
Update tmp.tmp_dbrotors
SET sBalanced = '0' 
WHERE sBalanced = 'No';

-- Now the records need to be inserted into the SKU Attribute table 

  
-- The parts do not exist in tblSKUPartAssociation so that must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT R.ixSOPSKU
     , 1896
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_dbrotors R;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 757
     , R.dHatBoltCircle1
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dHatBoltCircle1 IS NOT NULL; --  16 rows affected


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
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sBedded IS NOT NULL; --  16 rows affected



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
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sBalanced IS NOT NULL; --  16 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 654
     , R.ixSpindleType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixSpindleType IS NOT NULL; -- 15 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 789
     , R.ixRearEndAxle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRearEndAxle IS NOT NULL; -- 1 rows affected



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
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorDiameter IS NOT NULL; -- 16 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 749
     , R.ixCompound
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixCompound IS NOT NULL; -- 10 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 793
     , R.ixRotorType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorType IS NOT NULL; -- 14 rows affected


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
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorStyle IS NOT NULL; -- 16 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 794
     , R.ixRotorSurfaceFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorSurfaceFinish IS NOT NULL; -- 16 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 795
     , R.ixRotorMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorMaterialType IS NOT NULL; -- 16 rows affected



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
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixVaneCount IS NOT NULL; -- 15 rows affected



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
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorConstruction IS NOT NULL; -- 16 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 796
     , R.ixHatType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixHatType IS NOT NULL; -- 13 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 797
     , R.ixHatMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixHatMaterialType IS NOT NULL; -- 13 rows affected




INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 798
     , R.ixHatFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixHatFinish IS NOT NULL; -- 13 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 644
     , R.dWheelDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId1
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dWheelDiameter IS NOT NULL; --  16 rows affected

   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 739
     , R.dRotorWidth
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId2
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dRotorWidth IS NOT NULL; --  16 rows affected 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 799
     , R.dHatOffsetDimension 
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId3
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dHatOffsetDimension IS NOT NULL; --  16 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 133
     , R.dStudDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId4
FROM tmp.tmp_dbrotors R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dStudDiameter IS NOT NULL; --  16 rows affected
   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_dbrotors R;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8351408009';


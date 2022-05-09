 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 13260; -- Disc Brake Rotor Hat Sets
 
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
WHERE sTitle = 'Hat Mount Hole Type' -- Dropdown box, 4 -- Template ID 755
   OR sTitle = 'Material Type' -- Dropdown box, 4 -- Template ID 31
   OR sTitle = 'Hat Mount Style' -- Dropdown box, 4 -- Template ID 756
   OR sTitle = 'Finish' -- Dropdown box, 4 -- Template ID 44
   OR sTitle = 'Rotor Hat Bolt Pattern' -- Dropdown box, 4 -- Template ID 413
   OR sTitle = 'Mount Hole Size' -- Measurement/Size/Length, 5 -- Template ID 722  -- UnitId = 6 (inches)  
   OR sTitle = 'Inside Diameter' -- Measurement/Size/Length, 5 -- Template ID 91  -- UnitId = 6 (inches) 
   OR sTitle = 'Outside Diameter' -- Measurement/Size/Length, 5 -- Template ID 92  -- UnitId = 6 (inches) 
   OR sTitle = 'Offset' -- Measurement/Size/Length, 5 -- Template ID 233  -- UnitId = 6 (inches)  
   OR sTitle = 'Shoe Inside Dimension' -- Measurement/Size/Length, 5 -- Template ID 746  -- UnitId = 6 (inches)  
   OR sTitle = 'Face Thickness' -- Measurement/Size/Length, 5 -- Template ID 748  -- UnitId = 6 (inches)    
   OR sTitle = 'Stud Diameter' -- Measurement/Size/Length, 5 -- Template ID 133 -- Unit Id = 6
   OR sTitle = 'Stud Diameter 2' -- Measurement/Size/Length, 5 -- Template ID 760  -- Unit Id = 6
   OR sTitle = 'Stud Diameter 3' -- Measurement/Size/Length, 5 -- Template ID 761  -- Unit Id = 6    
   OR sTitle = 'Hat Bolt Circle 1' -- Text, 1 -- Template ID 757 
   OR sTitle = 'Hat Bolt Circle 2' -- Text, 1 -- Template ID 758 
   OR sTitle = 'Hat Bolt Circle 3' -- Text, 1 -- Template ID 759   
   OR sTitle = 'Weight' -- Weight, 6 -- Template ID 35 -- Unit Id = 14   
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_dbrotorhatsets;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_dbrotorhatsets
 ADD ixHatMountHoleType INT AFTER sHatMountHoleType
,ADD ixMaterialType INT AFTER sMaterialType
,ADD ixHatMountStyle INT AFTER sHatMountStyle
,ADD ixFinish INT AFTER sFinish
,ADD ixRotorHatBoltPattern INT AFTER sRotorHatBoltPattern
,ADD ixUnitId1 INT AFTER dMountHoleSize
,ADD ixUnitId2 INT AFTER dInsideDiameter
,ADD ixUnitId3 INT AFTER dOutsideDiameter
,ADD ixUnitId4 INT AFTER dOffset
,ADD ixUnitId5 INT AFTER dShoeInsideDimension
,ADD ixUnitId6 INT AFTER dFaceThickness
,ADD ixUnitId7 INT AFTER dStudDiameter
,ADD ixUnitId8 INT AFTER dStudDiameter2
,ADD ixUnitId9 INT AFTER dStudDiameter3
,ADD ixUnitId10 INT AFTER dWeight;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_dbrotorhatsets CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_dbrotorhatsets, AttributeDropdownItem
SET tmp.tmp_dbrotorhatsets.ixHatMountHoleType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotorhatsets.sHatMountHoleType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 755; 

SELECT *
FROM tmp.tmp_dbrotorhatsets
WHERE ixHatMountHoleType IS NULL; -- all records updated 


UPDATE tmp.tmp_dbrotorhatsets, AttributeDropdownItem
SET tmp.tmp_dbrotorhatsets.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotorhatsets.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_dbrotorhatsets
WHERE ixMaterialType IS NULL; -- all records updated 


UPDATE tmp.tmp_dbrotorhatsets, AttributeDropdownItem
SET tmp.tmp_dbrotorhatsets.ixHatMountStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotorhatsets.sHatMountStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 756; 

SELECT *
FROM tmp.tmp_dbrotorhatsets
WHERE ixHatMountStyle IS NULL; -- all records updated 


UPDATE tmp.tmp_dbrotorhatsets, AttributeDropdownItem
SET tmp.tmp_dbrotorhatsets.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotorhatsets.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44;  

SELECT *
FROM tmp.tmp_dbrotorhatsets
WHERE ixFinish IS NULL; -- all records updated 


UPDATE tmp.tmp_dbrotorhatsets, AttributeDropdownItem
SET tmp.tmp_dbrotorhatsets.ixRotorHatBoltPattern = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dbrotorhatsets.sRotorHatBoltPattern = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 413; 

SELECT *
FROM tmp.tmp_dbrotorhatsets
WHERE ixRotorHatBoltPattern IS NULL; -- all records with values updated after making the changes below 

UPDATE tmp.tmp_dbrotorhatsets
SET sRotorHatBoltPattern = '8 x 7.78"'
WHERE sRotorHatBoltPattern = '8 x 7.78';

-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId1 = 6
WHERE dMountHoleSize IS NOT NULL; 

UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId2 = 6
WHERE dInsideDiameter IS NOT NULL; 

UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId3 = 6 
WHERE dOutsideDiameter IS NOT NULL;

UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId4 = 6 
WHERE dOffset IS NOT NULL;

UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId5 = 6
WHERE dShoeInsideDimension IS NOT NULL; 

UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId6 = 6
WHERE dFaceThickness IS NOT NULL; 

UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId7 = 6 
WHERE dStudDiameter IS NOT NULL;

UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId8 = 6 
WHERE dStudDiameter2 IS NOT NULL;


UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId9 = 6 
WHERE dStudDiameter3 IS NOT NULL;


UPDATE tmp.tmp_dbrotorhatsets
SET ixUnitId10 = 14
WHERE dWeight IS NOT NULL;


-- Now the records need to be inserted into the SKU Attribute table 

SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_dbrotorhatsets)
  AND ixPartTerminologyID <> 13260; 
  
-- The 142 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT R.ixSOPSKU
     , 13260
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_dbrotorhatsets R;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 757
     , R.sHatBoltCircle1
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sHatBoltCircle1 IS NOT NULL
  AND R.sHatBoltCircle1 <> ' '; --  147 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 758
     , R.sHatBoltCircle2
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sHatBoltCircle2 IS NOT NULL
  AND R.sHatBoltCircle2 <> ' '; --  42 rows affected
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 759
     , R.sHatBoltCircle3
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.sHatBoltCircle3 IS NOT NULL
  AND R.sHatBoltCircle3 <> ' '; --  20 rows affected
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 755
     , R.ixHatMountHoleType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixHatMountHoleType IS NOT NULL; -- 147 rows affected


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
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixMaterialType IS NOT NULL; -- 142 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 756
     , R.ixHatMountStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixHatMountStyle IS NOT NULL; -- 147 rows affected


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
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixFinish IS NOT NULL; -- 142 rows affected


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
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.ixRotorHatBoltPattern IS NOT NULL; -- 142 rows affected


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
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dMountHoleSize IS NOT NULL
  AND R.dMountHoleSize <> 'N/A'
  AND R.dMountHoleSize <> 0.00; --  130 rows affected
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 91
     , R.dInsideDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId2
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dInsideDiameter IS NOT NULL
  AND R.dInsideDiameter <> ' '
  AND R.dInsideDiameter <> 0.00; --  147 rows affected
  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 92
     , R.dOutsideDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId3
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dOutsideDiameter IS NOT NULL
  AND R.dOutsideDiameter <> ' '
  AND R.dOutsideDiameter <> 0.00; --  146 rows affected 
  
  
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
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dOffset IS NOT NULL
  AND R.dOffset <> ' '
  AND R.dOffset <> 0.00; --  142 rows affected  
  

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
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dShoeInsideDimension IS NOT NULL
  AND R.dShoeInsideDimension <> ' '
  AND R.dShoeInsideDimension <> 0.00; --  24 rows affected  
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 748
     , R.dFaceThickness
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId6
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dFaceThickness IS NOT NULL
  AND R.dFaceThickness <> ' '
  AND R.dFaceThickness <> 0.00; --  147 rows affected 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 133
     , R.dStudDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId7
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dStudDiameter IS NOT NULL
  AND R.dStudDiameter <> ' '
  AND R.dStudDiameter <> 0.00; --  147 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 760
     , R.dStudDiameter2
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId8
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dStudDiameter2 IS NOT NULL
  AND R.dStudDiameter2 <> ' '
  AND R.dStudDiameter2 <> 0.00; --  42 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT R.ixSOPSKU
     , 761
     , R.dStudDiameter3
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , R.ixUnitId9
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dStudDiameter3 IS NOT NULL
  AND R.dStudDiameter3 <> ' '
  AND R.dStudDiameter3 <> 0.00; --  20 rows affected    
  

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
FROM tmp.tmp_dbrotorhatsets R
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = R.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE R.dWeight IS NOT NULL
  AND R.dWeight <> ' '
  AND R.dWeight <> 0.00; --  103 rows affected  
  
  
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_dbrotorhatsets R;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8351700357';


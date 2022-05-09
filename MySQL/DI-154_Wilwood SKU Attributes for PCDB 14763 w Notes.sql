 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 14763; -- Brake Pedal Assemblies
 
-- For each column header (attribute) it needs to be determined what "type" they are. 
-- This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 5;


-- Type 2 & 4 will be special types that will take additional steps; 
-- all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Pedal Type' -- Text, 1 -- Template ID 788
   OR sTitle = 'Material Type' -- Dropdown box, 4 -- Template ID 31
   OR sTitle = 'Finish' -- Dropdown box, 4 -- Template ID 44 
   OR sTitle = 'Mount Position' -- Dropdown box, 4 -- Template ID 682
   OR sTitle = 'Mount Facing' -- Dropdown box, 4 -- Template ID 731
   OR sTitle = 'Balance Bar' -- Yes/No, 2 -- Template ID 732
   OR sTitle = 'Mounted Length' -- Measurement/Size/Length, 5 -- Template ID 144 -- Unit Id = 6    
   OR sTitle = 'Pedal 1 Ratio' -- Text, 1 -- Template ID 733         
   OR sTitle = 'Pedal 2 Ratio' -- Text, 1 -- Template ID 734  
   OR sTitle = 'Pedal 1 Length' -- Measurement/Size/Length, 5 -- Template ID 735 -- Unit Id = 6            
   OR sTitle = 'Pedal 2 Length' -- Measurement/Size/Length, 5 -- Template ID 736  -- Unit Id = 6    
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_brakepedal;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_brakepedal
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixMountPosition INT AFTER sMountPosition 
,ADD ixMountFacing INT AFTER sMountFacing 
,ADD ixUnitId1 INT AFTER dMountedLength
,ADD ixUnitId2 INT AFTER dPedal1Length
,ADD ixUnitId3 INT AFTER dPedal2Length;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_brakepedal CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_brakepedal, AttributeDropdownItem
SET tmp.tmp_brakepedal.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakepedal.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_brakepedal
WHERE ixMaterialType IS NULL; -- all records with values updated except those containing the listing of 'Aluminum / Steel'; asked JGO changed to aluminum 


UPDATE tmp.tmp_brakepedal, AttributeDropdownItem
SET tmp.tmp_brakepedal.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakepedal.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_brakepedal
WHERE ixFinish IS NULL; -- all records updated after the change below was applied 


UPDATE tmp.tmp_brakepedal, AttributeDropdownItem
SET tmp.tmp_brakepedal.ixMountPosition = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakepedal.sMountPosition = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 682; 

SELECT *
FROM tmp.tmp_brakepedal
WHERE ixMountPosition IS NULL; -- all records with values updated 


UPDATE tmp.tmp_brakepedal, AttributeDropdownItem
SET tmp.tmp_brakepedal.ixMountFacing = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakepedal.sMountFacing = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 731; 

SELECT *
FROM tmp.tmp_brakepedal
WHERE ixMountFacing IS NULL; -- all records with values updated 


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_brakepedal
SET ixUnitId1 = 6
WHERE dMountedLength IS NOT NULL; 

UPDATE tmp.tmp_brakepedal
SET ixUnitId2 = 6
WHERE dPedal1Length IS NOT NULL; 

UPDATE tmp.tmp_brakepedal
SET ixUnitId3 = 6
WHERE dPedal2Length IS NOT NULL;


-- Update the Yes/No values to Boolean readings 
Update tmp.tmp_brakepedal
SET sBalanceBar = '1' 
WHERE sBalanceBar = 'Yes';
Update tmp.tmp_brakepedal
SET sBalanceBar = '0' 
WHERE sBalanceBar = 'No';


-- Now the records need to be inserted into the SKU Attribute table 
  
-- The 10 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT BP.ixSOPSKU
     , 14763
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_brakepedal BP;


SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_brakepedal); 

UPDATE tblSKUPartAssociation
SET dtUpdate = NOW()
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_brakepedal);


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 788
     , BP.sPedalType
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.sPedalType IS NOT NULL
   OR BP.sPedalType <> ' '; --  21 rows affected   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 733
     , BP.sPedal1Ratio
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.sPedal1Ratio IS NOT NULL
   OR BP.sPedal1Ratio <> ' '; --  21 rows affected
   
DELETE FROM SKUAttribute
WHERE SKUAttribute.ixTemplateAttributeId = 733 
   AND SKUAttribute.ixAttributeTypeId = 1 
   AND SKUAttribute.ixPartTerminologyID = 14763
   AND sValue = ' ';
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 734
     , BP.sPedal2Ratio
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.sPedal2Ratio IS NOT NULL
   OR BP.sPedal2Ratio <> ' '; --  21 rows affected
   
   
DELETE FROM SKUAttribute
WHERE SKUAttribute.ixTemplateAttributeId = 734
   AND SKUAttribute.ixAttributeTypeId = 1 
   AND SKUAttribute.ixPartTerminologyID = 14763
   AND sValue = ' ';   
     

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 732
     , BP.sBalanceBar
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.sBalanceBar IS NOT NULL
   AND BP.sBalanceBar <> ' '; --  16 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 31
     , BP.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.ixMaterialType IS NOT NULL
  AND BP.ixMaterialType <> 32; -- 206 rows affected
  
DELETE 
FROM SKUAttribute 
WHERE SKUAttribute.ixTemplateAttributeId = 31 
  AND SKUAttribute.sValue = 32; -- deletes records with blank values


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 44
     , BP.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.ixFinish IS NOT NULL
   AND BP.ixFinish <> 46; -- 9 rows affected


DELETE
-- SELECT * 
FROM SKUAttribute 
WHERE SKUAttribute.ixTemplateAttributeId = 44
  AND SKUAttribute.sValue = 46; -- deletes records with blank values
  
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 682
     , BP.ixMountPosition
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.ixMountPosition IS NOT NULL; -- 18 rows affected
   


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 731
     , BP.ixMountFacing
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.ixMountFacing IS NOT NULL; -- 18 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 144
     , BP.dMountedLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId1
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dMountedLength IS NOT NULL
   AND BP.dMountedLength <> ' '; --  14 rows affected

   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 735
     , BP.dPedal1Length
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId2
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dPedal1Length IS NOT NULL
   AND BP.dPedal1Length NOT LIKE ' '
   AND BP.dPedal1Length <> 0.00; --  14 rows affected 


   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 736
     , BP.dPedal2Length
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId2
FROM tmp.tmp_brakepedal BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dPedal2Length IS NOT NULL
   AND BP.dPedal2Length NOT LIKE ' '
   AND BP.dPedal2Length <> 0.00; --  6 rows affected 


   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_brakepedal BP;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8353403950';


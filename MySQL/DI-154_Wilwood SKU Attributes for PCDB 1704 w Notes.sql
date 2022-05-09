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
   -- OR sTitle = 'Rotor Diameter' -- dropdown box, 4 -- Template ID 261 -- UnitId = 6 (inches) 
   -- OR sTitle = 'Caliper Mounting Type' -- dropdown box, 4 -- Template ID 718 
   OR sTitle = 'Mount Type' -- dropdown box, 4 -- Template ID 766  
   OR sTitle = 'Caliper Type' -- Text, 1 -- Template ID 791
   OR sTitle = 'Caliper Finish' -- dropdown box, 4 -- Template ID 379   
   OR sTitle = 'Piston Type' -- dropdown box, 4 -- Template ID 792
   OR sTitle = 'Compound' -- dropdown box, 4 -- Template ID 749  
   -- OR sTitle = 'Mounting Side' -- dropdown box, 4 -- Template ID 318 
   -- OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31  
   -- OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36        
   -- OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44           
   -- OR sTitle = 'Rotor Thickness' -- Measurement/Size/Length, 5 -- Template ID 377 -- UnitId = 6 (inches) 
   -- OR sTitle = 'Bore Size' -- Measurement/Size/Length, 5 -- Template ID 147 -- UnitId = 6 (inches)       
   -- OR sTitle = 'Bore 2 Size' -- Measurement/Size/Length, 5 -- Template ID 719   -- UnitId = 6 (inches) 
   -- OR sTitle = 'Bore 3 Size' -- Measurement/Size/Length, 5 -- Template ID 720  -- UnitId = 6 (inches)  
   -- OR sTitle = 'Mount Hole Size' -- Measurement/Size/Length, 5 -- Template ID 722 -- UnitId = 6 (inches)     
   -- OR sTitle = 'Mounted Height' -- Measurement/Size/Length, 5 -- Template ID 204 -- UnitId = 6 (inches) 
   -- OR sTitle = 'Centerline of Holes' -- Measurement/Size/Length, 5 -- Template ID 30 -- UnitId = 6 (inches)         
   -- OR sTitle = 'Weight' -- weight, 6 -- Template ID 35 -- UnitId = 14 (pounds)        
   -- OR sTitle = 'Thread Pitch' -- text, 1 -- Template ID 142     
   OR sTitle = 'Pad Area' -- area, 19 -- Template ID 723 -- UnitId = 39 (sq. in)    
   OR sTitle = 'Total Piston Area' -- area, 19 -- Template ID 721  -- UnitId = 39 (sq. in)       
   OR sTitle = 'Pad Volume' -- volume, 20 -- Template ID 724    -- UnitId = 49 (cubic in)    
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_discbrakecalipers2;


-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_discbrakecalipers2
 ADD ixCaliperPistons INT AFTER sCaliperPistons
,ADD ixMountType INT AFTER sMountType
,ADD ixPistonType INT AFTER sPistonType
,ADD ixCaliperFinish INT AFTER sCaliperFinish
,ADD ixCompound INT AFTER sCompound
,ADD ixUnitId1 INT AFTER dTotalPistonArea
,ADD ixUnitId2 INT AFTER dPadArea
,ADD ixUnitId3 INT AFTER dPadVolume;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_discbrakecalipers2 CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_discbrakecalipers2, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers2.ixCaliperPistons = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers2.sCaliperPistons = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 309; 
   
UPDATE tmp.tmp_discbrakecalipers2 
SET sCaliperPistons = 'Two' 
WHERE sCaliperPistons = '0';  


UPDATE tmp.tmp_discbrakecalipers2 
SET sCaliperPistons = 'Single' 
WHERE sCaliperPistons = 'One';  

SELECT *
FROM tmp.tmp_discbrakecalipers2
WHERE ixCaliperPistons IS NULL; -- All records updated 

UPDATE tmp.tmp_discbrakecalipers2, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers2.ixMountType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers2.sMountType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 766; 

SELECT *
FROM tmp.tmp_discbrakecalipers2
WHERE ixMountType IS NULL; -- All records updated 


UPDATE tmp.tmp_discbrakecalipers2, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers2.ixPistonType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers2.sPistonType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 792; 

SELECT *
FROM tmp.tmp_discbrakecalipers2
WHERE ixPistonType IS NULL; -- All records updated 


UPDATE tmp.tmp_discbrakecalipers2, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers2.ixCaliperFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers2.sCaliperFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 379; 

SELECT *
FROM tmp.tmp_discbrakecalipers2
WHERE ixCaliperFinish IS NULL; -- All records updated 


UPDATE tmp.tmp_discbrakecalipers2, AttributeDropdownItem
SET tmp.tmp_discbrakecalipers2.ixCompound = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakecalipers2.sCompound = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 749; 

SELECT *
FROM tmp.tmp_discbrakecalipers2
WHERE ixCompound IS NULL; -- All records updated 

-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_discbrakecalipers2
SET ixUnitId1 = 39
WHERE dTotalPistonArea IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers2
SET ixUnitId2 = 39 
WHERE dPadArea IS NOT NULL; 

UPDATE tmp.tmp_discbrakecalipers2
SET ixUnitId3 = 49 
WHERE dPadVolume IS NOT NULL; 


-- Now the records need to be inserted into the SKU Attribute table 

-- The parts do not exist in tblSKUPartAssociation so that must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DBC.ixSOPSKU
     , 1704
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_discbrakecalipers2 DBC;


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
FROM tmp.tmp_discbrakecalipers2 DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixCaliperPistons IS NOT NULL; -- 21 values inserted 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 766
     , DBC.ixMountType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers2 DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixMountType IS NOT NULL; -- 21 values inserted 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 791
     , DBC.sCaliperType
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers2 DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.sCaliperType IS NOT NULL; -- 21 values inserted 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 379
     , DBC.ixCaliperFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers2 DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixCaliperFinish IS NOT NULL; -- 21 values inserted 

   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 792
     , DBC.ixPistonType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers2 DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixPistonType IS NOT NULL; -- 21 values inserted 

  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 749
     , DBC.ixCompound
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_discbrakecalipers2 DBC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.ixCompound IS NOT NULL; -- 21 values inserted 


 
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 723
     , DBC.dPadArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId2  
FROM tmp.tmp_discbrakecalipers2 DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dPadArea IS NOT NULL; -- 21 values inserted 



 
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 721
     , DBC.dTotalPistonArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId1  
FROM tmp.tmp_discbrakecalipers2 DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dTotalPistonArea IS NOT NULL; -- 21 values inserted 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DBC.ixSOPSKU
     , 724
     , DBC.dPadVolume
     , 20
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , DBC.ixUnitId3  
FROM tmp.tmp_discbrakecalipers2 DBC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = DBC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE DBC.dPadVolume IS NOT NULL; -- 21 values inserted 

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_discbrakecalipers2
WHERE ixSOPSKU = '83514011290'
ORDER BY ixSOPSKU;

SELECT TemplateAttribute.sTitle
     , SA.* 
FROM SKUAttribute SA
LEFT JOIN TemplateAttribute ON TemplateAttribute.ixTemplateAttributeId = SA.ixTemplateAttributeId
WHERE ixSKU = '83514011290'; 


-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '83514011290';


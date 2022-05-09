 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 11532; -- Brake Hydraulic Hose Kits
 
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
WHERE sTitle = 'Overall Length' -- Measurement/Size/Length, 5 -- Template ID 34 -- Unit Id = 6
   OR sTitle = 'AN Size' -- Dropdown box, 4 -- Template ID 652
   OR sTitle = 'Inlet Fitting' -- Text, 1 -- Template ID 202
   OR sTitle = 'Inlet Fitting Angle' -- Dropdown box, 4 -- Template ID 725
   OR sTitle = 'Outlet Fitting' -- Text, 1 -- Template ID 203
   OR sTitle = 'Outlet Fitting Angle' -- Dropdown box, 4 -- Template ID 728
   OR sTitle = 'Thread Pitch' -- Text, 1 -- Template ID 142
   OR sTitle = 'Weight' -- Weight, 6 -- Template ID 35 -- Unit Id = 14 (pounds) 
   OR sTitle = 'Sold in Quantity' -- Dropdown box, 4 -- Template ID 41
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_hosekits;


SELECT DISTINCT dWeight FROM tmp.tmp_hosekits;
UPDATE tmp.tmp_hosekits SET dWeight = '1.00' WHERE dWeight = '1';
UPDATE tmp.tmp_hosekits SET dWeight = '0.80' WHERE dWeight = '0.8';
UPDATE tmp.tmp_hosekits SET dWeight = '1.20' WHERE dWeight = '1.2';
UPDATE tmp.tmp_hosekits SET dWeight = '2.00' WHERE dWeight = '2';
UPDATE tmp.tmp_hosekits SET dWeight = '0.50' WHERE dWeight = '0.5';
UPDATE tmp.tmp_hosekits SET dWeight = '1.50' WHERE dWeight = '1.5';
UPDATE tmp.tmp_hosekits SET dWeight = '0.90' WHERE dWeight = '0.9';
UPDATE tmp.tmp_hosekits SET dWeight = '0.20' WHERE dWeight = '0.2';

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_hosekits
 ADD ixANSize INT AFTER sANSize
,ADD ixInletFittingAngle INT AFTER sInletFittingAngle
,ADD ixOutletFittingAngle INT AFTER sOutletFittingAngle
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity
,ADD ixUnitId INT AFTER dOverallLength
,ADD ixUnitId2 INT AFTER dWeight;

 
-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_hosekits CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_hosekits, AttributeDropdownItem
SET tmp.tmp_hosekits.ixANSize = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hosekits.sANSize = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 652; 

SELECT *
FROM tmp.tmp_hosekits
WHERE ixANSize IS NULL; -- all records updated that had values 


UPDATE tmp.tmp_hosekits, AttributeDropdownItem
SET tmp.tmp_hosekits.ixInletFittingAngle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hosekits.sInletFittingAngle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 725; -- 136 rows affected 

SELECT *
FROM tmp.tmp_hosekits
WHERE ixInletFittingAngle IS NULL; -- all records updated that had values 


UPDATE tmp.tmp_hosekits, AttributeDropdownItem
SET tmp.tmp_hosekits.ixOutletFittingAngle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hosekits.sOutletFittingAngle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 728; -- 133 rows affected 

SELECT *
FROM tmp.tmp_hosekits
WHERE ixOutletFittingAngle IS NULL; -- all records updated that had values 


UPDATE tmp.tmp_hosekits, AttributeDropdownItem
SET tmp.tmp_hosekits.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_hosekits.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; -- 137 rows affected 

SELECT *
FROM tmp.tmp_hosekits
WHERE ixSoldinQuantity IS NULL; -- all records updated 


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_hosekits
SET ixUnitId = 6
WHERE dOverallLength IS NOT NULL; 

UPDATE tmp.tmp_hosekits
SET ixUnitId2 = 14
WHERE dWeight IS NOT NULL; 


SELECT * FROM tmp.tmp_hosekits;


-- Now the records need to be inserted into the SKU Attribute table 

SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_hosekits); 

UPDATE tblSKUPartAssociation
SET ixPartTerminologyID = 11532
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_hosekits)
  AND ixSKUPartAssociationID IN ('229416', '173807', '130625', '106253');
  
UPDATE tblSKUPartAssociation
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_hosekits)
  AND ixSKUPartAssociationID IN ('229416', '173807', '130625', '106253');  
  
UPDATE tblSKUPartAssociation
SET dtUpdate = NOW()
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_hosekits)
  AND ixSKUPartAssociationID IN ('229416', '173807', '130625', '106253');    

-- The 133 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT HK.ixSOPSKU
     , 11532
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_hosekits HK;


UPDATE tblSKUPartAssociation
SET dtUpdate = NOW()
WHERE ixSKUPartAssociationID = 171705;

UPDATE tblSKUPartAssociation
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixSKUPartAssociationID = 171705;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 202
     , HK.sInletFitting
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.sInletFitting IS NOT NULL
   OR HK.sInletFitting <> ' '; --  137 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 203
     , HK.sOutletFitting
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.sOutletFitting IS NOT NULL
   OR HK.sOutletFitting <> ' '; --  137 rows affected
   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 142
     , HK.sThreadPitch
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.sThreadPitch IS NOT NULL
   OR HK.sThreadPitch <> ' '; --  137 rows affected   
   
   
DELETE
-- SELECT * 
FROM SKUAttribute
WHERE ixTemplateAttributeId = 142 
  AND sValue = ' ';
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 652
     , HK.ixANSize
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.ixANSize IS NOT NULL; -- 136 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 725
     , HK.ixInletFittingAngle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.ixInletFittingAngle IS NOT NULL; -- 136 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 728
     , HK.ixOutletFittingAngle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.ixOutletFittingAngle IS NOT NULL; -- 133 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 41
     , HK.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.ixSoldinQuantity IS NOT NULL; -- 137 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 34
     , HK.dOverallLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HK.ixUnitId
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.dOverallLength IS NOT NULL
   AND HK.dOverallLength <> ' '
   AND HK.dOverallLength <> 0.00; --  136 rows affected
   
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HK.ixSOPSKU
     , 35
     , HK.dWeight
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HK.ixUnitId2
FROM tmp.tmp_hosekits HK
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HK.dWeight IS NOT NULL
   AND HK.dWeight <> ' '
   AND HK.dWeight <> 0.00; -- 137 rows affected   


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_hosekits HK;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '8352208840';


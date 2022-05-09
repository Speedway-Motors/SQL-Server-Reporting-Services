 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 11389; -- Brake Fluids
 
-- For each column header (attribute) it needs to be determined what "type" they are. This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 8;

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 20;


SELECT *
FROM AttributeType; -- Type 2 & 4 will be special types that will take additional steps; all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Dry Boiling Point' -- Temperature, 8 -- Template ID 774 -- UnitId = 21 (*F) 
   OR sTitle = 'Wet Boiling Point' -- Temperature, 8 -- Template ID 775 -- UnitId = 21 (*F)          
   OR sTitle = 'Sold in Quantity' -- Dropdown box, 4 -- Template ID 41 
   OR sTitle = 'Liquid Measurement' -- Volume, 20 -- Template ID 140 -- UnitId = 47 (fl. oz)    
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_brakefluid;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_brakefluid
 ADD ixSoldinQuantity INT AFTER sSoldinQuantity
,ADD ixUnitId1 INT AFTER sDryBoilingPoint
,ADD ixUnitId2 INT AFTER sWetBoilingPoint
,ADD ixUnitId3 INT AFTER sLiquidMeasurement;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_brakefluid CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_brakefluid, AttributeDropdownItem
SET tmp.tmp_brakefluid.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakefluid.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_brakefluid
WHERE ixSoldinQuantity IS NULL; -- all records updated 


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_brakefluid
SET ixUnitId1 = 21
WHERE sDryBoilingPoint IS NOT NULL; 

UPDATE tmp.tmp_brakefluid
SET ixUnitId2 = 21
WHERE sWetBoilingPoint IS NOT NULL; 

UPDATE tmp.tmp_brakefluid
SET ixUnitId3 = 47 
WHERE sLiquidMeasurement IS NOT NULL; 


-- Now the records need to be inserted into the SKU Attribute table 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BF.ixSOPSKU
     , 774
     , BF.sDryBoilingPoint
     , 8
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BF.ixUnitId1
FROM tmp.tmp_brakefluid BF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BF.sDryBoilingPoint IS NOT NULL; -- 9 rows affected 
  
-- The parts do not exist in tblSKUPartAssociation so that must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT BF.ixSOPSKU
     , 11389
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_brakefluid BF;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BF.ixSOPSKU
     , 775
     , BF.sWetBoilingPoint
     , 8
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BF.ixUnitId2
FROM tmp.tmp_brakefluid BF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BF.sWetBoilingPoint IS NOT NULL; -- 9 rows affected 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BF.ixSOPSKU
     , 41
     , BF.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakefluid BF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BF.ixSoldinQuantity IS NOT NULL; -- 7 rows affected, 2 already existed 

  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BF.ixSOPSKU
     , 140
     , BF.sLiquidMeasurement
     , 20
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BF.ixUnitId3
FROM tmp.tmp_brakefluid BF
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BF.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BF.sLiquidMeasurement IS NOT NULL; --  7 rows affected, 2 already existed 
   
   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_brakefluid BF;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '83529011085';


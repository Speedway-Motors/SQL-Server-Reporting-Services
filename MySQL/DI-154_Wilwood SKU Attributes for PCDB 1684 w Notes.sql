 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 1684; -- Disc Brake Pad
 
-- For each column header (attribute) it needs to be determined what "type" they are. 
-- This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 5;

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 13;


SELECT *
FROM AttributeType; 
-- Type 2 & 4 will be special types that will take additional steps; 
-- all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Pad Area' -- Area, 19 -- Template ID 723 -- Unit Id = 39
   OR sTitle = 'Pad Volume' -- Volume, 20 -- Template ID 724 -- Unit Id = 49         
   OR sTitle = 'Bedded' -- Yes/No, 2 -- Template ID 743  
   OR sTitle = 'Peak Temperature' -- Temperature, 8 -- Template ID 752 -- Unit Id = 21
   OR sTitle = 'Peak Friction Rating' -- Force, 13 -- Template ID 753 -- Unit Id = 32
   OR sTitle = 'Pad Noise Rating' -- Dropdown box, 4 -- Template ID 754
   OR sTitle = 'Compound' -- Dropdown box, 4 -- Template ID 749
   OR sTitle = 'Quantity Included' -- Text, 1 -- Template ID 802         
   OR sTitle = 'Thickness' -- Measurement/Size/Length, 5 -- Template ID 449  -- Unit Id = 6 
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_discbrakepad;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_discbrakepad
 ADD ixPadNoiseRating INT AFTER sPadNoiseRating
,ADD ixCompound INT AFTER sCompound
,ADD ixUnitId1 INT AFTER dPadArea
,ADD ixUnitId2 INT AFTER dPadVolume
,ADD ixUnitId3 INT AFTER dPeakTemperature
,ADD ixUnitId4 INT AFTER dPeakFrictionRating
,ADD ixUnitId5 INT AFTER dThickness;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_discbrakepad CONVERT to character set latin1 collate latin1_general_cs;

-- STOPPED HERE ON FRIDAY -- 

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_discbrakepad, AttributeDropdownItem
SET tmp.tmp_discbrakepad.ixPadNoiseRating = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakepad.sPadNoiseRating = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 754; 

SELECT *
FROM tmp.tmp_discbrakepad
WHERE ixPadNoiseRating IS NULL; -- all records with values updated except those containing the listing of 'Moderate'; asked JGO to add 

SELECT * FROM AttributeDropdownItem WHERE ixTemplateAttributeId = 754;

UPDATE tmp.tmp_discbrakepad, AttributeDropdownItem
SET tmp.tmp_discbrakepad.ixCompound = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_discbrakepad.sCompound = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 749; 

SELECT *
FROM tmp.tmp_discbrakepad
WHERE ixCompound IS NULL; -- all records updated after the change below was applied 


-- Update all the UnitId values to the correct Unit Type 
UPDATE tmp.tmp_discbrakepad
SET ixUnitId1 = 39
WHERE dPadArea IS NOT NULL; 

UPDATE tmp.tmp_discbrakepad
SET ixUnitId2 = 49
WHERE dPadVolume IS NOT NULL; 

UPDATE tmp.tmp_discbrakepad
SET ixUnitId3 = 21
WHERE dPeakTemperature IS NOT NULL;

UPDATE tmp.tmp_discbrakepad
SET ixUnitId4 = 32
WHERE dPeakFrictionRating IS NOT NULL;

UPDATE tmp.tmp_discbrakepad
SET ixUnitId5 = 6 
WHERE dThickness IS NOT NULL;

-- Update the Yes/No values to Boolean readings 
Update tmp.tmp_discbrakepad
SET sBedded = '1' 
WHERE sBedded = 'Y';
Update tmp.tmp_discbrakepad
SET sBedded = '0' 
WHERE sBedded = 'N';


-- Now the records need to be inserted into the SKU Attribute table 
SELECT * FROM tmp.tmp_discbrakepad WHERE dPadArea = ' '; -- exclude these blank values from inserting as well as null values 
  
-- The 25 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT BP.ixSOPSKU
     , 1684
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_discbrakepad BP;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 802
     , BP.sQuantityIncluded
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.sQuantityIncluded IS NOT NULL
   OR BP.sQuantityIncluded <> ' '; --  305 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 743
     , BP.sBedded
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.sBedded IS NOT NULL; --  305 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 754
     , BP.ixPadNoiseRating
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.ixPadNoiseRating IS NOT NULL
   OR BP.sPadNoiseRating <> ' '; -- 206 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 749
     , BP.ixCompound
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.ixCompound IS NOT NULL; -- 303 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 723
     , BP.dPadArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId1
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dPadArea IS NOT NULL
   AND BP.dPadArea <> ' '; --  141 rows affected

   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 724
     , BP.dPadVolume
     , 20
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId2
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dPadVolume IS NOT NULL
   OR BP.dPadVolume NOT LIKE ' '; --  305 rows affected 

DELETE
FROM SKUAttribute 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakepad) 
  AND SKUAttribute.ixTemplateAttributeId = 724 
  AND SKUAttribute.ixAttributeTypeId = 20 
  AND SKUAttribute.ixCreateUser = 'SPEEDWAYMOTORS\\ascrook'
  AND sValue = ' '; -- 152 rows affected 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 752
     , BP.dPeakTemperature
     , 8
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId3
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dPeakTemperature IS NOT NULL
  AND BP.dPeakTemperature LIKE '%F'; --  305 rows affected


DELETE 
FROM SKUAttribute 
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_discbrakepad) 
  AND SKUAttribute.ixTemplateAttributeId = 752
  AND SKUAttribute.ixAttributeTypeId = 8
  AND SKUAttribute.ixCreateUser = 'SPEEDWAYMOTORS\\ascrook'
  AND sValue = ' '; -- 9 rows affected 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 753
     , BP.dPeakFrictionRating
     , 13
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId4
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dPeakFrictionRating IS NOT NULL
   AND BP.dPeakFrictionRating <> '0.00'; --  280 rows affected
   
   
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT BP.ixSOPSKU
     , 449
     , BP.dThickness
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , BP.ixUnitId5
FROM tmp.tmp_discbrakepad BP
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = BP.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE BP.dThickness IS NOT NULL
   AND BP.dThickness <> '0.00'
   AND BP.dThickness <> ' '; --  302 rows affected   
   
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_discbrakepad BP;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '83515012128K';


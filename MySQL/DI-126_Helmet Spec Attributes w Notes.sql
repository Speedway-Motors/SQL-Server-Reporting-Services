-- For each column header (attribute) it needs to be determined what "type" they are. This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 5;

SELECT *
FROM AttributeType; -- Type 2 & 4 will be special types that will take additional steps; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Pre-drilled for head and neck restraint' -- Yes/No, 2 -- Template ID 602 
   OR sTitle = 'Helmet Rating' -- dropdown box, 4 -- Template ID 532 
   OR sTitle = 'Helmet Size' -- dropdown box, 4 -- Template ID 531
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle = 'Tear Off Style' -- dropdown box, 4 -- Template ID 426
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_helmetspecs;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_helmetspecs
 ADD ixTearOffStyle INT AFTER sTearOffStyle
,ADD ixHelmetSize INT AFTER sHelmetSize
,ADD ixHelmetRating INT AFTER sHelmetRating
,ADD ixColor INT AFTER sColor;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_helmetspecs CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_helmetspecs, AttributeDropdownItem
SET tmp.tmp_helmetspecs.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_helmetspecs.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_helmetspecs
WHERE ixColor IS NULL; -- All records updated that had values 

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 36; -- Ask about "Marine Blue" "Copper"  

UPDATE tmp.tmp_helmetspecs, AttributeDropdownItem
SET tmp.tmp_helmetspecs.ixTearOffStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_helmetspecs.sTearOffStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 426; 

SELECT *
FROM tmp.tmp_helmetspecs
WHERE ixTearOffStyle IS NULL; -- All records updated that had values (1422 were null) 

UPDATE tmp.tmp_helmetspecs, AttributeDropdownItem
SET tmp.tmp_helmetspecs.ixHelmetSize = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_helmetspecs.sHelmetSize = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 531; 

SELECT *
FROM tmp.tmp_helmetspecs
WHERE ixHelmetSize IS NULL
ORDER BY sHelmetSize; -- All records updated that had values 

UPDATE tmp.tmp_helmetspecs
SET sHelmetSize = '7 7/8' 
WHERE sHelmetSize = '778'; 

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 531
ORDER BY sAttributeDropdownItemText; -- Ask about 7 7/8, 8, 8 1/8, 8 1/4, XXX-Small, XXXX-Small 

UPDATE tmp.tmp_helmetspecs, AttributeDropdownItem
SET tmp.tmp_helmetspecs.ixHelmetRating = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_helmetspecs.sHelmetRating = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 532; 

SELECT *
FROM tmp.tmp_helmetspecs
WHERE ixHelmetRating IS NULL
ORDER BY sHelmetRating; -- All records updated that had values 

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 532
ORDER BY sAttributeDropdownItemText; -- Ask about Snell SA2000 

-- Add the attribute type 2 value in 

ALTER TABLE tmp.tmp_helmetspecs
 ADD ixPredrilled INT AFTER sPredrilled; 

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_helmetspecs
SET ixPredrilled = 0
WHERE sPredrilled = 'No';

UPDATE tmp.tmp_helmetspecs
SET ixPredrilled = 1
WHERE sPredrilled = 'Yes';

SELECT *
FROM tmp.tmp_helmetspecs
WHERE ixPredrilled IS NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HS.ixSOPSKU
     , 36
     , HS.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_helmetspecs HS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HS.ixColor IS NOT NULL; -- only 1543 records inserted out of 2146 records total (all had ixColor values) 

SELECT  HS.ixSOPSKU
      , SA.ixSKU
      , HS.ixColor 
      , SA.sValue
FROM tmp.tmp_helmetspecs HS 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = HS.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 36
  AND SA.sValue IS NULL; -- other records must have already existed in the table
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HS.ixSOPSKU
     , 426
     , HS.ixTearOffStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_helmetspecs HS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HS.ixTearOffStyle IS NOT NULL; -- 1422 were null

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HS.ixSOPSKU
     , 531
     , HS.ixHelmetSize
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_helmetspecs HS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HS.ixHelmetSize IS NOT NULL; 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HS.ixSOPSKU
     , 532
     , HS.ixHelmetRating
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_helmetspecs HS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HS.ixHelmetRating IS NOT NULL; 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HS.ixSOPSKU
     , 602
     , HS.ixPredrilled
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_helmetspecs HS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HS.ixPredrilled IS NOT NULL;

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_helmetspecs;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '449176-S-SIL';

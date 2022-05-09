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
WHERE sTitle = 'MFG. Part #' -- text, 1 -- Template ID 325 
   OR sTitle = 'Suit Style' -- dropdown box, 4 -- Template ID 651 
   OR sTitle = 'Suit Size' -- dropdown box, 4 -- Template ID 650
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle = 'Suit SFI Rating' -- text, 1 -- Template ID 664
   OR sTitle = 'Suit Material Type' -- dropdown box, 4 -- Template ID 665  
   OR sTitle = 'Layers' -- dropdown box, 4 -- Template ID 456     
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sSuitMaterialType, sSuitSize, sColor, etc. 

SELECT * 
FROM tmp.tmp_racingsuits;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_racingsuits
 ADD ixSuitStyle INT AFTER sSuitStyle
,ADD ixSuitSize INT AFTER sSuitSize
,ADD ixColor INT AFTER sColor
,ADD ixSuitMaterialType INT AFTER sSuitMaterialType
,ADD ixLayers INT AFTER sLayers;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_racingsuits CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_racingsuits, AttributeDropdownItem
SET tmp.tmp_racingsuits.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_racingsuits.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_racingsuits
WHERE ixColor IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_racingsuits, AttributeDropdownItem
SET tmp.tmp_racingsuits.ixLayers = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_racingsuits.sLayers = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 456; 

SELECT *
FROM tmp.tmp_racingsuits
WHERE ixLayers IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_racingsuits, AttributeDropdownItem
SET tmp.tmp_racingsuits.ixSuitSize = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_racingsuits.sSuitSize = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 650; 

SELECT *
FROM tmp.tmp_racingsuits
WHERE ixSuitSize IS NULL; -- All records updated that had values 

SELECT * 
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 650; 

UPDATE tmp.tmp_racingsuits, AttributeDropdownItem
SET tmp.tmp_racingsuits.ixSuitStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_racingsuits.sSuitStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 651; 

SELECT *
FROM tmp.tmp_racingsuits
WHERE ixSuitStyle IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_racingsuits, AttributeDropdownItem
SET tmp.tmp_racingsuits.ixSuitMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_racingsuits.sSuitMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 665; 

SELECT *
FROM tmp.tmp_racingsuits
WHERE ixSuitMaterialType IS NULL
ORDER BY sSuitMaterialType; -- All records updated that had values 

SELECT * 
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 665; -- Need to add 'Fire Retardant Cotton' to attribute options 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RS.ixSOPSKU
     , 36
     , RS.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_racingsuits RS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE RS.ixColor IS NOT NULL
  AND RS.ixColor != 36; 

  
UPDATE SKUAttribute, tmp.tmp_racingsuits RS
SET sValue = RS.ixColor 
WHERE SKUAttribute.ixSKU = RS.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 36 
  AND SKUAttribute.ixAttributeTypeId = 4
  AND RS.ixColor IS NOT NULL
  AND RS.ixColor != 36; 
  
SELECT * 
FROM tmp.tmp_racingsuits
LEFT JOIN SKUAttribute SA ON SA.ixSKU = tmp.tmp_racingsuits.ixSOPSKU
WHERE tmp.tmp_racingsuits.ixColor = 36 
  AND SA.ixTemplateAttributeId = 36; 
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RS.ixSOPSKU
     , 456
     , RS.ixLayers
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_racingsuits RS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE RS.ixLayers IS NOT NULL
  AND RS.ixLayers != 456; 
  
SELECT RS.ixSOPSKU 
     , RS.ixLayers
     , SA.sValue
FROM tmp.tmp_racingsuits RS
LEFT JOIN SKUAttribute SA ON SA.ixSKU = RS.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 456
  AND (SA.sValue != RS.ixLayers
  OR SA.sValue IS NULL
       OR SA.sValue = '');  
  
UPDATE SKUAttribute, tmp.tmp_racingsuits RS
SET sValue = RS.ixLayers 
WHERE SKUAttribute.ixSKU = RS.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 456 
  AND SKUAttribute.ixAttributeTypeId = 4
  AND RS.ixLayers IS NOT NULL
  AND RS.ixLayers != 456; 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RS.ixSOPSKU
     , 650
     , RS.ixSuitSize
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_racingsuits RS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE RS.ixSuitSize IS NOT NULL
  AND RS.ixColor != 650; 

SELECT RS.ixSOPSKU 
     , RS.ixSuitSize
     , SA.sValue
FROM tmp.tmp_racingsuits RS
LEFT JOIN SKUAttribute SA ON SA.ixSKU = RS.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 650
  AND (SA.sValue != RS.ixSuitSize
  OR SA.sValue IS NULL
       OR SA.sValue = '');  
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RS.ixSOPSKU
     , 651
     , RS.ixSuitStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_racingsuits RS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE RS.ixSuitStyle IS NOT NULL
  AND RS.ixSuitStyle != 651;   

  SELECT RS.ixSOPSKU 
     , RS.ixSuitStyle
     , SA.sValue
FROM tmp.tmp_racingsuits RS
LEFT JOIN SKUAttribute SA ON SA.ixSKU = RS.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 651
  AND (SA.sValue != RS.ixSuitStyle
  OR SA.sValue IS NULL
       OR SA.sValue = '');
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RS.ixSOPSKU
     , 665
     , RS.ixSuitMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_racingsuits RS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE RS.ixSuitMaterialType IS NOT NULL
  AND RS.ixSuitMaterialType != 665;     

SELECT RS.ixSOPSKU 
     , RS.ixSuitMaterialType
     , SA.sValue
FROM tmp.tmp_racingsuits RS
LEFT JOIN SKUAttribute SA ON SA.ixSKU = RS.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 665
  AND (SA.sValue != RS.ixSuitMaterialType
  OR SA.sValue IS NULL
       OR SA.sValue = '');    
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RS.ixSOPSKU
     , 325
     , RS.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_racingsuits RS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE RS.sMFGPartNum IS NOT NULL;  

SELECT RS.ixSOPSKU 
     , RS.sMFGPartNum
     , SA.sValue
     , SA.ixCreateUser
FROM tmp.tmp_racingsuits RS
LEFT JOIN SKUAttribute SA ON SA.ixSKU = RS.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 325
  AND (SA.sValue != RS.sMFGPartNum
  OR SA.sValue IS NULL
       OR SA.sValue = '');   

DELETE FROM SKUAttribute
WHERE sValue = '' 
  AND ixTemplateAttributeId = 325; 

UPDATE SKUAttribute, tmp.tmp_racingsuits RS
SET sValue = RS.sMFGPartNum
WHERE SKUAttribute.ixSKU = RS.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 325 
  AND SKUAttribute.ixAttributeTypeId = 1
  AND ixSOPSKU IN ('67401069-BLK-M', '67401069-BLK-XS'); 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT RS.ixSOPSKU
     , 664
     , RS.sSuitSFIRating
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_racingsuits RS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = RS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE RS.sSuitSFIRating IS NOT NULL; 

SELECT RS.ixSOPSKU 
     , RS.sSuitSFIRating
     , SA.sValue
FROM tmp.tmp_racingsuits RS
LEFT JOIN SKUAttribute SA ON SA.ixSKU = RS.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 664
  AND (SA.sValue != RS.sSuitSFIRating 
   OR SA.sValue IS NULL
       OR SA.sValue = '');

DELETE FROM SKUAttribute
WHERE sValue = '' 
  AND SKUAttribute.ixTemplateAttributeId = 664;
  
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_racingsuits
WHERE ixSOPSKU = '124614-BLK-L';

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '124614-BLK-L';

SELECT TemplateAttribute.* 
FROM odsLive.SKUAttribute
JOIN TemplateAttribute ON TemplateAttribute.ixTemplateAttributeId = SKUAttribute.ixTemplateAttributeId
WHERE ixSKU = '124614-BLK-L';


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
WHERE sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31 
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44 
   OR sTitle = 'Hole Diameter' -- measurement/size/length, 5 -- Template ID 82
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle = 'Thread Pitch' -- text, 1 -- Template ID 142
   OR sTitle = 'Threads' -- dropdown box, 4 -- Template ID 145  
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMaterialType, sFinish, sColor, etc. 

SELECT * 
FROM tmp.tmp_heimjoints;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_heimjoints
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixColor INT AFTER sColor
,ADD ixThreads INT AFTER sThreads;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_heimjoints CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_heimjoints, AttributeDropdownItem
SET tmp.tmp_heimjoints.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_heimjoints.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_heimjoints
WHERE ixColor IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_heimjoints, AttributeDropdownItem
SET tmp.tmp_heimjoints.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_heimjoints.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_heimjoints
WHERE ixMaterialType IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_heimjoints, AttributeDropdownItem
SET tmp.tmp_heimjoints.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_heimjoints.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_heimjoints
WHERE ixFinish IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_heimjoints, AttributeDropdownItem
SET tmp.tmp_heimjoints.ixThreads = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_heimjoints.sThreads = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 145; 

SELECT *
FROM tmp.tmp_heimjoints
WHERE ixThreads IS NULL; -- All records updated that had values 

ALTER TABLE tmp.tmp_heimjoints
 ADD ixUnitID INT AFTER sHoleDiameter;
 
UPDATE tmp.tmp_heimjoints
SET ixUnitID = 6 
WHERE sHoleDiameter IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HJ.ixSOPSKU
     , 36
     , HJ.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_heimjoints HJ
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HJ.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HJ.ixColor IS NOT NULL
  AND HJ.ixColor <> 36; 

SELECT HJ.ixSOPSKU 
     , HJ.ixColor
     , SA.sValue
FROM tmp.tmp_heimjoints HJ 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = HJ.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 36
  AND (SA.sValue != HJ.ixColor
       OR SA.sValue IS NULL
       OR SA.sValue = ''); 
-- update after talking to wyatt  whether 150020 is red (38) or > black (181) < and whether 1750128 is > no color listed (36) < or silver (273) 

UPDATE SKUAttribute, tmp.tmp_heimjoints HJ 
SET sValue = HJ.ixColor
WHERE SKUAttribute.ixSKU = HJ.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 36
  AND SKUAttribute.ixAttributeTypeId = 4
  AND ixSOPSKU IN ('150020'); 
  
SELECT * FROM SKUAttribute WHERE ixSKU = '1750128'  AND SKUAttribute.ixTemplateAttributeId = 36 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HJ.ixSOPSKU
     , 31
     , HJ.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_heimjoints HJ
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HJ.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HJ.ixMaterialType IS NOT NULL
  AND HJ.ixMaterialType <> 31; 
  
SELECT HJ.ixSOPSKU 
     , HJ.ixMaterialType
     , SA.sValue
FROM tmp.tmp_heimjoints HJ 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = HJ.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 31
  AND (SA.sValue != HJ.ixMaterialType
  OR SA.sValue IS NULL
       OR SA.sValue = ''); 
-- update after talking to wyatt whether these are > 153 = chromoly < or 33 = steel   

UPDATE SKUAttribute, tmp.tmp_heimjoints HJ 
SET sValue = HJ.ixMaterialType 
WHERE SKUAttribute.ixSKU = HJ.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 31
  AND SKUAttribute.ixAttributeTypeId = 4
  AND ixSOPSKU IN ('1750806', '1750807', '7211016-RH', '7211016-LH'); 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HJ.ixSOPSKU
     , 82
     , HJ.sHoleDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , HJ.ixUnitID  
FROM tmp.tmp_heimjoints HJ
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HJ.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HJ.sHoleDiameter IS NOT NULL;

SELECT HJ.ixSOPSKU 
     , HJ.sHoleDiameter 
     , SA.sValue
FROM tmp.tmp_heimjoints HJ 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = HJ.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 82
  AND (SA.sValue != HJ.sHoleDiameter
  OR SA.sValue IS NULL
       OR SA.sValue = ''); -- change remaining SKU after verifying with Wyatt whether 150017 is .6250 hole diameter or .38 >>> '0.3750'

DELETE FROM SKUAttribute
WHERE ixTemplateAttributeId = 82 
  AND sValue = '';

UPDATE SKUAttribute, tmp.tmp_heimjoints HJ 
SET sValue = HJ.sHoleDiameter
WHERE SKUAttribute.ixSKU = HJ.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 82 
  AND SKUAttribute.ixAttributeTypeId = 5
  AND ixSOPSKU IN ('150020', '150019', '7211016-RH', '7211016-LH', '1750216'); 
  
UPDATE SKUAttribute
SET sValue = '0.3750'
WHERE ixSKU = '150017'
  AND ixTemplateAttributeId = 82;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HJ.ixSOPSKU
     , 142
     , HJ.sThreadPitch
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_heimjoints HJ
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HJ.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HJ.sThreadPitch IS NOT NULL;  

SELECT HJ.ixSOPSKU 
     , HJ.sThreadPitch
     , SA.sValue
FROM tmp.tmp_heimjoints HJ 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = HJ.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 142
  AND (SA.sValue != HJ.sThreadPitch
  OR SA.sValue IS NULL
       OR SA.sValue = ''); -- talk to wyatt about whether 150007 R/L should be > 5/8"-18 < or -16
  
UPDATE SKUAttribute, tmp.tmp_heimjoints HJ 
SET sValue = HJ.sThreadPitch
WHERE SKUAttribute.ixSKU = HJ.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 142
  AND SKUAttribute.ixAttributeTypeId = 1
  AND ixSOPSKU IN ('150007-R', '150007-L');   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HJ.ixSOPSKU
     , 44
     , HJ.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_heimjoints HJ
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HJ.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HJ.ixFinish IS NOT NULL
  AND HJ.ixFinish <> 44; 
  
SELECT HJ.ixSOPSKU 
     , HJ.ixFinish
     , SA.sValue
FROM tmp.tmp_heimjoints HJ 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = HJ.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 44
  AND (SA.sValue != HJ.ixFinish
  OR SA.sValue IS NULL
       OR SA.sValue = '');  
  -- whether the following SKUs (7211016-RH, 7211016-LH, 1750101, 1750201, 1750210, 1750211, 1750216, 1750757, 1750327) should be natural (176) or > zinc (125) <
  -- whether the following SKUs (91002158, 91002159) should be > andodized (87) < or painted (81) 
  -- whether 1750806 should be > black oxide (306) < or painted (81) 
  -- whether 91002125 should be > chrome (85) < or zinc (125) 
  -- whether 91002346 should be > chrome (85) < or natural (176) 
  
UPDATE SKUAttribute, tmp.tmp_heimjoints HJ 
SET sValue = HJ.ixFinish
WHERE SKUAttribute.ixSKU = HJ.ixSOPSKU
  AND SKUAttribute.ixTemplateAttributeId = 44
  AND SKUAttribute.ixAttributeTypeId = 4
  AND ixSOPSKU IN ('91002158', '91002159', '91002125', '91002346', '1750806');     
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT HJ.ixSOPSKU
     , 145
     , HJ.ixThreads
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_heimjoints HJ
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = HJ.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE HJ.ixThreads IS NOT NULL
  AND HJ.ixThreads <> 145; 

  
SELECT HJ.ixSOPSKU 
     , HJ.ixThreads
     , SA.sValue
FROM tmp.tmp_heimjoints HJ 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = HJ.ixSOPSKU
WHERE SA.ixTemplateAttributeId = 145
  AND (SA.sValue != HJ.ixThreads
  OR SA.sValue IS NULL
       OR SA.sValue = '');  
  
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_heimjoints;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '150020';

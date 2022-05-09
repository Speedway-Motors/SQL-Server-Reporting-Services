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
WHERE sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle = 'Sold in Quantity' -- dropdown box, 4 -- Template ID 41 
   OR sTitle = 'Transmission Speeds' -- dropdown box, 4 -- Template ID 663
   OR sTitle = 'Overall Diameter' -- measurement/size/length, 5 -- Template ID 80
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Garage Sale' -- yes/no, 2 -- Template ID 490 sTitle 
   OR sTitle = 'Thread Pitch' -- text, 1 -- Template ID 142
   OR sTitle = 'Threads' -- dropdown box, 4 -- Template ID 145
   OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_shiftknobs;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_shiftknobs
 ADD ixMaterialType INT AFTER sMaterialType 
,ADD ixColor INT AFTER sColor
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity 
,ADD ixUnitId INT AFTER sOverallDiameter
,ADD ixThreads INT AFTER sThreads
,ADD ixGarageSale INT AFTER sGarageSale
,ADD ixTransmissionSpeeds INT AFTER sTransmissionSpeeds;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shiftknobs CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
-- Update the values for transmission speeds 
UPDATE tmp.tmp_shiftknobs, AttributeDropdownItem
SET tmp.tmp_shiftknobs.ixTransmissionSpeeds = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftknobs.sTransmissionSpeeds = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 663; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_shiftknobs
WHERE ixTransmissionSpeeds IS NULL; -- all values updated 

-- Update the values for additional fields  
UPDATE tmp.tmp_shiftknobs, AttributeDropdownItem
SET tmp.tmp_shiftknobs.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftknobs.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_shiftknobs
WHERE ixMaterialType IS NULL; -- all values updated 

UPDATE tmp.tmp_shiftknobs, AttributeDropdownItem
SET tmp.tmp_shiftknobs.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftknobs.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 
   
SELECT *
FROM tmp.tmp_shiftknobs
WHERE ixColor IS NULL; -- all values updated 

UPDATE tmp.tmp_shiftknobs, AttributeDropdownItem
SET tmp.tmp_shiftknobs.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftknobs.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_shiftknobs
WHERE ixSoldinQuantity IS NULL; -- All records updated

UPDATE tmp.tmp_shiftknobs, AttributeDropdownItem
SET tmp.tmp_shiftknobs.ixThreads = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftknobs.sThreads = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 145; 

SELECT *
FROM tmp.tmp_shiftknobs
WHERE ixThreads IS NULL; -- All records are blank / null 

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_shiftknobs
SET ixGarageSale = 0
WHERE sGarageSale = 'No';

UPDATE tmp.tmp_shiftknobs
SET ixGarageSale = 1
WHERE sGarageSale = 'Yes';

UPDATE tmp.tmp_shiftknobs
SET ixUnitId = 6 
WHERE sOverallDiameter IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 31
     , SK.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 36
     , SK.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 41
     , SK.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 80
     , SK.sOverallDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , SK.ixUnitId  
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 142
     , SK.sThreadPitch
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 145
     , SK.ixThreads
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SK.ixThreads IS NOT NULL;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 325
     , SK.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 490
     , SK.ixGarageSale
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 663
     , SK.ixTransmissionSpeeds
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SK.ixTransmissionSpeeds IS NOT NULL;


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))

SELECT *
FROM tmp.tmp_shiftknobs;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491SK6890'

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
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44   
   OR sTitle = 'Transmission Speeds' -- dropdown box, 4 -- Template ID 663
   OR sTitle = 'Diameter' -- measurement/size/length, 5 -- Template ID 106
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Garage Sale' -- yes/no, 2 -- Template ID 490 sTitle 
   OR sTitle = 'Thread Pitch' -- text, 1 -- Template ID 142
   OR sTitle = 'Threads' -- dropdown box, 4 -- Template ID 145
   OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_shiftleverknobs;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_shiftleverknobs
 ADD ixMaterialType INT AFTER sMaterialType 
,ADD ixColor INT AFTER sColor
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity 
,ADD ixFinish INT AFTER sFinish
,ADD ixUnitId INT AFTER sDiameter
,ADD ixThreads INT AFTER sThreads
,ADD ixGarageSale INT AFTER sGarageSale
,ADD ixTransmissionSpeeds INT AFTER sTransmissionSpeeds;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shiftleverknobs CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
-- Update the values for Cable Housing  
UPDATE tmp.tmp_shiftleverknobs, AttributeDropdownItem
SET tmp.tmp_shiftleverknobs.ixTransmissionSpeeds = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftleverknobs.sTransmissionSpeeds = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 663; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_shiftleverknobs
WHERE ixTransmissionSpeeds IS NULL; -- all values updated that should have (excludes 0 kept as null)  

-- Update the values for additional fields  
UPDATE tmp.tmp_shiftleverknobs, AttributeDropdownItem
SET tmp.tmp_shiftleverknobs.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftleverknobs.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_shiftleverknobs
WHERE ixMaterialType IS NULL; -- 5 values did not update 

-- If all values do not update look at the values in the stored tables and determine if text values match / need to be changed 
-- see example below 
SELECT *
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 31; -- Polypropylene -- ask Jeremy if this value is correct and have him add it to his side if it is;  then it will be available to me 

-- Repeat update statement -- all values updated after polypropylene was added 

UPDATE tmp.tmp_shiftleverknobs, AttributeDropdownItem
SET tmp.tmp_shiftleverknobs.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftleverknobs.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 
   
SELECT *
FROM tmp.tmp_shiftleverknobs
WHERE ixColor IS NULL; -- 1 value did not update for SKU 491SK6886 listed as White/Red - PER JGO changed to 'White' only

SELECT *
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 36; 

-- Repeat update statement -- all values updated after the color was changed 

UPDATE tmp.tmp_shiftleverknobs, AttributeDropdownItem
SET tmp.tmp_shiftleverknobs.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftleverknobs.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_shiftleverknobs
WHERE ixSoldinQuantity IS NULL; -- All records updated

UPDATE tmp.tmp_shiftleverknobs, AttributeDropdownItem
SET tmp.tmp_shiftleverknobs.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftleverknobs.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_shiftleverknobs
WHERE ixFinish IS NULL; -- All records updated

UPDATE tmp.tmp_shiftleverknobs, AttributeDropdownItem
SET tmp.tmp_shiftleverknobs.ixThreads = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftleverknobs.sThreads = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 145; 

SELECT *
FROM tmp.tmp_shiftleverknobs
WHERE ixThreads IS NULL; -- All records updated

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_shiftleverknobs
SET ixGarageSale = 0
WHERE sGarageSale = 'No';

UPDATE tmp.tmp_shiftleverknobs
SET ixGarageSale = 1
WHERE sGarageSale = 'Yes';

UPDATE tmp.tmp_shiftleverknobs
SET ixUnitId = 6 
WHERE sDiameter IS NOT NULL; 

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
FROM tmp.tmp_shiftleverknobs SK 
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
FROM tmp.tmp_shiftleverknobs SK 
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
FROM tmp.tmp_shiftleverknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 44
     , SK.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftleverknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SK.ixSOPSKU
     , 106
     , SK.sDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , SK.ixUnitId  
FROM tmp.tmp_shiftleverknobs SK 
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
FROM tmp.tmp_shiftleverknobs SK 
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
FROM tmp.tmp_shiftleverknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID; -- column value can not be null; left blank? 

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
FROM tmp.tmp_shiftleverknobs SK 
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
FROM tmp.tmp_shiftleverknobs SK 
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
FROM tmp.tmp_shiftleverknobs SK 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SK.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SK.ixTransmissionSpeeds IS NOT NULL;


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))

SELECT *
FROM tmp.tmp_shiftleverknobs;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491SK6916'

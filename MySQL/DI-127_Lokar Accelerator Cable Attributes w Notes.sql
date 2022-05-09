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
   OR sTitle = 'Cable length' -- measurement/size/length, 5 -- Template ID 161
   OR sTitle = 'Hardware Included' -- Yes/No, 2 -- Template ID 243
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Garage Sale' -- yes/no, 2 -- Template ID 490 sTitle 
   OR sTitle = 'Cable Housing' -- dropdown box, 4 -- Template ID 661
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_acceleratorcables;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_acceleratorcables
 ADD ixColor INT AFTER sColor
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity 
,ADD ixFinish INT AFTER sFinish
,ADD ixUnitId INT AFTER sCableLength
,ADD ixHardwareIncluded INT AFTER sHardwareIncluded
,ADD ixGarageSale INT AFTER sGarageSale
,ADD ixCableHousing INT AFTER sCableHousing;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_acceleratorcables CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
-- Update the values for Cable Housing  
UPDATE tmp.tmp_acceleratorcables, AttributeDropdownItem
SET tmp.tmp_acceleratorcables.ixCableHousing = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_acceleratorcables.sCableHousing = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 661; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_acceleratorcables
WHERE ixCableHousing IS NULL; -- all values updated 

-- Update the values for additional fields  
UPDATE tmp.tmp_acceleratorcables, AttributeDropdownItem
SET tmp.tmp_acceleratorcables.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_acceleratorcables.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_acceleratorcables
WHERE ixFinish IS NULL; -- all values updated 

-- If all values do not update look at the values in the stored tables and determine if text values match / need to be changed 
-- see example below 
SELECT *
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 658;

UPDATE tmp.tmp_acceleratorcables
SET sNumberofBends = 'No Bends' 
WHERE sNumberofBends = 'No Bend';


-- Repeat update statement

UPDATE tmp.tmp_acceleratorcables, AttributeDropdownItem
SET tmp.tmp_acceleratorcables.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_acceleratorcables.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 
   
SELECT *
FROM tmp.tmp_acceleratorcables
WHERE ixColor IS NULL; -- all values updated 


UPDATE tmp.tmp_acceleratorcables, AttributeDropdownItem
SET tmp.tmp_acceleratorcables.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_acceleratorcables.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_acceleratorcables
WHERE ixSoldinQuantity IS NULL; -- All records updated

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_acceleratorcables
SET ixHardwareIncluded = 0
WHERE sHardwareIncluded = 'No';

UPDATE tmp.tmp_acceleratorcables
SET ixHardwareIncluded = 1
WHERE sHardwareIncluded = 'Yes';


UPDATE tmp.tmp_acceleratorcables
SET ixGarageSale = 0
WHERE sGarageSale = 'No';

UPDATE tmp.tmp_acceleratorcables
SET ixGarageSale = 1
WHERE sGarageSale = 'Yes';

UPDATE tmp.tmp_acceleratorcables
SET ixUnitId = 6 
WHERE sCableLength IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 36
     , AC.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 41
     , AC.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 44
     , AC.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 161
     , AC.sCableLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , AC.ixUnitId  
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 243
     , AC.ixHardwareIncluded
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 325
     , AC.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 490
     , AC.ixGarageSale
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT AC.ixSOPSKU
     , 661
     , AC.ixCableHousing
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_acceleratorcables AC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = AC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))

SELECT *
FROM tmp.tmp_acceleratorcables;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491TC1000LS196U'

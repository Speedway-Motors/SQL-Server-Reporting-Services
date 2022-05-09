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
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Garage Sale' -- yes/no, 2 -- Template ID 490 
   OR sTitle = 'Dipstick Mount Style' -- dropdown box, 4 -- Template ID 662   
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_dipsticks;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_dipsticks
 ADD ixColor INT AFTER sColor
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity 
,ADD ixFinish INT AFTER sFinish
,ADD ixGarageSale INT AFTER sGarageSale
,ADD ixDipstickMountStyle INT AFTER sDipstickMountStyle;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_dipsticks CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
-- Update the values for material type
UPDATE tmp.tmp_dipsticks, AttributeDropdownItem
SET tmp.tmp_dipsticks.ixDipstickMountStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dipsticks.sDipstickMountStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 662; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_dipsticks
WHERE ixDipstickMountStyle IS NULL; -- all values updated 

DELETE FROM tmp.tmp_dipsticks WHERE tmp_dipsticks_id2 = 30; -- this delete statement was needed because a row was added with no data/SKU 

-- Update the values for additional fields  

UPDATE tmp.tmp_dipsticks, AttributeDropdownItem
SET tmp.tmp_dipsticks.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dipsticks.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 
   
SELECT *
FROM tmp.tmp_dipsticks
WHERE ixColor IS NULL; -- all values updated 

UPDATE tmp.tmp_dipsticks, AttributeDropdownItem
SET tmp.tmp_dipsticks.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dipsticks.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_dipsticks
WHERE ixSoldinQuantity IS NULL; -- All records updated

UPDATE tmp.tmp_dipsticks, AttributeDropdownItem
SET tmp.tmp_dipsticks.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_dipsticks.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_dipsticks
WHERE ixFinish IS NULL; -- All records updated

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_dipsticks
SET ixGarageSale = 0
WHERE sGarageSale = 'No';

UPDATE tmp.tmp_dipsticks
SET ixGarageSale = 1
WHERE sGarageSale = 'Yes';

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT D.ixSOPSKU
     , 36
     , D.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_dipsticks D 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = D.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT D.ixSOPSKU
     , 41
     , D.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_dipsticks D 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = D.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT D.ixSOPSKU
     , 44
     , D.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_dipsticks D 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = D.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT D.ixSOPSKU
     , 325
     , D.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_dipsticks D 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = D.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT D.ixSOPSKU
     , 490
     , D.ixGarageSale
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_dipsticks D
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = D.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT D.ixSOPSKU
     , 662
     , D.ixDipstickMountStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_dipsticks D
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = D.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE D.ixDipstickMountStyle IS NOT NULL;


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_dipsticks;

-- Check TNG -- Trigger worked 
SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491ED500212'

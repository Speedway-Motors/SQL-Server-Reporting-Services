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
WHERE sTitle LIKE 'Material Type' -- dropdown box, 4 -- Template ID 31
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle LIKE 'Sold in Quantity' -- dropdown box, 4 -- Template ID 41 
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44   
   OR sTitle = 'Length' -- measurement/size/length, 5 -- Template ID 623
   OR sTitle LIKE 'Width' -- measurement/size/length, 5 -- Template ID 105   
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Garage Sale' -- yes/no, 2 -- Template ID 490 
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_pedalpadsets;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_pedalpadsets
 ADD ixMaterialType INT AFTER sMaterialType 
,ADD ixColor INT AFTER sColor
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity 
,ADD ixFinish INT AFTER sFinish
,ADD ixUnitId INT AFTER sLength
,ADD ixUnitId2 INT AFTER sWidth
,ADD ixGarageSale INT AFTER sGarageSale;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_pedalpadsets CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
-- Update the values for material type
UPDATE tmp.tmp_pedalpadsets, AttributeDropdownItem
SET tmp.tmp_pedalpadsets.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_pedalpadsets.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_pedalpadsets
WHERE ixMaterialType IS NULL; -- all values updated 

-- Update the values for additional fields  

UPDATE tmp.tmp_pedalpadsets, AttributeDropdownItem
SET tmp.tmp_pedalpadsets.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_pedalpadsets.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 
   
SELECT *
FROM tmp.tmp_pedalpadsets
WHERE ixColor IS NULL; -- all values updated 

UPDATE tmp.tmp_pedalpadsets, AttributeDropdownItem
SET tmp.tmp_pedalpadsets.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_pedalpadsets.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_pedalpadsets
WHERE ixSoldinQuantity IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_pedalpadsets, AttributeDropdownItem
SET tmp.tmp_pedalpadsets.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_pedalpadsets.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_pedalpadsets
WHERE ixFinish IS NULL; -- all values updated  

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_pedalpadsets
SET ixGarageSale = 0
WHERE sGarageSale = 'No';

UPDATE tmp.tmp_pedalpadsets
SET ixGarageSale = 1
WHERE sGarageSale = 'Yes';

UPDATE tmp.tmp_pedalpadsets
SET ixUnitId = 6 
WHERE sLength IS NOT NULL; 

UPDATE tmp.tmp_pedalpadsets
SET ixUnitId2 = 6 
WHERE sWidth IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 31
     , PPS.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_pedalpadsets PPS 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 36
     , PPS.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_pedalpadsets PPS 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 41
     , PPS.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_pedalpadsets PPS 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE ixSoldinQuantity IS NOT NULL;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 44
     , PPS.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_pedalpadsets PPS 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 623
     , PPS.sLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , PPS.ixUnitId  
FROM tmp.tmp_pedalpadsets PPS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 105
     , PPS.sWidth
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , PPS.ixUnitId2  
FROM tmp.tmp_pedalpadsets PPS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 325
     , PPS.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_pedalpadsets PPS 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT PPS.ixSOPSKU
     , 490
     , PPS.ixGarageSale
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_pedalpadsets PPS 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = PPS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_pedalpadsets;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491XBAG6121'

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
WHERE sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44 
   OR sTitle = 'Material Type' -- dropdown box, 4 -- Template ID 31 
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_crankhandles;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_crankhandles
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixColor INT AFTER sColor;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_crankhandles CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_crankhandles, AttributeDropdownItem
SET tmp.tmp_crankhandles.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_crankhandles.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_crankhandles
WHERE ixMaterialType IS NULL; -- All records updated that had values 

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 31; -- Ask JGO about "Raw Steel" 

UPDATE tmp.tmp_crankhandles, AttributeDropdownItem
SET tmp.tmp_crankhandles.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_crankhandles.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 

SELECT *
FROM tmp.tmp_crankhandles
WHERE ixMaterialType IS NULL; -- All records updated that had values 

UPDATE tmp.tmp_crankhandles, AttributeDropdownItem
SET tmp.tmp_crankhandles.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_crankhandles.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_crankhandles
WHERE ixMaterialType IS NULL; -- All records updated that had values 
-- Now the records need to be inserted into the SKU Attribute table 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT CH.ixSOPSKU
     , 31
     , CH.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_crankhandles CH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = CH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT CH.ixSOPSKU
     , 36
     , CH.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_crankhandles CH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = CH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT CH.ixSOPSKU
     , 44
     , CH.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_crankhandles CH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = CH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT CH.ixSOPSKU
     , 325
     , CH.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_crankhandles CH
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = CH.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_crankhandles;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491XIDH2016';

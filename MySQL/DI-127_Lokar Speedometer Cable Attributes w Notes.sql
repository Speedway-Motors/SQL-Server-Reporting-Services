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
WHERE sTitle = 'Overall Length' -- measurement/size/length, 5 -- Template ID 34
   -- OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle LIKE 'Sold in Quantity' -- dropdown box, 4 -- Template ID 41 
   -- OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44   
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Garage Sale' -- yes/no, 2 -- Template ID 490 
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_speedocables;


-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_speedocables
 ADD ixUnitId INT AFTER sOverallLength 
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity 
,ADD ixGarageSale INT AFTER sGarageSale;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_speedocables CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_speedocables, AttributeDropdownItem
SET tmp.tmp_speedocables.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_speedocables.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_speedocables
WHERE ixSoldinQuantity IS NULL; -- All records updated that had values 

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_speedocables
SET ixGarageSale = 0
WHERE sGarageSale = 'No';

UPDATE tmp.tmp_speedocables
SET ixGarageSale = 1
WHERE sGarageSale = 'Yes';

UPDATE tmp.tmp_speedocables
SET ixUnitId = 7 
WHERE sOverallLength IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SC.ixSOPSKU
     , 41
     , SC.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_speedocables SC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SC.ixSOPSKU
     , 325
     , SC.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_speedocables SC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SC.ixSOPSKU
     , 490
     , SC.ixGarageSale
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_speedocables SC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SC.ixSOPSKU
     , 34
     , SC.sOverallLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , SC.ixUnitId 
FROM tmp.tmp_speedocables SC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_speedocables;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491SP1502U108'

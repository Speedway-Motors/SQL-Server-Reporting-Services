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
WHERE sTitle = 'Cable length' -- measurement/size/length, 5 -- Template ID 161
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_shiftercables;


-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_shiftercables
 ADD ixUnitId INT AFTER sCablelength;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shiftercables CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 

UPDATE tmp.tmp_shiftercables
SET ixUnitId = 6 
WHERE sCablelength IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

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
FROM tmp.tmp_shiftercables SC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SC.ixSOPSKU
     , 161
     , SC.sCablelength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , SC.ixUnitId 
FROM tmp.tmp_shiftercables SC 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- These SKUs do not exist in TNG/PMS and PER JGO skip over them for now and Merchandising will update later 
DELETE FROM SKUAttribute
WHERE ixSKU IN ('491KDP2350HTBLACK' , '491KD2350HTBLACK60');


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_shiftercables; -- SKUs are missing from TNG/Product manager (i.e. 491KD2350HTBLACK60) why?? 

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491KDP20C6HT';


-- '491KDP2350HTBLACK' and '491KD2350HTBLACK60' do not exist in TNG or PMS 

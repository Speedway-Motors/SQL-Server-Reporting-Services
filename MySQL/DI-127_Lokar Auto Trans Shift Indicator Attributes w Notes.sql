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
WHERE sTitle LIKE 'Neutral Safety%' -- Yes/No, 2 -- Template ID 660
  ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_shiftindicators;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_shiftindicators
 ADD ixNeutralSafetySwitchIncluded INT AFTER sNeutralSafetySwitchIncluded; 


-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shiftindicators CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   


-- Update the values for additional fields  

UPDATE tmp.tmp_shiftindicators, AttributeDropdownItem
SET tmp.tmp_shiftindicators.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftindicators.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 
   

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_shiftindicators
SET ixNeutralSafetySwitchIncluded = 0
WHERE sNeutralSafetySwitchIncluded = 'No';

UPDATE tmp.tmp_shiftindicators
SET ixNeutralSafetySwitchIncluded = 1
WHERE sNeutralSafetySwitchIncluded = 'Yes';

SELECT *
FROM tmp.tmp_shiftindicators 
WHERE ixNeutralSafetySwitchIncluded IS NULL; 
-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SI.ixSOPSKU
     , 325
     , SI.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftindicators SI
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SI.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SI.ixSOPSKU
     , 660
     , SI.ixNeutralSafetySwitchIncluded
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftindicators SI 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SI.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;


SELECT *
FROM SKUAttribute
WHERE SKUAttribute.ixTemplateAttributeId = 660
  AND SKUAttribute.ixAttributeTypeId = 2 
  AND SKUAttribute.ixCreateUser = 'SPEEDWAYMOTORS\ascrook'
  AND EXTRACT(DAY FROM dtCreate) = 22
ORDER BY sValue;

-- I forgot to include NULL values while doing the above insert. Usually it would not allow this to occur but instead this inserted blank values into the field
-- which was breaking the SKU in product manager. A delete was done to remove these few records with that attribute tie. 
DELETE FROM SKUAttribute
WHERE ixSKU IN ('491XCINB1779', '491XCINB1736', '491XCINB1758', '491XCIND1716', '491CINS17001', '491CINS1798', '491CINS1799'
                '491CINS17002', '491CINR1796', '491CINB1792', '491CINB1760', '491CINB1791', '491CIND1727', '491CINS17003', '491CIND1728', '491XCINB1792')
  AND SKUAttribute.ixTemplateAttributeId = 660 
  AND EXTRACT(DAY FROM dtCreate) = 22; 

-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_shiftindicators
WHERE ixNeutralSafetySwitchIncluded IS NOT NULL;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491CINB1783'

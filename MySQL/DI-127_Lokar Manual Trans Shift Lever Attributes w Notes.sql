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
   OR sTitle = 'Color' -- dropdown box, 4 -- Template ID 36 
   OR sTitle = 'Sold in Quantity' -- dropdown box, 4 -- Template ID 41 
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44   
   OR sTitle = 'Arm Length' -- measurement/size/length, 5 -- Template ID 195
   OR sTitle = 'MFG. Part #' -- text, 1 -- 325 
   OR sTitle = 'Garage Sale' -- yes/no, 2 -- Template ID 490 
   OR sTitle = 'Number of Bends' -- dropdown box, 4 -- Template ID 658   
ORDER BY TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_shiftlevers;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_shiftlevers
 ADD ixMaterialType INT AFTER sMaterialType 
,ADD ixColor INT AFTER sColor
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity 
,ADD ixFinish INT AFTER sFinish
,ADD ixUnitId INT AFTER sArmLength
,ADD ixGarageSale INT AFTER sGarageSale
,ADD ixNumberofBends INT AFTER sNumberofBends;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shiftlevers CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
-- Update the values for material type
UPDATE tmp.tmp_shiftlevers, AttributeDropdownItem
SET tmp.tmp_shiftlevers.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevers.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_shiftlevers
WHERE ixMaterialType IS NULL; -- all values updated 

-- Update the values for additional fields  

UPDATE tmp.tmp_shiftlevers, AttributeDropdownItem
SET tmp.tmp_shiftlevers.ixColor = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevers.sColor = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 36; 
   
SELECT *
FROM tmp.tmp_shiftlevers
WHERE ixColor IS NULL; -- all values updated 

UPDATE tmp.tmp_shiftlevers, AttributeDropdownItem
SET tmp.tmp_shiftlevers.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevers.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_shiftlevers
WHERE ixSoldinQuantity IS NULL; -- All records updated

UPDATE tmp.tmp_shiftlevers, AttributeDropdownItem
SET tmp.tmp_shiftlevers.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevers.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_shiftlevers
WHERE ixFinish IS NULL; -- 3 records did not update where sFinish = 'Billet' 

SELECT *
FROM AttributeDropdownItem 
WHERE ixTemplateAttributeId = 44; -- ASK JGO to update value if this is correct 

UPDATE tmp.tmp_shiftlevers, AttributeDropdownItem
SET tmp.tmp_shiftlevers.ixNumberofBends = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevers.sNumberofBends = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 658; 

SELECT *
FROM tmp.tmp_shiftlevers
WHERE ixNumberofBends IS NULL; -- All records updated where a value was stored 

-- For YES/NO values simply do an update with 1/0 Values 
UPDATE tmp.tmp_shiftlevers
SET ixGarageSale = 0
WHERE sGarageSale = 'No';

UPDATE tmp.tmp_shiftlevers
SET ixGarageSale = 1
WHERE sGarageSale = 'Yes';

UPDATE tmp.tmp_shiftlevers
SET ixUnitId = 6 
WHERE sArmLength IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 31
     , SL.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevers SL 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 36
     , SL.ixColor
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevers SL 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 41
     , SL.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevers SL 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 44
     , SL.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevers SL 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 195
     , SL.sArmLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , SL.ixUnitId  
FROM tmp.tmp_shiftlevers SL
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 325
     , SL.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevers SL 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 490
     , SL.ixGarageSale
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevers SL 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SL.ixSOPSKU
     , 658
     , SL.ixNumberofBends
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevers SL 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SL.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SL.ixNumberofBends IS NOT NULL;


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_shiftlevers;

-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '491XMSL620F'

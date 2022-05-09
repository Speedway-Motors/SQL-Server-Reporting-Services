-- For each column header (attribute) it needs to be determined what "type" they are. This will be done in ODS. 

SELECT *
FROM AttributeType; -- Type 2 & 4 will be special types that will take additional steps; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'MFG. Part #' -- 325 
   OR sTitle = 'Shifter Mount Style' -- dropdown box -- Template ID 657
   OR sTitle = 'Shifter Arm Length' -- 656 
   OR sTitle = 'Number of Bends' -- dropdown box -- Template ID 658
   OR sTitle = 'Shifter Knob Style' -- dropdown box -- Template ID 659
   OR sTitle = 'Finish' -- dropdown box -- Template ID 44 
   OR sTitle = 'Neutral Safety Switch Included' -- yes/no -- Template ID 660
   OR sTitle = 'Sold in Quantity' -- dropdown box -- Template ID 41
   OR sTitle = 'Garage Sale'; -- yes/no -- Template ID 490

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 

SELECT * 
FROM tmp.tmp_shiftlevelassemblies;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_shiftlevelassemblies
ADD ixNumberofBends INT AFTER sNumberofBends
,ADD ixShifterKnobStyle INT AFTER sShifterKnobStyle
,ADD ixFinish INT AFTER sFinish
,ADD ixNeutralSafetySwitchIncluded INT AFTER sNeutralSafetySwitchIncluded 
,ADD ixSoldinQuantity INT AFTER sSoldinQuantity
,ADD ixGarageSale INT AFTER sGarageSale;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shiftlevelassemblies CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
SELECT ADI.*, SA.*
FROM tmp.tmp_shiftlevelassemblies SA
LEFT JOIN AttributeDropdownItem ADI ON ADI.sAttributeDropdownItemText = SA.sShifterMountStyle
   AND ADI.ixTemplateAttributeId = 657;
   
-- Update the values for Shifter Mount Style  
UPDATE tmp.tmp_shiftlevelassemblies, AttributeDropdownItem
SET tmp.tmp_shiftlevelassemblies.ixShifterMountStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevelassemblies.sShifterMountStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 657; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_shiftlevelassemblies
WHERE ixShifterMountStyle IS NULL; -- No values returned

-- Update the values for additional fields  
UPDATE tmp.tmp_shiftlevelassemblies, AttributeDropdownItem
SET tmp.tmp_shiftlevelassemblies.ixNumberofBends = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevelassemblies.sNumberofBends = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 658; 
   
-- Make sure everything inserted ok 
SELECT *
FROM tmp.tmp_shiftlevelassemblies
WHERE ixNumberofBends IS NULL; -- only 38 values updated 

-- If all values do not update look at the values in the stored tables and determine if text values match / need to be changed 
SELECT *
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 658;

UPDATE tmp.tmp_shiftlevelassemblies
SET sNumberofBends = 'No Bends' 
WHERE sNumberofBends = 'No Bend';

UPDATE tmp.tmp_shiftlevelassemblies
SET sNumberofBends = 'Double Bends' 
WHERE sNumberofBends = 'Double Bend';

-- Repeat update statement

UPDATE tmp.tmp_shiftlevelassemblies, AttributeDropdownItem
SET tmp.tmp_shiftlevelassemblies.ixShifterKnobStyle = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevelassemblies.sShifterKnobStyle = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 659; 
   
SELECT *
FROM tmp.tmp_shiftlevelassemblies
WHERE ixShifterKnobStyle IS NULL; -- KnobStyle 'Polished Mushroom' did not update 

SELECT *
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 659;

UPDATE tmp.tmp_shiftlevelassemblies, AttributeDropdownItem
SET tmp.tmp_shiftlevelassemblies.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevelassemblies.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44; 

SELECT *
FROM tmp.tmp_shiftlevelassemblies
WHERE ixFinish IS NULL; -- All records updated

-- For YES/NO values simply do an update with 0/1 Values 
UPDATE tmp.tmp_shiftlevelassemblies
SET ixNeutralSafetySwitchIncluded = 0
WHERE sNeutralSafetySwitchIncluded = 0;

UPDATE tmp.tmp_shiftlevelassemblies
SET ixNeutralSafetySwitchIncluded = 1
WHERE sNeutralSafetySwitchIncluded = 1;

UPDATE tmp.tmp_shiftlevelassemblies, AttributeDropdownItem
SET tmp.tmp_shiftlevelassemblies.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shiftlevelassemblies.sSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 

SELECT *
FROM tmp.tmp_shiftlevelassemblies
WHERE ixSoldinQuantity IS NULL; -- All records updated

UPDATE tmp.tmp_shiftlevelassemblies
SET ixGarageSale = 0
WHERE sGarageSale = 0;

UPDATE tmp.tmp_shiftlevelassemblies
SET ixGarageSale = 1
WHERE sGarageSale = 1;

-- Add another column to the temp table to store the unit ID for text values if needed
ALTER TABLE tmp.tmp_shiftlevelassemblies
ADD ixUnitId INT AFTER sShifterArmLength;

UPDATE tmp.tmp_shiftlevelassemblies
SET ixUnitId = 6 
WHERE sShifterArmLength IS NOT NULL; 

-- Now the records need to be inserted into the SKU Attribute table 
SELECT SA.ixSOPSKU
     , 325
     , SA.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
LIMIT 10;


INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 657
     , SA.ixShifterMountStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 325
     , SA.sMFGPartNum
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 656
     , SA.sShifterArmLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , SA.ixUnitId  
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 658
     , SA.ixNumberofBends
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 659
     , SA.ixShifterKnobStyle
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 44
     , SA.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 660
     , SA.ixNeutralSafetySwitchIncluded
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 41
     , SA.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SA.ixSOPSKU
     , 490
     , SA.ixGarageSale
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shiftlevelassemblies SA 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SA.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- Check against temp table in product manager 

SELECT *
FROM tmp.tmp_shiftlevelassemblies;

-- Check TNG -- Trigger worked 

SELECT *
FROM tblskuvariant_productgroup_attribute_value
LEFT JOIN  tblskuvariant ON tblskuvariant_productgroup_attribute_value.ixSKUVariant = tblskuvariant.ixSKUVariant
WHERE tblskuvariant.ixSOPSKU = '491ATS64R70WAN'

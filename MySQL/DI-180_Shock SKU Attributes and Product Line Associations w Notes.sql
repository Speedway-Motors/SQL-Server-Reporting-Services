SELECT * 
FROM tmp.tmp_shock_spec_data;

ALTER TABLE tmp.tmp_shock_spec_data
 ADD ixProductLine INT AFTER sProductLineTitle;
 
-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shock_spec_data CONVERT to character set latin1 collate latin1_general_cs; 

   
UPDATE tmp.tmp_shock_spec_data, tblproductline 
SET tmp.tmp_shock_spec_data.ixProductLine = tblproductline.ixProductLine
WHERE tmp.tmp_shock_spec_data.sProductLineTitle = tblproductline.sTitle; 

SELECT * 
FROM tmp.tmp_shock_spec_data
WHERE ixProductLine IS NULL; 


SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Shock Type' -- dropdown box, 4 -- Template ID 100  
   OR sTitle = 'Adjustability' -- dropdown box, 4 -- Template ID 331
   OR sTitle = 'Shock Body Material' -- dropdown box, 4 -- Template ID 335
   OR sTitle = 'Shock Body Size' -- dropdown box, 4 -- Template ID 679
   OR sTitle = 'Shock Body Type' -- dropdown box, 4 -- Template ID 678
   OR sTitle = 'Shock Stroke' -- dropdown box, 4 -- Template ID 675
   OR sTitle = 'Sold in Quantity' -- dropdown box, 4 -- Template ID 41
   OR sTitle LIKE 'MFG%' -- text, 1 -- Template ID 325
ORDER BY TA.ixTemplateAttributeId;


-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_shock_spec_data
 ADD ixShockType INT AFTER sShockType
,ADD ixAdjustability INT AFTER sAdjustability
,ADD ixShockBodyMaterial INT AFTER sShockBodyMaterial
,ADD ixShockBodySize INT AFTER sShockBodySize
,ADD ixShockBodyType INT AFTER sShockBodyType
,ADD ixShockStroke INT AFTER sShockStroke
,ADD ixSoldinQuantity INT AFTER iSoldinQuantity;

-- Update the null values for the fields just added 

UPDATE tmp.tmp_shock_spec_data, AttributeDropdownItem
SET tmp.tmp_shock_spec_data.ixShockType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data.sShockType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 100; 

SELECT DISTINCT sShockType
FROM tmp.tmp_shock_spec_data
WHERE ixShockType IS NULL; -- All records updated that had values except 'Mono tube'

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 100; -- listed as 'Mono Tube' vs. 'Mono tube' 

UPDATE tmp.tmp_shock_spec_data
SET sShockType = 'Mono Tube' 
WHERE sShockType = 'Mono tube'; 


UPDATE tmp.tmp_shock_spec_data, AttributeDropdownItem
SET tmp.tmp_shock_spec_data.ixAdjustability = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data.sAdjustability = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 331; 

SELECT DISTINCT sAdjustability
FROM tmp.tmp_shock_spec_data
WHERE ixAdjustability IS NULL; -- All records updated that had values except 'Non-adjustable'

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 331; -- listed as 'Non-Adjustable' vs. 'Non-adjustable' 

UPDATE tmp.tmp_shock_spec_data
SET sAdjustability = 'Non-Adjustable'
WHERE sAdjustability = 'Non-adjustable' ; 


UPDATE tmp.tmp_shock_spec_data, AttributeDropdownItem
SET tmp.tmp_shock_spec_data.ixShockBodyMaterial = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data.sShockBodyMaterial = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 335; 
   
SELECT DISTINCT sShockBodyMaterial
FROM tmp.tmp_shock_spec_data
WHERE ixShockBodyMaterial IS NULL; -- all records updated that had values 



UPDATE tmp.tmp_shock_spec_data, AttributeDropdownItem
SET tmp.tmp_shock_spec_data.ixShockBodySize = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data.sShockBodySize = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 679; 

SELECT DISTINCT sShockBodySize
FROM tmp.tmp_shock_spec_data
WHERE ixShockBodySize IS NULL; -- no records updated -- listed as 'Large' and 'Small' 

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 679; -- listed as 'Large Body' and 'Small Body' vs. 'Large' and 'Small' 

UPDATE tmp.tmp_shock_spec_data
SET sShockBodySize = 'Large Body'
WHERE sShockBodySize = 'Large' ; 

UPDATE tmp.tmp_shock_spec_data
SET sShockBodySize = 'Small Body'
WHERE sShockBodySize = 'Small'; 


UPDATE tmp.tmp_shock_spec_data, AttributeDropdownItem
SET tmp.tmp_shock_spec_data.ixShockBodyType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data.sShockBodyType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 678; 
   
SELECT DISTINCT sShockBodyType
FROM tmp.tmp_shock_spec_data
WHERE ixShockBodyType IS NULL;



UPDATE tmp.tmp_shock_spec_data, AttributeDropdownItem
SET tmp.tmp_shock_spec_data.ixShockStroke = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data.sShockStroke = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 675; 
   
SELECT DISTINCT sShockStroke
FROM tmp.tmp_shock_spec_data
WHERE ixShockStroke IS NULL;

SELECT *  
FROM AttributeDropdownItem
WHERE ixTemplateAttributeId = 675; 


UPDATE tmp.tmp_shock_spec_data
SET sShockStroke = '7.5'
WHERE sShockStroke = '7.50"'; 



UPDATE tmp.tmp_shock_spec_data, AttributeDropdownItem
SET tmp.tmp_shock_spec_data.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data.iSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 
   
SELECT DISTINCT iSoldinQuantity
FROM tmp.tmp_shock_spec_data
WHERE ixSoldinQuantity IS NULL;

-- Before adding attributes to final table make sure all SKUs have correctly associated product lines 
-- (any time a product line association is wrong / deleted / then re-added it breaks all the attribute associations currently existing 

ALTER TABLE tmp.tmp_shock_spec_data
ADD ixSKUBase INT AFTER ixSOPSKU; 

UPDATE tmp.tmp_shock_spec_data, tblskuvariant
SET tmp.tmp_shock_spec_data.ixSKUBase = tblskuvariant.ixSKUBase
WHERE tmp.tmp_shock_spec_data.ixSOPSKU = tblskuvariant.ixSOPSKU; -- 20237 rows affected 


SELECT * 
FROM tmp.tmp_shock_spec_data 
WHERE ixSKUBase IS NULL; -- 0 records 


SELECT *
FROM tblskubase SB
JOIN tmp.tmp_shock_spec_data PLA ON PLA.ixSKUBase = SB.ixSKUBase 
WHERE PLA.ixProductLine <> SB.ixProductLine -- none 
   OR SB.ixProductLine IS NULL; -- all values are currently null 
   
SELECT DISTINCT SB.ixSKUBase, SB.ixProductLine, SSD.ixProductLine
FROM tmp.tmp_shock_spec_data SSD
LEFT JOIN tblskubase SB ON SB.ixSKUBase = SSD.ixSKUBase; -- 2669 distinct SKU Bases 
   
UPDATE tblskubase SB, tmp.tmp_shock_spec_data
SET SB.ixProductLine = tmp.tmp_shock_spec_data.ixProductLine
WHERE SB.ixSKUBase = tmp.tmp_shock_spec_data.ixSKUBase
  AND tmp.tmp_shock_spec_data.ixSKUBase IS NOT NULL; -- 2669 rows affected 


SELECT DISTINCT ixSKUBase 
FROM tmp.tmp_shock_spec_data; -- 16984 distinct records existed 


-- Now the records need to be inserted into the SKU Attribute table 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 100
     , SSD.ixShockType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockType IS NOT NULL; -- only 7577 records inserted out of 20211 records total 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 331
     , SSD.ixAdjustability
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixAdjustability IS NOT NULL; -- only 7517 records inserted out of 20149 records total 



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 335
     , SSD.ixShockBodyMaterial
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockBodyMaterial IS NOT NULL; -- only 7607 records inserted out of 20208 records total 



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 679
     , SSD.ixShockBodySize
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockBodySize IS NOT NULL; -- only 20179 records inserted out of 20180 records total 




INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 678
     , SSD.ixShockBodyType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockBodyType IS NOT NULL; -- only 20210 records inserted out of 20211 records total 



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 675
     , SSD.ixShockStroke
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockStroke IS NOT NULL; -- only 16787 records inserted out of 16788 records total 



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 41
     , SSD.ixSoldinQuantity
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixSoldinQuantity IS NOT NULL; -- only 7570 records inserted out of 20211 records total 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 325
     , SSD.sMFGPart
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_shock_spec_data SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.sMFGPart IS NOT NULL
  AND SSD.sMFGPart <> ' '; -- only 7639 records inserted out of 20237 records total 
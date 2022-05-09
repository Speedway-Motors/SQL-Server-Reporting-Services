SELECT * 
FROM tmp.tmp_shock_spec_data_two;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_shock_spec_data_two CONVERT to character set latin1 collate latin1_general_cs; 


SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Shock Type' -- dropdown box, 4 -- Template ID 100  
   OR sTitle = 'Adjustability' -- dropdown box, 4 -- Template ID 331
   OR sTitle = 'Shock Body Material' -- dropdown box, 4 -- Template ID 335
   OR sTitle = 'Shock Body Size' -- dropdown box, 4 -- Template ID 679
   OR sTitle = 'Shock Body Type' -- dropdown box, 4 -- Template ID 678
   OR sTitle = 'Compression Valving' -- text, 1 -- Template ID 687
   OR sTitle = 'Rebound Valving' -- text, 1 -- Template ID 688
   OR sTitle = 'Coil-Over Compatible' -- yes/no, 2 -- Template ID 337    
   OR sTitle = 'Gas Pressure Adjustable' -- yes/no, 2 -- Template ID 676    
   OR sTitle = 'Shock Stroke' -- dropdown box, 4 -- Template ID 675
   OR sTitle = 'Upper Shock Mount' -- dropdown box, 4 -- Template ID 333    
   OR sTitle = 'Lower Shock Mount' -- dropdown box, 4 -- Template ID 334  
   OR sTitle = 'Mount Position' -- dropdown box, 4 -- Template ID 682
   OR sTitle = 'External Canister' -- yes/no, 2 -- Template ID 680  
   OR sTitle = 'Extended Length' -- measurement/size/length, 5 -- Template ID 98
   OR sTitle = 'Compressed Length' -- measurement/size/length, 5 -- Template ID 99      
   OR sTitle = 'Body Diameter' -- measurement/size/length, 5 -- Template ID 302      
   OR sTitle = 'Rebuildable' -- yes/no, 2 -- Template ID 677    
   OR sTitle = 'Finish' -- dropdown box, 4 -- Template ID 44       
   OR sTitle = 'Bushing Material' -- dropdown box, 4 -- Template ID 301
   OR sTitle = 'Bushing Diameter' -- measurement/size/length, 5 -- Template ID 224     
   OR sTitle = 'Sold in Quantity' -- dropdown box, 4 -- Template ID 41
   OR sTitle LIKE 'MFG%' -- text, 1 -- Template ID 325
ORDER BY ixAttributeTypeId -- TA.ixTemplateAttributeId;


-- Insert additional columns for all 2/4 types to store the correct text value ID and 5 types insert a unique unit ID column

ALTER TABLE tmp.tmp_shock_spec_data_two
 ADD ixShockType INT AFTER sShockType
,ADD ixAdjustability INT AFTER sAdjustability
,ADD ixShockBodyMaterial INT AFTER sShockBodyMaterial
,ADD ixShockBodySize INT AFTER sShockBodySize
,ADD ixShockBodyType INT AFTER sShockBodyType
,ADD ixCoiloverCompatible INT AFTER sCoiloverCompatible
,ADD ixGasPressureAdjustable INT AFTER sGasPressureAdjustable
,ADD ixShockStroke INT AFTER sShockStroke
,ADD ixUpperShockMount INT AFTER sUpperShockMount
,ADD ixLowerShockMount INT AFTER sLowerShockMount
,ADD ixMountPosition INT AFTER sMountPosition
,ADD ixExternalCanister INT AFTER sExternalCanister 
,ADD ixUnitId1 INT AFTER sExtendedLength
,ADD ixUnitId2 INT AFTER sCompressedLength
,ADD ixUnitId3 INT AFTER sBodyDiameter
,ADD ixRebuildable INT AFTER sRebuildable
,ADD ixFinish INT AFTER sFinish
,ADD ixBushingMaterial INT AFTER sBushingMaterial
,ADD ixUnitId4 INT AFTER sBushingDiameter
,ADD ixSoldinQuantity INT AFTER iSoldinQuantity;

-- Update the null values for the fields just added 

UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixShockType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sShockType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 100; 

SELECT DISTINCT sShockType
FROM tmp.tmp_shock_spec_data_two
WHERE ixShockType IS NULL; -- All records updated that had values 


UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixAdjustability = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sAdjustability = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 331; 

SELECT DISTINCT sAdjustability
FROM tmp.tmp_shock_spec_data_two
WHERE ixAdjustability IS NULL; -- All records updated that had values 


UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixShockBodyMaterial = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sShockBodyMaterial = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 335; 
   
SELECT DISTINCT sShockBodyMaterial
FROM tmp.tmp_shock_spec_data_two
WHERE ixShockBodyMaterial IS NULL; -- all records updated that had values 


UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixShockBodySize = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sShockBodySize = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 679; 

SELECT DISTINCT sShockBodySize
FROM tmp.tmp_shock_spec_data_two
WHERE ixShockBodySize IS NULL; -- no records updated -- listed as 'Large' and 'Small' 

UPDATE tmp.tmp_shock_spec_data_two
SET sShockBodySize = 'Large Body'
WHERE sShockBodySize = 'Large' ; 


UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixShockBodyType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sShockBodyType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 678; 
   
SELECT DISTINCT sShockBodyType
FROM tmp.tmp_shock_spec_data_two
WHERE ixShockBodyType IS NULL;



UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixCoiloverCompatible = 1  
WHERE tmp.tmp_shock_spec_data_two.sCoiloverCompatible = 'Yes';  

UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixCoiloverCompatible = 0  
WHERE tmp.tmp_shock_spec_data_two.sCoiloverCompatible = 'No';  
   
SELECT DISTINCT sCoiloverCompatible
FROM tmp.tmp_shock_spec_data_two
WHERE ixCoiloverCompatible IS NULL;



UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixGasPressureAdjustable = 1  
WHERE tmp.tmp_shock_spec_data_two.sGasPressureAdjustable = 'Yes';  

UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixGasPressureAdjustable = 0  
WHERE tmp.tmp_shock_spec_data_two.sGasPressureAdjustable = 'No';  
   
SELECT DISTINCT sGasPressureAdjustable
FROM tmp.tmp_shock_spec_data_two
WHERE ixGasPressureAdjustable IS NULL;



UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixShockStroke = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sShockStroke = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 675; 
   
SELECT DISTINCT sShockStroke
     , COUNT(DISTINCT ixSOPSKU) AS Cnt 
FROM tmp.tmp_shock_spec_data_two
WHERE ixShockStroke IS NULL
GROUP BY sShockStroke; -- values of sShockStroke IN ('c' (1), '4.25' (196), '8.04' (197), '4.1' (2)) -- verify with Tyler whether these values should be inserted


UPDATE tmp.tmp_shock_spec_data_two
SET sShockStroke = '8'
WHERE sShockStroke = '8.04' ; 



UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixUpperShockMount = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sUpperShockMount = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 333; 
   
SELECT DISTINCT sUpperShockMount
FROM tmp.tmp_shock_spec_data_two
WHERE ixUpperShockMount IS NULL; -- 'T-bar' value not found  -- verify with Tyler whether this value needs to be changed to 'Tie Bar' or added to the attribute list 


UPDATE tmp.tmp_shock_spec_data_two
SET sUpperShockMount = 'Tie Bar'
WHERE sUpperShockMount = 'T-bar' ; 



UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixLowerShockMount = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sLowerShockMount = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 334; 
   
SELECT DISTINCT sLowerShockMount
FROM tmp.tmp_shock_spec_data_two
WHERE ixLowerShockMount IS NULL; 

UPDATE tmp.tmp_shock_spec_data_two 
SET sLowerShockMount = '5/8 Inch Sleeve'
WHERE sLowerShockMount = '5-8 Inch Sleee';


UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixMountPosition = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sMountPosition = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 682; 
   
SELECT DISTINCT sMountPosition
FROM tmp.tmp_shock_spec_data_two
WHERE ixMountPosition IS NULL; 


UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixExternalCanister = 1  
WHERE tmp.tmp_shock_spec_data_two.sExternalCanister = 'Yes';  

UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixExternalCanister = 0  
WHERE tmp.tmp_shock_spec_data_two.sExternalCanister = 'No';  
   
SELECT DISTINCT sExternalCanister
FROM tmp.tmp_shock_spec_data_two
WHERE ixExternalCanister IS NULL;


UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixUnitId1 = 6  -- inches 
WHERE tmp.tmp_shock_spec_data_two.sExtendedLength <> '';  

SELECT *
FROM tmp.tmp_shock_spec_data_two
WHERE sExtendedLength <> ''; -- 10,270 records don't have values, 12299 do have values 



UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixUnitId2 = 6  -- inches 
WHERE tmp.tmp_shock_spec_data_two.sCompressedLength <> '';  

SELECT *
FROM tmp.tmp_shock_spec_data_two
WHERE sCompressedLength = ''; -- 10,270 records don't have values, 12299 do have values 


UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixUnitId3 = 6  -- inches 
WHERE tmp.tmp_shock_spec_data_two.sBodyDiameter <> '';  

SELECT *
FROM tmp.tmp_shock_spec_data_two
WHERE sBodyDiameter <> ''; -- 19,382 records don't have values, 3187 do have values 



UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixUnitId4 = 6  -- inches 
WHERE tmp.tmp_shock_spec_data_two.sBushingDiameter <> '';  

SELECT *
FROM tmp.tmp_shock_spec_data_two
WHERE sBushingDiameter = ''; -- 22,281 records don't have values, 288 do have values 




UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixRebuildable = 1  
WHERE tmp.tmp_shock_spec_data_two.sRebuildable = 'Yes';  

UPDATE tmp.tmp_shock_spec_data_two
SET tmp.tmp_shock_spec_data_two.ixRebuildable = 0  
WHERE tmp.tmp_shock_spec_data_two.sRebuildable = 'No';  
   
SELECT DISTINCT sRebuildable
FROM tmp.tmp_shock_spec_data_two
WHERE ixRebuildable IS NULL;



UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44
   AND sFinish <> ''; 
   
SELECT DISTINCT sFinish
FROM tmp.tmp_shock_spec_data_two
WHERE ixFinish IS NULL; 


UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixBushingMaterial = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.sBushingMaterial = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 301
   AND sBushingMaterial <> ''; 
   
SELECT DISTINCT sBushingMaterial
FROM tmp.tmp_shock_spec_data_two
WHERE ixBushingMaterial IS NULL; 



UPDATE tmp.tmp_shock_spec_data_two, AttributeDropdownItem
SET tmp.tmp_shock_spec_data_two.ixSoldinQuantity = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_shock_spec_data_two.iSoldinQuantity = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 41; 
   
SELECT DISTINCT iSoldinQuantity
FROM tmp.tmp_shock_spec_data_two
WHERE ixSoldinQuantity IS NULL;


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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockType IS NOT NULL; -- only 11623 records inserted out of 13469 records total 


SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.ixShockType AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixShockType <> SA.sValue
  AND SA.ixTemplateAttributeId = 100; -- ask Tyler what to do with these (4) SKUs 
  
UPDATE SKUAttribute
SET sValue = 97 
WHERE sValue = 98 
 AND ixTemplateAttributeId = 100 
 AND ixSKU IN ('582A946B', '582AC750B', '72151953', '7215196'); -- per Tyler's response
  
SELECT * FROM AttributeDropdownItem WHERE AttributeDropdownItem.ixTemplateAttributeId = 100;  -- 98=mono 97=twin


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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixAdjustability IS NOT NULL; -- only 9243 records inserted out of 10888 records total 

-- CREATE TABLE tmp.tmp_adjustability_alter
SELECT SSD.ixSOPSKU
      , SA.sValue AS TableValue
      , SSD.ixAdjustability AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixAdjustability <> SA.sValue
  AND SA.ixTemplateAttributeId = 331; -- ask Tyler what to do with these (307) SKUs 
  
SELECT * FROM AttributeDropdownItem WHERE AttributeDropdownItem.ixTemplateAttributeId = 331;  -- 381=??? 1024=non-adjustable  AND 1022=single 1023=double


UPDATE SKUAttribute 
SET sValue = 1023
WHERE ixSKU IN (SELECT ixSOPSKU
                FROM tmp.tmp_adjustability_alter
                )
 AND ixTemplateAttributeId = 331;



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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockBodyMaterial IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 15886 records inserted out of 17738 records total 


SELECT * 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU 
WHERE SPA.ixSKU IS NULL; -- ixSOPSKU = '582-PGAN840' is not a valid SKU -- follow up with Tyler on how to proceed


-- CREATE TABLE tmp.tmp_shockbodymaterial
SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.ixShockBodyMaterial AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixShockBodyMaterial <> SA.sValue
  AND SA.ixTemplateAttributeId = 335
  -- AND SA.sValue = 391
  ; -- ask Tyler what to do with these (49) SKUs 
  
SELECT * FROM AttributeDropdownItem WHERE AttributeDropdownItem.ixTemplateAttributeId = 335;  -- 391=steel 392=aluminum


UPDATE SKUAttribute 
SET sValue = 392
WHERE ixSKU IN (SELECT ixSOPSKU
                FROM tmp.tmp_shockbodymaterial
                )
 AND ixTemplateAttributeId = 335;
 

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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockBodySize IS NOT NULL; -- only 3721 records inserted out of 3721 records total 




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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockBodyType IS NOT NULL; -- only 13467 records inserted out of 13467 records total 



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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixShockStroke IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 17440 records inserted out of 17441 records total 



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 333
     , SSD.ixUpperShockMount
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixUpperShockMount IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 11567 records inserted out of 13269 records total 


SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.ixUpperShockMount AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixUpperShockMount <> SA.sValue
  AND SA.ixTemplateAttributeId = 333; -- ask Tyler what to do with these (4) SKUs 
  
SELECT * FROM AttributeDropdownItem WHERE AttributeDropdownItem.ixTemplateAttributeId = 333;  -- 385=1/2 Inch Eyelet 386=5/8 Inch Eyelet 1242=Eyelet


UPDATE SKUAttribute 
SET sValue = 1242
WHERE ixSKU IN ('940128121')
 AND ixTemplateAttributeId = 333;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 334
     , SSD.ixLowerShockMount
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixLowerShockMount IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 11567 records inserted out of 13470 records total 
  
SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.ixLowerShockMount AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixLowerShockMount <> SA.sValue
  AND SA.ixTemplateAttributeId = 334; -- ask Tyler what to do with these (206) SKUs 
  
SELECT * FROM AttributeDropdownItem WHERE AttributeDropdownItem.ixTemplateAttributeId = 334;  


UPDATE SKUAttribute 
SET sValue = 387
WHERE ixSKU IN ('72153683', '721536835', '72153684', '71253685', '721536853')
 AND ixTemplateAttributeId = 334;
 
 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 682
     , SSD.ixMountPosition
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixMountPosition IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 11068 records inserted out of 11068 records total 
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 44
     , SSD.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixFinish IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 11589 records inserted out of 13264 records total 


SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.ixFinish AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixFinish <> SA.sValue
  AND SA.ixTemplateAttributeId = 44; -- ask Tyler what to do with these (3) SKUs 
  
SELECT * FROM AttributeDropdownItem WHERE AttributeDropdownItem.ixTemplateAttributeId = 44;  -- 81=Painted 169=Powder Coated 



UPDATE SKUAttribute 
SET sValue = 169
WHERE ixSKU IN ('72151953', '7215196', '72151972')
 AND ixTemplateAttributeId = 44;
 
   
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 301
     , SSD.ixBushingMaterial
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixBushingMaterial IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 0 records inserted out of 484 records total 

-- all records matched 
  

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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixSoldinQuantity IS NOT NULL
  AND SSD.ixSOPSKU <> '582-PGAN840'; -- only 11593 records inserted out of 13470 records total 


SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.ixSoldinQuantity AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixSoldinQuantity <> SA.sValue
  AND SA.ixTemplateAttributeId = 41; -- ask Tyler what to do with these (3) SKUs 
  
SELECT * FROM AttributeDropdownItem WHERE AttributeDropdownItem.ixTemplateAttributeId = 41;  -- 41=Each 42=Pair 84=Kit


UPDATE SKUAttribute 
SET sValue = 41
WHERE ixSKU IN ('582A650B', '582A746B')
 AND ixTemplateAttributeId = 41;
 
 

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
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.sMFGPart IS NOT NULL
  AND SSD.sMFGPart <> ''; -- only 12102 records inserted out of 13505 records total 

SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.sMFGPart AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.sMFGPart <> SA.sValue
  AND SA.ixTemplateAttributeId = 325
  AND SSD.sMFGPart <> ''; -- ask Tyler what to do with these (495) SKUs 


UPDATE SKUAttribute 
SET sValue = '60957'
WHERE ixSKU IN ('72160957')
 AND ixTemplateAttributeId = 325;  
 
 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 687
     , SSD.sCompressionValving
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.sCompressionValving IS NOT NULL
  AND SSD.sCompressionValving <> ''; -- only 13342 records inserted out of 13342 records total   
  
  
-- all records matched 
  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 688
     , SSD.sReboundValving
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.sReboundValving IS NOT NULL
  AND SSD.sReboundValving <> ''; -- only 13257 records inserted out of 13257 records total     
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 98
     , SSD.sExtendedLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , SSD.ixUnitId1
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixUnitId1 IS NOT NULL; --  only 10397 records inserted out of 12299 records total     


SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.sExtendedLength AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.sExtendedLength <> SA.sValue
  AND SA.ixTemplateAttributeId = 98
  AND SSD.sExtendedLength <> ''; -- ask Tyler what to do with these (865) SKUs 

UPDATE SKUAttribute 
SET sValue = '13.375'
WHERE ixSKU IN ('582ASB530B')
 AND ixTemplateAttributeId = 98;  
   

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 99
     , SSD.sCompressedLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , SSD.ixUnitId2
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixUnitId2 IS NOT NULL; --  only 10396 records inserted out of 12299 records total     


SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.sCompressedLength AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.sCompressedLength <> SA.sValue
  AND SA.ixTemplateAttributeId = 99
  AND SSD.sCompressedLength <> ''; -- ask Tyler what to do with these (651) SKUs 

  
UPDATE SKUAttribute 
SET sValue = '11.50'
WHERE ixSKU IN ('582A654B7', '582A65B7', '582A664B7')
 AND ixTemplateAttributeId = 99;  
 
 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 302
     , SSD.sBodyDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , SSD.ixUnitId3
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixUnitId3 IS NOT NULL; --  only 2043 records inserted out of 3187 records total    

CREATE TABLE tmp.tmp_bodydiameter
SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.sBodyDiameter AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.sBodyDiameter <> SA.sValue
  AND SA.ixTemplateAttributeId = 302
  AND SSD.sBodyDiameter <> ''; -- ask Tyler what to do with these (737) SKUs 

  
UPDATE SKUAttribute 
SET sValue = '2.00'
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_bodydiameter)
 AND ixTemplateAttributeId = 302;  
 
 

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 224
     , SSD.sBushingDiameter
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , SSD.ixUnitId4
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixUnitId4 IS NOT NULL; -- only 288 records inserted out of 288 records total   


INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 337
     , SSD.ixCoiloverCompatible
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixCoiloverCompatible IS NOT NULL
  AND SSD.ixSOPSKU NOT IN (SELECT ixSKU FROM SKUAttribute WHERE SKUAttribute.ixTemplateAttributeId = 337); -- only 10693 records inserted out of 12548 records total   
  
SELECT SSD.ixSOPSKU
     , SA.sValue AS TableValue
     , SSD.ixCoiloverCompatible AS ExcelValue
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = SSD.ixSOPSKU      
WHERE SSD.ixCoiloverCompatible <> SA.sValue
  AND SA.ixTemplateAttributeId = 337
  AND SSD.ixCoiloverCompatible <> ''; -- ask Tyler what to do with these (2) SKUs 
  

UPDATE SKUAttribute 
SET sValue = 1
WHERE ixSKU IN ('72151953', '7215196')
 AND ixTemplateAttributeId = 337;  
  
  
INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 676
     , SSD.ixGasPressureAdjustable
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixGasPressureAdjustable IS NOT NULL; -- only 13470 records inserted out of 13470 records total     

-- all values matched  
  

INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 680
     , SSD.ixExternalCanister
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixExternalCanister IS NOT NULL; -- only 13470 records inserted out of 13470 records total     



INSERT INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT SSD.ixSOPSKU
     , 677
     , SSD.ixRebuildable
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_shock_spec_data_two SSD 
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = SSD.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SSD.ixRebuildable IS NOT NULL; -- only 13178 records inserted out of 13178 records total     
 -- NOTE ---- PCDB aka SEMA Part ID 
 
 SELECT * FROM SEMAPart WHERE PartTerminologyID = 1836; -- Brake Master Cylinders
 
-- For each column header (attribute) it needs to be determined what "type" they are. 
-- This will be done in ODS. 

SELECT *
FROM AttributeUnit
WHERE ixAttributeTypeId = 20;


-- Type 2 & 4 will be special types that will take additional steps; 
-- all measurement types will need unit fields added; other values are text only  

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Material Type' -- Dropdown box, 4 -- Template ID 31
   OR sTitle = 'Finish' -- Dropdown box, 4 -- Template ID 44
   OR sTitle = 'Reservoir Type' -- Dropdown box, 4 -- Template ID 780
   OR sTitle = 'Stroke' -- Measurement/Size/Length, 5 -- Template ID 308 -- UnitId = 6 (inches)
   OR sTitle = 'Bore Size' -- Measurement/Size/Length, 5 -- Template ID 147 -- UnitId = 6 (inches) 
   OR sTitle = 'Length' -- Measurement/Size/Length, 5 -- Template ID 623 -- UnitId = 6 (inches)
   OR sTitle = 'Flange to End' -- Measurement/Size/Length, 5 -- Template ID 784  -- Unit Id = 6 (inches)
   OR sTitle = 'Outlet Size' -- Measurement/Size/Length, 5 -- Template ID 48  -- Unit Id = 6 (inches)    
   OR sTitle = 'Outlet Size 2' -- Measurement/Size/Length, 5 -- Template ID 785 -- Unit Id = 6 (inches)     
   OR sTitle = 'Inlet Fitting' -- Text, 1 -- Template ID 202 
   OR sTitle = 'Outlet Fit' -- Text, 1 -- Template ID 786  
   OR sTitle = 'Outlet Fit 2' -- Text, 1 -- Template ID 787   
   OR sTitle = 'Outlets' -- Quantity, 3 -- Template ID 779   
   OR sTitle = 'Area' -- Area, 19 -- Template ID 776 -- UnitId = 39 (sq. in)   
   OR sTitle = 'Volume' -- Volume, 20 -- Template ID 777 -- UnitId = 49 (cubic inches)   
   OR sTitle = 'Capacity' -- Volume, 20 -- Template ID 281  -- UnitId = 47 (fluid ounces)    
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;

-- Load data from Excel file; Rename the columns to be more code friendly (i.e. remove special characters and spaces and append with 's' to the front of the value) 
-- e.g. ixSOPSKU, sMFGPartNum, sCableLength, sHardwareIncluded, etc. 

SELECT * 
FROM tmp.tmp_brakemc;

-- Insert additional columns for all 2/4 types to store the correct text value ID 
ALTER TABLE tmp.tmp_brakemc
 ADD ixMaterialType INT AFTER sMaterialType
,ADD ixFinish INT AFTER sFinish
,ADD ixReservoirType INT AFTER sReservoirType
,ADD ixUnitId1 INT AFTER dStroke
,ADD ixUnitId2 INT AFTER dBoreSize
,ADD ixUnitId3 INT AFTER dLength
,ADD ixUnitId4 INT AFTER dFlangetoEnd
,ADD ixUnitId5 INT AFTER dOutletSize
,ADD ixUnitId6 INT AFTER dOutletSize2
,ADD ixUnitId7 INT AFTER dArea
,ADD ixUnitId8 INT AFTER dVolume
,ADD ixUnitId9 INT AFTER dCapacity;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_brakemc CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 

UPDATE tmp.tmp_brakemc, AttributeDropdownItem
SET tmp.tmp_brakemc.ixMaterialType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakemc.sMaterialType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 31; 

SELECT *
FROM tmp.tmp_brakemc
WHERE ixMaterialType IS NULL; -- all records updated 


UPDATE tmp.tmp_brakemc, AttributeDropdownItem
SET tmp.tmp_brakemc.ixFinish = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakemc.sFinish = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 44;  

SELECT *
FROM tmp.tmp_brakemc
WHERE ixFinish IS NULL; -- all records updated after changes below were made 

UPDATE tmp.tmp_brakemc
SET sFinish = 'Black E-Coat' 
WHERE sFinish = 'Black E-coat';


UPDATE tmp.tmp_brakemc, AttributeDropdownItem
SET tmp.tmp_brakemc.ixReservoirType = AttributeDropdownItem.ixAttributeDropdownItemId
WHERE tmp.tmp_brakemc.sReservoirType = AttributeDropdownItem.sAttributeDropdownItemText
   AND AttributeDropdownItem.ixTemplateAttributeId = 780; 

SELECT *
FROM tmp.tmp_brakemc
WHERE ixReservoirType IS NULL; -- all records with values updated 


-- Update all the UnitId values to the correct Unit Type 

UPDATE tmp.tmp_brakemc
SET ixUnitId1 = 6 
WHERE dStroke IS NOT NULL;

UPDATE tmp.tmp_brakemc
SET ixUnitId2 = 6 
WHERE dBoreSize IS NOT NULL;

UPDATE tmp.tmp_brakemc
SET ixUnitId3 = 6 
WHERE dLength IS NOT NULL;


UPDATE tmp.tmp_brakemc
SET ixUnitId4 = 6 
WHERE dFlangetoEnd IS NOT NULL;

UPDATE tmp.tmp_brakemc
SET ixUnitId5 = 6 
WHERE dOutletSize IS NOT NULL;

UPDATE tmp.tmp_brakemc
SET ixUnitId6 = 6 
WHERE dOutletSize2 IS NOT NULL;

UPDATE tmp.tmp_brakemc
SET ixUnitId7 = 39
WHERE dArea IS NOT NULL;


UPDATE tmp.tmp_brakemc
SET ixUnitId8 = 49
WHERE dVolume IS NOT NULL;

UPDATE tmp.tmp_brakemc
SET ixUnitId9 = 47
WHERE dCapacity IS NOT NULL;

-- Now the records need to be inserted into the SKU Attribute table 

SELECT * FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_brakemc)
  AND ixPartTerminologyID <> 1836; 
  
UPDATE tblSKUPartAssociation
SET ixPartTerminologyID = 1836
WHERE ixSKUPartAssociationID IN (73023, 117247, 73022);

UPDATE tblSKUPartAssociation
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixSKUPartAssociationID IN (73023, 117247, 73022);

UPDATE tblSKUPartAssociation
SET dtUpdate = NOW()
WHERE ixSKUPartAssociationID IN (73023, 117247, 73022);
  
-- The 52 parts that do not exist in tblSKUPartAssociation must first be updated 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT MC.ixSOPSKU
     , 1836
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
FROM tmp.tmp_brakemc MC; 


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 202
     , MC.sInletFitting
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.sInletFitting IS NOT NULL
  AND MC.sInletFitting <> ' '; -- 23 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 786
     , MC.sOutletFit
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.sOutletFit IS NOT NULL
  AND MC.sOutletFit <> ' '; -- 49 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 787
     , MC.sOutletFit2
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.sOutletFit2 IS NOT NULL
  AND MC.sOutletFit2 <> ' '; -- 34 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 779
     , MC.iOutlets
     , 3
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.iOutlets IS NOT NULL
  AND MC.iOutlets <> ' '; -- 66 rows affected 
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 31
     , MC.ixMaterialType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.ixMaterialType IS NOT NULL; -- 64 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 44
     , MC.ixFinish
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.ixFinish IS NOT NULL; -- 64 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 780
     , MC.ixReservoirType
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.ixReservoirType IS NOT NULL; -- 66 rows affected


  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 308
     , MC.dStroke
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId1
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dStroke IS NOT NULL
  AND MC.dStroke <> ' '
  AND MC.dStroke <> 0.00; --  67 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 147
     , MC.dBoreSize
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId2
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dBoreSize IS NOT NULL
  AND MC.dBoreSize <> ' '
  AND MC.dBoreSize <> 0.00; --  64 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 623
     , MC.dLength
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId3
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dLength IS NOT NULL
  AND MC.dLength <> ' '
  AND MC.dLength <> 0.00; --  64 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 784
     , MC.dFlangetoEnd
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId4
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dFlangetoEnd IS NOT NULL
  AND MC.dFlangetoEnd <> ' '
  AND MC.dFlangetoEnd <> 0.00; --  62 rows affected    
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 48
     , MC.dOutletSize
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId5
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dOutletSize IS NOT NULL
  AND MC.dOutletSize <> ' '
  AND MC.dOutletSize <> 0.00; --  66 rows affected 
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 785
     , MC.dOutletSize2
     , 5
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId6
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dOutletSize2 IS NOT NULL
  AND MC.dOutletSize2 <> ' '
  AND MC.dOutletSize2 <> 0.00; --  34 rows affected    
  

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 776
     , MC.dArea
     , 19
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId7
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dArea IS NOT NULL
  AND MC.dArea <> ' '
  AND MC.dArea <> 0.00; --  67 rows affected  
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 777
     , MC.dVolume
     , 20
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId8
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dVolume IS NOT NULL
  AND MC.dVolume <> ' '
  AND MC.dVolume <> 0.00; --  33 rows affected    
  
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT MC.ixSOPSKU
     , 281
     , MC.dCapacity
     , 20
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , MC.ixUnitId9
FROM tmp.tmp_brakemc MC
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = MC.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE MC.dCapacity IS NOT NULL
  AND MC.dCapacity <> ' '
  AND MC.dCapacity <> 0.00; --  55 rows affected      
  
-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_brakemc MC;
                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '83526012900BK';


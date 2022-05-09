-- There were only 2 values on this sheet so I input the data manually vs. loading a temp table 


INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
VALUES ('8358309807' , 7576 , 'SPEEDWAYMOTORS\\ascrook' , NOW());

INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
VALUES ('83583010832' , 7576 , 'SPEEDWAYMOTORS\\ascrook' , NOW());

SELECT AT.*, TA.sTitle, TA.ixTemplateAttributeId -- , AU.ixUnitId, AU.sPluralUnitName
FROM TemplateAttribute TA 
LEFT JOIN AttributeType AT ON AT.ixAttributeTypeId = TA.ixAttributeTypeId 
-- LEFT JOIN AttributeUnit AU ON AU.ixAttributeTypeId = TA.ixAttributeTypeId
WHERE sTitle = 'Spindle Type' -- Dropdown box, 4 -- Template ID 654
   OR sTitle = 'Material Type' -- Dropdown box, 4 -- Template ID 31
   OR sTitle = 'Finish' -- Dropdown box, 4 -- Template ID 44
   OR sTitle = 'Spindle Drop' -- Text, 1 -- Template ID 737
   OR sTitle = 'Side' -- Text, 1 -- Template ID 738  
   OR sTitle = 'Weight' -- Weight, 6 -- Template ID 35 -- Unit Id = 14
ORDER BY sAttributeTypeName; -- TA.ixTemplateAttributeId;


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '8358309807'
     , 737
     , '2 Inch' 
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '8358309807'; --  1 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '83583010832'
     , 737
     , 'Stock Height' 
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '83583010832'; --  1 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '8358309807'
     , 738
     , 'L/H or R/H' 
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '8358309807'; --  1 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '83583010832'
     , 738
     , 'L/H or R/H' 
     , 1
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '83583010832'; --  1 rows affected



INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '8358309807'
     , 35
     , '9.20' 
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , 14
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '8358309807'; --  1 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '83583010832'
     , 35
     , '9.00' 
     , 6
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , 14
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '83583010832'; --  1 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '8358309807'
     , 654
     , 1485
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '8358309807'; --  1 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '83583010832'
     , 654
     , 1672
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '83583010832'; --  1 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '8358309807'
     , 31
     , 33
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '8358309807'; --  1 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '83583010832'
     , 31
     , 33
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '83583010832'; --  1 rows affected


INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '8358309807'
     , 44
     , 333
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '8358309807'; --  1 rows affected

INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT DISTINCT '83583010832'
     , 44
     , 333
     , 4
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL
FROM tblSKUPartAssociation SPA 
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU = '83583010832'; --  1 rows affected


-- Check against product manager (test 5-10 skus) (products.speedwaymotors.com > SKUs > " ... " Search > Notepad icon (edit))
SELECT *
FROM tmp.tmp_discbrakepad BP;

                  
-- Check TNG -- Trigger worked 

SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '83583010832';
-- Insert values into ODS to appear on the WEB   
  
INSERT IGNORE INTO SKUAttribute (ixSKU, ixTemplateAttributeId, sValue, ixAttributeTypeId, ixPartTerminologyID, ixCreateUser, dtCreate, ixTemplateId, ixUnitId ) 
SELECT ASGS.ixSOPSKU
     , 490
     , 1
     , 2
     , SPA.ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook'
     , NOW()
     , T.ixTemplateId
     , NULL 
FROM tmp.tmp_alpinestars_gs_skus ASGS
LEFT JOIN tblSKUPartAssociation SPA ON SPA.ixSKU = ASGS.ixSOPSKU
LEFT JOIN Template T ON T.ixPartTerminologyID = SPA.ixPartTerminologyID;

-- 702 values inserted, 124 values already existed with a garage sale attribute value

SELECT *
FROM odsLive.SKUAttribute SA 
WHERE SA.ixSKU IN (SELECT ixSOPSKU    
                   FROM tmp.tmp_alpinestars_gs_skus
                  ) 
  AND SA.ixTemplateAttributeId = 490
  AND sValue = 0;  
  
-- 9 SKUs already listed were marked as not being garage sale so the values needed to be updated   
              
UPDATE SKUAttribute
SET sValue = 1 
WHERE ixTemplateAttributeId = 490 
  AND ixPartTerminologyID = 14639 
  AND ixSKUAttributeId IN (698437, 699000, 699005, 699056, 699112, 699117, 699123, 699131, 699137);
  
  
-- Verify tng trigger worked 
SELECT *
FROM tngLive.tblskuvariant_productgroup_attribute_value
LEFT JOIN  tngLive.tblskuvariant ON tngLive.tblskuvariant_productgroup_attribute_value.ixSKUVariant = tngLive.tblskuvariant.ixSKUVariant
WHERE tngLive.tblskuvariant.ixSOPSKU = '1246611';
  
SELECT * FROM tblSKUPartAssociation LIMIT 10; -- USE ODS
 -- ixSKUPartAssociationID, ixSKU, ixPartTerminologyID, ixCreateUser, ixUpdateUser, dtCreate, dtUpdate 

SELECT * FROM SEMAPart WHERE PartTerminologyID = '5908'; -- PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology, sSingularPartTerm


SELECT * 
FROM tmp.tmp_edelbrock_pcdb; -- 3123 rows 


SELECT DISTINCT ixSKU
     , ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_edelbrock_pcdb; -- 3123 rows returned 

SELECT SPA.ixSKU 
     , SPA.ixPartTerminologyID 
     , SKU.ixPartTerminologyID 
FROM tblSKUPartAssociation SPA 
LEFT JOIN tmp.tmp_edelbrock_pcdb SKU ON SKU.ixSKU = SPA.ixSKU
WHERE SPA.ixPartTerminologyID <> SKU.ixPartTerminologyID 
  OR SPA.ixPartTerminologyID IS NULL; -- 1 records returned for ixSKU 3252324 current value 14637 new value 17205 

INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DISTINCT ixSKU
     , ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_edelbrock_pcdb; -- 3090 rows affected


SELECT DISTINCT ixSOPSKU 
FROM tngLive.tblskuvariant 
WHERE ixSOPSKU IN (SELECT ixSKU FROM tmp.tmp_edelbrock_pcdb); -- only 21 SKUs currently exist in the web DB from the loaded file 10/27/14


-- check to verify there are not multiple sku pcdb associations for 1 sku which breaks PMS 
SELECT ixSKU 
     , COUNT(DISTINCT ixPartTerminologyID) 
FROM tblSKUPartAssociation
GROUP BY ixSKU 
HAVING COUNT(DISTINCT ixPartTerminologyID) > 1; -- 1 records returned ixSKU 3252324 

SELECT * 
FROM tblSKUPartAssociation
WHERE ixSKU = '3252324'; -- ixSKUPartAssociationID value to delete = 121619 

DELETE FROM tblSKUPartAssociation 
WHERE tblSKUPartAssociation.ixSKUPartAssociationID = 121619; 

-- check how many attributes are tied to this SKU 
SELECT * 
FROM SKUAttribute
WHERE ixSKU = '3252324'; -- ixTemplateAttributeId = 490 sValue = 1 

SELECT * 
FROM TemplateAttribute
WHERE ixTemplateAttributeId = 490; -- garage sale 


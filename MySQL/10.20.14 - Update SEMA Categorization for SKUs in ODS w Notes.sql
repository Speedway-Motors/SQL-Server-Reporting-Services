SELECT * FROM tblSKUPartAssociation LIMIT 10; -- USE ODS
 -- ixSKUPartAssociationID, ixSKU, ixPartTerminologyID, ixCreateUser, ixUpdateUser, dtCreate, dtUpdate 

SELECT * FROM SEMAPart WHERE PartTerminologyID = '10962'; -- PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology, sSingularPartTerm


SELECT * 
FROM tmp.tmp_sku_pcdb_update; -- 994 rows 


ALTER TABLE tmp.tmp_sku_pcdb_update
ADD CategoryID SMALLINT AFTER categoryname
,ADD SubCategoryID SMALLINT AFTER subcategoryname
,ADD PartTerminologyID SMALLINT AFTER partterminologyname; 


ALTER TABLE tmp.tmp_sku_pcdb_update CONVERT to character set latin1 collate latin1_general_cs;

UPDATE tmp.tmp_sku_pcdb_update, SEMACategory
SET tmp.tmp_sku_pcdb_update.CategoryID = SEMACategory.CategoryID
WHERE tmp.tmp_sku_pcdb_update.categoryname = SEMACategory.categoryname; -- 994 rows affected 

UPDATE tmp.tmp_sku_pcdb_update 
SET categoryname = 'Brake' 
WHERE CategoryID IS NULL; 

UPDATE tmp.tmp_sku_pcdb_update, SEMASubcategory
SET tmp.tmp_sku_pcdb_update.SubCategoryID = SEMASubcategory.SubCategoryID
WHERE tmp.tmp_sku_pcdb_update.subcategoryname = SEMASubcategory.subcategoryname; -- 994 rows affected 


UPDATE tmp.tmp_sku_pcdb_update, SEMAPart
SET tmp.tmp_sku_pcdb_update.PartTerminologyID = SEMAPart.PartTerminologyID
WHERE tmp.tmp_sku_pcdb_update.partterminologyname = SEMAPart.partterminologyname; -- 994 rows affected 


SELECT DISTINCT ixSOPSKU
     , PartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_sku_pcdb_update; -- 994 rows returned 

-- CREATE TABLE tmp_skus_with_diff_pcdb  
SELECT SPA.ixSKU 
     , SPA.ixPartTerminologyID 
     , SKU.PartTerminologyID   
FROM odsLive.tblSKUPartAssociation SPA 
LEFT JOIN tmp.tmp_sku_pcdb_update SKU ON SKU.ixSOPSKU = SPA.ixSKU
WHERE SPA.ixPartTerminologyID <> SKU.PartTerminologyID 
  OR SPA.ixPartTerminologyID IS NULL; -- 346 records returned 

SELECT DISTINCT DIFF.ixSKU 
     , COUNT(DISTINCT ixSKUAttributeId) AS Cnt 
FROM tmp.tmp_skus_with_diff_pcdb DIFF 
LEFT JOIN SKUAttribute SA ON SA.ixSKU = DIFF.ixSKU 
GROUP BY DIFF.ixSKU
ORDER BY Cnt DESC; -- no attributes were tied to any SKUs THEREFORE re-pointing the SEMA part will not break anything

INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DISTINCT ixSOPSKU
     , PartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_sku_pcdb_update
WHERE ixSOPSKU NOT IN (SELECT ixSKU FROM tblSKUPartAssociation); -- 465 rows affected


-- CREATE TABLE asc_duplicate_entries
SELECT * 
FROM tblSKUPartAssociation SPA 
WHERE SPA.ixCreateUser = 'SPEEDWAYMOTORS\\ascrook' 
 -- AND ixSKU IN (SELECT ixSOPSKU FROM tmp.tmp_sku_pcdb_update)
  AND DATE_FORMAT(dtCreate,'%y-%m-%d') = '14-10-20';
  
-- DELETE 
-- SELECT * 
FROM tblSKUPartAssociation
WHERE tblSKUPartAssociation.ixSKUPartAssociationID IN (SELECT ixSKUPartAssociationID
                                                       FROM asc_duplicate_entries
                                                       );
  
  
DELETE
-- SELECT * 
FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSKU 
                FROM tmp.tmp_skus_with_diff_pcdb 
               );


INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DISTINCT ixSOPSKU
     , PartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_sku_pcdb_update
WHERE ixSOPSKU NOT IN (SELECT ixSKU FROM tblSKUPartAssociation); -- 465 rows affected



SELECT DISTINCT ixSOPSKU 
FROM tngLive.tblskuvariant 
WHERE ixSOPSKU IN (SELECT ixSOPSKU FROM tmp.tmp_sku_pcdb_update); -- only 503 SKUs currently exist in the web DB from the loaded file 10/20/14


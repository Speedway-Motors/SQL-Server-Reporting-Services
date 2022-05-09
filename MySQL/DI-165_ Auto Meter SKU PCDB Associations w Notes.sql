SELECT * FROM tblSKUPartAssociation; 

SELECT * FROM SEMAPart WHERE PartTerminologyID = '17712';


SELECT * 
FROM tmp.tmp_autometerskus;


SELECT DISTINCT ixSKU_
     , ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_autometerskus; -- 2518 rows returned 

SELECT SPA.ixSKU 
     , SPA.ixPartTerminologyID 
     , AMS.ixPartTerminologyID 
FROM tblSKUPartAssociation SPA 
LEFT JOIN tmp.tmp_autometerskus AMS ON AMS.ixSKU_ = SPA.ixSKU
WHERE SPA.ixPartTerminologyID = AMS.ixPartTerminologyID 
  OR SPA.ixPartTerminologyID IS NULL; -- 6 records do not match the wanted inserts, 6 additional records already exist

INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DISTINCT ixSKU_
     , ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_autometerskus; -- 2512 rows affected

-- 6 rows inserted that should not have creating double PCDB associations which will break PMS lookup 
SELECT COUNT(DISTINCT ixPartTerminologyID)   
     , ixSKU 
FROM tblSKUPartAssociation
GROUP BY ixSKU 
HAVING COUNT(DISTINCT ixPartTerminologyID) > 1; 


SELECT * 
FROM tblSKUPartAssociation
WHERE ixSKU IN ('1822370', '1825201', '1825357', '1825358', '1825821', '1825831'); 

-- Per Wyatt leave the old association and Jesse C. can change in PMS if wanted 
DELETE FROM tblSKUPartAssociation
WHERE ixSKUPartAssociationID IN ('264806', '263836', '264144', '264143', '263260', '264888');


SELECT DISTINCT ixSOPSKU 
FROM tblskuvariant 
WHERE ixSOPSKU IN (SELECT ixSKU_ FROM tmp.tmp_autometerskus); -- only 23 SKUs currently exist in the web DB from the loaded file 9/16/14
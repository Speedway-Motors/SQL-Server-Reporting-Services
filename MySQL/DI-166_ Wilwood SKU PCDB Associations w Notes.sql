SELECT * FROM tblSKUPartAssociation LIMIT 10; 

SELECT * FROM SEMAPart WHERE PartTerminologyID = '1714';


SELECT * 
FROM tmp.tmp_wilwood_pcdb; -- 1564 rows 


SELECT DISTINCT ixSKU
     , ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_wilwood_pcdb; -- 1564 rows returned 

SELECT SPA.ixSKU 
     , SPA.ixPartTerminologyID 
     , W.ixPartTerminologyID 
FROM tblSKUPartAssociation SPA 
LEFT JOIN tmp.tmp_wilwood_pcdb W ON W.ixSKU = SPA.ixSKU
WHERE SPA.ixPartTerminologyID <> W.ixPartTerminologyID 
  OR SPA.ixPartTerminologyID IS NULL; -- 17 records do not match the wanted inserts, 205 additional records already exist

INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, ixCreateUser, dtCreate) 
SELECT DISTINCT ixSKU
     , ixPartTerminologyID
     , 'SPEEDWAYMOTORS\\ascrook' 
     , NOW() 
FROM tmp.tmp_wilwood_pcdb
-- WHERE clause to exclude double associations 
WHERE ixSKU NOT IN ('83523010117', '83523010118', '83523010119', '8352309982', '8352309983', '83523010115', '83523010116', '8352307049', '8352307710', 
                    '8352307540', '8352303029', '8352305976', '8352305977', '8352305978', '8352303079', '8352303052', '8352309171'); -- 1342 rows affected

-- Per Wyatt leave the old association and Jesse C. can change in PMS if wanted 

SELECT DISTINCT ixSOPSKU 
FROM tngLive.tblskuvariant 
WHERE ixSOPSKU IN (SELECT ixSKU FROM tmp.tmp_wilwood_pcdb); -- only 3 SKUs currently exist in the web DB from the loaded file 9/16/14
-- 8351206807, 83512012003RD, 83514010219
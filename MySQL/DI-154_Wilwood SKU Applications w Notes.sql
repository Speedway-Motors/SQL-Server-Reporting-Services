-- upload the skus given into a temp table 
SELECT * 
FROM tmp.tmp_wilwoodappassign; 

-- DROP TABLE tmp.tmp_wilwoodappassign; 

-- add additional columns to store other values needed 
ALTER TABLE tmp.tmp_wilwoodappassign
 ADD ixSKUVariant INT AFTER ixSOPSKU;

-- Update the collation so you can join against the current tables in TNG 
ALTER TABLE tmp.tmp_wilwoodappassign CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values in the added field
UPDATE tmp.tmp_wilwoodappassign W, tblskuvariant SV 
SET W.ixSKUVariant = SV.ixSKUVariant
WHERE W.ixSOPSKU = SV.ixSOPSKU; -- 29241 rows upated 

-- find if any values did not update 
SELECT DISTINCT ixSOPSKU
FROM tmp.tmp_wilwoodappassign
WHERE ixSKUVariant IS NULL; -- 142 Distinct SKUs did not update; provide to JGO to add to PMS // per JGO do nothing with these SKUs 

-- add additional columns to store other values needed 
ALTER TABLE tmp.tmp_wilwoodappassign
 ADD ixApplication INT AFTER sApplicationValue;

 
-- Update the null values in the added field
UPDATE tmp.tmp_wilwoodappassign W, tblapplication A 
SET W.ixApplication = A.ixApplication 
WHERE W.sApplicationValue = A.sApplicationValue; -- 33101 rows updated  

-- find if any values did not update 
SELECT DISTINCT sApplicationValue
FROM tmp.tmp_wilwoodappassign
WHERE ixApplication IS NULL; -- all application values updated now 


-- Insert the values in the xref table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) 
SELECT ixSKUVariant
     , ixApplication
     , ixSOPSKU
FROM tmp.tmp_wilwoodappassign
WHERE ixSKUVariant IS NOT NULL
  AND ixApplication IS NOT NULL; -- 29,241 records, only 4303 records inserted  (only 4395 distinct records existed), 4303 records already inserted previously





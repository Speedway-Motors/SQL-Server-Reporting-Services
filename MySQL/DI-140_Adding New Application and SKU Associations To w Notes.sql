-- verify the value does not already exist before inserting 
SELECT * 
FROM tblapplication
WHERE UPPER(sApplicationValue) LIKE '%SPRINT%';

-- insert the value into the table. the ixApplication is auto incrementing and therefore does not need to be specified 
INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('Lightning Sprint', 'Race Cars'); 

-- upload the skus given into a temp table 
SELECT * 
FROM tmp.tmp_lightningsprint; 

-- add additional columns to store other values needed 
ALTER TABLE tmp.tmp_lightningsprint
 ADD ixSKUVariant INT AFTER ixSOPSKU;

-- Update the collation so you can join against the current tables in TNG 
ALTER TABLE tmp.tmp_lightningsprint CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values in the added field
UPDATE tmp.tmp_lightningsprint LS, tblskuvariant SV 
SET LS.ixSKUVariant = SV.ixSKUVariant
WHERE LS.ixSOPSKU = SV.ixSOPSKU; 

-- find if any values did not update 
SELECT * 
FROM tmp.tmp_lightningsprint
WHERE ixSKUVariant IS NULL; -- I have asked Wyatt to add this to the web DB and once done I will add it with the rest of the SKUs 

-- Insert the values in the xref table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) 
SELECT ixSKUVariant
     , ixApplication
     , ixSOPSKU
FROM tmp.tmp_lightningsprint
WHERE ixSKUVariant IS NOT NULL;

-- All distinct records inserted 


       
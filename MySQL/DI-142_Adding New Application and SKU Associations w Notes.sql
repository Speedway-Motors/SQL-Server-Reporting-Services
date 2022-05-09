-- verify the value does not already exist before inserting 
SELECT * 
FROM tblapplication
WHERE UPPER(sApplicationValue) LIKE '%MUSTANG%';

-- insert the value into the table. the ixApplication is auto incrementing and therefore does not need to be specified 
INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1974-78 Ford Mustang II', 'Cars'); 

-- upload the skus given into a temp table 
SELECT * 
FROM tmp.tmp_mustangii; 

-- add additional columns to store other values needed 
ALTER TABLE tmp.tmp_mustangii
 ADD ixSKUVariant INT AFTER ixSOPSKU;

-- Update the collation so you can join against the current tables in TNG 
ALTER TABLE tmp.tmp_mustangii CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values in the added field
UPDATE tmp.tmp_mustangii M, tblskuvariant SV 
SET M.ixSKUVariant = SV.ixSKUVariant
WHERE M.ixSOPSKU = SV.ixSOPSKU; 

-- find if any values did not update 
SELECT * 
FROM tmp.tmp_mustangii
WHERE ixSKUVariant IS NULL; -- all values updated 

-- Insert the values in the xref table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) 
SELECT ixSKUVariant
     , ixApplication
     , ixSOPSKU
FROM tmp.tmp_mustangii
WHERE ixSKUVariant IS NOT NULL;

-- All distinct records inserted 



-- verify the value does not already exist before inserting 
SELECT * 
FROM tblapplication
WHERE UPPER(sApplicationValue) LIKE '%CHEV%';

-- insert the value into the table. the ixApplication is auto incrementing and therefore does not need to be specified 
INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1953-62 Chevy Corvette', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1963-67 Chevy Corvette', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1968-82 Chevy Corvette', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1984-96 Chevy Corvette', 'Cars'); 

-- upload the skus given into a temp table 
SELECT * 
FROM tmp.tmp_vetteone; 

-- add additional columns to store other values needed 
ALTER TABLE tmp.tmp_vetteone
 ADD ixSKUVariant INT AFTER ixSOPSKU;

-- Update the collation so you can join against the current tables in TNG 
ALTER TABLE tmp.tmp_vetteone CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values in the added field
UPDATE tmp.tmp_vetteone V, tblskuvariant SV 
SET V.ixSKUVariant = SV.ixSKUVariant
WHERE V.ixSOPSKU = SV.ixSOPSKU; 

-- find if any values did not update 
SELECT * 
FROM tmp.tmp_vetteone
WHERE ixSKUVariant IS NULL; -- all values updated 

-- Insert the values in the xref table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) 
SELECT ixSKUVariant
     , ixApplication
     , ixSOPSKU
FROM tmp.tmp_vetteone
WHERE ixSKUVariant IS NOT NULL;

-- All distinct records inserted 

       
-- upload the skus given into a temp table 
SELECT * 
FROM tmp.tmp_vettetwo; 

-- add additional columns to store other values needed 
ALTER TABLE tmp.tmp_vettetwo
 ADD ixSKUVariant INT AFTER ixSOPSKU;

-- Update the collation so you can join against the current tables in TNG 
ALTER TABLE tmp.tmp_vettetwo CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values in the added field
UPDATE tmp.tmp_vettetwo V, tblskuvariant SV 
SET V.ixSKUVariant = SV.ixSKUVariant
WHERE V.ixSOPSKU = SV.ixSOPSKU; 

-- find if any values did not update 
SELECT * 
FROM tmp.tmp_vettetwo
WHERE ixSKUVariant IS NULL; -- all values updated 

-- Insert the values in the xref table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) 
SELECT ixSKUVariant
     , ixApplication
     , ixSOPSKU
FROM tmp.tmp_vettetwo
WHERE ixSKUVariant IS NOT NULL;

-- All distinct records inserted        


-- upload the skus given into a temp table 
SELECT * 
FROM tmp.tmp_vettethree; 

-- add additional columns to store other values needed 
ALTER TABLE tmp.tmp_vettethree
 ADD ixSKUVariant INT AFTER ixSOPSKU;

-- Update the collation so you can join against the current tables in TNG 
ALTER TABLE tmp.tmp_vettethree CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values in the added field
UPDATE tmp.tmp_vettethree V, tblskuvariant SV 
SET V.ixSKUVariant = SV.ixSKUVariant
WHERE V.ixSOPSKU = SV.ixSOPSKU; 

-- find if any values did not update 
SELECT * 
FROM tmp.tmp_vettethree
WHERE ixSKUVariant IS NULL; -- all values updated 

-- Insert the values in the xref table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) 
SELECT ixSKUVariant
     , ixApplication
     , ixSOPSKU
FROM tmp.tmp_vettethree
WHERE ixSKUVariant IS NOT NULL;

-- All distinct records inserted 
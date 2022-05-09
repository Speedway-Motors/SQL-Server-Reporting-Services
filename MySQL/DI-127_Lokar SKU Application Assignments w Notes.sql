-- The next task is assigning SKUs to new/additional ixApplication(s)

/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU and sApplicationValue).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. AWS Live _ tmp). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp.tmp_lokar_application_assign *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp.tmp_lokar_application_assign
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixSKUVariant associated with the SOP ixSOPSKU 
ALTER TABLE tmp.tmp_lokar_application_assign 
ADD ixSKUVariant int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_lokar_application_assign
LIMIT 10;

-- Update the collation of the table if needed
ALTER TABLE tmp.tmp_lokar_application_assign CONVERT to character set latin1 collate latin1_general_cs;

-- Update the new ixSKUVariant column with the corresponding values 
UPDATE tmp.tmp_lokar_application_assign LAA, tblskuvariant SV 
SET LAA.ixSKUVariant = SV.ixSKUVariant
WHERE LAA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_lokar_application_assign
WHERE ixSKUVariant IS NULL;  -- There should be 0 records returned -- 9 were returned that were built incorrectly by the merchants per JGO 

-- A new column will need to be added to the temp table to store the tng version ixApplication associated with the sApplicationValue 
ALTER TABLE tmp.tmp_lokar_application_assign 
ADD ixApplication int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_lokar_application_assign
LIMIT 10;

-- Update the new ixApplication column with the corresponding values 
UPDATE tmp.tmp_lokar_application_assign LAA, tblapplication A 
SET LAA.ixApplication = A.ixApplication
WHERE LAA.sApplicationValue = A.sApplicationValue;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_lokar_application_assign
WHERE ixApplication IS NULL;  -- There should be 0 records returned 

-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) -- all values updated 
SELECT DISTINCT ixSKUVariant, ixApplication, ixSOPSKU -- 2765 values updated, 2765 distinct values 
FROM tmp.tmp_lokar_application_assign
WHERE ixSKUVariant IS NOT NULL;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp.tmp_lokar_application_assign;



-- Repeat above steps above for second columns of applications 

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp.tmp_lokar_application_assign2
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixSKUVariant associated with the SOP ixSOPSKU 
ALTER TABLE tmp.tmp_lokar_application_assign2 
ADD ixSKUVariant int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_lokar_application_assign2
LIMIT 10;

-- Update the collation of the table if needed
ALTER TABLE tmp.tmp_lokar_application_assign2 CONVERT to character set latin1 collate latin1_general_cs;

-- Update the new ixSKUVariant column with the corresponding values 
UPDATE tmp.tmp_lokar_application_assign2 LAA, tblskuvariant SV 
SET LAA.ixSKUVariant = SV.ixSKUVariant
WHERE LAA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_lokar_application_assign2
WHERE ixSKUVariant IS NULL;  -- There should be 0 records returned -- 9 were returned that were built incorrectly by the merchants per JGO 

-- A new column will need to be added to the temp table to store the tng version ixApplication associated with the sApplicationValue 
ALTER TABLE tmp.tmp_lokar_application_assign2 
ADD ixApplication int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_lokar_application_assign2
LIMIT 10;

-- Update the new ixApplication column with the corresponding values 
UPDATE tmp.tmp_lokar_application_assign2 LAA, tblapplication A 
SET LAA.ixApplication = A.ixApplication
WHERE LAA.sApplicationValue = A.sApplicationValue;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_lokar_application_assign2
WHERE ixApplication IS NULL;  -- There should be 0 records returned 

-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) -- all values updated 
SELECT DISTINCT ixSKUVariant, ixApplication, ixSOPSKU -- 28 values updated, 28 distinct values 
FROM tmp.tmp_lokar_application_assign2
WHERE ixSKUVariant IS NOT NULL
  AND ixApplication IS NOT NULL;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp.tmp_lokar_application_assign2;



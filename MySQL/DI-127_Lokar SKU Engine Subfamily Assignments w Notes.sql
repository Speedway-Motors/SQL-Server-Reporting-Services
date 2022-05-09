-- The next task is assigning SKUs to new/additional Engine families/subfamilies
/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU and sEngineFamilyName and sEngineSubfamilyName).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. AWS Live _ tmp). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp.tmp_lokar_engine_assign *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp.tmp_lokar_engine_assign
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixEngineFamily associated with the sEngineFamilyName
ALTER TABLE tmp.tmp_lokar_engine_assign 
ADD ixEngineFamily int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_lokar_engine_assign
LIMIT 10;

-- Update the collation of the table if needed
ALTER TABLE tmp.tmp_lokar_engine_assign CONVERT to character set latin1 collate latin1_general_cs;

-- Update the new ixEngineFamily column with the corresponding values 
UPDATE tmp.tmp_lokar_engine_assign LEA, tblengine_family EF  
SET LEA.ixEngineFamily = EF.ixEngineFamily
WHERE LEA.sEngineFamilyName = EF.sEngineFamilyName;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_lokar_engine_assign
WHERE ixEngineFamily IS NULL;  -- There should be 0 records returned 

-- A new column will need to be added to the temp table to store the tng version ixEngineSubfamily associated with the sEngineSubfamilyName 
ALTER TABLE tmp.tmp_lokar_engine_assign 
ADD ixEngineSubfamily int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_lokar_engine_assign
LIMIT 10;

-- Update the new ixEngineSubfamily column with the corresponding values 
UPDATE tmp.tmp_lokar_engine_assign LEA, tblengine_subfamily ESF  
SET LEA.ixEngineSubfamily = ESF.ixEngineSubfamily
WHERE LEA.ixEngineFamily = ESF.ixEngineFamily
  AND LEA.sEngineSubfamilyName = ESF.sEngineSubfamilyName;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_lokar_engine_assign
WHERE ixEngineSubfamily IS NULL;  -- There should be 0 records returned 

-- A new column will need to be added to the temp table to store the tng version ixSKUVairant associated with the SOP ixSOPSKU  
ALTER TABLE tmp.tmp_lokar_engine_assign 
ADD ixSKUVariant int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_lokar_engine_assign
LIMIT 10;

-- Update the new ixSKUVariant column with the corresponding values 
UPDATE tmp.tmp_lokar_engine_assign LEA, tblskuvariant SV 
SET LEA.ixSKUVariant = SV.ixSKUVariant
WHERE LEA.ixSOPSKU = SV.ixSOPSKU;

-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tblskuvariant_engine_subfamily_xref (ixSKUVariant, ixEngineSubfamily, ixSOPSKU) -- all values updated 
SELECT DISTINCT ixSKUVariant, ixEngineSubfamily, ixSOPSKU -- 28 values updated, 28 distinct values 
FROM tmp.tmp_lokar_engine_assign
WHERE ixSKUVariant IS NOT NULL
  AND ixEngineSubfamily IS NOT NULL;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp.tmp_lokar_engine_assign;

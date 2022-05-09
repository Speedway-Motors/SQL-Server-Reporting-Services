-- The next task is assigning SKUs to new/additional ixApplication(s)

/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU and sApplicationValue).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. tngQA). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp_skuapplicationassignment *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp_skuapplicationassignment
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixSKUBase associated with the SOP ixSOPSKU 
ALTER TABLE tmp_skuapplicationassignment 
ADD ixSKUBase int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp_skuapplicationassignment
LIMIT 10;

-- Update the new ixSKUBase column with the corresponding values 
UPDATE tmp_skuapplicationassignment SAA, tblskuvariant SV 
SET SAA.ixSKUBase = SV.ixSKUBase
WHERE SAA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp_skuapplicationassignment
WHERE ixSKUBase IS NULL;  -- There should be 0 records returned 

-- There was an empty data row that was returning and needed to be deleted; below is the correct syntax
DELETE 
FROM tmp_skuapplicationassignment
WHERE tmp_skuapplicationassignment_id2 = 195;

-- A new column will need to be added to the temp table to store the tng version ixApplication associated with the sApplicationValue 
ALTER TABLE tmp_skuapplicationassignment 
ADD ixApplication int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp_skuapplicationassignment
LIMIT 10;

-- Update the new ixApplication column with the corresponding values 
UPDATE tmp_skuapplicationassignment SAA, tblapplication A 
SET SAA.ixApplication = A.ixApplication
WHERE SAA.sApplicationValue = A.sApplicationValue;

-- Verify all data updated  
SELECT *
FROM tmp_skuapplicationassignment
WHERE ixApplication IS NULL;  -- There should be 0 records returned 

-- Some records returned because the stored value for an application value was spelled incorrectly in the permanent table
UPDATE tblapplication
SET sApplicationValue = '2004-06 Pontiac GTO'
WHERE ixApplication = 89;

-- Re-run the update clause above after the data is corrected then verify all data updated. If null values still exist new applications may need to be added to the table 

-- The final table these need to be updated in is tblskuvariant_application_xref which also has ixSKUVariant so this will need to be added to the temp table
ALTER TABLE tmp_skuapplicationassignment 
ADD ixSKUVariant int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp_skuapplicationassignment
LIMIT 10;

-- Update the new ixSKUBase column with the corresponding values 
UPDATE tmp_skuapplicationassignment SAA, tblskuvariant SV 
SET SAA.ixSKUVariant = SV.ixSKUVariant
WHERE SAA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp_skuapplicationassignment
WHERE ixSKUVariant IS NULL;  -- There should be 0 records returned 

-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tblskuvariant_application_xref (ixSKUVariant, ixApplication, ixSOPSKU) -- all values updated 
SELECT DISTINCT ixSKUVariant, ixApplication, ixSOPSKU -- 238 undistinct, 238 distinct 
FROM tmp_skuapplicationassignment
WHERE ixSKUBase IS NOT NULL;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp_skuapplicationassignment;






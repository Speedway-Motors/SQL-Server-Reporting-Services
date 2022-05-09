-- The first task is assigning SKUs to additional ixMarket(s) 

/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU and sMarketName).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. AWS Live _ tmp). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp.tmp_skumarketassignment *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp.tmp_skumarketassignment
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixMarket associated with the sMarketName 
ALTER TABLE tmp.tmp_skumarketassignment 
ADD ixMarket int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_skumarketassignment
LIMIT 10;

-- Update the collation of the table if needed
ALTER TABLE tmp.tmp_skumarketassignment CONVERT to character set latin1 collate latin1_general_cs;

-- Update the new ixMarket column with the corresponding values 
UPDATE tmp.tmp_skumarketassignment SMA, tblmarket M  
SET SMA.ixMarket = M.ixMarket
WHERE SMA.sMarketName = M.sMarketName;

-- A new column will need to be added to the temp table to store the tng version ixSKUBase associated with the SOP ixSOPSKU 
ALTER TABLE tmp.tmp_skumarketassignment 
ADD ixSKUBase int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_skumarketassignment
LIMIT 10;

-- Update the new ixSKUBase column with the corresponding values 
UPDATE tmp.tmp_skumarketassignment SMA, tblskuvariant SV 
SET SMA.ixSKUBase = SV.ixSKUBase
WHERE SMA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_skumarketassignment
WHERE ixSKUBase IS NULL;  -- There should be 0 records returned -- There were 11 records that did not update correctly

-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- all values updated  - 4 already existed 
SELECT DISTINCT ixSKUBase, ixMarket -- 2058 distinct 
FROM tmp.tmp_skumarketassignment
WHERE ixSKUBase IS NOT NULL
  AND ixMarket IS NOT NULL;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp.tmp_skumarketassignment;



   
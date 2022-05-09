-- The first task is creating a new market that does not currently exist in tng 

-- Verify that the market does not already exist in tng 
SELECT *
FROM tblmarket;

/****************************
A similar market already exists ixMarket = 1775 "Drag Race" (vs. Drag Racing). 
I checked with Wyatt and he would like to modify the name from "Race" to "Racing" 
and then associate all new SKUs to the category as provided in the Excel file. 
In addition I have made and provided to him an Excel output of the SKUs already 
associated with the previously created market in case they needed to be removed in the
future 
*****************************/

-- Update the market naming convention 
UPDATE tblmarket
SET sMarketName = 'Drag Racing' 
WHERE ixMarket = 1775;

-- Verify it updated correctly 
SELECT *
FROM tblmarket 
WHERE ixMarket = 1775; 

-- The next step is to assign the SKUs provided by Wyatt in the Excel spreadsheet to the market 

/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU and sMarketName).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. tngQA). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp_skumarketassignment *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp_skumarketassignment
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixSKUBase associated with the SOP ixSOPSKU 
ALTER TABLE tmp_skumarketassignment 
ADD ixSKUBase int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp_skumarketassignment
LIMIT 10;

-- Update the new ixSKUBase column with the corresponding values 
UPDATE tmp_skumarketassignment SMA, tblskuvariant SV 
SET SMA.ixSKUBase = SV.ixSKUBase
WHERE SMA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NULL;  -- There should be 0 records returned 

/********************************* 
125 records had NULL ixSKUBase data; it looks like in some instances the "-" was removed to show 
index parts and others where the SKUs just have not been added to the web catalog. I emailed 
Wyatt an Excel file with the SKUs to correct and give back to me once they have been corrected. 
I will currently exclude these from the insert into the final table
***********************************/

-- A new column will need to be added to the temp table to store the tng version ixMarket associated with the sMarketName 
ALTER TABLE tmp_skumarketassignment 
ADD ixMarket int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp_skumarketassignment
LIMIT 10;

-- Update the new ixSKUBase column with the corresponding values 
UPDATE tmp_skumarketassignment SMA, tblmarket M
SET SMA.ixMarket = M.ixMarket
WHERE SMA.sMarketName = M.sMarketName;

-- Verify all data updated  
SELECT *
FROM tmp_skumarketassignment
WHERE ixMarket IS NULL;  -- There should be 0 records returned 

-- Insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 722 values already existed in tblskubasemarket 
SELECT DISTINCT ixSKUBase, ixMarket -- 8760 undistinct, 5179 distinct 
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NOT NULL; -- this will ignore those values that did not update due to not existing in the web catalog 

-- The last task is to make the existing market that was updated visible on the web

UPDATE tblmarket
SET flgVisible = 1 
WHERE ixMarket = 1775;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp_skumarketassignment;




   
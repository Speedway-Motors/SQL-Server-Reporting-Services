-- The first task is assigning SKUs to additional ixMarket(s) 

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
UPDATE tmp_skumarketassignment SMA, tngLive.tblskuvariant SV 
SET SMA.ixSKUBase = SV.ixSKUBase
WHERE SMA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NULL;  -- There should be 0 records returned 

SELECT * 
FROM tngLive.tblskuvariant 
WHERE ixSOPSKU IN ('54784771', '54777631', '5478857', '5478684', '5472938', '54783921', '54789501', '54784781', '54784791', '54783931', 
                    '5477760', '5475568', '5477530T', '5472314', '5478768'); -- 15 records do not exist in tblskuvariant (i.e. not on the web) 
                    
-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tngLive.tblskubasemarket (ixSKUBase, ixMarket) -- 1 value already existed 
SELECT DISTINCT ixSKUBase, ixMarket -- 535 distinct 
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NOT NULL
  AND ixMarket = 225;
  
INSERT IGNORE INTO tngLive.tblskubasemarket (ixSKUBase, ixMarket) -- 6 values already existed 
SELECT DISTINCT ixSKUBase, ixMarket2 -- 544 distinct 
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NOT NULL
  AND ixMarket2 = 2;  
  
INSERT IGNORE INTO tngLive.tblskubasemarket (ixSKUBase, ixMarket) -- 1 value already existed 
SELECT DISTINCT ixSKUBase, ixMarket3 -- 535 distinct 
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NOT NULL
  AND ixMarket3 = 1877;    
  
INSERT IGNORE INTO tngLive.tblskubasemarket (ixSKUBase, ixMarket) -- 1 value already existed 
SELECT DISTINCT ixSKUBase, ixMarket4 -- 535 distinct 
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NOT NULL
  AND ixMarket4 = 949;  
  
INSERT IGNORE INTO tngLive.tblskubasemarket (ixSKUBase, ixMarket) -- 1 value already existed 
SELECT DISTINCT ixSKUBase, ixMarket5 -- 535 distinct 
FROM tmp_skumarketassignment
WHERE ixSKUBase IS NOT NULL
  AND ixMarket5 = 857;    

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp_skumarketassignment;



   
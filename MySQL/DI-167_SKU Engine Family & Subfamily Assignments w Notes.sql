-- Look at the tables you will be using / inserting data into to undestand structure(s) 

SELECT *
FROM tblengine_family;

SELECT *
FROM tblengine_subfamily;

SELECT * 
FROM tblskuvariant_engine_subfamily_xref; -- ixSKUVariant, ixEngineSubfamily, ixSOPSKU 

/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU and sEngineFamilyName).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Choose the correct DB (AWS Live) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. tmp). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp_skuenginedata *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT * 
FROM tmp.tmp_skuenginedata;

-- Add the additional columns needed 
ALTER TABLE tmp.tmp_skuenginedata
 ADD ixSKUVariant int AFTER ixSOPSKU
,ADD ixEngineFamily int AFTER sEngineFamilyName
,ADD ixEngineSubfamily int AFTER sEngineSubfamilyName;

-- Verify the rows inserted correctly
SELECT * 
FROM tmp.tmp_skuenginedata;

-- Update the new columns with the corresponding values 
UPDATE tmp.tmp_skuenginedata SED, tngLive.tblskuvariant SV 
SET SED.ixSKUVariant = SV.ixSKUVariant
WHERE SED.ixSOPSKU = SV.ixSOPSKU;

SELECT * 
FROM tmp.tmp_skuenginedata
WHERE ixSKUVariant IS NULL; -- 3 records did not update / are not valid ('54784771', '54784781', '54784791')

UPDATE tmp.tmp_skuenginedata SED, tngLive.tblengine_family E
SET SED.ixEngineFamily = E.ixEngineFamily
WHERE SED.sEngineFamilyName = E.sEngineFamilyName;

SELECT * 
FROM tmp.tmp_skuenginedata
WHERE ixEngineFamily IS NULL; -- 22 records did not update because they were null values 

UPDATE tmp.tmp_skuenginedata SED, tngLive.tblengine_subfamily ESF
SET SED.ixEngineSubfamily = ESF.ixEngineSubfamily
WHERE SED.sEngineSubfamilyName = ESF.sEngineSubfamilyName
  AND SED.ixEngineFamily = ESF.ixEngineFamily;

SELECT * 
FROM tmp.tmp_skuenginedata
WHERE ixEngineSubfamily IS NULL; -- 22 records did not update because they were null values 

-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tngLive.tblskuvariant_engine_subfamily_xref (ixSKUVariant, ixEngineSubfamily, ixSOPSKU) -- all records inserted 
SELECT DISTINCT ixSKUVariant, ixEngineSubfamily, ixSOPSKU -- 76 distinct 
FROM tmp.tmp_skuenginedata
WHERE ixSKUVariant IS NOT NULL
  AND ixEngineSubfamily IS NOT NULL;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp.tmp_skuenginedata;

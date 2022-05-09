-- the way the excel file was stored there will be empty space column data that needs to be converted to nulls before getting started
-- if the table was not created to allow nulls you will need to select the table - choose alter - then columns - then unselect no nulls

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_1 = NULL WHERE Rear_Axle_Family_1 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_2 = NULL WHERE Rear_Axle_Family_2 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_3 = NULL WHERE Rear_Axle_Family_3 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_4 = NULL WHERE Rear_Axle_Family_4 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_5 = NULL WHERE Rear_Axle_Family_5 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_6 = NULL WHERE Rear_Axle_Family_6 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_7 = NULL WHERE Rear_Axle_Family_7 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_8 = NULL WHERE Rear_Axle_Family_8 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_9 = NULL WHERE Rear_Axle_Family_9 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_10 = NULL WHERE Rear_Axle_Family_10 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_11 = NULL WHERE Rear_Axle_Family_11 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_12 = NULL WHERE Rear_Axle_Family_12 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_13 = NULL WHERE Rear_Axle_Family_13 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_14 = NULL WHERE Rear_Axle_Family_14 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_15 = NULL WHERE Rear_Axle_Family_15 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_16 = NULL WHERE Rear_Axle_Family_16 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_17 = NULL WHERE Rear_Axle_Family_17 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_18 = NULL WHERE Rear_Axle_Family_18 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_19 = NULL WHERE Rear_Axle_Family_19 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_20 = NULL WHERE Rear_Axle_Family_20 = '';

UPDATE tmp_rear_axle_load
SET Rear_Axle_Family_21 = NULL WHERE Rear_Axle_Family_21 = '';

-- look at data in table 

SELECT *
FROM tmp_rear_axle_load;

-- create a condensed table so that each sku has (x) amount of columns for however many axle families it is a part of 

CREATE TABLE tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_1 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_1 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_2 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_2 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_3 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_3 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_4 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_4 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_5 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_5 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_6 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_6 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_7 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_7 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_8 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_8 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_9 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_9 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_10 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_10 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_11 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_11 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_12 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_12 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_13 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_13 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_14 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_14 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_15 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_15 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_16 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_16 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_17 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_17 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_18 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_18 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_19 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_19 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_20 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_20 IS NOT NULL;

INSERT INTO tmp_rear_axle_load_condense
SELECT SKU AS ixSOPSKU
     , Rear_Axle_Family_21 AS sRearAxleFamily
FROM tmp_rear_axle_load
WHERE Rear_Axle_Family_21 IS NOT NULL;

-- check the data and how it looks in the table 

SELECT *
FROM tmp_rear_axle_load_condense;

-- add two columns to the tmp table to accomodate the int values for sku and rear axle family from the existing tables 

ALTER TABLE tmp_rear_axle_load_condense
ADD COLUMN ixSKUVariant int,
ADD COLUMN ixRearAxleFamily int;

-- insert these values into the existing table to make sure all values exist before doing updates  
-- 12 axle families that do not exist in tblrearaxle_family 

INSERT IGNORE INTO tblrearaxle_family (sRearAxleFamily)
SELECT DISTINCT sRearAxleFamily
FROM tmp_rear_axle_load_condense;

-- update the tmp table to house the corresponding existing table values 

UPDATE tmp_rear_axle_load_condense RALC, tblrearaxle_family RAF 
SET RALC.ixRearAxleFamily = RAF.ixRearAxleFamily
WHERE RALC.sRearAxleFamily = RAF.sRearAxleFamily;


-- check the data and how it looks in the table 

SELECT DISTINCT sRearAxleFamily
FROM tmp_rear_axle_load_condense
WHERE ixRearAxleFamily IS NULL;


-- update the other field

UPDATE tmp_rear_axle_load_condense RALC, tblskuvariant SV 
SET RALC.ixSKUVariant = SV.ixSKUVariant
WHERE RALC.ixSOPSKU = SV.ixSOPSKU;

-- check the data and how it looks in the table - all sku variants loaded properly 

SELECT *
FROM tmp_rear_axle_load_condense
WHERE ixSKUVariant IS NULL;

-- import the data into the existing table to become part of the live database 
-- to avoid duplicate entries / PK error add ignore to insert statement
-- out of 3507 records 1830 were added to the tables as new entries 
INSERT IGNORE INTO tblskuvariant_rearaxle_family (ixSOPSKU, ixRearAxleFamily, ixSKUVariant) 
SELECT ixSOPSKU
     , ixRearAxleFamily
     , ixSKUVariant
FROM tmp_rear_axle_load_condense;

-- after everything is complete remember to drop the tmp tables from the DB so they do not get stored 
DROP TABLE tmp_rear_axle_load;
DROP TABLE tmp_rear_axle_load_condense;






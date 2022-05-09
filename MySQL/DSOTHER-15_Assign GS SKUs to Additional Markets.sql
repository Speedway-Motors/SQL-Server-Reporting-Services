-- Assign all SKUs in sheet 2 of the attached Excel file to ixMarket 2 (Oval Track) and ixMarket 741 (Open Wheel)
-- Assign all SKUs in sheet 3 of the attached Excel file to ixMarket 225 (Street Rod), ixMarket 857 (Classic Truck), ixMarket 949 (Muscle Car) and ixMarket 1877 (T-Bucket)

/*

 1) To start create and Excel file with the SOP SKU (ixSOPSKU) and another column with the market it should be placed in (i.e. oval track = 2) 
 2) Use the MYSQL for Excel add on to create a temp table in tng that stores this data (i.e. tmpskumarketassign) 
 3) Insert a new column into the table to house the ixSKUBase for these SKUs to make later insertion into tblskubasemarket easier 

*/

ALTER TABLE tmpskumarketassign 
ADD ixSKUBase int;

-- look at the table to verify it was added 

SELECT * 
FROM tmpskumarketassign -- 20245 rows 
LIMIT 10; 

-- update the ixSKUBase values into the temp table 

UPDATE tmpskumarketassign SMA, tblskubase SB 
SET SMA.ixSKUBase = SB.ixSKUBase
WHERE SMA.ixSOPSKU = SB.ixSOPSKUBase;

-- check where values were not updated (2 did not update due to Excel changing to a non-text value) 

SELECT *
FROM tmpskumarketassign
WHERE ixSKUBase IS NULL; -- ixSOPSKU = '2.37E+208' x2 Ask Jeremy about this 

-- insert DISTINCT values into tblskubasemarket where ixSKUBase was not null in the tmp table created (**)

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 15404 values updated into tng table (some values [250] already existed with that market value in the table)
SELECT DISTINCT ixSKUBase, ixMarket -- 20243 undistinct, 15654 distinct 
FROM tmpskumarketassign
WHERE ixSKUBase IS NOT NULL;

-- for the same SKUs to be added as another market sector simply update the tmp table to change the ixMarket from one to the other (i.e. 2 [Oval Track] to 741 [Open Wheel]) 

UPDATE tmpskumarketassign
SET ixMarket = 741
WHERE ixMarket = 2;

-- then re-do the insert step above (**)

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 15431 values updated into tng table (some values [223] already existed with that market value in the table)
SELECT DISTINCT ixSKUBase, ixMarket -- 20243 undistinct, 15654 distinct 
FROM tmpskumarketassign
WHERE ixSKUBase IS NOT NULL;

-- drop the temp table once you no longer need it 

DROP TABLE tmpskumarketassign;

-- repeat all steps for remaining market inserts 

ALTER TABLE tmpskumarketassign 
ADD ixSKUBase int;

-- look at the table to verify it was added 

SELECT * 
FROM tmpskumarketassign -- 19804 rows 
LIMIT 10; 

-- update the ixSKUBase values into the temp table 

UPDATE tmpskumarketassign SMA, tblskubase SB 
SET SMA.ixSKUBase = SB.ixSKUBase
WHERE SMA.ixSOPSKU = SB.ixSOPSKUBase;

-- check where values were not updated (1 did not update due to Excel changing to a non-text value) 

SELECT *
FROM tmpskumarketassign
WHERE ixSKUBase IS NULL; -- ixSOPSKU = '91913.3' Ask Jeremy about this 

-- insert DISTINCT values into tblskubasemarket where ixSKUBase was not null in the tmp table created (**)

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 17421 values updated into tng table (some values [136] already existed with that market value in the table)
SELECT DISTINCT ixSKUBase, ixMarket -- 19803 undistinct, 17557 distinct 
FROM tmpskumarketassign
WHERE ixSKUBase IS NOT NULL;

-- for the same SKUs to be added as another market sector simply update the tmp table to change the ixMarket from one to the other (i.e. 2 [Oval Track] to 741 [Open Wheel]) 
-- ixMarket 857 (Classic Truck), ixMarket 949 (Muscle Car) and ixMarket 1877 (T-Bucket)
UPDATE tmpskumarketassign
SET ixMarket = 857
WHERE ixMarket = 225;

-- then re-do the insert step above (**)

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 17445 values updated into tng table (some values [112] already existed with that market value in the table)
SELECT DISTINCT ixSKUBase, ixMarket -- -- 19803 undistinct, 17557 distinct 
FROM tmpskumarketassign
WHERE ixSKUBase IS NOT NULL;

-- for the same SKUs to be added as another market sector simply update the tmp table to change the ixMarket from one to the other (i.e. 2 [Oval Track] to 741 [Open Wheel]) 
-- ixMarket 949 (Muscle Car) and ixMarket 1877 (T-Bucket)
UPDATE tmpskumarketassign
SET ixMarket = 949
WHERE ixMarket = 857;

-- then re-do the insert step above (**)

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 17400 values updated into tng table (some values [157] already existed with that market value in the table)
SELECT DISTINCT ixSKUBase, ixMarket -- -- 19803 undistinct, 17557 distinct 
FROM tmpskumarketassign
WHERE ixSKUBase IS NOT NULL;

-- for the same SKUs to be added as another market sector simply update the tmp table to change the ixMarket from one to the other (i.e. 2 [Oval Track] to 741 [Open Wheel]) 
-- ixMarket 1877 (T-Bucket)
UPDATE tmpskumarketassign
SET ixMarket = 1877
WHERE ixMarket = 949;

-- then re-do the insert step above (**)

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 17473 values updated into tng table (some values [84] already existed with that market value in the table)
SELECT DISTINCT ixSKUBase, ixMarket -- -- 19803 undistinct, 17557 distinct 
FROM tmpskumarketassign
WHERE ixSKUBase IS NOT NULL;

-- drop the temp table once you no longer need it 

DROP TABLE tmpskumarketassign;
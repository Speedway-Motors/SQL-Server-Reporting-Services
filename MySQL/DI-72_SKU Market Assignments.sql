-- the new temp table will show in the refreshed table list that was exported from excel 
-- in order to make the data fit into the current tables condense into one table 

-- first set the values in each market column equal to the ixMarket value that exists in the current tables 

-- update the values accordingly 

UPDATE tmp_market_sku_assign MSA 
SET Oval_Track = 2 WHERE Oval_Track = 1;

UPDATE tmp_market_sku_assign MSA 
SET Pedal_Car = 3 WHERE Pedal_Car = 1;

UPDATE tmp_market_sku_assign MSA 
SET Garage_Sale = 222 WHERE Garage_Sale = 1;

UPDATE tmp_market_sku_assign MSA 
SET Street_Rod = 225 WHERE Street_Rod = 1;

UPDATE tmp_market_sku_assign MSA 
SET Open_Wheel = 741 WHERE Open_Wheel = 1;

UPDATE tmp_market_sku_assign MSA 
SET Classic_Truck = 857 WHERE Classic_Truck = 1;

UPDATE tmp_market_sku_assign MSA 
SET Muscle_Car = 949 WHERE Muscle_Car = 1;

UPDATE tmp_market_sku_assign MSA 
SET TBucket = 1877 WHERE TBucket = 1;

UPDATE tmp_market_sku_assign MSA 
SET Drag_Race = 1775 WHERE Drag_Race = 1;

SELECT * 
FROM tmp_market_sku_assign MSA
WHERE ixSKUBase = 53803;

-- create a condensed version of the table so that each sku base has multiple rows for every corresponding market it is a part of 
DROP TABLE tmp_market_sku_assign_condense;
CREATE TABLE tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Oval_Track AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Oval_Track = 2;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Pedal_Car AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Pedal_Car = 3;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Garage_Sale AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Garage_Sale = 222;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Street_Rod AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Street_Rod = 225;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Open_Wheel AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Open_Wheel = 741;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Classic_Truck AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Classic_Truck = 857;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Muscle_Car AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Muscle_Car = 949;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.TBucket AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE TBucket = 1877;

INSERT INTO tmp_market_sku_assign_condense 
SELECT MSA.ixSKUBase
     , MSA.Drag_Race AS ixMarket
FROM tmp_market_sku_assign MSA
WHERE Drag_Race = 1775;

-- check some values against the original excel file 

SELECT *
FROM tmp_market_sku_assign_condense
WHERE ixSKUBase = 4082;

-- see how many duplicate values already exist in live table (243)

SELECT SBM.ixSKUBase
     , SBM.ixMarket
FROM tblskubasemarket SBM
WHERE SBM.ixSKUBase IN (SELECT MSAC.ixSKUBase
                        FROM tmp_market_sku_assign_condense MSAC
                       );

-- once data has been checked insert it into the current tables 
-- 1934 unique values only 1721 records inserted with ignore statement on (213 duplicate records)
INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket)
SELECT DISTINCT ixSKUBase 
     , ixMarket 
FROM tmp_market_sku_assign_condense MSAC; 


-- re-check data went into the table correctly 
SELECT DISTINCT SBM.ixMarket, sMarketName 
FROM tblskubasemarket SBM
LEFT JOIN tblmarket M ON M.ixMarket = SBM.ixMarket
WHERE ixSKUBase = 36202;

-- to make sure all data exists 
SELECT MSAC.ixSKUBase, SBM.ixSKUBase -- , SBM.ixMarket
FROM tmp_market_sku_assign_condense MSAC 
LEFT JOIN tblskubasemarket SBM ON SBM.ixSKUBase = MSAC.ixSKUBase

-- drop temp tables so they are not left in permanent db 
DROP TABLE tmp_market_sku_assign;
DROP TABLE tmp_market_sku_assign_condense;
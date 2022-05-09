SELECT *
FROM tblmarket;

-- ixMarket came from old PSG dept IDs per RCE so choose a unique value and create new market 
INSERT INTO tblmarket (ixMarket, sMarketName, dtCreate, dtLastUpdate, flgActive, flgVisible)
VALUES (4,'Sport Compact', Now(), Now(), 1, 1);

-- re-select from tblmarket to verify values insert correctly 

-- move data from spreadsheet to temp table to query against and check that all data exists in table 

SELECT * FROM tmp_sportcompactupload

-- add column for ixSKUBase (tng format) 

ALTER TABLE tmp_sportcompactupload
ADD ixSKUBase int;

-- verify it was added 

SELECT * FROM tmp_sportcompactupload;

-- update values into the temp table 

UPDATE tmp_sportcompactupload SC, tblskubase SB 
SET SC.ixSKUBase = SB.ixSKUBase
WHERE SC.ixSOPSKUBase = SB.ixSOPSKUBase;

-- check that all values updated in the temp table 

SELECT * FROM tmp_sportcompactupload
WHERE ixSKUBase IS NULL; -- no values are null 

-- insert DISTINCT values into tblskubasemarket where ixSKUBase was not null in the tmp table created 

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- 325 values updated into tng table 
SELECT DISTINCT ixSKUBase, ixMarket 
FROM tmp_sportcompactupload
WHERE ixSKUBase IS NOT NULL;

-- for the same SKUs to be added as another market sector simply update the tmp table to change the ixMarket from one to the other (i.e. 4 [Sport Compact] to 222 [Garage Sale]) 

UPDATE tmp_sportcompactupload
SET ixMarket = 222
WHERE ixMarket = 4;

-- then re-do the insert step above 

INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket) -- only 1 row updated as all other values already cross reference to the garage sale market in the table 
SELECT DISTINCT ixSKUBase, ixMarket 
FROM tmp_sportcompactupload
WHERE ixSKUBase IS NOT NULL;

-- drop the temp table once you no longer need it 

DROP TABLE tmp_sportcompactupload;
SELECT * FROM tngLive.tmp_engine_codes;

UPDATE tmp_engine_codes
SET Code_2 = NULL WHERE Code_2 = '';

UPDATE tmp_engine_codes
SET Code_3 = NULL WHERE Code_3 = '';

UPDATE tmp_engine_codes
SET Code_4 = NULL WHERE Code_4 = '';

UPDATE tmp_engine_codes
SET Code_5 = NULL WHERE Code_5 = '';

UPDATE tmp_engine_codes
SET Code_6 = NULL WHERE Code_6 = '';

UPDATE tmp_engine_codes
SET Code_7 = NULL WHERE Code_7 = '';

UPDATE tmp_engine_codes
SET Code_8 = NULL WHERE Code_8 = '';

UPDATE tmp_engine_codes
SET Code_9 = NULL WHERE Code_9 = '';

UPDATE tmp_engine_codes
SET Code_10 = NULL WHERE Code_10 = '';

UPDATE tmp_engine_codes
SET Code_11 = NULL WHERE Code_11 = '';

UPDATE tmp_engine_codes
SET Code_12 = NULL WHERE Code_12 = '';

UPDATE tmp_engine_codes
SET Code_13 = NULL WHERE Code_13 = '';

UPDATE tmp_engine_codes
SET Code_14 = NULL WHERE Code_14 = '';

UPDATE tmp_engine_codes
SET Code_15 = NULL WHERE Code_15 = '';

UPDATE tmp_engine_codes
SET Code_16 = NULL WHERE Code_16 = '';

UPDATE tmp_engine_codes
SET Code_17 = NULL WHERE Code_17 = '';

UPDATE tmp_engine_codes
SET Code_18 = NULL WHERE Code_18 = '';

UPDATE tmp_engine_codes
SET Code_19 = NULL WHERE Code_19 = '';

UPDATE tmp_engine_codes
SET Code_20 = NULL WHERE Code_20 = '';

UPDATE tmp_engine_codes
SET Code_21 = NULL WHERE Code_21 = '';

UPDATE tmp_engine_codes
SET Code_22 = NULL WHERE Code_22 = '';

UPDATE tmp_engine_codes
SET Code_23 = NULL WHERE Code_23 = '';

UPDATE tmp_engine_codes
SET Code_24 = NULL WHERE Code_24 = '';

UPDATE tmp_engine_codes
SET Code_25 = NULL WHERE Code_25 = '';

UPDATE tmp_engine_codes
SET Code_26 = NULL WHERE Code_26 = '';

UPDATE tmp_engine_codes
SET Code_27 = NULL WHERE Code_27 = '';

SELECT *
FROM tngLive.tmp_engine_codes
WHERE SKU = '91015177' 
  AND Engine_Family_ = 'Chrysler Big Block V8';

USE tngLive;
INSERT INTO tblengine_family (sEngineFamilyName)
SELECT DISTINCT Engine_Family_ 
FROM tngLive.tmp_engine_codes;

DROP TABLE tmp_subfamily_condense;
CREATE TABLE tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_1 AS SubFamily
FROM tmp_engine_codes
WHERE Code_1 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_2 AS SubFamily
FROM tmp_engine_codes
WHERE Code_2 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_3 AS SubFamily
FROM tmp_engine_codes
WHERE Code_3 IS NOT NULL;  

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_4 AS SubFamily
FROM tmp_engine_codes
WHERE Code_4 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_5 AS SubFamily
FROM tmp_engine_codes
WHERE Code_5 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_6 AS SubFamily
FROM tmp_engine_codes
WHERE Code_6 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_7 AS SubFamily
FROM tmp_engine_codes
WHERE Code_7 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_8 AS SubFamily
FROM tmp_engine_codes
WHERE Code_8 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_9 AS SubFamily
FROM tmp_engine_codes
WHERE Code_9 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_10 AS SubFamily
FROM tmp_engine_codes
WHERE Code_10 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_11 AS SubFamily
FROM tmp_engine_codes
WHERE Code_11 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_12 AS SubFamily
FROM tmp_engine_codes
WHERE Code_12 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_13 AS SubFamily
FROM tmp_engine_codes
WHERE Code_13 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_14 AS SubFamily
FROM tmp_engine_codes
WHERE Code_14 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_15 AS SubFamily
FROM tmp_engine_codes
WHERE Code_15 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_16 AS SubFamily
FROM tmp_engine_codes
WHERE Code_16 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_17 AS SubFamily
FROM tmp_engine_codes
WHERE Code_17 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_18 AS SubFamily
FROM tmp_engine_codes
WHERE Code_18 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_19 AS SubFamily
FROM tmp_engine_codes
WHERE Code_19 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_20 AS SubFamily
FROM tmp_engine_codes
WHERE Code_20 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_21 AS SubFamily
FROM tmp_engine_codes
WHERE Code_21 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_22 AS SubFamily
FROM tmp_engine_codes
WHERE Code_22 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_23 AS SubFamily
FROM tmp_engine_codes
WHERE Code_23 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_24 AS SubFamily
FROM tmp_engine_codes
WHERE Code_24 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_25 AS SubFamily
FROM tmp_engine_codes
WHERE Code_25 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_26 AS SubFamily
FROM tmp_engine_codes
WHERE Code_26 IS NOT NULL;

INSERT INTO tmp_subfamily_condense
SELECT SKU
	   , Engine_Family_
     , Code_27 AS SubFamily
FROM tmp_engine_codes
WHERE Code_27 IS NOT NULL;

ALTER TABLE tmp_subfamily_condense
ADD COLUMN ixEngineFamily int;

alter table tmp_subfamily_condense convert to character set latin1 collate latin1_general_cs;

UPDATE tmp_subfamily_condense SC, tblengine_family EF 
SET SC.ixEngineFamily = EF.ixEngineFamily
WHERE SC.Engine_Family_ = EF.sEngineFamilyName;

-- make sure that all values updated 
SELECT *
FROM tmp_subfamily_condense
WHERE ixEngineFamily IS NULL; 

INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
SELECT DISTINCT SubFamily
     , ixEngineFamily
FROM tmp_subfamily_condense;

ALTER TABLE tmp_subfamily_condense
ADD COLUMN ixEngineSubfamily int,
ADD COLUMN ixSKUVariant int; 
  
UPDATE tmp_subfamily_condense SC, tblengine_subfamily SF 
SET SC.ixEngineSubfamily = SF.ixEngineSubfamily
WHERE SC.ixEngineFamily = SF.ixEngineFamily
  AND SC.SubFamily = SF.sEngineSubfamilyName;

-- make sure that all values updated 
SELECT *
FROM tmp_subfamily_condense
WHERE ixEngineSubfamily IS NULL; 

UPDATE tmp_subfamily_condense SC, tblskuvariant SV 
SET SC.ixSKUVariant = SV.ixSKUVariant
WHERE SC.SKU = SV.ixSOPSKU;

-- make sure that all values updated 
SELECT *
FROM tmp_subfamily_condense
WHERE ixSKUVariant IS NULL; 

-- there were duplicate entries so ignore is added to allow the inserts to continue and bypass the duplicates (4 found) 
INSERT IGNORE INTO tblskuvariant_engine_subfamily_xref (ixSKUVariant, ixEngineSubfamily, ixSOPSKU) 
SELECT ixSKUVariant
     , ixEngineSubfamily
     , SKU
FROM tmp_subfamily_condense;

-- check data
SELECT ixSOPSKU
     , EF.sEngineFamilyName
     , SF.sEngineSubfamilyName
FROM tblskuvariant_engine_subfamily_xref ESFX
LEFT JOIN tblengine_subfamily SF ON SF.ixEngineSubfamily = ESFX.ixEngineSubfamily
LEFT JOIN tblengine_family EF ON EF.ixEngineFamily = SF.ixEngineFamily
WHERE ixSOPSKU = '930C46'
LIMIT 10 ;

DROP TABLE tmp_engine_codes;
DROP TABLE tmp_subfamily_condense;





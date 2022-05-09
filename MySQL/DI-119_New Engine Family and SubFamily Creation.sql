SELECT *
FROM tblengine_family
WHERE sEngineFamilyName LIKE 'Ford%'
LIMIT 10;

-- ixEngineFamily is auto incrementing 

INSERT INTO tblengine_family (sEngineFamilyName)
VALUES ('Ford Modular V8'); -- 26
INSERT INTO tblengine_family (sEngineFamilyName)
VALUES ('Holden V8'); -- 27
INSERT INTO tblengine_family (sEngineFamilyName)
VALUES ('Chrysler Slant Six'); -- 28 
INSERT INTO tblengine_family (sEngineFamilyName)
VALUES ('Pontiac Iron Duke Inline Four'); -- 29
INSERT INTO tblengine_family (sEngineFamilyName)
VALUES ('Chevy Inline Four'); -- 30 
INSERT INTO tblengine_family (sEngineFamilyName)
VALUES ('Chevy Corvair Air Cooled Flat Six'); -- 31 
 
SELECT *
FROM tblengine_family
WHERE sEngineFamilyName IN ('Ford Modular V8', 'Holden V8', 'Chrysler Slant Six', 'Pontiac Iron Duke Inline Four'
                             , 'Chevy Inline Four', 'Chevy Corvair Air Cooled Flat Six'); 
                             
SELECT *
FROM tblengine_subfamily
LIMIT 10;

-- ixEngineSubfamily is auto incrementing 

INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('4.6', 26); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('5.0', 26); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('5.4', 26); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('5.8', 26); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('6.2', 26); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('253', 27); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('308', 27); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('170', 28); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('198', 28); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('225', 28); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('151', 29); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('153', 30); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('140', 31); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('145', 31); 
INSERT INTO tblengine_subfamily (sEngineSubfamilyName, ixEngineFamily) 
VALUES ('164', 31); 

SELECT *
FROM tblengine_subfamily
WHERE ixEngineFamily IN (26,27,28,29,30,31);
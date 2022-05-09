-- Look at the table and make sure the values are not existing 
SELECT *
FROM tblsanctioning_body;

-- Add the remaining values into the table 

INSERT INTO tblsanctioning_body (sSanctioningBody) 
VALUES ('USMTS');

INSERT INTO tblsanctioning_body (sSanctioningBody) 
VALUES ('World of Outlaws');

INSERT INTO tblsanctioning_body (sSanctioningBody) 
VALUES ('DIRTcar');

-- Verify that the table updated correctly  
SELECT *
FROM tblsanctioning_body;

-- Look at the table and make sure the values are not existing 
SELECT *
FROM tblengine_family
WHERE sEngineFamilyName IN ('Chevy 90-Degree V6', 'Chevy 60-Degree V6');

-- Add the remaining values into the table 

INSERT INTO tblengine_family (sEngineFamilyName) 
VALUES ('Chevy 90-Degree V6'); -- ixEngineFamily 24

INSERT INTO tblengine_family (sEngineFamilyName)
VALUES ('Chevy 60-Degree V6'); -- ixEngineFamily 25

-- Look at the layout of the next table to add data to
SELECT * 
FROM tblengine_subfamily
WHERE ixEngineFamily = 13;

-- Add the remaining values into the table 
INSERT INTO tblengine_subfamily(sEngineSubfamilyName,ixEngineFamily)
VALUES (200,24);

INSERT INTO tblengine_subfamily(sEngineSubfamilyName,ixEngineFamily)
VALUES (229,24);

INSERT INTO tblengine_subfamily(sEngineSubfamilyName,ixEngineFamily)
VALUES (262,24);

INSERT INTO tblengine_subfamily(sEngineSubfamilyName,ixEngineFamily)
VALUES (2.8,25);

INSERT INTO tblengine_subfamily(sEngineSubfamilyName,ixEngineFamily)
VALUES (3.1,25);

INSERT INTO tblengine_subfamily(sEngineSubfamilyName,ixEngineFamily)
VALUES (3.4,25);

-- check that data loaded into table properly 
SELECT *
FROM tblengine_subfamily
WHERE ixEngineFamily IN ('24','25');

-- last data upload of applications not existing in the table
-- first load into temp table then bring over 

SELECT *
FROM tblapplication
ORDER BY ixApplication;

INSERT INTO tblapplication (sApplicationValue) 
SELECT DISTINCT Applications
FROM tmp_application_additions;

DROP TABLE tmp_application_additions;
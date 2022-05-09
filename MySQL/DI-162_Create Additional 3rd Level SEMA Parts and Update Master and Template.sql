SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18239 -- move on from here 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18240, 'Suspension Tie Bars', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings and Accessories%'; -- 210

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18240;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18240, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18240, 'Suspension Tie Bars', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18240; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18240;


-- Insert the next value 
SELECT * FROM SEMAPart WHERE partterminologyname LIKE 'Exhaust Header%'; -- PartTerminologyID 18103 
-- already existed 

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Exhaust'; -- 11

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Exhaust Headers%'; -- 150

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18103;

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18103; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18103;


-- Change existing part name to new name 
SELECT * 
FROM SEMAPart 
WHERE partterminologyname LIKE 'Panhard Rods%'; -- PartTerminologyID 13647 

UPDATE SEMAPart 
SET partterminologyname = 'Panhard Bars' 
WHERE partterminologyname = 'Panhard Rods'; 

UPDATE SEMAPart 
SET sSingularPartTerm = 'Panhard Bar' 
WHERE sSingularPartTerm = 'Panhard Rod'; 


UPDATE SEMAPart 
SET RevDate = NOW()
WHERE sSingularPartTerm = 'Panhard Bar'; 

SELECT *
FROM SEMAPart 
WHERE PartTerminologyID = 13647; 

SELECT * 
FROM SEMACodeMaster
WHERE PartTerminologyID = 13647; 

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 13647; 

Update Template
SET sTitle = 'Panhard Bars' 
WHERE ixPartTerminologyID = 13647; 

Update Template
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixPartTerminologyID = 13647; 


-- verify it auto udpated on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 13647;

SELECT *
FROM tngLive.tblsemapart
WHERE ixSemaPart = 13647;


-- Change existing part name to new name 
SELECT * 
FROM SEMAPart 
WHERE partterminologyname LIKE 'Panhard Rod Braces%'; -- PartTerminologyID 14817 

UPDATE SEMAPart 
SET partterminologyname = 'Panhard Bar Braces' 
WHERE partterminologyname = 'Panhard Rod Braces'; 

UPDATE SEMAPart 
SET sSingularPartTerm = 'Panhard Bar Brace' 
WHERE sSingularPartTerm = 'Panhard Rod Brace'; 


UPDATE SEMAPart 
SET RevDate = NOW()
WHERE sSingularPartTerm = 'Panhard Bar Brace'; 

SELECT *
FROM SEMAPart 
WHERE PartTerminologyID = 14817; 

SELECT * 
FROM SEMACodeMaster
WHERE PartTerminologyID = 14817; 

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 14817; 

Update Template
SET sTitle = 'Panhard Bar Braces' 
WHERE ixPartTerminologyID = 14817; 

Update Template
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixPartTerminologyID = 14817; 


-- verify it auto udpated on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 14817;

SELECT *
FROM tngLive.tblsemapart
WHERE ixSemaPart = 14817;


-- Change existing part name to new name 
SELECT * 
FROM SEMAPart 
WHERE partterminologyname LIKE 'Panhard Rod%'; -- PartTerminologyID 14818

UPDATE SEMAPart 
SET partterminologyname = 'Panhard Bar Relocation Kits' 
WHERE PartTerminologyID = 14818; 

UPDATE SEMAPart 
SET sSingularPartTerm = 'Panhard Bar Relocation Kit' 
WHERE PartTerminologyID = 14818; 


UPDATE SEMAPart 
SET RevDate = NOW()
WHERE PartTerminologyID = 14818; 

SELECT *
FROM SEMAPart 
WHERE PartTerminologyID = 14818; 

SELECT * 
FROM SEMACodeMaster
WHERE PartTerminologyID = 14818; 

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 14818; 

Update Template
SET sTitle = 'Panhard Bar Relocation Kits' 
WHERE ixPartTerminologyID = 14818; 

Update Template
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixPartTerminologyID = 14818; 


-- verify it auto udpated on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 14818;

SELECT *
FROM tngLive.tblsemapart
WHERE ixSemaPart = 14818;


-- Change existing part name to new name 
SELECT * 
FROM SEMAPart 
WHERE partterminologyname LIKE 'Suspension Panhard Rod%'; -- PartTerminologyID 10924

UPDATE SEMAPart 
SET partterminologyname = 'Panhard Bar Bushings' 
WHERE PartTerminologyID = 10924; 

UPDATE SEMAPart 
SET sSingularPartTerm = 'Panhard Bar Bushing' 
WHERE PartTerminologyID = 10924; 


UPDATE SEMAPart 
SET RevDate = NOW()
WHERE PartTerminologyID = 10924; 

SELECT *
FROM SEMAPart 
WHERE PartTerminologyID = 10924; 

SELECT * 
FROM SEMACodeMaster
WHERE PartTerminologyID = 10924; 

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 10924; 

Update Template
SET sTitle = 'Panhard Bar Bushings' 
WHERE ixPartTerminologyID = 10924; 

Update Template
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixPartTerminologyID = 10924; 


-- verify it auto udpated on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 10924;

SELECT *
FROM tngLive.tblsemapart
WHERE ixSemaPart = 10924;



-- Change existing part name to new name 
SELECT * 
FROM SEMAPart 
WHERE partterminologyname LIKE 'Suspension Track Bar%'; -- PartTerminologyID 14921

UPDATE SEMAPart 
SET partterminologyname = 'Panhard Bar Brackets' 
WHERE PartTerminologyID = 14921; 

UPDATE SEMAPart 
SET sSingularPartTerm = 'Panhard Bar Bracket' 
WHERE PartTerminologyID = 14921; 


UPDATE SEMAPart 
SET RevDate = NOW()
WHERE PartTerminologyID = 14921; 

SELECT *
FROM SEMAPart 
WHERE PartTerminologyID = 14921; 

SELECT * 
FROM SEMACodeMaster
WHERE PartTerminologyID = 14921; 

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 14921; 

Update Template
SET sTitle = 'Panhard Bar Bracket' 
WHERE ixPartTerminologyID = 14921; 

Update Template
SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook'
WHERE ixPartTerminologyID = 14921; 


-- verify it auto udpated on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 14921;

SELECT *
FROM tngLive.tblsemapart
WHERE ixSemaPart = 14921;




SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18210 -- move on from here 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18211, 'Valve Cover Breathers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18211;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18211, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18211, 'Valve Cover Breathers', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18211; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18211;

-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18212, 'Valve Cover Breather Grommets', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18212;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18212, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18212, 'Valve Cover Breather Grommets', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18212; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18212;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18213, 'Valve Cover Oil Filler Extensions', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18213;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18213, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18213, 'Valve Cover Oil Filler Extensions', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18213; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18213;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18214, 'Valve Cover Oil Filler Caps', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18214;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18214, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18214, 'Valve Cover Oil Filler Caps', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18214; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18214;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18215, 'Valve Cover Breather Pre-Filters', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18215;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18215, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18215, 'Valve Cover Breather Pre-Filters', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18215; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18215;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18216, 'Valve Cover Emblems', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18216;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18216, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18216, 'Valve Cover Emblems', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18216; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18216;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18217, 'Valve Cover Breather Stands', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18217;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18217, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18217, 'Valve Cover Breather Stands', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18217; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18217;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18218, 'Fuel Injection Systems', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Fuel Injection%'; -- 160

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18218;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 160, 18218, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18218, 'Fuel Injection Systems', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18218; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18218;

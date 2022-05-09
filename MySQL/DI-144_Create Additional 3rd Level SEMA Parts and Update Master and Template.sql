SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18205 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18206, 'Power Steering Upgrade Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Steering'; -- 15

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Power Steering Comp%'; -- 189

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18206;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (15, 189, 18206, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18206, 'Power Steering Upgrade Kits', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18206; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18206;

-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18207, 'Frame C-Notch Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Frame%'; -- 158

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18207;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 158, 18207, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18207, 'Frame C-Notch Kits', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18207; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18207;

-- insert the next part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18208, 'Carburetor Throttle Shafts', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Carburetion%'; -- 125

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18208;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 125, 18208, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18208, 'Carburetor Throttle Shafts', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18208; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18208;

-- insert the next part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18209, 'Anti-Sway Bar Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings and%'; -- 210

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18209;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18209, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18209, 'Anti-Sway Bar Kits', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18209; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18209;

-- change the naming of an existing SEMA Part -- Per CCC and RCE this is ok to do 
SELECT * 
FROM SEMAPart 
WHERE partterminologyname LIKE 'Nylon Cable%'; -- 10125

-- manually changed 
SELECT * 
FROM SEMAPart 
WHERE PartTerminologyID = 10125;

SELECT * 
FROM SEMACodeMaster
WHERE PartTerminologyID = 10125; -- 23, 240, 10125 

SELECT * 
FROM Template 
WHERE ixPartTerminologyID = 10125;
-- manually changed 

-- verify whether it auto corrected on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 10125; -- part name not referenced no changes needed 


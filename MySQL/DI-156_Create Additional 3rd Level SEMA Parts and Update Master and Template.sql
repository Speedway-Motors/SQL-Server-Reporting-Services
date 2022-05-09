SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18228 -- move on from here 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18229, 'Pull Bars', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18229, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18229, 'Pull Bars', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18229; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18229;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18230, 'Pull Bar Springs', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18230, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18230, 'Pull Bar Springs', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18230; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18230;




-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18231, 'Pull Bar Bushings', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18231, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18231, 'Pull Bar Bushings', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18231; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18231;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18232, 'Pull Bar Bolts', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18232, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18232, 'Pull Bar Bolts', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18232; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18232;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18233, 'Coil Spring Sliders', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18233, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18233, 'Coil Spring Sliders', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18233; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18233;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18234, 'Coil Spring Slider Plates', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18234, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18234, 'Coil Spring Slider Plates', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18234; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18234;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18235, 'Coil Spring Slider Shafts', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18235, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18235, 'Coil Spring Slider Shafts', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18235; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18235;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18236, 'Coil Spring Slider Rebuild Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18236, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18236, 'Coil Spring Slider Rebuild Kits', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18236; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18236;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18237, 'Coil Spring Slider Pins', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18237, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18237, 'Coil Spring Slider Pins', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18237; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18237;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18238, 'Axle Housing Top Link Brackets', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings%'; -- 210

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18238, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18238, 'Axle Housing Top Link Brackets', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18238; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18238;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18239, 'Bump Steer Correction Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Steering'; -- 15

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Tie Rods, Drag Links%'; -- 323

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (15, 323, 18239, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18239, 'Bump Steer Correction Kits', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18239; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18239;

-- Update an existing value 
SELECT * FROM SEMAPart WHERE partterminologyname LIKE 'Suspension Control Arm%'; -- PartTerminologyID = 7538 
UPDATE SEMAPart SET partterminologyname = 'Suspension Control Arm Cross Shafts' WHERE PartTerminologyID = '7538';
UPDATE SEMAPart SET sSingularPartTerm = 'Suspension Control Arm Cross Shaft' WHERE PartTerminologyID = '7538';

SELECT * FROM Template WHERE ixPartTerminologyID = 7538; 
UPDATE Template SET sTitle = 'Suspension Control Arm Cross Shafts' WHERE ixPartTerminologyID = 7538;
UPDATE Template SET dtUpdate = NOW() WHERE ixPartTerminologyID = 7538;
UPDATE Template SET ixUpdateUser = 'SPEEDWAYMOTORS\\ascrook' WHERE ixPartTerminologyID = 7538;
SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18218 -- move on from here 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18219, 'Axle Spacers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Driveline and Axles'; -- 5

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Axle Hard%'; -- 114

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18219;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (5, 114, 18219, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18219, 'Axle Spacers', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18219; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18219;

-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18220, 'Injector Stack Air Filters', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Filter%'; -- 153

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18220;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 153, 18220, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18220, 'Injector Stack Air Filters', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18220; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18220;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18221, 'Air Filter Storage Covers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Filter%'; -- 153

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18221;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 153, 18221, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18221, 'Air Filter Storage Covers', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18221; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18221;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18222, 'Air Cleaner Bases', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Filter%'; -- 153

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18222;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 153, 18222, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18222, 'Air Cleaner Bases', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18222; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18222;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18223, 'Air Filter Elements', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Filter%'; -- 153

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18223;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 153, 18223, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18223, 'Air Filter Elements', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18223; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18223;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18224, 'Fuel Injector Filter Storage Covers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Fuel Inject%'; -- 160

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18224;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 160, 18224, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18224, 'Fuel Injector Filter Storage Covers', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18224; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18224;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18225, 'Valve Cover Breather Storage Covers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Engine'; -- 10

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Valve Covers and%'; -- 326

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18225;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (10, 326, 18225, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18225, 'Valve Cover Breather Storage Covers', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18225; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18225;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18226, 'Valve Cover Breather Pre-Filters', NOW(), 1, 1);
-- Already exists as PartTerminologyID 18215 
SELECT * FROM SEMAPart WHERE SEMAPart.partterminologyname LIKE 'Valve Cover Breather Pre%';
SELECT * FROM SEMACodeMaster WHERE PartTerminologyID = 18215;
SELECT * FROM Template WHERE Template.ixPartTerminologyID = 18215;
-- move on to the next 


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18226, 'Disc Brake Caliper Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Brake'; -- 3

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Disc Brakes and%'; -- 328

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18226;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (3, 328, 18226, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18226, 'Disc Brake Caliper Kits', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18226; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18226;


-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18227, 'Ball Joint Sleeves', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings and%'; -- 210

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18227;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18227, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18227, 'Ball Joint Sleeves', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18227; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18227;



-- Insert the next SEMA Part 
INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18228, 'Leaf Spring Complete Conversion Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Leaf Springs and%'; -- 314

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18228;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 314, 18228, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18228, 'Leaf Spring Complete Conversion Kits', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18228; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18228;




SELECT * FROM SEMAPart WHERE partterminologyname LIKE 'Seat Head Restraint%'; -- 18201 
SELECT * FROM SEMACodeMaster WHERE PartTerminologyID = 18201;
SELECT * FROM Template WHERE ixPartTerminologyID = 18201;

SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18201; -- ixSemaCategorization 9797 ixSemaCategory 2 ixSemaSubCategory 199 

SELECT *
FROM tngLive.tblsemapart
WHERE ixSemaPart = 18201;



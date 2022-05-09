SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18168 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18169, 'Carburetor Fuel Conversion Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Carburetion%'; -- 125 

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18169;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 125, 18169, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18169, 'Carburetor Fuel Conversion Kits', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18169; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18169;

-- repeat for each tertiary value wanting to be added 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18170, 'Carburetor Float Bowls', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Carburetion%'; -- 125 

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18170;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 125, 18170, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18170, 'Carburetor Float Bowls', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18170; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18170;

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18171, 'Carburetor Caps', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Carburetion%'; -- 125 

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18171;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 125, 18171, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18171, 'Carburetor Caps', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18171; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18171;


INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18172, 'Carburetor Tuning Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Carburetion%'; -- 125 

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18172;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 125, 18172, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18172, 'Carburetor Tuning Kits', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18172; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18172;

-- Before the remaining 3rd level / tertiary part terminology values can be added the 2nd level / secondary subcategories need to be added as well 

SELECT *
FROM SEMASubcategory
ORDER BY SubCategoryID DESC; -- 345 is the highest value currently existing

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Complete Suspension%';

INSERT INTO SEMASubcategory (SubCategoryID, subcategoryname, flgSMIAdded) 
VALUES (346, 'Complete Suspension Kits', 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

-- Now the additional tertiary values can be added 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18173, 'Complete Front Clips', NOW(), 1, 1);

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18173;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 346, 18173, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18173, 'Complete Front Clips', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18173; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18173;

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18174, 'Complete Rear Clips', NOW(), 1, 1);

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18174;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 346, 18174, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18174, 'Complete Rear Clips', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18174; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18174;

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18175, 'Front Suspension Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18175;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 346, 18175, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18175, 'Front Suspension Kits', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18175; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18175;

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18176, 'Rear Suspension Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18176;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 346, 18176, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18176, 'Rear Suspension Kits', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18176; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18176;


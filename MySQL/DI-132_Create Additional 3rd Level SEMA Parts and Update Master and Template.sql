SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18194 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18195, 'Leaf Spring Spacers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Leaf Springs and Acc%'; -- 314

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18195;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 314, 18195, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18195, 'Leaf Spring Spacers', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18195; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18195;


INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18196, 'Leaf Spring Sliders', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Leaf Springs and Acc%'; -- 314

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18196;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 314, 18196, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18196, 'Leaf Spring Sliders', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18196; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18196;



INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18197, 'Friction Shocks', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Shocks, Coilovers%'; -- 203

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18197;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 203, 18197, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18197, 'Friction Shocks', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18197; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18197;


INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18198, 'Friction Shock Links', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Shocks, Coilovers%'; -- 203

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18198;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 203, 18198, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18198, 'Friction Shock Links', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18198; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18198;



INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18199, 'Portable Chairs', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Apparel and Gifts'; -- 26

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Tailgating%'; -- 338

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18199;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (26, 338, 18199, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18199, 'Portable Chairs', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18199; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18199;


INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18200, 'Leg Restraints', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Safety Products'; -- 24

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Racing Harnesses %'; -- 301

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18200;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (24, 301, 18200, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18200, 'Leg Restraints', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18200; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18200;


INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18201, 'Seat Head Restraint Attachements', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Seats%'; -- 199

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18201;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 199, 18201, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18201, 'Seat Head Restraint Attachements', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18201; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18201;


INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18202, 'Seat Shoulder Restraint Attachments', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Seats%'; -- 199

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18202;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 199, 18202, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18202, 'Seat Shoulder Restraint Attachments', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18202; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18202;


INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18203, 'Seat Leg Restraint Attachments', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Seats%'; -- 199

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18203;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 199, 18203, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18203, 'Seat Leg Restraint Attachments', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18203; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18203;



INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18204, 'Seat Head and Shoulder Restraint Attachments', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Seats%'; -- 199

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18204;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 199, 18204, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18204, 'Seat Head and Shoulder Restraint Attachments', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18204; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18204;



INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18205, 'Differential Cross Pins', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Driveline and Axles'; -- 5

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Differen%'; -- 137

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18205;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (5, 137, 18205, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18205, 'Differential Cross Pins', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18205; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18205;
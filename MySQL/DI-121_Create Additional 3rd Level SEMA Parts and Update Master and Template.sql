SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18153 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18154', 'Spun Tanks', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Fuel Storage%'; -- 162 

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18154;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 162, 18154, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18154, 'Spun Tanks', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18154; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18154;

-- repeat for each tertiary value wanting to be added 

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18154 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18155', 'Front Suspension Crossmembers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Frame%'; -- 158 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 158, 18155, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18155;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18155, 'Front Suspension Crossmembers', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18155; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18155;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18155 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18156', 'Rear Suspension Crossmembers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Frame%'; -- 158 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 158, 18156, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18156;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18156, 'Rear Suspension Crossmembers', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18156; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18156;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18156 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18157', 'Feeler Gauges', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Tools'; -- 18

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Hand Tools%'; -- 170 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (18, 170, 18157, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18157;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18157, 'Feeler Gauges', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18157; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18157;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18157 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18158', 'Headlight Dimmer Switch Covers', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Electrical, Lighting and Body'; -- 7

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Switches%'; -- 211 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (7, 211, 18158, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18158;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18158, 'Headlight Dimmer Switch Covers', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18158; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18158;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18158 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18159', 'Water Hose Spray Nozzles', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Tools'; -- 18

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Water System Service%'; -- 255 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (18, 255, 18159, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18159;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18159, 'Water Hose Spray Nozzles', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18159; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18159;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18159 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18160', 'Accelerator Linkage Kits', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Air and Fuel Delivery'; -- 12

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Carburetion%'; -- 125 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (12, 125, 18160, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18160;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18160, 'Accelerator Linkage Kits', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18160; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18160;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18160 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18161', 'Auto Trans Shifter Boots', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Automatic Transmission'; -- 20

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Shifters and%'; -- 319 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (20, 319, 18161, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18161;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18161, 'Auto Trans Shifter Boots', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18161; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18161;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18161 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18162', 'Auto Trans Shifter Boot Rings', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Automatic Transmission'; -- 20

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Shifters and%'; -- 319 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (20, 319, 18162, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18162;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18162, 'Auto Trans Shifter Boot Rings', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18162; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18162;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18162 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18163', 'Manual Trans Shift Knob Adapters', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Manual Transmission'; -- 21

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Shifters and%'; -- 319 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (21, 319, 18163, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18163;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18163, 'Manual Trans Shift Knob Adapters', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18163; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18163;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18163 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18164', 'Brake Pedal Arms', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Brake'; -- 3

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Brake Pedal'; -- 334 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (3, 334, 18164, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18164;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18164, 'Brake Pedal Arms', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18164; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18164;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18164 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18165', 'Radiator Air Boxes', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Body'; -- 2

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Front Panel'; -- 159 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (2, 159, 18165, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18165;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18165, 'Radiator Air Boxes', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18165; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18165;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18165 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18166', 'Thermal Sleeves', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Cooling'; -- 4

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Hoses and Pipes'; -- 177 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (4, 177, 18166, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18166;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18166, 'Thermal Sleeves', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18166; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18166;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18166 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18167', 'Swedged Tubes', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms, Bushings and Accessories'; -- 210 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18167, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18167;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18167, 'Swedged Tubes', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18167; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18167;

SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The high part terminology ID is currently 18167 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18168', 'Hose Separators', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Cooling'; -- 4

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Hoses and Pipes'; -- 177 

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (4, 177, 18168, NOW());

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18168;

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18168, 'Hose Separators', NOW(), NOW(), 'ascrook', 'ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18168; 

-- verify it auto created on tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18168;


-- Wyatt also requested moving 'Axle Limit Straps' from Driveline and Axles > Axle Hardware into Suspension > Suspension Arms, Bushings and Accessories 
-- Because he is not wanting to do this at the SKU level this will not be hard to do; the only changes will need to be to SEMACodeMaster in ODS
-- and tblSEMACategorization in TNG 

SELECT *
FROM SEMACodeMaster
WHERE PartTerminologyID = 11613; 

SELECT *
FROM SEMAPart
WHERE partterminologyname LIKE 'Axle Limit%'; -- PartTerminologyID = 11613 

SELECT *
FROM SEMACategory
WHERE categoryname LIKE 'Suspension%'; -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms,%'; -- 210 

-- TNG trigger updated 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 11613;


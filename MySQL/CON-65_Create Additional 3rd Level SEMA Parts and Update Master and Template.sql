SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

-- The highest part terminology ID is currently 18209 - move on from here 

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES (18210, 'Brake Line Quick Disconnect', NOW(), 1, 1);

SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Brake'; -- 3

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Brake Hyd%'; -- 122

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18210;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (3, 122, 18210, NOW());

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18210, 'Brake Line Quick Disconnect', NOW(), NOW(), 'SPEEDWAYMOTORS\\ascrook', 'SPEEDWAYMOTORS\\ascrook', 1);

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18210; 

-- verify it auto created on tng 
SELECT *
FROM tngLive.tblsemacategorization
WHERE ixSemaPart = 18210;



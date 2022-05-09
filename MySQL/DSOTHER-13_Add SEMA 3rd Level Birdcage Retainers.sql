SELECT *
FROM SEMAPart
ORDER BY PartTerminologyID DESC;

INSERT INTO SEMAPart (PartTerminologyID, partterminologyname, RevDate, flgSpeedwayAdded, flgDisplayTerminology)
VALUES ('18144', 'Birdcage Retainers', NOW(), 1, 1);


SELECT * 
FROM SEMACategory 
WHERE categoryname = 'Suspension' -- 16

SELECT *
FROM SEMASubcategory
WHERE subcategoryname LIKE 'Suspension Arms%' -- 210 

SELECT * 
FROM SEMACodeMaster
WHERE SEMACodeMaster.PartTerminologyID = 18144;

INSERT INTO SEMACodeMaster (CategoryID, SubCategoryID, PartTerminologyID, RevDate)
VALUES (16, 210, 18144, NOW());

SELECT * 
FROM Template
WHERE ixPartTerminologyID = 18144; 

INSERT INTO Template (ixPartTerminologyID, sTitle, dtCreate, dtUpdate, ixCreateUser, ixUpdateUser, flgActive)
VALUES (18144, 'Birdcage Retainers', NOW(), NOW(), 'ascrook', 'ascrook', 1)


-- tng 
SELECT *
FROM tblsemacategorization
WHERE ixSemaPart = 18144;

INSERT INTO tblsemapart
VALUES (


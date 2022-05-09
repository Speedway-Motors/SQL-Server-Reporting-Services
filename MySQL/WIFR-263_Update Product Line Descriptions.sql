SELECT *
FROM tblproductline 
WHERE ixSOPProductLine IN ('2170', '2173', '2171', '2172'); -- to verify the values already existing in table 

-- it was determined that additional rows had already been created with the new values but should not be duplicated to 
-- checking to see how many other product lines have duplicate entries 
SELECT COUNT(ixSOPProductLine) AS Cnt 
     , ixSOPProductLine
FROM tblproductline
GROUP BY ixSOPProductLine 
ORDER BY Cnt DESC; 

-- verify which product lines have skus tied to them so as not to delete those 
SELECT COUNT(1) 
     , ixProductLine 
FROM tblskubase
WHERE ixProductLine IN (1024,1025,1026,1027,1366,1367,1368,1369) 
GROUP BY ixProductLine;

DELETE FROM tblproductline 
WHERE ixProductLine IN (1366,1367,1368,1369); -- delete the product lines that do not have records associated with them

-- last edit the description field with the updated information 

UPDATE tblproductline
SET sTitle = 'Clay Smith Legend Series Hydraulic Roller Cam/Lifter Kits'
WHERE ixSOPProductLine = '2170';
-- 2170 = Clay Smith Legend Series Hydraulic Roller Cam/Lifter Kits
UPDATE tblproductline
SET sTitle = 'Clay Smith Torquesmith Hydraulic Flat Tappet Cam/Lifter Kits'
WHERE ixSOPProductLine = '2171';
-- 2171 = Clay Smith Torquesmith Hydraulic Flat Tappet Cam/Lifter Kits
UPDATE tblproductline
SET sTitle = 'Clay Smith Tracksmith Hydraulic Flat Tappet Cam/Lifter Kits'
WHERE ixSOPProductLine = '2172';
-- 2172 = Clay Smith Tracksmith Hydraulic Flat Tappet Cam/Lifter Kits
UPDATE tblproductline
SET sTitle = 'Clay Smith Streetsmith Hydraulic Flat Tappet Cam/Lifter Kits'
WHERE ixSOPProductLine = '2173';
-- 2173 = Clay Smith Streetsmith Hydraulic Flat Tappet Cam/Lifter Kits

-- the other SOP line that had multiple records found during data integrity search 
SELECT *
FROM tblproductline 
WHERE ixSOPProductLine = '1795';

-- verify which product lines have skus tied to them so as not to delete those 
SELECT COUNT(1) 
     , ixProductLine 
FROM tblskubase
WHERE ixProductLine IN (447,1365) 
GROUP BY ixProductLine; -- 447 has the values attached, Wyatt verified the correct description of the product line should be 
-- 1795 - Blue Diamond Model A Pedal Car Parts

DELETE FROM tblproductline 
WHERE ixProductLine = 1365; -- delete the product lines that do not have records associated with them

-- last edit the description field with the updated information 
UPDATE tblproductline
SET sTitle = 'Blue Diamond Model A Pedal Car Parts'
WHERE ixSOPProductLine = '1795';



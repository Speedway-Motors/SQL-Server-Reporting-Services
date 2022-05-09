-- APPLICATION REMOVAL

-- First determine what the data looks like 
SELECT *
FROM tblapplication 
WHERE sApplicationValue LIKE '1947-53 Chevy%'; -- ixApplication = '15' 

/**************************************
Determine whether SKUs are associated to the application being deleted. 
If there are those need to be deleted first (Check with Wyatt before doing
so) because there is a FK constraint that will not allow the application 
to be deleted with SKUs currently associated with it 
**********************************/
SELECT *
FROM tblskuvariant_application_xref
WHERE ixApplication = 15; -- There are 2 records associated with the application to be deleted (ixSOPSKU = 275475/275476) 

-- Delete the SKU xref data after checking with Wyatt
DELETE FROM tblskuvariant_application_xref
WHERE ixApplication = 15; 

-- Then delete the application itself 
DELETE FROM tblapplication 
WHERE ixApplication = 15;

-- Repeat for additional application deletions 
SELECT *
FROM tblapplication 
WHERE sApplicationValue LIKE 'Steering Wheel%'; -- ixApplication = '60' 

SELECT *
FROM tblskuvariant_application_xref
WHERE ixApplication = 60; -- There are 0 records associated with the application to be deleted 

DELETE FROM tblapplication 
WHERE ixApplication = 60;

-- ENGINE SUBFAMILY REMOVAL 

-- First determine what data looks like 
SELECT *
FROM tblengine_family
WHERE sEngineFamilyName LIKE 'Buick%'; -- Buick Nailhead V8 = ixEngineFamily 3

SELECT *
FROM tblengine_subfamily 
WHERE ixEngineFamily = 3; -- sEngineSubfamilyName IN ('400', '430', '455') synonymous with ixEngineSubfamily IN ('47', '123', '155')

SELECT *
FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (47, 123, 155); -- There are 0 records associated with the engine subfamily to be deleted 

-- Delete the SKU variant xref data after checking with Wyatt
DELETE FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (47, 123, 155);

-- Then delete the subfamily itself 
DELETE FROM tblengine_subfamily
WHERE ixEngineSubfamily IN (47, 123, 155);

-- Repeat for remaining instances 

SELECT *
FROM tblengine_family
WHERE sEngineFamilyName LIKE 'Ford Small Block%'; -- Ford Small Block V8 = ixEngineFamily 13

SELECT *
FROM tblengine_subfamily 
WHERE ixEngineFamily = 13
  AND sEngineSubfamilyName IN ('429', '460'); -- synonymous with ixEngineSubfamily IN ('122', '154')

SELECT *
FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (122, 154); -- There are 6 records (3 ixSOPSKU(s) = 677424/543680/543681 all associated with both engine subfamilies to be deleted 

-- Delete the SKU variant xref data after checking with Wyatt
DELETE FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (122, 154);

-- Then delete the subfamily itself 
DELETE FROM tblengine_subfamily
WHERE ixEngineSubfamily IN (122, 154);

-- ENGINE FAMILY AND SUBFAMILY REMOVAL 

-- First determine what data looks like 
SELECT *
FROM tblengine_family
WHERE sEngineFamilyName LIKE 'Ford FE%'; -- Ford FE Ford = ixEngineFamily 22

SELECT *
FROM tblengine_subfamily 
WHERE ixEngineFamily = 22
  AND sEngineSubfamilyName IN ('352', '390', '428'); -- synonymous with ixEngineSubfamily IN (78, 138, 166)

-- Verify that the 3 categories exist under the family that is staying 
SELECT *
FROM tblengine_subfamily 
WHERE ixEngineFamily = 12; -- all subfamilies exist 

SELECT *
FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (78, 138, 166); -- There are 0 records associated with the engine subfamily to be deleted 

-- Delete the SKU variant xref data after checking with Wyatt
DELETE FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (78, 138, 166);

-- Then delete the subfamily itself 
DELETE FROM tblengine_subfamily
WHERE ixEngineSubfamily IN (78, 138, 166);

-- Finally delete the engine family itself
DELETE FROM tblengine_family
WHERE ixEngineFamily = 22;

-- Repeat for remaining instances 
SELECT *
FROM tblengine_family
WHERE sEngineFamilyName LIKE 'Old%'; -- Oldmobile V8 = ixEngineFamily 23

SELECT *
FROM tblengine_subfamily 
WHERE ixEngineFamily = 23
  AND sEngineSubfamilyName IN ('303', '324'); -- synonymous with ixEngineSubfamily IN (90, 143)

-- Verify that the 2 categories exist under the family that is staying 
SELECT *
FROM tblengine_subfamily 
WHERE ixEngineFamily = 4; -- all subfamilies exist 

SELECT *
FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (90, 143); -- There are 2 records (1 ixSOPSKU = 5603286 associated with both engine subfamilies to be deleted)

-- Delete the SKU variant xref data after checking with Wyatt
DELETE FROM tblskuvariant_engine_subfamily_xref
WHERE ixEngineSubfamily IN (90, 143);

-- Then delete the subfamily itself 
DELETE FROM tblengine_subfamily
WHERE ixEngineSubfamily IN (90, 143);

-- Finally delete the engine family itself
DELETE FROM tblengine_family
WHERE ixEngineFamily = 23




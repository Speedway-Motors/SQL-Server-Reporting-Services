-- The next task is assigning SKUs to SEMA groups 
/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU, categoryname, subcategoryname, and partterminologyname).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. AWS Live _ tmp). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp.tmp_addsemaclassification *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp.tmp_addsemaclassification
LIMIT 10;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_addsemaclassification CONVERT to character set latin1 collate latin1_general_cs;

-- Add columns to the temp tables to store the ODS ID values for the SEMA information 
ALTER TABLE tmp.tmp_addsemaclassification
ADD CategoryID smallint; 

ALTER TABLE tmp.tmp_addsemaclassification
ADD SubCategoryID smallint; 

ALTER TABLE tmp.tmp_addsemaclassification
ADD PartTerminologyID smallint; 

-- Look at a small reference to make sure columns were added correctly 
SELECT *
FROM tmp.tmp_addsemaclassification
LIMIT 10; 

-- Update the values for CategoryID 
UPDATE tmp.tmp_addsemaclassification, SEMACategory
SET tmp.tmp_addsemaclassification.CategoryID = SEMACategory.CategoryID 
WHERE tmp.tmp_addsemaclassification.Category = SEMACategory.categoryname; -- 5036/5036 values updated 

-- Check that all records did update 
SELECT *
FROM tmp.tmp_addsemaclassification
WHERE tmp.tmp_addsemaclassification.CategoryID IS NULL;  --  All records updated 

-- Update the values for SubCategoryID 
UPDATE tmp.tmp_addsemaclassification, SEMASubcategory
SET tmp.tmp_addsemaclassification.SubCategoryID = SEMASubcategory.SubCategoryID 
WHERE tmp.tmp_addsemaclassification.SubCategory = SEMASubcategory.subcategoryname; -- 5036/5036 values updated 

-- Check that all records did update  
SELECT *
FROM tmp.tmp_addsemaclassification
WHERE tmp.tmp_addsemaclassification.SubCategoryID IS NULL;  --  All records updated 

-- Update the values for PartTerminologyID 
UPDATE tmp.tmp_addsemaclassification, SEMAPart
SET tmp.tmp_addsemaclassification.PartTerminologyID = SEMAPart.PartTerminologyID 
WHERE tmp.tmp_addsemaclassification.PartTerminology = SEMAPart.partterminologyname; -- 5036/5036 values updated 

-- Check which records did not update 
SELECT *
FROM tmp.tmp_addsemaclassification
WHERE tmp.tmp_addsemaclassification.PartTerminologyID IS NULL; --  All records updated 


-- Verify there are no duplicate values in the tmp table 

SELECT COUNT(DISTINCT Speedway_SKU) 
FROM tmp.tmp_addsemaclassification; -- 5036 rows // 5036 distinct skus 

-- Verify these skus are not already referencing another SEMA part terminology in the existing table 

SELECT COUNT(DISTINCT ixSKU)
FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT Speedway_SKU
                FROM tmp.tmp_addsemaclassification
               ) ; -- 490 exist currently 
               
-- Insert the values into the ODS table 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, dtCreate, ixCreateUser) 
SELECT tmp.tmp_addsemaclassification.Speedway_SKU
     , PartTerminologyID 
     , UTC_TIMESTAMP()
     , 'SPEEDWAYMOTORS\\ascrook' 
FROM tmp.tmp_addsemaclassification
LEFT JOIN tblSKUPartAssociation ON tblSKUPartAssociation.ixSKU = tmp.tmp_addsemaclassification.Speedway_SKU
WHERE tblSKUPartAssociation.ixSKU IS NULL; -- 4546 values inserted + 490 alraedy existing = 5036 total 


-- Check the values inserted OK 
SELECT * 
FROM tblSKUPartAssociation
WHERE ixCreateUser = 'SPEEDWAYMOTORS\\ascrook' 
ORDER BY dtCreate DESC; 

SELECT * 
FROM tblSKUPartAssociation SPA
LEFT JOIN SEMAPart SP ON SP.PartTerminologyID = SPA.ixPartTerminologyID
WHERE SPA.ixSKU IN ('AUP2961', 'AUP2962', 'AUP2963', 'AUP2987', 'AUP2988', 'AUP3001', 'UP40106', 'UP41701', 'UP42424', 'UP42600', 'UP43639', 'UP43981', 'UP44506');

-- Check that some values triggered tngLive update
SELECT *
FROM tngLive.tblskuvariant 
WHERE ixSOPSKU IN (SELECT Speedway_SKU
                   FROM tmp.tmp_addsemaclassification
                  )
 AND ixSemaPart IS NULL
 
 
UPDATE tngLive.tblskuvariant  
SET ixSemaPart = 7512
WHERE ixSOPSKU IN ('AUP3001');


SELECT SPA.ixPartTerminologyID
     , SEMA.PartTerminologyID
     , SV.ixSemaPart
FROM tblSKUPartAssociation SPA 
LEFT JOIN tmp.tmp_addsemaclassification SEMA ON SEMA.Speedway_SKU = SPA.ixSKU
LEFT JOIN tngLive.tblskuvariant SV ON SV.ixSOPSKU = SPA.ixSKU 
WHERE SPA.ixPartTerminologyID <> SEMA.PartTerminologyID
   OR SPA.ixPartTerminologyID <> SV.ixSemaPart; 
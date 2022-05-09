-- The next task is assigning SKUs to new/additional SEMA groups 
/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU, categoryname, subcategoryname, and partterminologyname).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. AWS Live _ tmp). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp.tmp_lokar_sema_assign *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp.tmp_lokar_sema_assign
LIMIT 10;

-- Update the collation so you can join against the current tables in ODS 
ALTER TABLE tmp.tmp_lokar_sema_assign CONVERT to character set latin1 collate latin1_general_cs;

-- Add columns to the temp tables to store the ODS ID values for the SEMA information 
ALTER TABLE tmp.tmp_lokar_sema_assign
ADD CategoryID smallint; 

ALTER TABLE tmp.tmp_lokar_sema_assign
ADD SubCategoryID smallint; 

ALTER TABLE tmp.tmp_lokar_sema_assign
ADD PartTerminologyID smallint; 

-- Look at a small reference to make sure columns were added correctly 
SELECT *
FROM tmp.tmp_lokar_sema_assign
LIMIT 10; 

-- Update the values for CategoryID 
UPDATE tmp.tmp_lokar_sema_assign, SEMACategory
SET tmp.tmp_lokar_sema_assign.CategoryID = SEMACategory.CategoryID 
WHERE tmp.tmp_lokar_sema_assign.categoryname = SEMACategory.categoryname; -- 2774/2774 values updated 

-- Check that all records did update 
SELECT *
FROM tmp.tmp_lokar_sema_assign
WHERE tmp.tmp_lokar_sema_assign.CategoryID IS NULL;  --  All records updated 

-- Update the values for SubCategoryID 
UPDATE tmp.tmp_lokar_sema_assign, SEMASubcategory
SET tmp.tmp_lokar_sema_assign.SubCategoryID = SEMASubcategory.SubCategoryID 
WHERE tmp.tmp_lokar_sema_assign.subcategoryname = SEMASubcategory.subcategoryname; -- 2774/2774 values updated 

-- Check that all records did update  
SELECT *
FROM tmp.tmp_lokar_sema_assign
WHERE tmp.tmp_lokar_sema_assign.SubCategoryID IS NULL;  --  All records updated 

-- Update the values for PartTerminologyID 
UPDATE tmp.tmp_lokar_sema_assign, SEMAPart
SET tmp.tmp_lokar_sema_assign.PartTerminologyID = SEMAPart.PartTerminologyID 
WHERE tmp.tmp_lokar_sema_assign.partterminologyname = SEMAPart.partterminologyname; -- 2764/2774 values updated 

-- Check which records did not update 
SELECT *
FROM tmp.tmp_lokar_sema_assign
WHERE tmp.tmp_lokar_sema_assign.PartTerminologyID IS NULL
ORDER BY partterminologyname; -- partterminologyname 'Door Handles' 

-- Look into further to make sure it does not already exist before adding to DB 
SELECT *
FROM SEMACategory
WHERE categoryname = 'Body'; -- CategoryID = 2 

SELECT *
FROM SEMASubcategory
WHERE subcategoryname = 'Doors'; -- SubCategoryID = '139' 

SELECT SEMACodeMaster.*, SEMAPart.partterminologyname
FROM SEMACodeMaster
LEFT JOIN SEMAPart ON SEMAPart.PartTerminologyID = SEMACodeMaster.PartTerminologyID
WHERE CategoryID = 2
  AND SubCategoryID = 139
ORDER BY partterminologyname;

-- 'Door Handles' did not exist as a tertiary value but 'Interior Door Handles' did. Per JGO they were changed to this value. Update was re-run and all values updated.

-- Verify there are no duplicate values in the tmp table 

SELECT COUNT(DISTINCT ixSOPSKU) 
FROM tmp.tmp_lokar_sema_assign; -- 2774 rows // 2774 distinct skus 

-- Verify these skus are not already referencing another SEMA part terminology in the existing table 

SELECT *
FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSOPSKU 
                FROM tmp.tmp_lokar_sema_assign
               ) ; -- None exist currently 
               
-- Insert the values into the ODS table 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, dtCreate, ixCreateUser) 
SELECT tmp.tmp_lokar_sema_assign.ixSOPSKU 
     , PartTerminologyID 
     , UTC_TIMESTAMP()
     , 'ascrook'
FROM tmp.tmp_lokar_sema_assign
LEFT JOIN tblSKUPartAssociation ON tblSKUPartAssociation.ixSKU = tmp.tmp_lokar_sema_assign.ixSOPSKU
WHERE tblSKUPartAssociation.ixSKU IS NULL; -- 2774 values inserted 


-- Check the values inserted OK 
SELECT * 
FROM tblSKUPartAssociation
WHERE ixCreateUser = 'ascrook'
ORDER BY dtCreate DESC; 

-- Check that some values triggered tngLive update
SELECT *
FROM tngLive.tblskuvariant 
WHERE ixSOPSKU IN (SELECT ixSOPSKU 
                   FROM tmp.tmp_lokar_sema_assign
                  )


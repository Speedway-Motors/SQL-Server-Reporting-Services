/* Load data into a temp table from the file given */ 

-- Update the collation so you can join against the current tables in ODS 

ALTER TABLE tmp.tmp_asc_sku_sema_assign CONVERT to character set latin1 collate latin1_general_cs;

-- Add columns to the temp tables to store the ODS ID values for the SEMA information 

ALTER TABLE tmp.tmp_asc_sku_sema_assign 
ADD CategoryID smallint; 

ALTER TABLE tmp.tmp_asc_sku_sema_assign
ADD SubCategoryID smallint; 

ALTER TABLE tmp.tmp_asc_sku_sema_assign
ADD PartTerminologyID smallint; 

-- Look at a small reference to make sure columns were added correctly 

SELECT *
FROM tmp.tmp_asc_sku_sema_assign
LIMIT 10; 

-- Update the values for CategoryID 

UPDATE tmp.tmp_asc_sku_sema_assign, SEMACategory
SET tmp.tmp_asc_sku_sema_assign.CategoryID = SEMACategory.CategoryID 
WHERE tmp.tmp_asc_sku_sema_assign.categoryname = SEMACategory.categoryname; -- 16,123/16,178 values updated 

-- Check which records did not update 

SELECT *
FROM tmp.tmp_asc_sku_sema_assign
WHERE tmp.tmp_asc_sku_sema_assign.CategoryID IS NULL;  --  These are the "null" values where John wanted SEMA categorization removed which we do not want to do  

-- Update the values for SubCategoryID 

UPDATE tmp.tmp_asc_sku_sema_assign, SEMASubcategory
SET tmp.tmp_asc_sku_sema_assign.SubCategoryID = SEMASubcategory.SubCategoryID 
WHERE tmp.tmp_asc_sku_sema_assign.subcategoryname = SEMASubcategory.subcategoryname; -- 16,124/16,178 values updated 

-- Check which records did not update 

SELECT *
FROM tmp.tmp_asc_sku_sema_assign
WHERE tmp.tmp_asc_sku_sema_assign.SubCategoryID IS NULL;  -- These are the "null" values where John wanted SEMA categorization removed which we do not want to do 

-- Update the values for PartTerminologyID 

UPDATE tmp.tmp_asc_sku_sema_assign, SEMAPart
SET tmp.tmp_asc_sku_sema_assign.PartTerminologyID = SEMAPart.PartTerminologyID 
WHERE tmp.tmp_asc_sku_sema_assign.partterminologyname = SEMAPart.partterminologyname; -- 16,124/16,178 values updated 

-- Check which records did not update 

SELECT *
FROM tmp.tmp_asc_sku_sema_assign
WHERE tmp.tmp_asc_sku_sema_assign.PartTerminologyID IS NULL
ORDER BY partterminologyname; -- These are the "null" values where John wanted SEMA categorization removed which we do not want to do 

-- This step was not needed because the varchar length was corrected on this transfer from Excel 
UPDATE tmp.tmp_asc_sku_sema_assign
SET PartTerminologyID = 17046
WHERE partterminologyname LIKE 'Spring Shackle Lowering Kit/Leaf Spring Lower%';
-- 'Brake Master Cylinder / Booster / Valve Assem%' -- ID 17864
-- 'Brake Hydraulic System Pressure Bleeder Press%' -- ID 12060
-- 'Suspension Trailing Arm Bushing%' -- ID 16557
-- 'Fuel Injection Fuel Rail%' -- ID 15150
-- 'Windshield Wiper Arm, Linkage and Motor Assem%' -- ID 15446
-- 'Spring Shackle Lowering Kit/Leaf Spring Lower%' -- ID 17046 

-- Verify there are no duplicate values in the tmp table 

SELECT COUNT(DISTINCT ixSKU) 
FROM tmp.tmp_asc_sku_sema_assign; -- 16178 rows // 16178 distinct skus 

-- Verify these skus are not already referencing another SEMA part terminology in the existing table 

SELECT *
FROM tblSKUPartAssociation
WHERE ixSKU IN (SELECT ixSKU 
                FROM tmp.tmp_asc_sku_sema_assign
               ) ; -- 2,103 SKUs already exist in the SEMA association table // we do not currently want to modify/change these values to what John F. is suggesting
               
-- Insert the values into the ODS table 
INSERT IGNORE INTO tblSKUPartAssociation (ixSKU, ixPartTerminologyID, dtCreate, ixCreateUser) 
SELECT tmp_asc_sku_sema_assign.ixSKU 
     , PartTerminologyID 
     , UTC_TIMESTAMP()
     , 'ascrook'
FROM tmp.tmp_asc_sku_sema_assign
LEFT JOIN tblSKUPartAssociation ON tblSKUPartAssociation.ixSKU = tmp.tmp_asc_sku_sema_assign.ixSKU
WHERE tblSKUPartAssociation.ixSKU IS NULL; -- 14,075 values inserted 


-- Check the values inserted OK 
SELECT * 
FROM tblSKUPartAssociation
WHERE ixCreateUser = 'ascrook' 

-- Not needed because the above insert was corrected to reference the correct columns before running on Live 
UPDATE tblSKUPartAssociation, tmp.tmp_asc_sku_sema_assign
SET tblSKUPartAssociation.ixPartTerminologyID = tmp.tmp_asc_sku_sema_assign.PartTerminologyID
WHERE tblSKUPartAssociation.ixSKU = tmp.tmp_asc_sku_sema_assign.ixSKU
  AND ixCreateUser = 'ascrook';
  
-- Check that some values triggered tngLive update
SELECT *
FROM tngLive.tblskuvariant 
WHERE ixSOPSKU IN (SELECT ixSKU 
                   FROM tmp.tmp_asc_sku_sema_assign
                  )


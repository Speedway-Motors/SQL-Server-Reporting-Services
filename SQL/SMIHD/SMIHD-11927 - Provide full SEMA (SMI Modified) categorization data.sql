-- SMIHD-11927 - Provide full SEMA (SMI Modified) categorization data

-- query used to populate the "SMIHD-11927 - complete modified SEMA categorization data.xlsb" spreadsheet
-- PUT " AROUND THE DATA because there are commas in some of the part names that cause Excel to split into additional columns
SELECT '"' + cc.sCategoryName+ '"' AS 'Category'
    , '"' + cs.sSubCategoryName+ '"' AS 'Sub-Category' 
    , '"' + cp.sPartName + '"' AS 'PartName'
FROM tngLive.tblcategorization c 
    inner join tngLive.tblcategorization_category cc on cc.ixCategorizationCategory = c.ixCategorizationCategory
    inner join tngLive.tblcategorization_subcategory cs on c.ixCategorizationSubCategory = cs.ixCategorizationSubCategory
    inner join tngLive.tblcategorization_part cp on c.ixCategorizationPart = cp.ixCategorizationPart
ORDER BY cc.sCategoryName, cs.sSubCategoryName, cp.sPartName


/*    -- xample of the categorization from RON
select*
from tngLive.tblskubase b
inner join tngLive.tblcategorization_part cp on b.ixCategorizationPart = cp.ixCategorizationPart
--inner join tng.tblcategorization c on cp.ixCanonicalCategorization = c.ixCategorization  -- Canonical Categorization
inner join tngLive.tblcategorization c on cp.ixCategorizationPart = c.ixCategorizationPart  -- All Categorization
inner join tngLive.tblcategorization_category cc on cc.ixCategorizationCategory = c.ixCategorizationCategory
inner join tngLive.tblcategorization_subcategory cs on c.ixCategorizationSubCategory = cs.ixCategorizationSubCategory
*/







tblcategorization_category_tblsemacategory
tblcategorization_part_tblsemapart
tblcategorization_subcategory_tblsemasubcategory
tblsemacategorization
tblsemacategory
tblsemacategory_xref
tblsemapart
tblsemapart_xref
tblsemasubcategory
tblsemasubcategory_xref


SELECT TOP 10 * from tngLive.tblsemacategory
SELECT TOP 10 * from tngLive.tblsemasubcategory
SELECT TOP 10 * from tngLive.tblsemacategorization
SELECT TOP 10 * from tngLive.tblsemapart


SELECT count(distinct sCategoryName) from tngLive.tblsemacategory -- 26
SELECT count(distinct sSubCategoryName) from tngLive.tblsemasubcategory -- 249
SELECT count(distinct sSemaPartName) from tngLive.tblsemapart -- 9995

SELECT *
FROM tngLive.tblsemacategory CAT
    LEFT JOIN tngLive.tblsemacategory_xref CATX on CATX.ixSemaCategory = CAT.ixSemaCategory
    LEFT JOIN tngLive.tblsemasubcategory_xref SUBCX ON SUBCX.ixSemaCategory = CAT.ixSemaCategory
    LEFT JOIN tngLive.tblsemasubcategory SUBC on SUBC.ixSemaSubCategory = SUBCX.ixSemaSubCategory


SELECT *
FROM tngLive.tblsemasubcategory SUBC
    LEFT JOIN tngLive.tblsemasubcategory_xref SUBCX ON SUBCX.ixSemaSubCategory = SUBC.ixSemaSubCategory
    LEFT JOIN tngLive.tblsemacategory_xref CATX on CATX.ixSemaCategory = SUBCX.ixSemaCategory
    LEFT JOIN tngLive.tblsemacategory CAT on CAT.ixSemaCategory = CATX.ixSemaCategory  
    -- LEFT JOIN tngLive.tblsemapart_xref PX on PX.ixSemaPartXref = CATX.ixS

SELECT *
FROM tngLive.tblsemapart P
    LEFT JOIN tngLive.tblsemapart_xref PX ON PX.ixSemaPart = P.ixSemaPart
    LEFT JOIN tngLive.tblsemasubcategory_xref SUBCX ON SUBCX.ixSemaSubCategory = SUBC.ixSemaSubCategory
    LEFT JOIN tngLive.tblsemacategory_xref CATX on CATX.ixSemaCategory = SUBCX.ixSemaCategory
    LEFT JOIN tngLive.tblsemacategory CAT on CAT.ixSemaCategory = CATX.ixSemaCategory  




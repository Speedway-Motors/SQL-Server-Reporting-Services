-- SMIHD-2168 - Update SMI Reorting SEMA Categorization with values from tng DB

/* 
From Ron:  Below are the steps and the queries needed to sync the SEMA categorization values.
(6 steps), safe (we make a backup first), testable (within a transaction with a rollback first).
*/

/************************************************************************************
1.	Export data via tool (toad, dbforge studio etc..) from the read replica tngLive
    a.	For this data a tab delimited file works best
************************************************************************************/
SELECT 
  s.ixSOPSKU
  , c.sCategoryName
  , sc.sSubCategoryName
  , p.sSemaPartName
FROM tblskuvariant s
    inner join tblsemacategorization cat on s.ixSemaPart = cat.ixSemaPart
    inner join tblsemacategory c on c.ixSemaCategory = cat.ixSemaCategory
    inner join tblsemasubcategory sc on cat.ixSemaSubCategory = sc.ixSemaSubCategory
    inner join tblsemapart p on cat.ixSemaPart = p.ixSemaPart
ORDER BYixSOPSKU



/************************************************************************************
2.	Clear data from the import table on DW-Staging1
************************************************************************************/
TRUNCATE SMITemp.dbo.SyncSKUCategorization



/************************************************************************************
3.	Import the data into SMITemp.dbo.SyncSKUCategorization 
************************************************************************************/	




/************************************************************************************
4.	backup the current SEMA data in tblSKU
************************************************************************************/
SELECT ixSKU, sSEMACategory, sSEMASubCategory, sSEMAPart 
into [SMITemp].dbo.tblSKU_BU_20150909 -- <-- rename with current date
FROM [SMI Reporting].dbo.tblSKU
WHERE flgDeletedFromSOP = 0



/************************************************************************************
5.	Check the data to make sure it looks ok to update
************************************************************************************/
SELECT sync.*, 
    s.sSEMACategory, s.sSEMASubCategory, s.sSEMAPart
FROM [SMI Reporting].dbo.tblSKU s
    inner join [SMITemp].dbo.SyncSKUCategorization sync on s.ixSKU = sync.ixSKU
WHERE s.sSEMACategory <> sync.CategoryName
        OR
      s.sSEMASubCategory <> sync.SubCategoryName
        OR
      s.sSEMAPart <> sync.PartName
        OR
      ( s.sSEMAPart is null and sync.PartName is not null )
ORDER BY s.sSEMACategory desc



/************************************************************************************
6.	Run the update with a rollback to verify right number of rows to be updated 
    then change it to a commit
************************************************************************************/
BEGIN TRANSACTION;

    SELECT sync.*, 
        s.sSEMACategory, s.sSEMASubCategory, s.sSEMAPart
    FROM [SMI Reporting].dbo.tblSKU s
        inner join [SMITemp].dbo.SyncSKUCategorization sync on s.ixSKU = sync.ixSKU
    WHERE s.sSEMACategory <> sync.CategoryName
            OR
          s.sSEMASubCategory <> sync.SubCategoryName
            OR
          s.sSEMAPart <> sync.PartName
            OR
          ( s.sSEMAPart is null and sync.PartName is not null )

    UPDATE s 
    SET s.sSEMACategory = sync.CategoryName
        , s.sSEMASubCategory = sync.SubCategoryName
        , s.sSEMAPart = sync.PartName
    FROM [SMI Reporting].dbo.tblSKU s
    inner join
           [SMITemp].dbo.SyncSKUCategorization sync on s.ixSKU = sync.ixSKU
    WHERE s.sSEMACategory <> sync.CategoryName
            OR
          s.sSEMASubCategory <> sync.SubCategoryName
            OR
          s.sSEMAPart <> sync.PartName
            OR
          ( s.sSEMAPart is null and sync.PartName is not null )  

    SELECT 
    sync.*, s.sSEMACategory, s.sSEMASubCategory, s.sSEMAPart
    FROM [SMI Reporting].dbo.tblSKU s
    inner join [SMITemp].dbo.SyncSKUCategorization sync on s.ixSKU = sync.ixSKU
    WHERE s.sSEMACategory <> sync.CategoryName
            OR
          s.sSEMASubCategory <> sync.SubCategoryName
            OR
          s.sSEMAPart <> sync.PartName
            OR
          ( s.sSEMAPart is null and sync.PartName is not null ) 
              
ROLLBACK;     
-- COMMIT;


-- Ratio of "active" SKUs with and without categorizaion
SELECT * FROM tblSKU WHERE sSEMACategory is NOT null
and flgDeletedFromSOP = 0
and flgActive = 1
and ixSKU in (SELECT ixSKU FROM tblCatalogDetail WHERE ixCatalog = 'WEB.15')
/*
110K Active SKUs with SEMA categorization
 24K Active SKUs without categorization
 =================
 82% categorized
*/
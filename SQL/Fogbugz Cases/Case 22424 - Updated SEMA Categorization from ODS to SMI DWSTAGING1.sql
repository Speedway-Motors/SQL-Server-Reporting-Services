-- First create a backup of the table you are updating in case any problems occur 
SELECT *
INTO [SMITemp].dbo.ASC_tblSKU_BU_042214
FROM tblSKU 

/************************
Using the view (SELECT * FROM vwSkuSemaCategorization) from MySQL ODS, output all data to a CSV file. 
(Tools > Export > Export Wizard > Next > Add > Views > (verify odsLive is selected) vwSkuSemaCategorization > 
 Next > Next (all options selected are correct) > select wanted categories (remove CategoryID, SubCategoryID, 
 PartTerminologyID) > Next > Choose the file name/location (i.e. C:\Users\ASCROOK\Desktop\ASC_22424_UpdateSEMACategorization.csv) 
 > Uncheck "Add Date/Time suffix to filename" > Next > Next > Finish). Go to the db you want to import on [SMITemp] 
 and use the import task wizard to pull the data over. 
**************************/ 

--Verify all data loaded properly 
SELECT *
FROM [SMITemp].dbo.ASC_22424_UpdateSEMACategorization -- 153,525 rows 

--Update the tblSKU values accordingly 

UPDATE S
SET S.sSEMACategory = USC.categoryname
  , S.sSEMASubCategory = USC.subcategoryname
  , S.sSEMAPart = USC.partterminologyname
FROM [SMITemp].dbo.ASC_22424_UpdateSEMACategorization USC
JOIN tblSKU S ON S.ixSKU = USC.ixSKU -- 153,525 rows affected 

--Look at the data to verify it updated properly 
SELECT USC.ixSKU 
     , S.ixSKU 
     , USC.categoryname
     , S.sSEMACategory
     , USC.subcategoryname
     , S.sSEMASubCategory
     , USC.partterminologyname
     , S.sSEMAPart
FROM [SMITemp].dbo.ASC_22424_UpdateSEMACategorization USC
JOIN tblSKU S ON S.ixSKU = USC.ixSKU      

-- A quick check to see how many SKUs are still uncategorized in the db at this point 
SELECT *
FROM tblSKU 
WHERE flgActive = 1 
  AND dtDiscontinuedDate > GETDATE() 
  AND flgDeletedFromSOP = 0 
  AND (sSEMACategory IS NULL -- 28,960
    OR sSEMASubCategory IS NULL
    OR sSEMAPart IS NULL
      ) -- 28,960 SKUs uncategorized 

-- To check how many rows from the BU table don't match the new data in the table 
SELECT COUNT(S.ixSKU) 
FROM tblSKU S
JOIN [SMITemp].dbo.ASC_tblSKU_BU_042214 BU ON BU.ixSKU = S.ixSKU 
WHERE S.sSEMACategory <> BU.sSEMACategory 
   OR S.sSEMASubCategory <> BU.sSEMASubCategory 
   OR S.sSEMAPart <> BU.sSEMAPart 
   OR (S.sSEMACategory IS NOT NULL
       AND BU.sSEMACategory IS NULL)
   OR (S.sSEMASubCategory IS NOT NULL
       AND BU.sSEMASubCategory IS NULL)
   OR (S.sSEMAPart IS NOT NULL
       AND BU.sSEMAPart IS NULL)         -- 14,957 values changed
 
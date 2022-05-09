-- SMIHD-4118 - Add SEMA Categoization to Spreadsheet


/* QUERY from SKUs with SEMA Categorization.rdl */
        DECLARE @SEMACategory varchar(100),
        @SEMASubCategory varchar(100)

        SELECT @SEMACategory = 'Air and Fuel Delivery',
        @SEMASubCategory = 'Fuel Storage'

        SELECT S.ixSKU as 'SKU'
                    , S.sDescription as 'Description'
            -- RTRIM removes the trailing spaces
                    , RTRIM(S.sSEMACategory) as 'Category'
                    , RTRIM(S.sSEMASubCategory) as 'Sub Category'
                    , RTRIM(S.sSEMAPart) as 'Part Terminology'
        FROM
        tblSKU S 
        WHERE S.sSEMACategory IS NOT NULL
             AND S.dtDiscontinuedDate > GETDATE()
             AND S.flgActive = '1'
             AND S.flgDeletedFromSOP = '0'
             AND RTRIM(S.sSEMACategory) IN (@SEMACategory) 
        --     AND S.sSEMASubCategory IN (@SEMASubCategory) 
          --   AND S.sSEMAPart IN (@SEMAPart) 
          
          AND S.ixSKU LIKE '4581208%'
        GROUP BY  RTRIM(S.sSEMACategory)
                           , RTRIM(S.sSEMASubCategory)
                           , RTRIM(S.sSEMAPart)
                           , S.ixSKU 
                           , S.sDescription
        ORDER BY RTRIM(S.sSEMACategory)
                           , RTRIM(S.sSEMASubCategory)
                           , RTRIM(S.sSEMAPart)
                           , S.ixSKU 
                           , S.sDescription
/*                   
SKU	    Description	            Category	            Sub Category	Part Terminology
4581208	FUEL CELL STRAP-8 GAL	Air and Fuel Delivery	Fuel Storage	Fuel Tank Straps                   
*/








SELECT * from tblSKU where ixSKU = '4907'


-- DROP TABLE [SMITemp].dbo.PJC_SMIHD4118_SKUListNeedingSEMACategorization

SELECT * FROM [SMITemp].dbo.PJC_SMIHD4118_SKUListNeedingSEMACategorization
order by TempID



SELECT X.* FROM
[SMITemp].dbo.PJC_SMIHD4118_SKUListNeedingSEMACategorization X
WHERE ixSKU NOT IN (SELECT ixSKU from tblSKU where flgDeletedFromSOP = 0)

/* manually added these fields to temp table
sSEMACategory
sSEMASubCategory
sSEMAPart
*/


BEGIN TRAN

update A 
set sSEMACategory = B.sSEMACategory,
   sSEMASubCategory = B.sSEMASubCategory,
   sSEMAPart = B.sSEMAPart 
from [SMITemp].dbo.PJC_SMIHD4118_SKUListNeedingSEMACategorization A
 join [SMI Reporting].dbo.tblSKU B on A.ixSKU = B.ixSKU
 
ROLLBACK TRAN


-- FINAL results to paste into spreadsheet
SELECT * 
FROM [SMITemp].dbo.PJC_SMIHD4118_SKUListNeedingSEMACategorization
order by TempID




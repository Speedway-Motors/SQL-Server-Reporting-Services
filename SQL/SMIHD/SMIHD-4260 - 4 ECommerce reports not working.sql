-- SMIHD-4260 - 4 ECommerce reports not working

/*
in tng the column ixSOPBrand was removed.  This caused issues with 4 reports (that we know of).
Either thier queires were broken or the Stored procs in TNG failed because they couldn't return that specific field.
*/
/*    REPORT                        ISSUE/FIX                                                       STATUS
=========================           ==================                                          ========================
1) SKU Bases Missing Images         ?Ron modified proc to return col aliased as 'ixSOPBrand'    FIXED
2) SKU Basis with Short Info Tabs   Ron modified proc                                           FIXED
3) SKUs by Brand Association        Unknown column 'B.ixSOPBrand' in 'field list'               Broken
4) SKUs Missing Product Lines       Ron modified proc                                           FIXED
*/

-- 2)SKU Basis with Short Info Tabs
SELECT ixSOPSKUBase, sName,         -- 1,068 rows 
        sTextBlock 'InfoTabTextBlock',
        sCategoryName, sSubCategoryName, sSemaPartName, sBrandName, ixBrand,
        1 as 'RecordCount' 
    FROM openQuery([TNGREADREPLICA],'   ') --   <-- MySQL proc written by Ron
    ORDER BY ixSOPSKUBase
    
    -- TOAD
    -- RUNNING: CALL spBase_ShortInfoTab(); 
    -- RETURNS: Unknown column 'br.ixSOPBrand' in 'field list'
    
    
    
-- 3) SKUs by Brand Association    

-- RDL Query
SELECT ixSOPSKUBase, sName, ixSOPSKU, ixProductLine,
	sCategoryName, sSubCategoryName, sSemaPartName,
	sBrandName, ixSOPBrand,
    COUNT(*) 'RecordCount'
FROM openQuery([TNGREADREPLICA],'CALL spBase_MissingProductLine()')
GROUP BY ixSOPSKUBase, sName,	ixSOPSKU, ixProductLine,
	sSubCategoryName, sCategoryName, sSemaPartName,
	sBrandName, ixSOPBrand
ORDER BY ixSOPSKUBase, ixSOPSKU 

    -- TOAD
    -- RUNNING CALL spBase_MissingProductLine();
    -- RETURNS: Unknown column 'br.ixSOPBrand' in 'field list'





-- 4) SKUs Missing Product Lines  
    -- RUN IN TOAD
SELECT *
FROM openquery([TNGREADREPLICA], '
        SELECT DISTINCT B.ixBrand AS ''ixSOPBrand''
     , B.sBrandName
     , PL.ixSOPProductLine 
     , PL.sTitle
     , SV.ixSOPSKU
     , SV.sSKUVariantName
FROM tblskubase SB 
JOIN tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
LEFT JOIN tblproductline PL ON PL.ixProductLine = SB.ixProductLine 
LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand 
WHERE (B.ixBrand = ?) 
  AND (
        (flgBackorderable = 1) 
          OR (flgBackorderable = 0 AND iTotalQAV > 0)
       )
  AND flgPublish = 1 
  ')
  
  
    -- TOAD
    -- RUNNING Above query
    -- RETURNS: Unknown column 'B.ixSOPBrand' in 'field list'
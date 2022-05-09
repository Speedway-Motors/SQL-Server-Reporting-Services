-- SMIHD-9153 - New Report SKUs without Product Pages

/*
SELECT CD.ixSKU FROM tblCatalogDetail CD where ixCatalog = '519'  -- 14,022 SKUs
SELECT * from tblCatalogMaster where ixCatalog = '519'
*/

-- PV   PVName  	


SELECT CD.i1stPage 'FirstPage'
    , CD.s1stLocation 'FirstLocation'
    , CD.ixSKU
    , VS.ixVendor 'PV'
    , V.sName 'PVName'
         --   , S.sBaseIndex
          --  , PP.ixSOPSKUBase
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription'  
    , S.sSEMACategory 'Category'
    , S.sSEMASubCategory 'SubCategory'
    , S.sSEMAPart 'Part'  
    , B.sBrandDescription 'Brand'      
    , S.flgUnitOfMeasure 'UnitOfMeasure'
    , 'TBD' 'MadeToOrder'
    , 'TBD' 'DropshipOnly'
    , S.mPriceLevel1 'PriceLvl1'
    , S.dtCreateDate 'SKUCreateDate'
    , PP.ActiveProductPage
    , (CASE WHEN CD2.ixSKU IS NULL then 'N'
       ELSE 'Y'
       END) 'InWEB.17'
    -- , S.dtDiscontinuedDate 'DiscontinuedDate'
    -- , S.flgBackorderAccepted 'BOAccepted'
    -- , PL.sTitle 'ProductLine'
FROM tblCatalogDetail CD
    left join tblCatalogDetail CD2 on CD.ixSKU = CD2.ixSKU and CD2.ixCatalog = 'WEB.17'
    left join tblSKU S on CD.ixSKU = S.ixSKU
    left join (-- SKU Bases 
               SELECT ixSOPSKUBase, ActiveProductPage 
               FROM openquery([TNGREADREPLICA], 'SELECT b.ixSOPSKUBase, pp.flgActive as ActiveProductPage
                                                 FROM tblskubase b
                                                    left JOIN tblproductpageskubase AS ppsb ON b.ixSKUBase = ppsb.ixSKUBase
                                                    left JOIN tblproductpage AS pp ON ppsb.ixProductPage = pp.ixProductPage
                                                 ') TNG  -- REMOVED THE WHERE CLAUSES
               ) PP on S.sBaseIndex COLLATE SQL_Latin1_General_CP1_CI_AS = PP.ixSOPSKUBase COLLATE SQL_Latin1_General_CP1_CI_AS
    left join tblBrand B on S.ixBrand = B.ixBrand    
    left join tblProductLine PL on S.ixProductLine = PL.ixProductLine        
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
WHERE CD.ixCatalog  = '519'
    and (PP.ActiveProductPage is NULL  -- pulls SKUs that have no ProductPage or who's PP = 0
         or PP.ActiveProductPage = 0
         or CD2.ixCatalog is NULL)  -- pulls SKUs not listed in current WEB catalog
ORDER BY PP.ActiveProductPage

/*
SELECT * FROM tblCatalogDetail where ixCatalog = '520'
SELECT * FROM tblCatalogMaster where ixCatalog = '520'
*/

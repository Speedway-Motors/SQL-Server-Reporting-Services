-- SMIHD-9152 - Wholesale PL1 vs Inventory PL1

-- SKU Inventory PL1 differs from Wholesale catalogs PL1
-- Wholesale Price Deltas
-- PRS.17 & MRR.17

DECLARE @Catalog varchar(10)--,  @ComparisonCatalog varchar(10)
SELECT @Catalog = 'PRS.17'--,  @ComparisonCatalog = '518'

SELECT CD.ixSKU 'SKU'
     -- S.sBaseIndex 'BaseIndex'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , S.mPriceLevel1 'InventoryPL1'
    , CD.mPriceLevel1 'CatalogPL1' 
    , (S.mPriceLevel1-CD.mPriceLevel1) 'PriceChange'
,S.mAverageCost 'AvgCost'
,S.mLatestCost 'LatestCost'
,VS.mCost 'PVCost'
,VS.ixVendor 'PVNum'
,V.sName 'PVName'
,S.flgActive
, (CASE WHEN GS.ixSKU IS NOT NULL THEN 'Y'
   ELSE 'N'
   END
   ) AS 'GarageSaleSKU'
    , B.sBrandDescription 'Brand'    
    , PL.sTitle 'ProductLine'    
    , S.sSEMACategory 'Category'
    , S.sSEMASubCategory 'SubCategory'    
    , S.sSEMAPart 'Part'
FROM tblCatalogDetail CD
    left join tblSKU S on CD.ixSKU = S.ixSKU
    left join tblBrand B on S.ixBrand = B.ixBrand    
    left join tblProductLine PL on S.ixProductLine = PL.ixProductLine     
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU 
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor           
WHERE S.flgDeletedFromSOP = 0
   AND CD.ixCatalog = @Catalog           -- 134,195
   AND S.mPriceLevel1 <> CD.mPriceLevel1    --  39,924
ORDER BY (S.mPriceLevel1-CD.mPriceLevel1)

/*
SELECT COUNT(*) FROM tblCatalogDetail where ixCatalog = 'MRR.17' -- 134,206  / 39,924  30% differ
SELECT COUNT(*) FROM tblCatalogDetail where ixCatalog = 'PRS.17' -- 167,826 /  41,995  25% differ
*/


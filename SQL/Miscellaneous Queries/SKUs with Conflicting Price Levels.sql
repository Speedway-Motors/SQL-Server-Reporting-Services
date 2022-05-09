-- SKUs with Conflicting Price Levels
select CD.ixSKU 'SKU'
     -- S.sBaseIndex 'BaseIndex'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , S.mPriceLevel1 'InventoryPL1'
    , S.mPriceLevel2 'InventoryPL2'
    , S.mPriceLevel3 'InventoryPL3'
    , S.mPriceLevel4 'InventoryPL4'
    , S.mPriceLevel5 'InventoryPL5'                
  --  , CD.mPriceLevel1 'CatalogPL1' 
--    , (S.mPriceLevel1-CD.mPriceLevel1) 'PriceChange'
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

FROM tblSKU S
    join tblCatalogDetail CD on S.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.17'
    left join tblBrand B on S.ixBrand = B.ixBrand    
    left join tblProductLine PL on S.ixProductLine = PL.ixProductLine     
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU 
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor           
WHERE S.flgDeletedFromSOP = 0
and (   S.mPriceLevel2-S.mPriceLevel1 > 0.01
     or S.mPriceLevel3-S.mPriceLevel1 > 0.01
     or S.mPriceLevel4-S.mPriceLevel1 > 0.01
     or S.mPriceLevel5-S.mPriceLevel1 > 0.01
     or S.mPriceLevel3-S.mPriceLevel2 > 0.01
     or S.mPriceLevel4-S.mPriceLevel2 > 0.01
     or S.mPriceLevel5-S.mPriceLevel2 > 0.01
     or S.mPriceLevel4-S.mPriceLevel3 > 0.01
     or S.mPriceLevel5-S.mPriceLevel3 > 0.01
     or S.mPriceLevel5-S.mPriceLevel4 > 0.01
     )    
-- and S.flgActive = 0      -- 690    
-- and S.mPriceLevel1 > 0
order by PVNum, S.ixSKU
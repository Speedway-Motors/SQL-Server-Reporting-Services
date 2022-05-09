-- Variance between SKU Price Levels

SELECT ixSKU, mPriceLevel1, mPriceLevel4, -- mPriceLevel2, mPriceLevel3, mPriceLevel5
    (mPriceLevel1-mPriceLevel4) 'PriceVariance',
    (((mPriceLevel1-mPriceLevel4)/mPriceLevel1)*100) 'PV%'
from tblCatalogDetail SD -- on S.ixSKU = SD.ixSKU
where SD.ixCatalog = 'PRS.17'   
   -- and mPriceLevel1 > 0
   -- and mPriceLevel1 > 0                -- 164,028
   -- and mPriceLevel4 <= mPriceLevel1    -- 163,675
    -- and mPriceLevel4+.03 <= mPriceLevel1 --161,221
    --and mPriceLevel1 > 100
order by 'PV%' desc-- 'PriceVariance' 
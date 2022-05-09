-- SMIHD-8404 - Price Exceptions for MRR17

SELECT CD.ixSKU 'SKU', 
S.sDescription 'SKUDescription', 
CD.mPriceLevel3'MRR17PL3', 
S.mPriceLevel1 'CurrentPriceLevel1'
from tblCatalogDetail CD
    left join tblSKU S on CD.ixSKU = S.ixSKU
where CD.ixCatalog = 'MRR.17'
order by S.ixSKU


order by (S.mPriceLevel3 - CD.mPriceLevel3) 


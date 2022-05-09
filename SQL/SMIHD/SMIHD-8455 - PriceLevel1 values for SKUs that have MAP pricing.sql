-- SMIHD-8455 - PriceLevel1 values for SKUs that have MAP pricing
select ixSKU, sDescription, mMAP, mPriceLevel1, mPriceLevel2, mPriceLevel3, mPriceLevel4, mPriceLevel5
from tblSKU
where flgDeletedFromSOP = 0
    and mMAP is NOT NULL
   -- and mMAP > mPriceLevel1
order by ixSKU

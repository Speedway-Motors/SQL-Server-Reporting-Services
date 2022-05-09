-- SMIHD-5221 - Count of SKUs available on the Web

-- NOTE: Marketing often wants information at the SKU BASE level, not the variant level
--       so be sure to ASK each time!

select COUNT(DISTINCT SKU.ixSKU) -- 182,174
from tblSKU SKU
    join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation = 99
where SKU.flgActive = 1
    and SKU.flgDeletedFromSOP = 0 --  INCLUDES Garage Sale SKUs          
    and SKU.mPriceLevel1 > 0 -- to exclude SKUs that are only sold as kit/BOM components
    and (SL.iQAV > 0
         OR
         SKU.flgBackorderAccepted = 1) -- this will include many dropship only SKUs that we never stock but still sell

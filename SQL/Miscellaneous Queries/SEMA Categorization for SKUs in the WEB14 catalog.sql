-- SEMA Categorization for SKUs in the WEB14 catalog

select distinct SKU.ixSKU, SKU.sDescription, SKU.sSEMACategory, SKU.sSEMASubCategory, PGC.ixMarket  -- 36,426 (22%) have no SEMA categorization!?!
from tblSKU SKU
    left join tblCatalogDetail CD on SKU.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.14' 
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where SKU.flgDeletedFromSOP = 0     -- 217,099
    and SKU.flgActive = 1           -- 163,097
    and SKU.flgIntangible = 0       -- 162,982
    -- and (CD.mPriceLevel1 is NULL or CD.mPriceLevel1 = 0)     <-- tons without prices !?!   possibly GS or dropship only SKUs?
order by SKU.sSEMACategory, ixMarket
   
    
    
    
select * from tblCatalogMaster where ixCatalog like '%WEB%'
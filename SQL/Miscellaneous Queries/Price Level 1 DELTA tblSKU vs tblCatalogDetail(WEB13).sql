-- Price Level 1 DELTA tblSKU vs tblCatalogDetail('WEB.13')


select * from tblCatalogMaster
where dtEndDate > getdate()
and dtStartDate < getdate()
order by dtStartDate


select ixSKU from tblCatalogDetail
where ixCatalog = '351' -- 2013 LT SPRING STREET                                11614
and ixSKU in (select ixSKU from tblCatalogDetail where ixCatalog = 'WEB.13')--  11612


-- Price Level 1 DELTA 
-- tblSKU vs tblCatalogDetail('WEB.13')
select CD.ixSKU, CD.mPriceLevel1 'Web.13_PL1', 
    SKU.mPriceLevel1 'SKU_PL1', -- 98 
    ABS (CD.mPriceLevel1-SKU.mPriceLevel1) PriceDelta,
    SKU.sWebImageUrl
from tblCatalogDetail CD
    full outer join tblSKU SKU on CD.ixSKU = SKU.ixSKU
where CD.ixCatalog = 'WEB.13'
    and CD.mPriceLevel1 <> SKU.mPriceLevel1
    and SKU.flgIntangible = 0
    and SKU.flgMadeToOrder = 0
    and SKU.flgDeletedFromSOP = 0
order by ABS (CD.mPriceLevel1-SKU.mPriceLevel1) desc
-- 94,642 SKUs have matching Price Level 1
--  3,993 do NOT match
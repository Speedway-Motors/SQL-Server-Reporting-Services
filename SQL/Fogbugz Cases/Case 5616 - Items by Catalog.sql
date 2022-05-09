select
    CD.ixSKU             SKU,
    SKU.sDescription    Description,
    CD.mPriceLevel1 as 'Level 1 Price',
    CD.mPriceLevel2 as 'Level 2 Price',
    CD.mPriceLevel3 as 'Level 3 Price',
    CD.mPriceLevel4 as 'Level 4 Price',
    CD.mPriceLevel5 as 'Level 5 Price',
    CD.i1stPage as '1st Page',
    SKU.flgUnitOfMeasure UnitOfMeasure,
    SKU.mAverageCost     Cost
from
    tblCatalogDetail CD
    left join tblSKU SKU on CD.ixSKU = SKU.ixSKU
where
    CD.ixCatalog = '290' --user defined
    
order by
    CD.i1stPage,
    CD.ixSKU
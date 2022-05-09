-- Catalog Price Levels differ from current SKU price Levels
/*
select dtDateLastSOPUpdate, * from tblSKU
where ixSKU = '200252.05'
*/
select CD.ixSKU, 
    CD.mPriceLevel1 'CatPL1',	
    S.mPriceLevel1 'tblSKUPL1',
    (CD.mPriceLevel1 - 	S.mPriceLevel1) 'PL1Delta',
    CD.mPriceLevel2 'CatPL2',	
    S.mPriceLevel2 'tblSKUPL2',	
    (CD.mPriceLevel2 - 	S.mPriceLevel2) 'PL2Delta',   
    CD.mPriceLevel3 'CatPL3',
    S.mPriceLevel3 'tblSKUPL3',	
    (CD.mPriceLevel3 - 	S.mPriceLevel3) 'PL3Delta',  
    CD.mPriceLevel4 'CatPL4',	
    S.mPriceLevel4 'tblSKUPL4',	
    (CD.mPriceLevel4 - 	S.mPriceLevel4) 'PL4Delta', 
    CD.mPriceLevel5 'CatPL5',
    S.mPriceLevel5 'tblSKUPL5',
    (CD.mPriceLevel5 - 	S.mPriceLevel5) 'PL5Delta'
from tblCatalogDetail CD
left join tblSKU S on CD.ixSKU = S.ixSKU
WHERE CD.ixCatalog = 'WEB.16'
and (CD.mPriceLevel1 <> S.mPriceLevel1
 OR CD.mPriceLevel2 <> S.mPriceLevel2
 OR CD.mPriceLevel3 <> S.mPriceLevel3
 OR CD.mPriceLevel4 <> S.mPriceLevel4
 OR CD.mPriceLevel5 <> S.mPriceLevel5)   
AND (
     ABS(CD.mPriceLevel1 - 	S.mPriceLevel1) > .01
 OR ABS(CD.mPriceLevel2 - 	S.mPriceLevel2) > .01
 OR ABS(CD.mPriceLevel3 - 	S.mPriceLevel3) > .01
 OR ABS(CD.mPriceLevel4 - 	S.mPriceLevel4) > .01
 OR ABS(CD.mPriceLevel5 - 	S.mPriceLevel5) > .01   
     )


-- SELECT * from tblCatalogMaster where ixCatalog like '%WEB%'
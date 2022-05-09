-- Case 17655 - export Catalog Pricing report data for WEB 13 to Excel
Select CD.ixSKU, 
    CD.mPriceLevel1, CD.mPriceLevel2, CD.mPriceLevel3, CD.mPriceLevel4, CD.mPriceLevel5, 
    CD.i1stPage, CD.i2ndPage, CD.i3rdPage, CD.i4thPage, CD.i5thPage, CD.i6thPage, CD.i7thPage, 
    CD.dSquareInches
from tblCatalogDetail CD
   left join tblSKU SKU on CD.ixSKU = SKU.ixSKU
where CD.ixCatalog = 'WEB.13'
  and SKU.flgDeletedFromSOP = 0
order by i1stPage, ixSKU


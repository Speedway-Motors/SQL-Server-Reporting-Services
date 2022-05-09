select DISTINCT OL.ixSKU, SKU.mPriceLevel1, OL.mWeightedKitComponentPrice, NEWID()
from tblOrderLine OL
join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where OL.ixShippedDate >= 17533
    and OL.mWeightedKitComponentPrice < SKU.mPriceLevel1
    and SKU.mPriceLevel1 > 0
    and OL.flgKitComponent = 1
    and OL.flgLineStatus = 'Shipped'
ORDER BY NEWID()

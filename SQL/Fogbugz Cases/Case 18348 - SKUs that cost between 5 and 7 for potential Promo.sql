-- Case 18348 - SKUs that cost between 5 and 7 for potential Promo
select SKU.ixSKU, SKU.sDescription,
    SKUL.iQAV , SKU.mPriceLevel1, 
    SKU.mLatestCost, SKU.mAverageCost,
    SKU.dWeight, SKU.iWidth,  SKU.iHeight, SKU.iLength,
    (SKU.iLength + ((SKU.iWidth+SKU.iHeight)*2)) as Laser,
    RTRIM(SKU.sSEMACategory) SEMACat, RTRIM(SKU.sSEMASubCategory)SEMASubCat, RTRIM(SKU.sSEMAPart) SEMAPart
from tblSKU SKU
    join tblSKULocation SKUL on SKUL.ixSKU = SKU.ixSKU
where flgDeletedFromSOP = 0
    and dtDiscontinuedDate >= '04/16/2013'
    and SKUL.ixLocation = '99'
    and SKU.flgIntangible = 0
    and SKUL.iQAV > 10
    and SKU.mLatestCost between 5.00 and 7.00
    and SKU.mAverageCost between 5.00 and 7.00
    and SKU.dWeight NOT like '%9' -- if it ends in 9 it hasn't been weighed because we're Speedway and we do stuff like taht :/
    and (SKU.iLength + ((SKU.iWidth+SKU.iHeight)*2) < 130)
    and SKU.ixSKU not LIKE 'BOX-%'
order by
    SKU.mPriceLevel1 desc
    --,SKU.sSEMACategory, SKU.sSEMASubCategory, SKU.sSEMAPart,
    --,Laser desc,
    --,SKU.dWeight    
    
 
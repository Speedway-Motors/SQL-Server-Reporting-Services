-- checking usage of fake SKUs to replace with flags eventually
SELECT COUNT(OL.ixOrder) 'OLCount',
    OL.ixSKU, 
    ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription',
    S.mAverageCost, 
    S.mPriceLevel1,
    S.flgIntangible
FROM tblOrderLine OL   
    join tblOrder O on O.ixOrder = OL.ixOrder   
    join tblSKU S on OL.ixSKU = S.ixSKU
    LEFT join tblCatalogDetail CD on OL.ixSKU = CD.ixSKU 
                                     and CD.ixCatalog = 'WEB.17' --[dbo].[GetCurrentWebCatalog] ()
WHERE O.dtShippedDate >= '12/06/16'   
    and sOrderStatus = 'Shipped'   
    and flgLineStatus = 'Shipped'   -- 56,759
    -- EXCLUDES
        AND OL.ixSKU NOT LIKE 'INS%' -- excludes SOME inserts
        AND UPPER(ISNULL(S.sWebDescription,S.sDescription)) NOT LIKE '%CATALOG%'
       -- AND CD.ixSKU is NULL -- NOT in WEB.17 catalog
        AND S.flgIntangible = 1
GROUP BY OL.ixSKU, S.mAverageCost, S.mPriceLevel1, ISNULL(S.sWebDescription,S.sDescription), S.flgIntangible
HAVING COUNT(OL.ixOrder) > 365 -- average 1+ orders/day  
ORDER BY COUNT(OL.ixOrder) desc
    --   OL.ixSKU
    -- S.mPriceLevel1, 
    
/*    
select O.sOrderStatus, OL.*
from tblOrderLine OL   
    join tblOrder O on O.ixOrder = OL.ixOrder  
where ixSKU = '001'
 and O.dtShippedDate >= '12/06/16' 
 and flgLineStatus = 'Shipped' 
 order by mExtendedPrice
 */
 
 
 
 
 
 
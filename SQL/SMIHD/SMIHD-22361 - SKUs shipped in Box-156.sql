-- SMIHD-22361 - SKUs shipped in Box-156 

SELECT P.sTrackingNumber, P.ixOrder, P.ixBoxSKU,
    OL.ixSKU,
    S.iLength--, S.iWidth, S.iHeight
from tblPackage P
    left join tblOrderLine OL on P.ixOrder = OL.ixOrder
                        and P.sTrackingNumber = OL.sTrackingNumber
    left join tblSKU S on OL.ixSKU = S.ixSKU
where ixShipDate >= 18994 -- 1/1/2020
    and flgCanceled = 0
    and flgReplaced = 0
    and ixBoxSKU = 'BOX-156'
    and S.iLength > 46
order by S.iLength desc, S.ixSKU


SELECT 
FROM tblPackage
where ixBoxSKU = 'BOX-156'
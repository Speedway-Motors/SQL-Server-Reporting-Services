
-- SMIHD-11789 - Prop 65 SKUs count by pick zone

SELECT (CASE
        WHEN SL.sPickingBin like '5A%' or SL.sPickingBin like '5B%' or SL.sPickingBin like '5C%' THEN '5ABC'
        WHEN SL.sPickingBin like '5D%' or SL.sPickingBin like '5E%' or SL.sPickingBin like '5F%' THEN '5DEF'
        WHEN SL.sPickingBin like '4A%' or SL.sPickingBin like '4B%' or SL.sPickingBin like '4C%' THEN '4ABC'
        WHEN SL.sPickingBin like '4D%' or SL.sPickingBin like '4E%' or SL.sPickingBin like '4F%' THEN '4DEF'
        WHEN SL.sPickingBin like '3A%' or SL.sPickingBin like '3B%' or SL.sPickingBin like '3C%' THEN '3ABC'
        WHEN SL.sPickingBin like '3D%' or SL.sPickingBin like '3E%' or SL.sPickingBin like '3F%' THEN '3DEF'
        WHEN SL.sPickingBin like 'V%' THEN 'V'
        WHEN SL.sPickingBin like 'X%' THEN 'X'
        WHEN SL.sPickingBin like 'Y%' THEN 'Y'
        WHEN SL.sPickingBin like 'Z%' THEN 'Z'
        WHEN SL.sPickingBin like 'B%' AND SL.sPickingBin <> 'BOM' THEN 'B'
        WHEN SL.sPickingBin like 'A%' THEN 'A'
        WHEN SL.sPickingBin like 'R%' THEN 'R'
        ELSE 'OTHER' -- B.ixBin
        END) 'PickZone',
        count(OL.ixSKU) 'OLCount',
        SUM(OL.iQuantity) 'TotSKUQty'
from tblOrderLine OL
    left join tblSKU S on OL.ixSKU = S.ixSKU 
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
where ixShippedDate = 18510     -- 15,519
    and ixOrder NOT LIKE 'P%'
    and ixOrder NOT LIKE 'Q%'   -- 11,864
    and S.flgProp65 = 1         -- 6,500 order lines    10,463 Qty
    and OL.flgLineStatus = 'Shipped'
    and OL.ixOrder in (SELECT ixOrder from tblOrder where sShipToState = 'CA') -- ONLY NEED ORDERS SHIPPED TO CALIFORNIA
    --and OL.flgKitComponent = 1
group by (CASE
        WHEN SL.sPickingBin like '5A%' or SL.sPickingBin like '5B%' or SL.sPickingBin like '5C%' THEN '5ABC'
        WHEN SL.sPickingBin like '5D%' or SL.sPickingBin like '5E%' or SL.sPickingBin like '5F%' THEN '5DEF'
        WHEN SL.sPickingBin like '4A%' or SL.sPickingBin like '4B%' or SL.sPickingBin like '4C%' THEN '4ABC'
        WHEN SL.sPickingBin like '4D%' or SL.sPickingBin like '4E%' or SL.sPickingBin like '4F%' THEN '4DEF'
        WHEN SL.sPickingBin like '3A%' or SL.sPickingBin like '3B%' or SL.sPickingBin like '3C%' THEN '3ABC'
        WHEN SL.sPickingBin like '3D%' or SL.sPickingBin like '3E%' or SL.sPickingBin like '3F%' THEN '3DEF'
        WHEN SL.sPickingBin like 'V%' THEN 'V'
        WHEN SL.sPickingBin like 'X%' THEN 'X'
        WHEN SL.sPickingBin like 'Y%' THEN 'Y'
        WHEN SL.sPickingBin like 'Z%' THEN 'Z'
        WHEN SL.sPickingBin like 'B%' AND SL.sPickingBin <> 'BOM' THEN 'B'
        WHEN SL.sPickingBin like 'A%' THEN 'A'
        WHEN SL.sPickingBin like 'R%' THEN 'R'
        ELSE 'OTHER' -- B.ixBin
        END)
ORDER BY (CASE
        WHEN SL.sPickingBin like '5A%' or SL.sPickingBin like '5B%' or SL.sPickingBin like '5C%' THEN '5ABC'
        WHEN SL.sPickingBin like '5D%' or SL.sPickingBin like '5E%' or SL.sPickingBin like '5F%' THEN '5DEF'
        WHEN SL.sPickingBin like '4A%' or SL.sPickingBin like '4B%' or SL.sPickingBin like '4C%' THEN '4ABC'
        WHEN SL.sPickingBin like '4D%' or SL.sPickingBin like '4E%' or SL.sPickingBin like '4F%' THEN '4DEF'
        WHEN SL.sPickingBin like '3A%' or SL.sPickingBin like '3B%' or SL.sPickingBin like '3C%' THEN '3ABC'
        WHEN SL.sPickingBin like '3D%' or SL.sPickingBin like '3E%' or SL.sPickingBin like '3F%' THEN '3DEF'
        WHEN SL.sPickingBin like 'V%' THEN 'V'
        WHEN SL.sPickingBin like 'X%' THEN 'X'
        WHEN SL.sPickingBin like 'Y%' THEN 'Y'
        WHEN SL.sPickingBin like 'Z%' THEN 'Z'
        WHEN SL.sPickingBin like 'B%' AND SL.sPickingBin <> 'BOM' THEN 'B'
        WHEN SL.sPickingBin like 'A%' THEN 'A'
        WHEN SL.sPickingBin like 'R%' THEN 'R'
        ELSE 'OTHER' -- B.ixBin
        END)
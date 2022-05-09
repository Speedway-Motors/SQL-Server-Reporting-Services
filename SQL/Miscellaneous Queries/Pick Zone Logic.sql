-- Pick Zone Logic
-- This is only an approximation Wyatt or Korth should be able to provide the detailed logic to determine picking zones

SELECT  
    (CASE
        WHEN B.ixBin like '5A%' or B.ixBin like '5B%' or B.ixBin like '5C%' THEN '5ABC'
        WHEN B.ixBin like '5D%' or B.ixBin like '5E%' or B.ixBin like '5F%' THEN '5DEF'
        WHEN B.ixBin like '4A%' or B.ixBin like '4B%' or B.ixBin like '4C%' THEN '4ABC'
        WHEN B.ixBin like '4D%' or B.ixBin like '4E%' or B.ixBin like '4F%' THEN '4DEF'
        WHEN B.ixBin like '3A%' or B.ixBin like '3B%' or B.ixBin like '3C%' THEN '3ABC'
        WHEN B.ixBin like '3D%' or B.ixBin like '3E%' or B.ixBin like '3F%' THEN '3DEF'
        WHEN B.ixBin like 'V%' THEN 'V'
        WHEN B.ixBin like 'X%' THEN 'X'
        WHEN B.ixBin like 'Y%' THEN 'Y'
        WHEN B.ixBin like 'Z%' THEN 'Z'
        WHEN B.ixBin like 'B%' AND B.ixBin <> 'BOM' THEN 'B'
        WHEN B.ixBin like 'A%' THEN 'A'
        WHEN B.ixBin like 'R%' THEN 'R'
        ELSE 'OTHER' -- B.ixBin
        END) 'PickZone',
     FORMAT(COUNT(B.ixBin),'###,###') 'PickBinCnt'
FROM tblBin B
    --join tblBinSku BS on B.ixBin = BS.ixBin and BS.ixLocation = 99
WHERE flgDeletedFromSOP = 0
    and sBinType = 'P'
    --and BS.ixLocation = 99
GROUP BY 
    (CASE
        WHEN B.ixBin like '5A%' or B.ixBin like '5B%' or B.ixBin like '5C%' THEN '5ABC'
        WHEN B.ixBin like '5D%' or B.ixBin like '5E%' or B.ixBin like '5F%' THEN '5DEF'
        WHEN B.ixBin like '4A%' or B.ixBin like '4B%' or B.ixBin like '4C%' THEN '4ABC'
        WHEN B.ixBin like '4D%' or B.ixBin like '4E%' or B.ixBin like '4F%' THEN '4DEF'
        WHEN B.ixBin like '3A%' or B.ixBin like '3B%' or B.ixBin like '3C%' THEN '3ABC'
        WHEN B.ixBin like '3D%' or B.ixBin like '3E%' or B.ixBin like '3F%' THEN '3DEF'
        WHEN B.ixBin like 'V%' THEN 'V'
        WHEN B.ixBin like 'X%' THEN 'X'
        WHEN B.ixBin like 'Y%' THEN 'Y'
        WHEN B.ixBin like 'Z%' THEN 'Z'
        WHEN B.ixBin like 'B%' AND B.ixBin <> 'BOM' THEN 'B'
        WHEN B.ixBin like 'A%' THEN 'A'
        WHEN B.ixBin like 'R%' THEN 'R'
        ELSE 'OTHER' -- B.ixBin
        END)
ORDER BY 'PickZone'

SELECT count(distinct ixBin)
 FROM tblBinSku
WHERE ixLocation = 99



SELECT O.ixOrder, OL.ixSKU, S.sDescription, OL.iQuantity, S.flgProp65
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Shipped'
    and O.dtOrderDate = '09/04/2018'
    and S.flgProp65 = 1
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.ixOrder = '8144912'
Order by O.ixOrder, OL.iOrdinality


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
FROM tblOrderLine OL
    left join tblSKU S on OL.ixSKU = S.ixSKU 
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
WHERE ixShippedDate = 18510     -- 15,519
    and ixOrder NOT LIKE 'P%'
    and ixOrder NOT LIKE 'Q%'   -- 11,864
    and S.flgProp65 = 1         -- 6,500 order lines    10,463 Qty
    and OL.flgLineStatus = 'Shipped'
    and OL.ixOrder in (SELECT ixOrder FROM tblOrder WHERE sShipToState = 'CA') -- ONLY NEED ORDERS SHIPPED TO CALIFORNIA
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



    SELECT top 10 * FROM tblSKULocation










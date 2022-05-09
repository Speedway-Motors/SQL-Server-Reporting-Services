SELECT OL.ixSKU
     , S.sDescription
     , OL.iQuantity AS Qty
     , OL.mUnitPrice AS UnitPrice
     , OL.mCost AS Cost
     , OL.mExtendedPrice AS ExtPrice
     , OL.mExtendedCost AS ExtCost
     , (((OL.mExtendedPrice - OL.mExtendedCost)/(NULLIF (OL.mExtendedPrice,0))*100)) AS 'Gross Margin %'
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON O.ixOrder = OL.ixOrder
LEFT JOIN tblSKU S ON OL.ixSKU = S.ixSKU 
WHERE O.ixCustomer = '1770000'
  AND O.dtShippedDate BETWEEN '01/01/11' AND '12/31/11'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType <> 'Internal'
  --AND O.sOrderChannel <> 'INTERNAL'
  --AND O.mMerchandise > '0'
  AND OL.flgKitComponent = '0'
  AND OL.flgLineStatus NOT IN ('Lost', 'Cancelled', 'fail')
--GROUP BY OL.ixSKU
  --     , S.sDescription
      -- , (((OL.mExtendedPrice - OL.mExtendedCost)/(NULLIF (OL.mExtendedPrice,0))*100)) 
ORDER BY OL.ixSKU


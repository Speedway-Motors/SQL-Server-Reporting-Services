


SELECT TOP 50 OL.ixSKU
     , SUM(OL.iQuantity) AS Qty
     , COUNT (OL.ixOrder) AS OrderCnt
     , SUM(OL.mExtendedPrice) AS Merch
     , SUM(OL.mExtendedCost) AS Cost 
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
WHERE O.sShipToCountry IN ('CA', 'CANADA') 
  AND O.dtShippedDate BETWEEN '04/01/11' AND '03/31/12'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.mMerchandise > 1 
  AND O.sShipToZip <> 'F'
  AND OL.ixSKU NOT IN ('COMINVOICE', 'READNOTE', 'HELP', 'DROPSHIP')
  AND OL.ixSKU NOT LIKE 'TECHELP%'
  AND OL.flgKitComponent = '0' 
GROUP BY OL.ixSKU 
ORDER BY Qty DESC

--Same query to exclude catalog results 

SELECT TOP 50 OL.ixSKU
     , SUM(OL.iQuantity) AS Qty
     , COUNT (OL.ixOrder) AS OrderCnt
     , SUM(OL.mExtendedPrice) AS Merch
     , SUM(OL.mExtendedCost) AS Cost 
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.sShipToCountry IN ('CA', 'CANADA') 
  AND O.dtShippedDate BETWEEN '04/01/11' AND '03/31/12'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.mMerchandise > 1 
  AND O.sShipToZip <> 'F'
  AND OL.ixSKU NOT IN ('COMINVOICE', 'READNOTE', 'HELP', 'DROPSHIP')
  AND OL.ixSKU NOT LIKE 'TECHELP%'
  AND OL.flgKitComponent = '0' 
  AND S.sSEMAPart <> 'Catalog'
GROUP BY OL.ixSKU 
ORDER BY Qty DESC

-- Check on figures 

SELECT DISTINCT OL.ixOrder
     , OL.ixSKU 
     , OL.iQuantity
     , OL.mExtendedPrice
     , OL.mExtendedCost
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
WHERE O.sShipToCountry IN ('CA', 'CANADA') 
  AND O.dtShippedDate BETWEEN '04/01/11' AND '03/31/12'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.mMerchandise > 1 
  AND O.sShipToZip <> 'F'
  AND OL.ixSKU = '8352300542'
  AND OL.flgKitComponent = '0' 


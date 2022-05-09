SELECT
   O.ixCustomer,
   O.dtShippedDate, 
   O.ixOrder,
   OL.ixSKU,
   SKU.sDescription SKUDescription,
   OL.iQuantity,
   OL.mUnitPrice,
   OL.mExtendedPrice
FROM tblOrder O
   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
   left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
WHERE  O.sOrderStatus = 'Shipped'
   and O.dtShippedDate >= '04/01/2010'
   and O.dtShippedDate < '04/01/2011'
   and O.ixCustomer in ('10700','10701') -- SUMMIT
   and O.sShipToZip not in ('44309','44278','30253','89431')
   and OL.flgKitComponent = 0 
   and SKU.ixSKU <> 'PLONLY'
UNION
SELECT
   O.ixCustomer,
   O.dtShippedDate, 
   O.ixOrder,
   OL.ixSKU,
   SKU.sDescription SKUDescription,
   OL.iQuantity,
   OL.mUnitPrice,
   OL.mExtendedPrice
FROM tblOrder O
   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
   left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
WHERE  O.sOrderStatus = 'Shipped'
   and O.dtShippedDate >= '04/01/2010'
   and O.dtShippedDate < '04/01/2011'
   and O.ixCustomer in ('10655','10158') -- JEGS
   and O.sShipToZip not in ('43015')
   and OL.flgKitComponent = 0 
   and SKU.ixSKU <> 'PLONLY'
UNION
SELECT
   O.ixCustomer,
   O.dtShippedDate, 
   O.ixOrder,
   OL.ixSKU,
   SKU.sDescription SKUDescription,
   OL.iQuantity,
   OL.mUnitPrice,
   OL.mExtendedPrice
FROM tblOrder O
   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
   left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
WHERE  O.sOrderStatus = 'Shipped'
   and O.dtShippedDate >= '04/01/2010'
   and O.dtShippedDate < '04/01/2011'
   and O.ixCustomer in ('10164','10704') -- JEGS
   and O.sShipToZip not in ('49098')
   and OL.flgKitComponent = 0 
   and SKU.ixSKU <> 'PLONLY'
ORDER BY O.ixCustomer,O.dtShippedDate desc, OL.mExtendedPrice desc, OL.ixSKU
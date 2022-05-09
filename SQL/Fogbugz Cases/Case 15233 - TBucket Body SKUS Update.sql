

/* This query is for all sales on items from 01/01/2012 to YTD */

SELECT TB.ixSKU
     , TB.sDescription
     , TB.dtCreateDate
     , TB.ixPGC
     , TB.sSEMACategory
     , TB.sSEMASubCategory
     , TB.sSEMAPart
     , SALES.TotalQty
     , SALES.TotalSales
FROM ASC_TBucketSKUS TB 
LEFT JOIN 
         (
           SELECT OL.ixSKU,
                  SUM(OL.iQuantity) AS TotalQty,
                  SUM(OL.mExtendedPrice) AS TotalSales
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL on OL.ixOrder = O.ixOrder
           WHERE OL.flgLineStatus = 'Shipped'
             and OL.dtShippedDate BETWEEN '01/01/2012' AND GETDATE()
             and OL.flgKitComponent = '0'
             and O.sOrderStatus = 'Shipped'
             and O.sOrderType <> 'Internal'
             and O.sOrderChannel <> 'INTERNAL'
             and O.mMerchandise > '0'                
           GROUP by OL.ixSKU
         ) 
           SALES on SALES.ixSKU = TB.ixSKU
ORDER BY TB.ixSKU



/* This query is for all sales on items from 01/01/2011 to 12/31/2011 */

SELECT TB.ixSKU
     , TB.sDescription
     , TB.dtCreateDate
     , TB.ixPGC
     , TB.sSEMACategory
     , TB.sSEMASubCategory
     , TB.sSEMAPart
     , SALES.TotalQty
     , SALES.TotalSales
FROM ASC_TBucketSKUS TB 
LEFT JOIN 
         (
           SELECT OL.ixSKU,
                  SUM(OL.iQuantity) AS TotalQty,
                  SUM(OL.mExtendedPrice) AS TotalSales
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL on OL.ixOrder = O.ixOrder
           WHERE OL.flgLineStatus = 'Shipped'
             and OL.dtShippedDate BETWEEN '01/01/2011' AND '12/31/2011'
             and OL.flgKitComponent = '0'
             and O.sOrderStatus = 'Shipped'
             and O.sOrderType <> 'Internal'
             and O.sOrderChannel <> 'INTERNAL'
             and O.mMerchandise > '0'                
           GROUP by OL.ixSKU
         ) 
           SALES on SALES.ixSKU = TB.ixSKU
ORDER BY TB.ixSKU


/* This query is for all sales on items from 01/01/2010 to 12/31/2010 */

SELECT TB.ixSKU
     , TB.sDescription
     , TB.dtCreateDate
     , TB.ixPGC
     , TB.sSEMACategory
     , TB.sSEMASubCategory
     , TB.sSEMAPart
     , SALES.TotalQty
     , SALES.TotalSales
FROM ASC_TBucketSKUS TB 
LEFT JOIN 
         (
           SELECT OL.ixSKU,
                  SUM(OL.iQuantity) AS TotalQty,
                  SUM(OL.mExtendedPrice) AS TotalSales
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL on OL.ixOrder = O.ixOrder
           WHERE OL.flgLineStatus = 'Shipped'
             and OL.dtShippedDate BETWEEN '01/01/2010' AND '12/31/2010'
             and OL.flgKitComponent = '0'
             and O.sOrderStatus = 'Shipped'
             and O.sOrderType <> 'Internal'
             and O.sOrderChannel <> 'INTERNAL'
             and O.mMerchandise > '0'                
           GROUP by OL.ixSKU
         ) 
           SALES on SALES.ixSKU = TB.ixSKU
ORDER BY TB.ixSKU


/* This query is for all sales on items from 01/01/2009 to 12/31/2009 */

SELECT TB.ixSKU
     , TB.sDescription
     , TB.dtCreateDate
     , TB.ixPGC
     , TB.sSEMACategory
     , TB.sSEMASubCategory
     , TB.sSEMAPart
     , SALES.TotalQty
     , SALES.TotalSales
FROM ASC_TBucketSKUS TB 
LEFT JOIN 
         (
           SELECT OL.ixSKU,
                  SUM(OL.iQuantity) AS TotalQty,
                  SUM(OL.mExtendedPrice) AS TotalSales
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL on OL.ixOrder = O.ixOrder
           WHERE OL.flgLineStatus = 'Shipped'
             and OL.dtShippedDate BETWEEN '01/01/2009' AND '12/31/2009'
             and OL.flgKitComponent = '0'
             and O.sOrderStatus = 'Shipped'
             and O.sOrderType <> 'Internal'
             and O.sOrderChannel <> 'INTERNAL'
             and O.mMerchandise > '0'                
           GROUP by OL.ixSKU
         ) 
           SALES on SALES.ixSKU = TB.ixSKU
ORDER BY TB.ixSKU
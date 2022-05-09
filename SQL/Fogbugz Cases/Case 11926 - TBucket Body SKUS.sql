
/* Notes on how the table was created:

 First I imported the SKUS into a table from the
 Excel file the DMH provided along with the additions 
 from the case notes. (save data to a text file as the 
 table name you want to create, go to the wanted server/database
 in SSMS and rt. click the database > tasks > import data >
 data source type - flat file source > next > find file (saved
 to desktop) > select 'Column name in first row' options > 
 next > next > preview > next > next > finish  */
 
-- Next, i did a quick check to see if there were any dupes

SELECT COUNT(*) QTYAllRows,
       COUNT(distinct ixSKU) QTYDistinct
from ASC_TBucketSKUS               

/*
QTYAllRows	QTYDistinct
129	        129
*/

/* When I created the table it only had 1 column.
  I manually added the columns sDescription,  dtCreateDate, ixPGC, 
  sSEMACategory, sSEMASubCategory, and sSEMAPart to make the SQL a bit easier later on.
  (Be sure to use the same data type and length as the tables your going to populate
  the data from. Next I populated those fields with data from our production tables */
  
update TB -- 129 rows
set sDescription = S.sDescription
from ASC_TBucketSKUS TB
    join tblSKU S on TB.ixSKU = S.ixSKU

update TB -- 129 rows
set dtCreateDate = S.dtCreateDate
from ASC_TBucketSKUS TB
    join tblSKU S on TB.ixSKU = S.ixSKU 

update TB -- 129 rows
set ixPGC = S.ixPGC
from ASC_TBucketSKUS TB
    join tblSKU S on TB.ixSKU = S.ixSKU 

update TB -- 129 rows
set sSEMACategory = S.sSEMACategory
from ASC_TBucketSKUS TB
    join tblSKU S on TB.ixSKU = S.ixSKU 

update TB -- 129 rows
set sSEMASubCategory = S.sSEMASubCategory
from ASC_TBucketSKUS TB
    join tblSKU S on TB.ixSKU = S.ixSKU 

update TB -- 129 rows
set sSEMAPart = S.sSEMAPart
from ASC_TBucketSKUS TB
    join tblSKU S on TB.ixSKU = S.ixSKU 

/* This query was to check the individual results of a particular 
SKU for the wanted data before entering it into a larger query */

SELECT COUNT(OL.ixSKU) AS 'Total Qty'
     , SUM (OL.mUnitPrice) AS 'Total Sales'
FROM tblOrderLine OL
JOIN tblOrder O on O.ixOrder = OL.ixOrder
WHERE OL.ixSKU = '9002000'
  and OL.flgLineStatus = 'Shipped'
  and OL.dtShippedDate BETWEEN '01/01/2012' AND '12/31/2012'
  and O.sOrderStatus = 'Shipped'
  and O.sOrderType <> 'Internal'
  and O.sOrderChannel <> 'INTERNAL'
  and O.mMerchandise > '0'
GROUP BY OL.ixSKU
ORDER BY OL.ixSKU




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
                  COUNT(OL.ixSKU) AS TotalQty,
                  SUM (OL.mUnitPrice) AS TotalSales
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
                  COUNT(OL.ixSKU) AS TotalQty,
                  SUM (OL.mUnitPrice) AS TotalSales
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
                  COUNT(OL.ixSKU) AS TotalQty,
                  SUM (OL.mUnitPrice) AS TotalSales
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
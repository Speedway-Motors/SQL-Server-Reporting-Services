-- Query to populate ASC_NEWEBAYUNIV table 

SELECT DISTINCT O.ixCustomer --17410 rows on 04/19/12 at 11:19
--DROP table ASC_NEWEBAYUNIV
--INTO ASC_NEWEBAYUNIV
FROM tblOrder O 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE C.ixSourceCode = 'EBAY'
  AND O.sOrderType = 'Retail'
  AND O.ixCustomer <> '1809726'
  AND O.sOrderStatus = 'Shipped' 
  AND C.dtAccountCreateDate >= '10/01/2010'
  AND O.mMerchandise > '0'
  AND C.flgDeletedFromSOP = 0
  AND O.sOrderChannel IN ('EBAY', 'AUCTION')
GROUP BY O.ixCustomer

--SELECT * FROM ASC_NEWEBAYUNIV



/* Starting pool of customer numbers whose first point of contact was through eBay 
   with at least two (or more) shipped orders (from any channel) stemming from the
   contact beginning with Q4 of 2010 */

-- Query to populate ASC_2PLUSEBAYUNIV table

SELECT DISTINCT NEU.ixCustomer --2895 rows on 04/19/12 at 11:20
    --, COUNT(O.ixOrder) AS TotalOrders
    --, SUM(O.mMerchandise) AS Revenue
    --, SUM(O.mMerchandiseCost) AS COGS
--DROP table ASC_2PLUSEBAYUNIV
--INTO ASC_2PLUSEBAYUNIV
FROM ASC_NEWEBAYUNIV NEU 
LEFT JOIN tblOrder O ON O.ixCustomer = NEU.ixCustomer 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE O.sOrderType = 'Retail'
  --AND C.ixSourceCode = 'EBAY'
  --AND O.ixCustomer <> '1809726'
  AND O.sOrderStatus = 'Shipped' 
  --AND C.dtAccountCreateDate >= '10/01/2010'
  AND O.mMerchandise > '0'
GROUP BY NEU.ixCustomer
HAVING COUNT(O.ixOrder) > '1' 

--SELECT * FROM ASC_2PLUSEBAYUNIV



-- Query to populate ASC_EBAY_FirstOrders table 


SELECT DISTINCT PEU.ixCustomer --2895 rows on 04/19/12 at 11:20
     , MIN(O.dtOrderDate)AS dtFirstOrder 
--DROP table ASC_EBAY_FirstOrders 
--INTO ASC_EBAY_FirstOrders
FROM ASC_2PLUSEBAYUNIV PEU
LEFT JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer 
WHERE O.sOrderStatus = 'Shipped' 
  AND O.sOrderChannel IN ('EBAY', 'AUCTION')
  AND O.sOrderType = 'Retail' 
  AND O.mMerchandise > 0
GROUP BY PEU.ixCustomer

-- Manually add additional field to ASC_EBAY_FirstOrders called ixFirstOrder 
-- varchar(10) allow nulls then run the following query to populate the needed data

UPDATE A  --2895 rows on 04/19/12 at 11:20
SET ixFirstOrder = O.ixOrder 
FROM ASC_EBAY_FirstOrders A 
JOIN tblOrder O on O.ixCustomer = A.ixCustomer 
and O.dtOrderDate = A.dtFirstOrder 
WHERE O.sOrderType = 'Retail' 
  and O.sOrderStatus = 'Shipped' 
  and O.sOrderChannel IN ('EBAY', 'AUCTION')
    and O.mMerchandise > 0



-- Query to populate ASC_2PLUSEBAYDATA table

SELECT DISTINCT PEU.ixCustomer --2895 rows on 04/19/12 at 11:20
              , C.dtAccountCreateDate
              , ISNULL (EBAY.Channel, 0) AS EBAYTotal
              , ISNULL (EBAY.Merch, 0) AS EBAYMerch
              , ISNULL (EBAY.Cost, 0) AS EBAYCost
              , ISNULL (PHONE.Channel, 0) AS CatalogTotal
              , ISNULL (PHONE.Merch, 0) AS CatalogMerch
              , ISNULL (PHONE.Cost, 0) AS CatalogCost
              , ISNULL (WEB.Channel, 0) AS WEBTotal
              , ISNULL (WEB.Merch, 0) AS WEBMerch
              , ISNULL (WEB.Cost, 0) AS WEBCost

--DROP table ASC_2PLUSEBAYDATA
--INTO ASC_2PLUSEBAYDATA

FROM ASC_2PLUSEBAYUNIV PEU

LEFT JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer

LEFT JOIN (SELECT DISTINCT PEU.ixCustomer --1689 ROWS
                , SUM (O.mMerchandise) AS Merch
                , SUM (O.mMerchandiseCost) AS Cost 
                , COUNT (O.sOrderChannel) AS Channel
           FROM ASC_2PLUSEBAYUNIV PEU
           JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer
           WHERE O.sOrderChannel IN ('AUCTION', 'EBAY')  
           AND O.sOrderType = 'Retail'
           AND O.sOrderStatus = 'Shipped'
           AND O.ixOrder NOT IN (SELECT ixFirstOrder FROM ASC_EBAY_FirstOrders) --2895 ROWS
           GROUP BY PEU.ixCustomer
          ) AS EBAY ON EBAY.ixCustomer = O.ixCustomer

LEFT JOIN (SELECT DISTINCT PEU.ixCustomer --711 ROWS
                , SUM (O.mMerchandise) AS Merch
                , SUM (O.mMerchandiseCost) AS Cost 
                , COUNT (O.sOrderChannel) AS Channel
           FROM ASC_2PLUSEBAYUNIV PEU
           JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer
           WHERE O.sOrderChannel IN ('NULL', 'COUNTER', 'E-MAIL', 'FAX', 'INTERNAL', 'MAIL', 'TRADESHOW', 'PHONE')
           AND O.sOrderType = 'Retail'
           AND O.sOrderStatus = 'Shipped'
           AND O.ixOrder NOT IN (SELECT ixFirstOrder FROM ASC_EBAY_FirstOrders) --711 ROWS
           GROUP BY PEU.ixCustomer
          ) AS PHONE ON PHONE.ixCustomer = O.ixCustomer

LEFT JOIN (SELECT DISTINCT PEU.ixCustomer --897 ROWS
                , SUM (O.mMerchandise) AS Merch
                , SUM (O.mMerchandiseCost) AS Cost 
                , COUNT (O.sOrderChannel) AS Channel
           FROM ASC_2PLUSEBAYUNIV PEU
           JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer
           WHERE O.sOrderChannel = 'WEB'   
             AND O.sOrderType = 'Retail'
             AND O.sOrderStatus = 'Shipped'
             AND O.ixOrder NOT IN (SELECT ixFirstOrder FROM ASC_EBAY_FirstOrders) --897 ROWS
           GROUP BY PEU.ixCustomer
          ) AS WEB ON WEB.ixCustomer = O.ixCustomer   
 
WHERE O.sOrderType = 'Retail'
  AND O.sOrderStatus = 'Shipped'


GROUP BY PEU.ixCustomer 
        , C.dtAccountCreateDate
        , EBAY.Channel
        , EBAY.Merch
        , EBAY.Cost
        , PHONE.Channel
        , PHONE.Merch
        , PHONE.Cost
        , WEB.Channel
        , WEB.Merch
        , WEB.Cost

ORDER BY EBAYTotal

-- SELECT * FROM ASC_2PLUSEBAYDATA

-- Query to populate ASC_2PLUSEBAYDATA2 table (to add Category column to table) 

SELECT DISTINCT PEU.ixCustomer --2895 ROWS
              , C.dtAccountCreateDate
              , ISNULL (EBAY.Channel, 0) AS EBAYTotal
              , ISNULL (EBAY.Merch, 0) AS EBAYMerch
              , ISNULL (EBAY.Cost, 0) AS EBAYCost
              , ISNULL (PHONE.Channel, 0) AS CatalogTotal
              , ISNULL (PHONE.Merch, 0) AS CatalogMerch
              , ISNULL (PHONE.Cost, 0) AS CatalogCost
              , ISNULL (WEB.Channel, 0) AS WEBTotal
              , ISNULL (WEB.Merch, 0) AS WEBMerch
              , ISNULL (WEB.Cost, 0) AS WEBCost
              , CHAN.Category AS Category 

--DROP table ASC_2PLUSEBAYDATA2
--INTO ASC_2PLUSEBAYDATA2

FROM ASC_2PLUSEBAYUNIV PEU

LEFT JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer

LEFT JOIN (SELECT DISTINCT PEU.ixCustomer --1764 ROWS
                , SUM (O.mMerchandise) AS Merch
                , SUM (O.mMerchandiseCost) AS Cost 
                , COUNT (O.sOrderChannel) AS Channel
           FROM ASC_2PLUSEBAYUNIV PEU
           JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer
           WHERE O.sOrderChannel IN ('AUCTION', 'EBAY')  
           AND O.sOrderType = 'Retail'
           AND O.sOrderStatus = 'Shipped'
           AND O.ixOrder NOT IN (SELECT ixFirstOrder FROM ASC_EBAY_FirstOrders)
           GROUP BY PEU.ixCustomer
          ) AS EBAY ON EBAY.ixCustomer = O.ixCustomer

LEFT JOIN (SELECT DISTINCT PEU.ixCustomer --705 ROWS
                , SUM (O.mMerchandise) AS Merch
                , SUM (O.mMerchandiseCost) AS Cost 
                , COUNT (O.sOrderChannel) AS Channel
           FROM ASC_2PLUSEBAYUNIV PEU
           JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer
           WHERE O.sOrderChannel IN ('NULL', 'COUNTER', 'E-MAIL', 'FAX', 'INTERNAL', 'MAIL', 'TRADESHOW', 'PHONE')
           AND O.sOrderType = 'Retail'
           AND O.sOrderStatus = 'Shipped'
           --AND O.ixOrder NOT IN (SELECT ixFirstOrder FROM ASC_EBAY_FirstOrders) --693 ROWS
           GROUP BY PEU.ixCustomer
          ) AS PHONE ON PHONE.ixCustomer = O.ixCustomer

LEFT JOIN (SELECT DISTINCT PEU.ixCustomer --888 ROWS
                , SUM (O.mMerchandise) AS Merch
                , SUM (O.mMerchandiseCost) AS Cost 
                , COUNT (O.sOrderChannel) AS Channel
           FROM ASC_2PLUSEBAYUNIV PEU
           JOIN tblOrder O ON O.ixCustomer = PEU.ixCustomer
           WHERE O.sOrderChannel = 'WEB'   
             AND O.sOrderType = 'Retail'
             AND O.sOrderStatus = 'Shipped'
             --AND O.ixOrder NOT IN (SELECT ixFirstOrder FROM ASC_EBAY_FirstOrders) --882 ROWS
           GROUP BY PEU.ixCustomer
          ) AS WEB ON WEB.ixCustomer = O.ixCustomer

LEFT JOIN (SELECT DISTINCT ixCustomer
                , (CASE WHEN EBAYTotal > 0 AND CatalogTotal = 0 AND WEBTotal = 0 THEN 'EBAY'
                        WHEN CatalogTotal > 0 AND EBAYTotal = 0 AND WEBTotal = 0 THEN 'CATALOG'
                        WHEN WEBTotal > 0 AND EBAYTotal = 0 AND CatalogTotal = 0 THEN 'WEB'
                        ELSE 'COMBO'
                  END) AS Category 
           FROM ASC_2PLUSEBAYDATA
           GROUP BY ixCustomer, EBAYTotal, CatalogTotal, WEBTotal
          ) AS CHAN ON CHAN.ixCustomer = O.ixCustomer   
 
WHERE O.sOrderType = 'Retail'
  AND O.sOrderStatus = 'Shipped'


GROUP BY PEU.ixCustomer 
        , C.dtAccountCreateDate
        , EBAY.Channel
        , EBAY.Merch
        , EBAY.Cost
        , PHONE.Channel
        , PHONE.Merch
        , PHONE.Cost
        , WEB.Channel
        , WEB.Merch
        , WEB.Cost
        , CHAN.Category

ORDER BY Category 


--SELECT * FROM ASC_2PLUSEBAYDATA2

-- Query to deterimine data for EBAY customers using ASC_2PLUSEBAYDATA2

SELECT COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(EBAYTotal) AS OrdCnt
     , (CAST(SUM(EBAYTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(EBAYMerch) AS Revenue
     , SUM(EBAYCost) AS Cost
     , SUM(EBAYMerch) / SUM(EBAYTotal) AS AOV 
     , (SUM(EBAYMerch) - SUM(EBAYCost)) / SUM(EBAYMerch) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'EBAY'

-- Query to deterimine data for WEB customers using ASC_2PLUSEBAYDATA2

SELECT COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(WEBTotal) AS OrdCnt
     , (CAST(SUM(WEBTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(WEBMerch) AS Revenue
     , SUM(WEBCost) AS Cost
     , SUM(WEBMerch) / SUM(WEBTotal) AS AOV 
     , (SUM(WEBMerch) - SUM(WEBCost)) / SUM(WEBMerch) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'WEB'

-- Query to deterimine data for CATALOG customers using ASC_2PLUSEBAYDATA2

SELECT COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(CatalogTotal) AS OrdCnt
     , (CAST(SUM(CatalogTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(CatalogMerch) AS Revenue
     , SUM(CatalogCost) AS Cost
     , SUM(CatalogMerch) / SUM(CatalogTotal) AS AOV 
     , (SUM(CatalogMerch) - SUM(CatalogCost)) / SUM(CatalogMerch) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'CATALOG'

-- Query to deterimine data for COMBO customers using ASC_2PLUSEBAYDATA2

SELECT COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(EBAYTotal) + SUM(WEBTotal) + SUM(CatalogTotal) AS OrdCnt
     , (CAST(SUM(EBAYTotal) + SUM(WEBTotal) + SUM(CatalogTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch) AS Revenue
     , SUM(EBAYCost) + SUM(WEBCost) + SUM(CatalogCost) AS Cost
     , (SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch)) / (SUM(EBAYTotal) + SUM(WEBTotal) + SUM(CatalogTotal)) AS AOV 
     , ((SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch)) - (SUM(EBAYCost) + SUM(WEBCost) + SUM(CatalogCost))) 
                        / (SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch)) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'COMBO'

-- Query to deterimine data for EBAY customers using ASC_2PLUSEBAYDATA2
-- broken out into quarters starting with Q4 2010 

SELECT (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
             WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
             WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
             WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
             WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
             WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
             ELSE 'Q22012'
        END) AS Age
     , COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(EBAYTotal) AS OrdCnt
     , (CAST(SUM(EBAYTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(EBAYMerch) AS Revenue
     , SUM(EBAYCost) AS Cost
     , SUM(EBAYMerch) / SUM(EBAYTotal) AS AOV 
     , (SUM(EBAYMerch) - SUM(EBAYCost)) / SUM(EBAYMerch) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'EBAY'
GROUP BY (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
               WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
               WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
               WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
               WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
               WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
               ELSE 'Q22012'
          END)

-- Query to deterimine data for WEB customers using ASC_2PLUSEBAYDATA2
-- broken out into quarters starting with Q4 2010 

SELECT (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
             WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
             WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
             WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
             WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
             WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
             ELSE 'Q22012'
        END) AS Age
     , COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(WEBTotal) AS OrdCnt
     , (CAST(SUM(WEBTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(WEBMerch) AS Revenue
     , SUM(WEBCost) AS Cost
     , SUM(WEBMerch) / SUM(WEBTotal) AS AOV 
     , (SUM(WEBMerch) - SUM(WEBCost)) / SUM(WEBMerch) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'WEB'
GROUP BY (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
               WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
               WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
               WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
               WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
               WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
               ELSE 'Q22012'
          END)

-- Query to deterimine data for Catalog customers using ASC_2PLUSEBAYDATA2
-- broken out into quarters starting with Q4 2010 

SELECT (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
             WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
             WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
             WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
             WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
             WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
             ELSE 'Q22012'
        END) AS Age
     , COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(CatalogTotal) AS OrdCnt
     , (CAST(SUM(CatalogTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(CatalogMerch) AS Revenue
     , SUM(CatalogCost) AS Cost
     , SUM(CatalogMerch) / SUM(CatalogTotal) AS AOV 
     , (SUM(CatalogMerch) - SUM(CatalogCost)) / SUM(CatalogMerch) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'CATALOG'
GROUP BY (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
               WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
               WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
               WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
               WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
               WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
               ELSE 'Q22012'
          END)

-- Query to deterimine data for COMBO customers using ASC_2PLUSEBAYDATA2
-- broken out into quarters starting with Q4 2010 

SELECT (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
             WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
             WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
             WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
             WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
             WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
             ELSE 'Q22012'
        END) AS Age
     , COUNT(DISTINCT ixCustomer) AS CustCnt
     , SUM(EBAYTotal) + SUM(WEBTotal) + SUM(CatalogTotal) AS OrdCnt
     , (CAST(SUM(EBAYTotal) + SUM(WEBTotal) + SUM(CatalogTotal) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch) AS Revenue
     , SUM(EBAYCost) + SUM(WEBCost) + SUM(CatalogCost) AS Cost
     , (SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch)) / (SUM(EBAYTotal) + SUM(WEBTotal) + SUM(CatalogTotal)) AS AOV 
     , ((SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch)) - (SUM(EBAYCost) + SUM(WEBCost) + SUM(CatalogCost))) 
                        / (SUM(EBAYMerch) + SUM(WEBMerch) + SUM(CatalogMerch)) AS GM
FROM ASC_2PLUSEBAYDATA2
WHERE Category = 'COMBO'
GROUP BY (CASE WHEN dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
               WHEN dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
               WHEN dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
               WHEN dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
               WHEN dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
               WHEN dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
               ELSE 'Q22012'
          END)

-- Query to determine data for all new customers whose first order was through the
-- eBay source type (including customers who only placed 1 order and subsequent orders)

SELECT (CASE WHEN C.dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
             WHEN C.dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
             WHEN C.dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
             WHEN C.dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
             WHEN C.dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
             WHEN C.dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
             ELSE 'Q22012'
        END) AS Age
     , COUNT(DISTINCT NEU.ixCustomer) AS CustCnt
     , COUNT (DISTINCT O.ixOrder) AS OrdCnt 
     , (CAST(COUNT(DISTINCT O.ixOrder) AS DECIMAL (10,2))) / CAST(COUNT(DISTINCT NEU.ixCustomer) AS DECIMAL(10,2)) AS OPC
     , SUM(O.mMerchandise) AS Revenue 
     , SUM(O.mMerchandiseCost) AS Cost
     , SUM(O.mMerchandise) / COUNT(DISTINCT O.ixOrder) AS AOV
     , (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) / SUM(O.mMerchandise) AS GM 
FROM ASC_NEWEBAYUNIV NEU
LEFT JOIN tblOrder O ON O.ixCustomer = NEU.ixCustomer 
LEFT JOIN tblCustomer C ON C.ixCustomer = NEU.ixCustomer
WHERE O.mMerchandise > 0 
  and O.sOrderType = 'Retail' 
  and O.sOrderStatus = 'Shipped' 
GROUP BY (CASE WHEN C.dtAccountCreateDate BETWEEN '10/01/10' AND '12/31/10' THEN 'Q42010'
               WHEN C.dtAccountCreateDate BETWEEN '01/01/11' AND '03/31/11' THEN 'Q12011'
               WHEN C.dtAccountCreateDate BETWEEN '04/01/11' AND '06/30/11' THEN 'Q22011'
               WHEN C.dtAccountCreateDate BETWEEN '07/01/11' AND '09/30/11' THEN 'Q32011'
               WHEN C.dtAccountCreateDate BETWEEN '10/01/11' AND '12/31/11' THEN 'Q42011'
               WHEN C.dtAccountCreateDate BETWEEN '01/01/12' AND '03/31/12' THEN 'Q12012'
               ELSE 'Q22012'
          END)

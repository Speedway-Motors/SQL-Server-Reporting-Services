
-- Y1 = Current/Most Recent Period
-- Y2 = Previous Period 

SELECT ISNULL(Y1.PGCType,Y2.PGCType) AS PGCType
     , ISNULL(Y1.NetSales,0) AS Y1NetSales
     , ISNULL(Y2.NetSales,0) AS Y2NetSales 
     , (ISNULL(Y1.NetSales,0)) - (ISNULL(Y2.NetSales,0)) AS Difference

FROM 

(SELECT ISNULL(SALES.PGCType,RTNS.PGCType) AS PGCType
                , ISNULL(SALES.Merch,0) - ISNULL(RTNS.Merch,0) AS NetSales
           FROM (SELECT ISNULL(SUBSTRING(S.ixPGC,1,1),'0') AS PGCType 
                      , ISNULL(SUM (OL.mExtendedPrice),0) AS Merch
                 FROM tblOrderLine OL 
                 LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                 WHERE OL.flgLineStatus = 'Shipped' 
                   AND OL.dtShippedDate BETWEEN @SalesStartDate1 AND @SalesEndDate1 --'01/01/12' AND '12/31/12' 
                   AND OL.ixCustomer IN (@CustomerNumber) --('10700', '10701') 
                 GROUP BY isnull(SUBSTRING(S.ixPGC,1,1),'0')
                ) AS SALES 

                 FULL OUTER JOIN (SELECT ISNULL(SUBSTRING(S.ixPGC,1,1),'0') AS PGCType 
                      , ISNULL(SUM (CMD.mExtendedPrice),0) AS Merch
                 FROM tblCreditMemoDetail CMD 
                 LEFT JOIN tblSKU S on S.ixSKU = CMD.ixSKU 
                 LEFT JOIN tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                 WHERE CMM.flgCanceled = '0' 
                   AND CMM.dtCreateDate BETWEEN @ReturnsStartDate1 AND @ReturnsEndDate1 --'01/01/12' AND '12/31/12' 
                   AND CMM.ixCustomer IN (@CustomerNumber) --('10700', '10701') 
                 GROUP BY isnull(SUBSTRING(S.ixPGC,1,1),'0')
                ) AS RTNS ON RTNS.PGCType = SALES.PGCType
          ) AS Y1 --Y1 = Most current year/period

FULL OUTER JOIN (SELECT ISNULL(SALES.PGCType,RTNS.PGCType) AS PGCType
                , ISNULL(SALES.Merch,0) - ISNULL(RTNS.Merch,0) AS NetSales
           FROM (SELECT ISNULL(SUBSTRING(S.ixPGC,1,1),'0') AS PGCType 
                      , ISNULL(SUM (OL.mExtendedPrice),0) AS Merch
                 FROM tblOrderLine OL 
                 LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                 WHERE OL.flgLineStatus = 'Shipped' 
                   AND OL.dtShippedDate BETWEEN @SalesStartDate2 AND @SalesEndDate2 --'01/01/11' AND '12/31/11' 
                   AND OL.ixCustomer IN (@CustomerNumber) --('10700', '10701') 
                 GROUP BY isnull(SUBSTRING(S.ixPGC,1,1),'0')
                ) AS SALES 

                 FULL OUTER JOIN (SELECT ISNULL(SUBSTRING(S.ixPGC,1,1),'0') AS PGCType 
                      , ISNULL(SUM (CMD.mExtendedPrice),0) AS Merch
                 FROM tblCreditMemoDetail CMD 
                 LEFT JOIN tblSKU S on S.ixSKU = CMD.ixSKU 
                 LEFT JOIN tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                 WHERE CMM.flgCanceled = '0' 
                   AND CMM.dtCreateDate BETWEEN @ReturnsStartDate2 AND @ReturnsEndDate2 --'01/01/11' AND '12/31/11'
                   AND CMM.ixCustomer IN (@CustomerNumber) --('10700', '10701') 
                 GROUP BY isnull(SUBSTRING(S.ixPGC,1,1),'0')
                ) AS RTNS ON RTNS.PGCType = SALES.PGCType
          ) AS Y2 ON Y2.PGCType = ISNULL(Y1.PGCType,Y2.PGCType) 

LEFT JOIN tblSKU S ON (SUBSTRING(S.ixPGC,1,1)) = ISNULL(Y1.PGCType,Y2.PGCType) 
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU 

GROUP BY ISNULL(Y1.PGCType,Y2.PGCType) 
     , ISNULL(Y1.NetSales,0) 
     , ISNULL(Y2.NetSales,0)
     , (ISNULL(Y1.NetSales,0)) - (ISNULL(Y2.NetSales,0))

ORDER BY PGCType

-- Check on SALES 

SELECT OL.* 
FROM tblOrderLine OL  
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE OL.flgLineStatus = 'Shipped' 
  AND OL.dtShippedDate BETWEEN '01/01/10' AND '12/31/11'
  --AND S.ixPGC LIKE 'A%' 
  AND OL.ixCustomer = '10511'

-- Check on RETURNS 

SELECT CMD.*
FROM tblCreditMemoDetail CMD 
LEFT JOIN tblSKU S ON S.ixSKU = CMD.ixSKU 
LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
WHERE CMM.dtCreateDate BETWEEN '01/01/10' AND '12/31/11'
  AND CMM.flgCanceled = '0'
  --AND S.ixPGC LIKE 'A%' 
  AND CMM.ixCustomer = '10511'
 
 
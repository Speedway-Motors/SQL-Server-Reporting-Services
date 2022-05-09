-- Analyzing Customer Ranking Changes
-- select COUNT(*) from vwCSTStartingPool -- 53,6256

DECLARE @Date datetime,
    @CompareToDate datetime,
    @MonthsBack int
    
SELECT @Date = '04/01/14',
@CompareToDate = '04/01/14',   
@MonthsBack = 72 

SELECT
    ISNULL(D.ixCustomer,CTD.ixCustomer) ixCustomer,
    -- RECENCY
    D.RecencyRank 'RecencyRank', 
    CTD.RecencyRank 'CTDRecencyRank', 
    (CTD.RecencyRank - D.RecencyRank) 'DeltaRecencyRank',
    
    -- FREQUENCY
    D.OrderQty 'OrderQty',
    CTD.OrderQty 'CTDOrderQty',
    (CTD.OrderQty-D.OrderQty) 'DeltaOrderQty',
/* 
DON'T USE.  Too large of a range for the same Qty of orders
    D.FrequencyRank 'FrequencyRank', 
    CTD.FrequencyRank 'CTDFrequencyRank',  
    (CTD.FrequencyRank - D.FrequencyRank) 'DeltaFrequencyRank',   
*/

    D.MonetaryRank 'MonetaryRank', 
    CTD.MonetaryRank 'CTDMonetaryRank', 
    (CTD.MonetaryRank - D.MonetaryRank) 'DeltaMonetaryRank',
    ((D.RecencyRank + D.FrequencyRank + D.FrequencyRank) / 3) 'AvgFDRank',
    ((CTD.RecencyRank + CTD.FrequencyRank + CTD.FrequencyRank) / 3) 'AvgCTDRank',
    (((D.RecencyRank + D.FrequencyRank + D.FrequencyRank) / 3) - ((CTD.RecencyRank + CTD.FrequencyRank + CTD.FrequencyRank) / 3)) 'DeltaAvgRank'

FROM (
        SELECT CST.ixCustomer
            ,RR.RecencyRank
            ,RR.LatestShipDate    
            ,FR.FrequencyRank
            ,FR.OrderQty    
            ,MR.MonetaryRank
            ,MR.Sales    
        FROM vwCSTStartingPool CST  -- 543,415
            -- RECENCY RANKING   <-- 50 seconds     
        LEFT JOIN 
            (SELECT CST.ixCustomer, max(O.dtOrderDate) LatestShipDate
            ,NTILE(100) OVER(ORDER BY max(O.dtOrderDate)) AS RecencyRank
            FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
            WHERE  O.dtShippedDate >= DATEADD(MM, -@MonthsBack, @Date)  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
            GROUP BY  CST.ixCustomer 
           -- ORDER BY CST.ixCustomer
            ) RR  ON RR.ixCustomer = CST.ixCustomer
            -- FREQUENCY RANKING   <-- 13 seconds   535,155 rows
        LEFT JOIN 
            (SELECT CST.ixCustomer, COUNT(O.ixOrder) OrderQty
            ,NTILE(100) OVER(ORDER BY COUNT(O.ixOrder)) AS FrequencyRank
            FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
            WHERE  O.dtShippedDate >= DATEADD(MM, -@MonthsBack, @Date)  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
            GROUP BY  CST.ixCustomer 
            ) FR ON FR.ixCustomer = CST.ixCustomer
             -- MONETARY RANKING  <-- 10 seconds
        LEFT JOIN 
            (SELECT CST.ixCustomer, SUM(O.mMerchandise) Sales
            ,NTILE(100) OVER(ORDER BY SUM(O.mMerchandise)) AS MonetaryRank
            FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
            WHERE  O.dtShippedDate >= DATEADD(MM, -@MonthsBack, @Date)  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
            GROUP BY  CST.ixCustomer 
            ) MR on MR.ixCustomer = CST.ixCustomer
       ) D
FULL OUTER JOIN
       (
        SELECT CST.ixCustomer
            ,RR.RecencyRank
            ,RR.LatestShipDate    
            ,FR.FrequencyRank
            ,FR.OrderQty    
            ,MR.MonetaryRank
            ,MR.Sales    
        FROM vwCSTStartingPool CST  -- 543,415
            -- RECENCY RANKING   <-- 50 seconds     
        LEFT JOIN 
            (SELECT CST.ixCustomer, max(O.dtOrderDate) LatestShipDate
            ,NTILE(100) OVER(ORDER BY max(O.dtOrderDate)) AS RecencyRank
            FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
            WHERE  O.dtShippedDate >= DATEADD(MM, -@MonthsBack, @CompareToDate)  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
            GROUP BY  CST.ixCustomer 
            ) RR  ON RR.ixCustomer = CST.ixCustomer
            -- FREQUENCY RANKING   <-- 13 seconds   535,155 rows
        LEFT JOIN 
            (SELECT CST.ixCustomer, COUNT(O.ixOrder) OrderQty
            ,NTILE(100) OVER(ORDER BY COUNT(O.ixOrder)) AS FrequencyRank
            FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
            WHERE  O.dtShippedDate >= DATEADD(MM, -@MonthsBack, @CompareToDate)  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
            GROUP BY  CST.ixCustomer 
            ) FR ON FR.ixCustomer = CST.ixCustomer
             -- MONETARY RANKING  <-- 10 seconds
        LEFT JOIN 
            (SELECT CST.ixCustomer, SUM(O.mMerchandise) Sales
            ,NTILE(100) OVER(ORDER BY SUM(O.mMerchandise)) AS MonetaryRank
            FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
            WHERE  O.dtShippedDate >= DATEADD(MM, -@MonthsBack, @CompareToDate)  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
            GROUP BY  CST.ixCustomer 
            ) MR on MR.ixCustomer = CST.ixCustomer
       ) CTD on D.ixCustomer = CTD.ixCustomer

order by 'DeltaOrderQty' desc
--DeltaAvgRank desc





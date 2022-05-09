-- Customer Ranking - prep work

/* 

NOTES:
   Ranking is percentile. e.g. rank of 98 means that customer ranked higher than 97% of the other customers

   
*/   
DECLARE @EndDate datetime
SELECT @EndDate = GETDATE() --'04/02/2014'

SELECT CST.ixCustomer
    ,FR.FrequencyRank
    ,RR.RecencyRank
    ,MR.MonetaryRank
*/    
FROM vwCSTStartingPool CST  -- 543,415

   -- DECLARE @EndDate datetime
   -- SELECT @EndDate = GETDATE()
    -- FREQUENCY RANKING   <-- 13 seconds   535,155 rows
LEFT JOIN 
    (select CST.ixCustomer
    ,NTILE(100) OVER(ORDER BY COUNT(O.ixOrder)) AS FrequencyRank
    from vwCSTStartingPool CST
        join tblOrder O on CST.ixCustomer = O.ixCustomer
    where  O.dtShippedDate >= DATEADD(MM, -72, @EndDate)  --DATEADD(MM, -@Recency, getdate()) 
       and O.sOrderType <> 'Internal'
       and O.sOrderChannel <> 'INTERNAL'
       and O.sOrderStatus in ('Shipped','Dropshipped')
       and O.mMerchandise > 1    
    GROUP BY  CST.ixCustomer 
    ) FR ON FR.ixCustomer = CST.ixCustomer

   -- DECLARE @EndDate datetime
    --SELECT @EndDate = GETDATE() --'04/02/2014'
    -- RECENCY RANKING   <-- 50 seconds     
LEFT JOIN 
    (select CST.ixCustomer
    ,NTILE(100) OVER(ORDER BY max(O.dtOrderDate)) AS RecencyRank
    from vwCSTStartingPool CST
        join tblOrder O on CST.ixCustomer = O.ixCustomer
    where  O.dtShippedDate >= DATEADD(MM, -72, @EndDate)  --DATEADD(MM, -@Recency, getdate()) 
       and O.sOrderType <> 'Internal'
       and O.sOrderChannel <> 'INTERNAL'
       and O.sOrderStatus in ('Shipped','Dropshipped')
       and O.mMerchandise > 1
    GROUP BY  CST.ixCustomer 
    ) RR  ON RR.ixCustomer = CST.ixCustomer
    
   -- DECLARE @EndDate datetime
   -- SELECT @EndDate = GETDATE() --'04/02/2014'
    -- MONETARY RANKING  <-- 10 seconds
LEFT JOIN 
    (select CST.ixCustomer
    ,NTILE(100) OVER(ORDER BY SUM(O.mMerchandise)) AS MonetaryRank
    from vwCSTStartingPool CST
        join tblOrder O on CST.ixCustomer = O.ixCustomer
    where  O.dtShippedDate >= DATEADD(MM, -72, @EndDate)  --DATEADD(MM, -@Recency, getdate()) 
       and O.sOrderType <> 'Internal'
       and O.sOrderChannel <> 'INTERNAL'
       and O.sOrderStatus in ('Shipped','Dropshipped')
       and O.mMerchandise > 1    
    GROUP BY  CST.ixCustomer 
    ) MR on MR.ixCustomer = CST.ixCustomer

ORDER BY --CST.ixCustomer
FR.FrequencyRank
    ,RR.RecencyRank
    ,MR.MonetaryRank
 
   

-- A+ customers.   100 in all three rankings
 select * from vwCSTRanking
 where FrequencyRank = 100
 and MonetaryRank = 100
 and RecencyRank = 100


-- out of the ordinary stats?
MonetaryRank OF 100 = Total 72 month Sales between $7,343 and $339,739
FrequencyRank OF 1 to 47 all have 1 order in the past 72 Months


select MonetaryRank, COUNT(*)
from  vwCSTRanking group by MonetaryRank
order by COUNT(*) desc

select FrequencyRank, COUNT(*)
from  vwCSTRanking group by FrequencyRank
order by COUNT(*) desc

select RecencyRank, COUNT(*)
from  vwCSTRanking group by RecencyRank
order by COUNT(*) desc

select COUNT(*) from vwCSTRanking

select COUNT(*) from vwCSTRanking
select COUNT(*) from vwCSTStartingPool

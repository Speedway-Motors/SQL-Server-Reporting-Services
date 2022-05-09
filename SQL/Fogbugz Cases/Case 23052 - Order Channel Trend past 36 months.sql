-- Case 23052 - Order Channel Trend past 36 months
SELECT 
    D.iYear, D.iQuarter,
   -- O.ixCustomer, O.sShipToState, 
   (CASE WHEN O.sOrderChannel = 'PHONE' then 'PHONE'
         WHEN O.sOrderChannel IN ('AUCTION','EBAY','WEB') THEN 'ONLINE'
         ELSE 'OTHER'
         end
         ) OrderChan,
    COUNT(O.ixOrder) 'OrdQty'         
from tblOrder O
    join vwCSTStartingPool CST on O.ixCustomer = CST.ixCustomer
    join tblDate D on O.ixShippedDate = D.ixDate
where O.sOrderStatus = 'Shipped' 
    and O.dtShippedDate between '04/01/2011' and '03/31/2014'
    and O.ixOrder NOT LIKE '%-%' -- exclude backorders
    and O.mMerchandise > 1
GROUP BY  D.iYear, D.iQuarter, 
        (CASE WHEN O.sOrderChannel = 'PHONE' then 'PHONE'
         WHEN O.sOrderChannel IN ('AUCTION','EBAY','WEB') THEN 'ONLINE'
         ELSE 'OTHER'
         end
         )
ORDER BY iYear, iQuarter, OrderChan      


SELECT O.ixCustomer,
    D.iYear, D.iQuarter,
   -- O.ixCustomer, O.sShipToState, 
   (CASE WHEN O.sOrderChannel = 'PHONE' then 'PHONE'
         WHEN O.sOrderChannel IN ('AUCTION','EBAY','WEB') THEN 'ONLINE'
         ELSE 'OTHER'
         end
         ) OrderChan,
    COUNT(Distinct O.ixOrder) 'OrderCount'  
into [SMITemp].dbo.PJC_23052_CustOrderBreakdown           
from tblOrder O
    join vwCSTStartingPool CST on O.ixCustomer = CST.ixCustomer
    join tblDate D on O.ixShippedDate = D.ixDate
where O.sOrderStatus = 'Shipped' 
    and O.dtShippedDate between '04/01/2011' and '03/31/2014'
    and O.ixOrder NOT LIKE '%-%' -- exclude backorders
    and O.mMerchandise > 1
GROUP BY O.ixCustomer,
         D.iYear, D.iQuarter, 
        (CASE WHEN O.sOrderChannel = 'PHONE' then 'PHONE'
         WHEN O.sOrderChannel IN ('AUCTION','EBAY','WEB') THEN 'ONLINE'
         ELSE 'OTHER'
         end
         )
ORDER BY O.ixCustomer, iYear, iQuarter, OrderChan      



/***** STARTING POOL ********/
 -- Customers meeting the conditions that have ordered in the last 36Mo
 -- DROP TABLE [SMITemp].dbo.PJC_23052_QualifyinCustomers
SELECT DISTINCT O.ixCustomer -- 387,730
into [SMITemp].dbo.PJC_23052_QualifyinCustomers
from tblOrder O
    join vwCSTStartingPool CST on O.ixCustomer = CST.ixCustomer
    join tblDate D on O.ixShippedDate = D.ixDate
where O.sOrderStatus = 'Shipped' 
    and O.dtShippedDate between '04/01/2011' and '03/31/2014'
    and O.ixOrder NOT LIKE '%-%' -- exclude backorders
    and O.mMerchandise > 1
   
   
-- Quarters being examined   
select distinct iYear, iQuarter
from tblDate where dtDate between '04/01/2011' and '03/31/2014'
order by iYear, iQuarter


-- CREATE table with Custs and ALL Counts to be populated
-- DROP TABLE [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan
select QC.ixCustomer, -- 387,730
    0 '2011-2Phone',    0 '2011-2Online',    0 '2011-2Other',
    0 '2011-3Phone',    0 '2011-3Online',    0 '2011-3Other',
    0 '2011-4Phone',    0 '2011-4Online',    0 '2011-4Other',        
    0 '2012-1Phone',    0 '2012-1Online',    0 '2012-1Other',
    0 '2012-2Phone',    0 '2012-2Online',    0 '2012-2Other',
    0 '2012-3Phone',    0 '2012-3Online',    0 '2012-3Other',
    0 '2012-4Phone',    0 '2012-4Online',    0 '2012-4Other',   
    0 '2013-1Phone',    0 '2013-1Online',    0 '2013-1Other',
    0 '2013-2Phone',    0 '2013-2Online',    0 '2013-2Other',
    0 '2013-3Phone',    0 '2013-3Online',    0 '2013-3Other',
    0 '2013-4Phone',    0 '2013-4Online',    0 '2013-4Other',  
    0 '2014-1Phone',    0 '2014-1Online',    0 '2014-1Other'
into [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan
from [SMITemp].dbo.PJC_23052_QualifyinCustomers QC         

 
 
select COUNT(*) from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan
select COUNT(*) from [SMITemp].dbo.PJC_23052_QualifyinCustomers


select top 10 * from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan


-- #01 
update FINAL 
set [2011-2Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2011-2Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #02 
update FINAL 
set [2011-2Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2011-2Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #03
update FINAL 
set [2011-2Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2011-2Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan     

-- #04 
update FINAL 
set [2011-3Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2011-3Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #05 
update FINAL 
set [2011-3Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2011-3Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #06
update FINAL 
set [2011-3Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2011-3Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan   


-- #07
update FINAL 
set [2011-4Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2011-4Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #08 
update FINAL 
set [2011-4Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2011-4Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #09
update FINAL 
set [2011-4Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2011
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2011
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2011-4Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #10
update FINAL 
set [2012-1Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2012-1Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #11 
update FINAL 
set [2012-1Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2012-1Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #12
update FINAL 
set [2012-1Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2012-1Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
    
-- #13
update FINAL 
set [2012-2Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2012-2Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #14 
update FINAL 
set [2012-2Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2012-2Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #15
update FINAL 
set [2012-2Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2012-2Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
        
-- #16
update FINAL 
set [2012-3Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2012-3Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #17 
update FINAL 
set [2012-3Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2012-3Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #18
update FINAL 
set [2012-3Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2012-3Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
    

-- #19
update FINAL 
set [2012-4Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2012-4Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #20 
update FINAL 
set [2012-4Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2012-4Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #21
update FINAL 
set [2012-4Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2012
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2012
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2012-4Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #22
update FINAL 
set [2013-1Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2013-1Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #23 
update FINAL 
set [2013-1Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2013-1Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #24
update FINAL 
set [2013-1Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2013-1Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
    
-- #25
update FINAL 
set [2013-2Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2013-2Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #26 
update FINAL 
set [2013-2Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2013-2Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #27
update FINAL 
set [2013-2Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 2 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 2 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2013-2Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
        
-- #28
update FINAL 
set [2013-3Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2013-3Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #29 
update FINAL 
set [2013-3Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2013-3Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #30
update FINAL 
set [2013-3Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 3 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 3 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2013-3Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
    

-- #31
update FINAL 
set [2013-4Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2013-4Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #32 
update FINAL 
set [2013-4Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2013-4Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #33
update FINAL 
set [2013-4Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2013
    and COB.iQuarter  = 4 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2013
        and COB.iQuarter  = 4 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2013-4Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
    
-- #34
update FINAL 
set [2014-1Phone] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2014
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'PHONE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2014
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'PHONE'
    GO
    select SUM([2014-1Phone]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #35 
update FINAL 
set [2014-1Online] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2014
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'ONLINE'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2014
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'ONLINE'
    GO
    select SUM([2014-1Online]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 

-- #36
update FINAL 
set [2014-1Other] = COB.OrderCount
from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan FINAL
 join [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB on FINAL.ixCustomer = COB.ixCustomer
WHERE   COB.iYear     = 2014
    and COB.iQuarter  = 1 
    and COB.OrderChan = 'OTHER'
GO
    -- validation check
    select SUM(OrderCount) from [SMITemp].dbo.PJC_23052_CustOrderBreakdown COB
    where COB.iYear     = 2014
        and COB.iQuarter  = 1 
        and COB.OrderChan = 'OTHER'
    GO
    select SUM([2014-1Other]) from  [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan 
    
                        
select top 10 * from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan
select top 10 * from [SMITemp].dbo.PJC_23052_CustOrderBreakdown 


select * from [SMITemp].dbo.PJC_23052_OrderCountByYrQtrChan
order by ([2011-2Phone]+[2011-2Online]+[2011-2Other]+[2011-3Phone]+[2011-3Online]+[2011-3Other]+[2011-4Phone]+[2011-4Online]+[2011-4Other]+[2012-1Phone]+[2012-1Online]+[2012-1Other]+[2012-2Phone]+[2012-2Online]+[2012-2Other]+[2012-3Phone]+[2012-3Online]+[2012-3Other]+[2012-4Phone]+[2012-4Online]+[2012-4Other]+[2013-1Phone]+[2013-1Online]+[2013-1Other]+[2013-2Phone]+[2013-2Online]+[2013-2Other]+[2013-3Phone]+[2013-3Online]+[2013-3Other]+[2013-4Phone]+[2013-4Online]+[2013-4Other]+[2014-1Phone]+[2014-1Online]+[2014-1Other])Desc



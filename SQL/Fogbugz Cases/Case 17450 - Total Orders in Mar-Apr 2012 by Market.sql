-- RawMarketTotals     
Select DISTINCT O.ixOrder,
    (CASE when PGC.ixMarket = '2B' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'TBSales',
    (CASE when PGC.ixMarket = 'B' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'BSales',     
    (CASE when PGC.ixMarket = 'PC' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'PCSales',  
    (CASE when PGC.ixMarket = 'R' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'RSales',  
    (CASE when PGC.ixMarket = 'SM' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'SMSales',  
    (CASE when PGC.ixMarket = 'SR' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'SRSales',  
    (CASE when PGC.ixMarket = 'TE' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'TESales'
into ASC_17450_MarchRawMarketTotals 
-- DROP TABLE ASC_17450_MarchRawMarketTotals 
from [SMI Reporting].dbo.tblOrder O    
    join [SMI Reporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where   O.sOrderStatus = 'Shipped' 
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '03/01/2012' and '03/31/2012'
    and O.ixOrder NOT LIKE '%-%'       
group by O.ixOrder,PGC.ixMarket 
order by O.ixOrder--,PGC.ixMarket 
-- 71528

SELECT TOP 1 * FROM ASC_17450_MarchRawMarketTotals 
--ixOrder	ixCustomer	TBSales	BSales	PCSales	RSales	SMSales	SRSales	TESales
--4000060	1876245		0.00	0.00	0.00	170.99	0.00	0.00	0.00

-- Summing up markets $ at the Order Level
select ixOrder, --45145
    sum(TBSales) as 'TBSales',
    sum(BSales)  as 'BSales',
    sum(PCSales) as 'PC Sales',
    sum(RSales)  as 'R Sales',
    sum(SMSales) as 'SM Sales',
    sum(SRSales) as 'SR Sales',
    sum(TESales) as 'TE Sales'
into ASC_17450_MarchOrderMarketSummaryTotals     
from ASC_17450_MarchRawMarketTotals
group by ixOrder
order by ixOrder 

-- only Orders where Race Sales are the Largest Market   -- 16,216 Orders
select DISTINCT ixOrder 
from ASC_17450_MarchOrderMarketSummaryTotals 
where   [R Sales] > [TBSales]
    and [R Sales] > [BSales]
    and [R Sales] > [PC Sales]
    and [R Sales] > [SM Sales]
    and [R Sales] > [SR Sales]
    and [R Sales] > [TE Sales] 
order by ixOrder  

--Check
SELECT *
FROM ASC_17450_MarchRawMarketTotals 
WHERE ixOrder IN ('4000060', '4000062', '4000065', '4000066', '4000068', '4000160', '4000161', 
                  '4000162', '4000163', '4000267', '4000365', '4000369', '4000462', '4000467', 
                  '4000468', '4000561', '4000567') 
ORDER BY ixOrder     

-- only Orders where Street Sales are the Largest Market   -- 19,857 Orders
select DISTINCT ixOrder 
from ASC_17450_MarchOrderMarketSummaryTotals 
where   [SR Sales] > [TBSales]
    and [SR Sales] > [BSales]
    and [SR Sales] > [PC Sales]
    and [SR Sales] > [SM Sales]
    and [SR Sales] > [R Sales]
    and [SR Sales] > [TE Sales] 
order by ixOrder   

-- only Orders where 'Both' Sales are the Largest Market   -- 6,147 Orders
select DISTINCT ixOrder 
from ASC_17450_MarchOrderMarketSummaryTotals 
where   [BSales] > [TBSales]
    and [BSales] > [SR Sales]
    and [BSales] > [PC Sales]
    and [BSales] > [SM Sales]
    and [BSales] > [R Sales]
    and [BSales] > [TE Sales] 
order by ixOrder       


-- RawMarketTotals     
Select DISTINCT O.ixOrder,
    (CASE when PGC.ixMarket = '2B' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'TBSales',
    (CASE when PGC.ixMarket = 'B' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'BSales',     
    (CASE when PGC.ixMarket = 'PC' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'PCSales',  
    (CASE when PGC.ixMarket = 'R' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'RSales',  
    (CASE when PGC.ixMarket = 'SM' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'SMSales',  
    (CASE when PGC.ixMarket = 'SR' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'SRSales',  
    (CASE when PGC.ixMarket = 'TE' THEN sum(OL.mExtendedPrice)
     ELSE 0
     END) AS 'TESales'
into ASC_17450_AprilRawMarketTotals 
-- DROP TABLE ASC_17450_AprilRawMarketTotals 
from [SMI Reporting].dbo.tblOrder O    
    join [SMI Reporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where   O.sOrderStatus = 'Shipped' 
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '04/01/2012' and '04/30/2012'
    and O.ixOrder NOT LIKE '%-%'       
group by O.ixOrder,PGC.ixMarket 
order by O.ixOrder--,PGC.ixMarket 
-- 67891

SELECT TOP 1 * FROM ASC_17450_AprilRawMarketTotals 
--ixOrder	TBSales	BSales	PCSales	RSales	SMSales	SRSales	TESales
--4131662	0.00	35.96	0.00	0.00	0.00	0.00	0.00

-- Summing up markets $ at the Order Level
select ixOrder, --44789
    sum(TBSales) as 'TBSales',
    sum(BSales)  as 'BSales',
    sum(PCSales) as 'PC Sales',
    sum(RSales)  as 'R Sales',
    sum(SMSales) as 'SM Sales',
    sum(SRSales) as 'SR Sales',
    sum(TESales) as 'TE Sales'
into ASC_17450_AprilOrderMarketSummaryTotals     
from ASC_17450_AprilRawMarketTotals
group by ixOrder
order by ixOrder 

-- only Orders where Race Sales are the Largest Market   -- 16,831 Orders
select DISTINCT ixOrder 
from ASC_17450_AprilOrderMarketSummaryTotals 
where   [R Sales] > [TBSales]
    and [R Sales] > [BSales]
    and [R Sales] > [PC Sales]
    and [R Sales] > [SM Sales]
    and [R Sales] > [SR Sales]
    and [R Sales] > [TE Sales] 
order by ixOrder  

-- only Orders where Street Sales are the Largest Market   -- 19,142 Orders
select DISTINCT ixOrder 
from ASC_17450_AprilOrderMarketSummaryTotals 
where   [SR Sales] > [TBSales]
    and [SR Sales] > [BSales]
    and [SR Sales] > [PC Sales]
    and [SR Sales] > [SM Sales]
    and [SR Sales] > [R Sales]
    and [SR Sales] > [TE Sales] 
order by ixOrder   

-- only Orders where 'Both' Sales are the Largest Market   -- 5,805 Orders
select DISTINCT ixOrder 
from ASC_17450_AprilOrderMarketSummaryTotals 
where   [BSales] > [TBSales]
    and [BSales] > [SR Sales]
    and [BSales] > [PC Sales]
    and [BSales] > [SM Sales]
    and [BSales] > [R Sales]
    and [BSales] > [TE Sales] 
order by ixOrder  

-- only Orders where 'Both' Sales are the Largest Market   -- 746 Orders
select DISTINCT ixOrder 
from ASC_17450_AprilOrderMarketSummaryTotals 
where   [TBSales] > [BSales]
    and [TBSales] > [SR Sales]
    and [TBSales] > [PC Sales]
    and [TBSales] > [SM Sales]
    and [TBSales] > [R Sales]
    and [TBSales] > [TE Sales] 
order by ixOrder              

-- only Orders where 'Both' Sales are the Largest Market   -- 279 Orders
select DISTINCT ixOrder 
from ASC_17450_AprilOrderMarketSummaryTotals 
where   [PC Sales] > [BSales]
    and [PC Sales] > [SR Sales]
    and [PC Sales] > [TBSales]
    and [PC Sales] > [SM Sales]
    and [PC Sales] > [R Sales]
    and [PC Sales] > [TE Sales] 
order by ixOrder 

-- only Orders where 'Both' Sales are the Largest Market   -- 1833 Orders
select DISTINCT ixOrder 
from ASC_17450_AprilOrderMarketSummaryTotals 
where   [SM Sales] > [BSales]
    and [SM Sales] > [SR Sales]
    and [SM Sales] > [TBSales]
    and [SM Sales] > [PC Sales]
    and [SM Sales] > [R Sales]
    and [SM Sales] > [TE Sales] 
order by ixOrder   

-- only Orders where 'Both' Sales are the Largest Market   -- 9 Orders
select DISTINCT ixOrder 
from ASC_17450_AprilOrderMarketSummaryTotals 
where   [TE Sales] > [BSales]
    and [TE Sales] > [SR Sales]
    and [TE Sales] > [TBSales]
    and [TE Sales] > [PC Sales]
    and [TE Sales] > [R Sales]
    and [TE Sales] > [SM Sales] 
order by ixOrder 
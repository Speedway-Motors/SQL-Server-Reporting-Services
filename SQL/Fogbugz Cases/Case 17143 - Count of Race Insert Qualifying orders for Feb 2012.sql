-- Case 17143 - Count of Race Insert Qualifying orders for Feb 2012
Count of "Race" orders for Feb 2012
Select sum(mMerchandise) Sales
from tblOrder O
where   O.sOrderStatus = 'Shipped'  -- 7,984,242
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.ixOrder NOT LIKE '%-%'    
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '02/01/2012' and '02/29/2012'
    
    
    
    
-- RawMarketTotals     
Select O.ixOrder,O.ixCustomer,
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
into PJC_17143_RawMarketTotals 
-- DROP TABLE PJC_17143_RawMarketTotals 
from [SMI Reporting].dbo.tblOrder O    
    join [SMI Reporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where   O.sOrderStatus = 'Shipped'  -- 8,114,989
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '02/01/2012' and '02/29/2012'
    and O.ixOrder NOT LIKE '%-%'       
group by O.ixOrder,O.ixCustomer,PGC.ixMarket 
order by O.ixOrder,O.ixCustomer,PGC.ixMarket 
-- 61,087

select top 1 * from PJC_17143_RawMarketTotals
-- ixOrder	ixCustomer	2B Sales	B Sales	PC Sales	R Sales	SM Sales	SR Sales	TE Sales
--4095553	1366846	    0.00	    5.00	0.00	    0.00	0.00	    0.00	    0.00



-- Summing up markets $ at the Order Level
select ixOrder, -- 38012
    ixCustomer, 
    sum(TBSales) as 'TBSales',
    sum(BSales)  as 'BSales',
    sum(PCSales) as 'PC Sales',
    sum(RSales)  as 'R Sales',
    sum(SMSales) as 'SM Sales',
    sum(SRSales) as 'SR Sales',
    sum(TESales) as 'TE Sales'
into PJC_17143_OrderMarketSummaryTotals     
from PJC_17143_RawMarketTotals
group by ixOrder, ixCustomer
order by ixOrder    

-- checks     
select count(*) from PJC_17143_OrderMarketSummaryTotals                 -- 38012
select count(distinct ixOrder) from PJC_17143_OrderMarketSummaryTotals  -- 38012
-- total Dollars =  $8,091,112 v

select * from PJC_17143_OrderMarketSummaryTotals
     
     
-- only Orders where Race Sales are the Largest Market   -- 13,593 Orders
select ixOrder, ixCustomer
from PJC_17143_OrderMarketSummaryTotals
where   [R Sales] > [TBSales]
   -- and [R Sales] > [BSales]
    and [R Sales] > [PC Sales]
    and [R Sales] > [SM Sales]
    and [R Sales] > [SR Sales]
    and [R Sales] > [TE Sales] 
order by ixCustomer    


-- only Orders where Race Sales are the Largest Market   -- 10,944 distinct Customers
select distinct ixCustomer
into PJC_17143_RaceCustomersNoGeoFilter
from PJC_17143_OrderMarketSummaryTotals -- 10,944
where   [R Sales] > [TBSales]
   -- and [R Sales] > [BSales] disregard 'BOTH' market
    and [R Sales] > [PC Sales]
    and [R Sales] > [SM Sales]
    and [R Sales] > [SR Sales]
    and [R Sales] > [TE Sales]  


-- imported all zips withing 500 mile radius of SMI (zip 68528)
-- PJC_17143_Geo_Zips500MileRadius
select count(*) from PJC_17143_Geo_Zips500MileRadius                    -- 5864
select count(distinct ixZipCode) from PJC_17143_Geo_Zips500MileRadius   -- 5864


select count(distinct ixCustomer) -- 2,429 Customers with a Race Dominant Order during Feb 2012 that live in the Geo
from PJC_17143_RaceCustomersNoGeoFilter
where ixCustomer in (select distinct C.ixCustomer
                     from [SMI Reporting].dbo.tblCustomer C 
                        join PJC_17143_Geo_Zips500MileRadius GEO on C.sMailToZip = GEO.ixZipCode)
                     where sMailToZip in (selec


                             
select * from [SMI Reporting].dbo.tblMarket


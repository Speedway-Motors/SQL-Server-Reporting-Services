-- vwOrderAllHistory
-- vwListPullStartingPool
-- vwOrderLineAllHistory



/* TEST 1
    Recency = 72M
    Frequency 1+
    Monetary > 0
    Market = Street
*/    
select SP.ixCustomer,PGC.ixMarket, -- 10 mins returns 270k rows
    count(distinct O.ixOrder) 'Freq', 
    SUM(OL.mExtendedPrice) 'Monetary'
from vwListPullStartingPool SP
    join vwOrderAllHistory O on SP.ixCustomer = O.ixCustomer
    join vwOrderLineAllHistory OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
    --join tblMarket M on M.ixMarket = PGC.ixMarket
where O.dtShippedDate >= '01/01/2008' -- DATEADD(MM, -@Recency, getdate()) -- RECENCY
   and OL.flgLineStatus = 'Shipped'
   and OL.flgKitComponent = 0 
   and O.sOrderType <> 'Internal'
   and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket = 'SR' -- @Market -- MARKET
group by SP.ixCustomer,PGC.ixMarket
having count(distinct O.ixOrder) >= 1 -- @Frequency -- FREQUENCY
and SUM(OL.mExtendedPrice) > 0 -- @Monetary -- MONETARY


/* TEST 2
    Recency = 12M
    Frequency 5+
    Monetary > 500
    Market = BothRaceStreet
*/    
select SP.ixCustomer,PGC.ixMarket, -- 10 mins returns 270k rows
    count(distinct O.ixOrder) 'Freq', 
    SUM(OL.mExtendedPrice) 'Monetary'
from vwListPullStartingPool SP
    join vwOrderAllHistory O on SP.ixCustomer = O.ixCustomer
    join vwOrderLineAllHistory OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
    --join tblMarket M on M.ixMarket = PGC.ixMarket
where O.dtShippedDate >= '02/07/2011' -- DATEADD(MM, -@Recency, getdate()) -- RECENCY
   and OL.flgLineStatus = 'Shipped'
   and OL.flgKitComponent = 0 
   and O.sOrderType <> 'Internal'
   and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket = 'B' -- @Market -- MARKET
group by SP.ixCustomer,PGC.ixMarket
having count(distinct O.ixOrder) >= 5 -- @Frequency -- FREQUENCY
and SUM(OL.mExtendedPrice) > 500 -- @Monetary -- MONETARY


select * from tblMarket


select PGC.ixMarket, M.sDescription, count(SKU.ixSKU) SKUCount
from tblPGC PGC
    join tblSKU SKU on SKU.ixPGC = PGC.ixPGC
    join tblMarket M on PGC.ixMarket = M.ixMarket
where SKU.flgActive = 1  
group by PGC.ixMarket , M.sDescription 
/*
ixMarket	Description	    SKUCount
2B	        TBucket	        1984
B	        BothRaceStreet	10385
PC	        PedalCar	    1646
R	        Race	        26434
SC	        SportCompact	101
SM	        SprintMidget	6051
SR	        StreetRod	    21171
TE	        Tools&Equip	    113
*/
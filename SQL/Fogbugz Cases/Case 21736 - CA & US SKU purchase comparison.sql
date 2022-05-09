-- Case 21736 - CA & US SKU purchase comparison 

select COUNT(distinct ixOrder) -- 31,427 orders
from tblOrder O
where     O.sOrderStatus = 'Shipped'
    and O.ixOrder not like '%-%'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.ixShippedDate between 16834 and 16858 -- 2/1/2014 and 2/25/2014
    and (O.sShipToCountry is NULL
        OR O.sShipToCountry in ('US','USA'))    

select COUNT(distinct ixOrder) -- 207 orders
from tblOrder O
where     O.sOrderStatus = 'Shipped'
    and O.ixOrder not like '%-%'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.ixShippedDate between 16834 and 16858 -- 2/1/2014 and 2/25/2014
    and (O.sShipToCountry is NULL
        OR O.sShipToCountry in ('CANADA'))    



select TOP 10
O.sShipToCountry,
count(DISTINCT O.ixOrder) OrderCount
from tblOrder O
where O.sOrderStatus = 'Shipped'
    and O.ixOrder not like '%-%'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.ixShippedDate between 16834 and 16858 -- 2/1/2014 and 2/25/2014
group by  O.sShipToCountry
order by count(*) desc
/*
Order   sShipTo
Count	Country
31427   US
207	    CANADA
84	    AUSTRALIA
19	    NEW ZEALAND
18	    FRANCE
17	    SWEDEN
15	    UNITED KINGDOM
11	    GERMANY
11	    JAPAN
7	    NORWAY
*/




-- drop table PJC_21736_US_TopSKUs
select top 20 
    SKU.ixSKU, COUNT(distinct OL.ixOrder) USOrdCount
    --SKU.sDescription, SKU.sSEMACategory
    --, SUM(OL.iQuantity) Qty
into PJC_21736_US_TopSKUs
from [SMI Reporting].dbo.tblOrderLine OL --on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join [SMI Reporting].dbo.tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixShippedDate between 16834 and 16858 -- 2/1/2014 and 2/25/2014
    and OL.flgLineStatus = 'Shipped'
    and OL.mExtendedPrice > 0    
    and OL.ixOrder not like '%-%'
    and SKU.mPriceLevel1 > 0
    and SKU.flgIntangible = 0
    and SKU.flgDeletedFromSOP = 0
--and OL.ixSKU = '8352300542'    
    and (O.sShipToCountry is NULL
        OR O.sShipToCountry in ('US','USA'))
group by SKU.ixSKU, SKU.sDescription, SKU.sSEMACategory   
order by USOrdCount desc

-- drop table PJC_21736_CA_TopSKUs
select top 20 
    SKU.ixSKU, COUNT(distinct OL.ixOrder) CAOrdCount
    --SKU.sDescription, SKU.sSEMACategory
    --, SUM(OL.iQuantity) Qty
into PJC_21736_CA_TopSKUs
from [SMI Reporting].dbo.tblOrderLine OL --on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join [SMI Reporting].dbo.tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixShippedDate between 16834 and 16858 -- 2/1/2014 and 2/25/2014
    and OL.flgLineStatus = 'Shipped'
    and OL.mExtendedPrice > 0    
    and OL.ixOrder not like '%-%'
    and SKU.mPriceLevel1 > 0
    and SKU.flgIntangible = 0
    and SKU.flgDeletedFromSOP = 0
--and OL.ixSKU = '8352300542'    
    and (O.sShipToCountry is NULL
        OR O.sShipToCountry = 'CANADA')
group by SKU.ixSKU, SKU.sDescription, SKU.sSEMACategory   
order by CAOrdCount desc

select * from PJC_21736_CA_TopSKUs

SELECT SKU.ixSKU, SKU.sDescription, SKU.sSEMACategory, US.USOrdCount, CA.CAOrdCount
from [SMI Reporting].dbo.tblSKU SKU
left join PJC_21736_US_TopSKUs US on US.ixSKU = SKU.ixSKU
left join PJC_21736_CA_TopSKUs CA on CA.ixSKU = SKU.ixSKU
where SKU.ixSKU in (select ixSKU from PJC_21736_US_TopSKUs)
   OR SKU.ixSKU in (select ixSKU from PJC_21736_CA_TopSKUs)
ORDER BY  US.USOrdCount DESC, CA.CAOrdCount DESC  
/*
USOrdCount	CAOrdCount	ixSKU	sDescription	sSEMACategory
222	4	91064027	SPEEDWAY 20 CIRCUIT KIT	Body
196	NULL	1750757	STEER SHAFT HEIM 3/4"RH	Suspension
158	NULL	1756047-RH	STEEL JAM NUTS 3/4" 6/PACK	Fasteners and Hardware
156	NULL	91064017	12 CIRCUIT MINIFUSE HARNESS	Body
154	NULL	91031831	BRK ADPT 1/8 NPT x3/8-24IF	Brake
152	3	91031345	2 psi-PURPLE RESIDUAL VALVE	Brake
144	NULL	1756046-RH	STEEL JAM NUTS 5/8" 6/PACK	Fasteners and Hardware
139	NULL	7209314	BOLT-THRU CUSHION KIT/PR	Engine
137	3	91031315-3/16	S/S SINGLE LINE CLMP (12	Brake
131	NULL	91064500	BATTERY DISCONNECT SWITCH	Electrical, Lighting and Body
126	NULL	91007102	FLAT 1/4 TURN SPRINGS 10/BG	Fasteners and Hardware
125	NULL	91031347	10psi-PURPLE RESIDUAL VALVE	Brake
122	NULL	91032234	U-JOINT, 3/4" WELD-ON	Steering
120	NULL	91666006	BATTERY BOX-WELD ON	Electrical, Charging and Starting
117	NULL	91012342	HEI DISTRIBUTOR FOR CHEVY	Ignition
112	3	91064052	IGNITION SWITCH -KEY TYPE	Electrical, Lighting and Body
107	NULL	69821504	REMOTE BATTERY TERMINALS	Electrical, Charging and Starting
105	NULL	91004-BLK	POP RIVETS 3/16" LG HEAD	Fasteners and Hardware
102	NULL	91632504	TIE ROD KIT,11/16",RAW	Steering
101	NULL	91031353	PURPLE PROPORTIONING VALVE	Brake
NULL	47	91088CANADA	CANADA CATALOG COMBO	Apparel and Gifts
NULL	3	91104015	28-34 RAD SUPPORT ROD BRKTS	Cooling
NULL	3	91134001	32-36 RAD SUPPORT RODS SS	Cooling
NULL	3	91137033	MINI-ZEPHYR'39(LED)TAILLITE	Electrical, Lighting and Body
NULL	3	9163220	SPEEDWAY VEGA BOX COMBO	Steering
NULL	3	75181A13520	TAILLIGHT MT GSKT 38-39	Electrical, Lighting and Body
NULL	3	1756046-LH	STEEL JAM NUTS 5/8" 6/PACK	Fasteners and Hardware
NULL	3	41010112	HORN BUTTON RETAINER	Electrical, Lighting and Body
NULL	3	49180FU	FLOOR MNT E-BRAKE CABLES	Brake
NULL	2	5509868	SMALL TRI BAR WING NUT	Emission Control
NULL	2	6178511	S.S. AN-3 TUBE NUT	Brake
NULL	2	9196887	8"/ 9"FORD PINION NUT	Driveline and Axles
NULL	2	91355005	PROBLEM SOLVER PEDAL-CHROME	Air and Fuel Delivery
NULL	2	91132103	32 V8-HDLGHT BAR EMBLEM	Body
NULL	2	91032298	DBL-D U-JNT x DBL-D (3/4	Steering
NULL	2	91045477	SLIDE ARM WASHER SET	Fasteners and Hardware
*/   
   
   
   
SELECT SUM(iQuantity) 
from [SMI Reporting].dbo.tblOrderLine
where ixSKU = '91064027'
and  ixShippedDate between 16834 and 16858   

-- drop table PJC_21736_US_TopSEMA
select top 5 
    SKU.sSEMACategory, COUNT(distinct OL.ixOrder) USOrdCount
    --SKU.sDescription, SKU.sSEMACategory
    --, SUM(OL.iQuantity) Qty
--into PJC_21736_US_TopSEMA
from [SMI Reporting].dbo.tblOrderLine OL --on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join [SMI Reporting].dbo.tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixShippedDate between 16834 and 16858 -- 2/1/2014 and 2/25/2014
    and OL.flgLineStatus = 'Shipped'
    and OL.mExtendedPrice > 0    
    and OL.ixOrder not like '%-%'
    and SKU.mPriceLevel1 > 0
    and SKU.flgIntangible = 0
    and SKU.flgDeletedFromSOP = 0
--and OL.ixSKU = '8352300542'    
    and (O.sShipToCountry is NULL
        OR O.sShipToCountry in ('US','USA'))
group by SKU.ixSKU, SKU.sDescription, SKU.sSEMACategory   
order by USOrdCount desc

-- drop table PJC_21736_CA_TopSEMA
select top 5 
    SKU.sSEMACategory, COUNT(distinct OL.ixOrder) CAOrdCount
    --SKU.sDescription, SKU.sSEMACategory
    --, SUM(OL.iQuantity) Qty
--into PJC_21736_CA_TopSEMA
from [SMI Reporting].dbo.tblOrderLine OL --on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join [SMI Reporting].dbo.tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixShippedDate between 16834 and 16858 -- 2/1/2014 and 2/25/2014
    and OL.flgLineStatus = 'Shipped'
    and OL.mExtendedPrice > 0    
    and OL.ixOrder not like '%-%'
    and SKU.mPriceLevel1 > 0
    and SKU.flgIntangible = 0
    and SKU.flgDeletedFromSOP = 0
--and OL.ixSKU = '8352300542'    
    and (O.sShipToCountry is NULL
        OR O.sShipToCountry = 'CANADA')
group by SKU.ixSKU, SKU.sDescription, SKU.sSEMACategory   
order by CAOrdCount desc   


SELECT SKU.sSEMACategory, US.USOrdCount, CA.CAOrdCount
from [SMI Reporting].dbo.tblSKU SKU
left join PJC_21736_US_TopSEMA US on US.sSEMACategory = SKU.sSEMACategory
left join PJC_21736_CA_TopSEMA CA on CA.sSEMACategory = SKU.sSEMACategory
where SKU.sSEMACategory in (select sSEMACategory from PJC_21736_US_TopSEMA)
   OR SKU.sSEMACategory in (select sSEMACategory from PJC_21736_CA_TopSEMA)
   
   
SELECT COUNT(DISTINCT sSEMACategory) FROM [SMI Reporting].dbo.tblSKU   
-- DSOTHER-14 add populate and test field ixPrimaryShipLocation on tblOrder


/***********************
 ********  SMI  ********
 **********************/
select count(*) from [SMI Reporting].dbo.tblOrder 
where dtOrderDate >= '12/01/2013' -- 18,875


select ixPrimaryShipLocation
   ,count(ixOrder) OrdCount
from [SMI Reporting].dbo.tblOrder
where dtOrderDate >= '12/01/2013'
group by ixPrimaryShipLocation
/*
ixPrimaryShipLocation	OrdCount
NULL	                110
99	                    18,871
*/

-- still not updating
select ixOrder, sOrderStatus, ixPrimaryShipLocation, dtOrderDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from [SMI Reporting].dbo.tblOrder
where dtOrderDate < '12/05/2013' 
    and ixPrimaryShipLocation is NOT NULL
and sOrderStatus = 'Pick Ticket'    
order by ixTimeLastSOPUpdate desc    -- 46568 

    
select ixOrder from tblOrder
where dtOrderDate >= '12/01/2013' 
and ixPrimaryShipLocation is NULL  
and sOrderStatus = 'Pick Ticket'

select distinct sOrderStatus 
from tblOrder
/*
Backordered
Cancelled
Open
Pick Ticket
Shipped
*/

select distinct ixPrimaryShipLocation  
from [SMI Reporting].dbo.tblOrder
/*
ixPrimaryShipLocation
NULL
99
*/

-- NULL ixPrimaryShipLocation
select ixOrder, sOrderStatus, dtDateLastSOPUpdate
from [SMI Reporting].dbo.tblOrder
where dtOrderDate >= '12/01/2013' 
    and ixPrimaryShipLocation is NULL
    
-- Pick Tickets    
select ixOrder, sOrderStatus, dtDateLastSOPUpdate
from [SMI Reporting].dbo.tblOrder
where dtOrderDate >= '12/01/2013' 
and sOrderStatus = 'Pick Ticket'
    and ixPrimaryShipLocation is NULL
        


/**********************
 ******** AFCO ********
 **********************/
select count(*) from [AFCOReporting].dbo.tblOrder 
where dtOrderDate >= '12/05/2013' -- 553
 
select ixPrimaryShipLocation
   ,count(ixOrder) OrdCount
from [AFCOReporting].dbo.tblOrder
where dtOrderDate >= '01/01/2013'
   -- and ixCustomer NOT in ('26103','26103')
group by ixPrimaryShipLocation


select ixOrder, sOrderStatus, dtDateLastSOPUpdate
from [AFCOReporting].dbo.tblOrder
where dtOrderDate >= '01/01/2013' 
    and ixCustomer in ('26101','26103')
    and ixPrimaryShipLocation is NULL
    

select distinct ixPrimaryShipLocation  
from [AFCOReporting].dbo.tblOrder
where dtOrderDate >= '01/01/2013' 
/*
ixPrimaryShipLocation
NULL
68
99
*/



select count(*) from [AFCOReporting].dbo.tblOrder 
where dtShippedDate >= '01/01/2013' --39,888 YTD
and dtDateLastSOPUpdate = '12/17/2013'

select count(*) from [AFCOReporting].dbo.tblOrder 
where dtOrderDate between '01/01/2012' and '12/31/2012' -- 53,062
and sOrderStatus = 'Shipped'


SELECT YEAR(dtOrderDate) 'OrderYr', COUNT(ixOrder) 'OrdCount'
 from [AFCOReporting].dbo.tblOrder 
 where sOrderStatus = 'Shipped'
 group by YEAR(dtOrderDate)
 order by YEAR(dtOrderDate)
 
 
 
/*
ACCT  OrdQty
26103 16,513
26101    276
      ======
      16,789 Afco to SMI internal orders
      
      
16,789 internal orders
22,980 SOP order Count
======
39,769

39,769v DW order count
      


select top 10 * from tblSKU
order by newid()

select ixSKU, CONVERT(VARCHAR, dtDateLastSOPUpdate, 10)  AS 'dtSOPUpdate'
, ixTimeLastSOPUpdate, sDescription, sWebDescription
from tblSKU where ixSKU = '91075-LTBRN'

--
ixSKU	dtDateLastSOPUpdate	ixTimeLastSOPUpdate, sWebDescription

-- 
ixSKU	Date	ixTimeLastSOPUpdate	sWebDescription
91075-LTBRN	12-17-13	55778	Light Brown Vinyl Headlight Covers

ixSKU	    Date	    ixTimeLastSOPUpdate	sDescription    sWebDescription
91075-LTBRN	12-17-13	55778	            Light Brown Vinyl Headlight Covers
91075-LTBRN	12-18-13	34608	            Light Brown Vinyl Headlight Covers

ixSKU	    dtSOPUpdate	ixTimeLastSOPUpdate	sDescription	        sorrysWebDescription
91075-LTBRN	12-18-13	34608	            HEADLIGHT COVERS. 7in	Light Brown Vinyl Headlight Covers
91075-LTBRN	12-18-13	38790	            HEADLIGHT COVERS. 7in	Light Brown Vinyl Headlight Covers
91075-LTBRN	12-18-13	43292	            HEADLIGHT COVERS. 7in	Light Brown Vinyl Headlight Cover
/*
select ixSKU, CONVERT(VARCHAR, dtDateLastSOPUpdate, 10)  AS 'dtSOPUpdate'
, ixTimeLastSOPUpdate, sDescription, sWebDescription
from tblSKU where ixSKU = '9134060'

ixSKU	dtSOPUpdate	ixTimeLastSOPUpdate	sDescription	            sWebDescription
9134060	11-27-13	44727	            BRONZE BOY WITH TOY RACER	Garage Sale - Bronze Boy
9134060	11-27-13	44727	            BRONZE BOY WITH TOY RACER	Garage Sale - Bronze Boy
9134060	11-27-13	44727	            BRONZE BOY WITH TOY RACER	Garage Sale - Bronze Boy
9134060	11-27-13	44727	            BRONZE BOY WITH TOY RACER	Garage Sale - Bronze Boy @2:09PM
9134060	12-18-13	51076	BRONZE BOY WITH TOY RACER	Garage Sale - Bronze Boy Statue
9134060	12-18-13	51909	BRONZE BOY WITH TOY RACER	Garage Sale - Bronze Boy Fig.

-- is the SKU being tested in the WEB.13 catalog?
select ixSKU from tblCatalogDetail where ixCatalog = 'WEB.13' and ixSKU = '9134060'
-- YES
*/

select * from tblSKU where ixSKU = '9134060'

51076

select * from tblTime where ixTime = 53417 ... 14:11:16  
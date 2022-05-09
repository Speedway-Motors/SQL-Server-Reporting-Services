/* Case 15267 - Update tblDeliveryAreaSurcharge with latest DAS zips from UPS

Current list is always available online at UPS.
http://www.ups.com/media/en/area_surcharge_zips_us.xls
*/  

select count(*) from  PJC_Latest_DAS_Zips -- 23713

select count(*) from tblDeliveryAreaSurcharge -- 23715

select * from tblDeliveryAreaSurcharge
where ixZipCode NOT in (select ixZipCode from PJC_Latest_DAS_Zips) -- 2 zips found
/*
23714	2011-06-17 12:01:23.457
40165	2011-06-17 12:01:23.457
*/

select * from PJC_Latest_DAS_Zips
where ixZipCode NOT in (select ixZipCode from tblDeliveryAreaSurcharge) -- 2 zips found

select * from tblOrder where sShipToZip in ('23714','40165')
and dtOrderDate > '01/01/2012'

-- since there were only 2 zips that need to be removed and 0 to be added
-- deleting them manually and updating the dtLastUpdate field with todays date.
DELETE 
from tblDeliveryAreaSurcharge 
where ixZipCode in ('23714','40165')

update tblDeliveryAreaSurcharge
set dtLastUpdate = getDate()

/*
ixShipMethod sDescription
2	UPS Ground
3	UPS 2 Day (Blue)
4	UPS 1 Day (Red)
5	UPS 3 Day
10	UPS Worldwide Expedited
11	UPS Worldwide Saver
12	UPS Standard
18	UPS SurePost
32	UPS 2 Day Economy    
*/

-- Count of UPS orders in last 12 Months
select count(*) -- 334,052
from tblOrder O
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '08/17/2011'
    and O.iShipMethod in (2,3,4,5,10,11,12,18,32)


-- Count of UPS orders in last 12 Months THAT WENT TO DAS ZIPS
select count(*) -- 150,251
from tblOrder O
    join tblDeliveryAreaSurcharge DAS on O.sShipToZip = DAS.ixZipCode
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '08/17/2011'
    and O.iShipMethod in (2,3,4,5,10,11,12,18,32)
    
    
-- % of UPS orders delivered to DAS zips in last 12 months = 44.98% (150,251 UPS DAS orders / 334,052 UPS ALL orders)    





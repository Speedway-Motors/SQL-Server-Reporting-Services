-- Case 25381 - Update tblDeliveryAreaSurcharge with latest values from UPS

/* 
CURRENT LIST IS AVAILABLE AT
http://www.ups.com/content/us/en/shipping/time/service/eas_download.html?srch_pos=1&srch_phr=Delivery+Area+Surcharge&WT.svl=SRCH
*/

select count(*), count(distinct ixZipCode)
from [SMI Reporting].dbo.tblDeliveryAreaSurcharge 
-- 23713	23713

select count(*), count(distinct ixZipCode)
from [SMITemp].dbo.PJC_25381_DAS_Zips_from_UPS_06232015 
--23715	23715

-- backup data
select *
into [SMIArchive].dbo.BU_tblDeliveryAreaSurcharge_04252015
from [SMI Reporting].dbo.tblDeliveryAreaSurcharge 


/*** NEW zips to add to tblDeliveryAreaSurcharge ***/
    select * FROM [SMITemp].dbo.PJC_25381_DAS_Zips_from_UPS_06232015 
    where ixZipCode NOT IN (SELECT ixZipCode From [SMI Reporting].dbo.tblDeliveryAreaSurcharge )
    24157
    32335
    34441
    71966
    73960

    INSERT INTO [SMI Reporting].dbo.tblDeliveryAreaSurcharge (ixZipCode, dtLastManualUpdate)
    SELECT '24157', NULL
    UNION ALL
    SELECT '32335', NULL
    UNION ALL
    SELECT '34441', NULL
    UNION ALL
    SELECT '71966', NULL
    UNION ALL
    SELECT '73960', NULL


/*** ZIPS to remove from tblDeliveryAreaSurcharge ***/
    select * FROM [SMI Reporting].dbo.tblDeliveryAreaSurcharge 
    where ixZipCode NOT IN (SELECT ixZipCode From [SMITemp].dbo.PJC_25381_DAS_Zips_from_UPS_06232015 )
    46075
    99540
    20041




    -- DELETE
    FROM [SMI Reporting].dbo.tblDeliveryAreaSurcharge 
    WHERE ixZipCode in ('46075','99540','20041')


-- update dtLastManualUpdate
UPDATE [SMI Reporting].dbo.tblDeliveryAreaSurcharge 
SET dtLastManualUpdate = '06/24/2015'




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
select count(*) -- 378,789
from tblOrder O
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '06/24/2014'
    and O.iShipMethod in (2,3,4,5,10,11,12,18,32)


-- Count of UPS orders in last 12 Months THAT WENT TO DAS ZIPS
select count(*) -- 169,928
from tblOrder O
    join tblDeliveryAreaSurcharge DAS on O.sShipToZip = DAS.ixZipCode
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '06/24/2014'
    and O.iShipMethod in (2,3,4,5,10,11,12,18,32)
    
    
-- % of UPS orders delivered to DAS zips in last 12 months = 44.86% (169,928 UPS DAS orders / 378,789 UPS ALL orders)    

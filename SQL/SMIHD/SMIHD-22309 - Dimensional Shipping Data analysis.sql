-- SMIHD-22309 - Dimensional Shipping Data analysis

-- Al will provide me a .csv with Order#, Tracking#, Pkg Volume, Tot SKU Volume

/* Questions
Richard:
    Just Fed-ex and UPS ship methods for now
    all BUs for now

    hold off on any shipping costs for now (tblPackage mPublishedFreight vs mShippingCost)
*/
/* No accurate actual/current cost in DW

-- examples from Ron:
select top 50 * from tblUspsPackageDetail order by dtImportDate desc -- 6-15-2021 latest import
select top 50 * from tblSpeedeePackageDetail order by dtDeliveryDate desc -- 1-16-2021 latest delivery date 
*/
SELECT * FROM [SMITemp].dbo.PJC_SMIHD22309_JulyPackages -- drop table [SMITemp].dbo.PJC_SMIHD22309_JulyPackages

select count(*) from [SMITemp].dbo.PJC_SMIHD22309_JulyPackages -- 168,067
select * from [SMITemp].dbo.PJC_SMIHD22309_JulyPackages where CartonVol = 0 -- 12,814

-- Analysis after importing SOP file Al provides
SELECT 
    O.ixOrder 'Order',
    O.iShipMethod 'ShipMethod', 
    SM.ixCarrier 'Carrier',
    O.ixPrimaryShipLocation 'ShipLoc', 
    BU.sBusinessUnit 'BusUnit',
    -- (P.mPublishedFreight or P.mShippingCost) -- will possibly add later
    P.sTrackingNumber 'TrackingNumber',
    SOP.CartonVol 'CartonVol', 
    SOP.TotSKUVol 'TotSKUVol',
   -- (SOP.TotSKUVol / SOP.CartonVol) 'PkgVsSKUVol%',   -- % of package vol vs totSKU volume
    P.ixPacker,
    P.ixVerifier,
    P.ixShipper,
    P.ixSuggestedBoxSKU,
    P.ixBoxSKU,
    (CASE when P.ixSuggestedBoxSKU=P.ixBoxSKU then 'Y' 
        else 'N'
        end)'SugBoxUsed'
 --   D.dtDate 'ShippedDate'
--INTO #JULYDetails -- DROP TABLE #JULYDetails
FROM [SMITemp].dbo.PJC_SMIHD22309_JulyPackages SOP
    LEFT JOIN tblOrder O on O.ixOrder = SOP.ixOrder
  --  LEFT JOIN tblOrderLine OL on OL.ixOrder = O.ixOrder
    LEFT JOIN tblBusinessUnit BU on BU.ixBusinessUnit = O.ixBusinessUnit
    LEFT JOIN tblPackage P on P.ixOrder = SOP.ixOrder
                        and P.sTrackingNumber = SOP.sTrackingNumber
   -- LEFT JOIN tblDate D on P.ixShipDate = D.ixDate                         
    LEFT JOIN tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
WHERE O.iShipMethod in (2,3,4,5,10,11,12,13,14,15,18,19,32) 
    and P.flgCanceled = 0
    and P.flgReplaced = 0 -- 125,249
    -- and SOP.CartonVol <> 0
    -- and O.ixBusinessUnit NOT IN   -- may exclude some BUs later
order by SOP.CartonVol

select * from tblShipMethod

SELECT * FROM tblShipMethod
where ixCarrier in ('UPS','FedEx')
/*
Shp
Mthd Carrier sDescription
2	UPS	    UPS Ground
3	UPS	    UPS 2 Day (Blue)
4	UPS	    UPS 1 Day (Red)
5	UPS	    UPS 3 Day
10	UPS	    UPS Worldwide Expedited
11	UPS	    UPS Worldwide Saver
12	UPS	    UPS Standard
13	FedEx	FedEx Ground
14	FedEx	FedEx Home Delivery
15	FedEx	FedEx SmartPost
18	UPS	    UPS SurePost
19	UPS	    Canada Post
32	UPS	    UPS 2 Day Economy

-- (2,3,4,5,10,11,12,13,14,15,18,19,32) 

SELECT * FROM tblBusinessUnit
*/

select * from tblPackage
where sTrackingNumber like '%~%'



-- SMIHD-22364


boxes L >= 48
or box W >= 30

-- Active boxes that are AH due to size
select ixSKU, sDescription, iLength, iWidth,  iHeight, flgActive, flgAdditionalHandling
into #ActiveAHBoxes
from tblSKU
where flgDeletedFromSOP = 0
    and flgActive = 1
    and (iLength >= 48
         or
         iWidth >= 30)
    and ixSKU like 'BOX-%'


-- Orders that had at least 1 AH (add. handling) package
SELECT distinct P.ixOrder, P.sTrackingNumber
into #AHPackages -- DROP TABLE #AHPackages
from tblPackage P
    left join tblOrder O on P.ixOrder = P.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                            and P.sTrackingNumber = OL.sTrackingNumber
    left join #ActiveAHBoxes AHB on AHB.ixSKU = P.ixBoxSKU
where P.ixShipDate between 19541 and 19571 -- 	07/01/2021   	07/31/2021
    and O.sOrderStatus = 'Shipped' -- 18,190 packages shipped
    and AHB.ixSKU is NOT NULL -- 88,405 non AH pkgs shipped    1,301 AH   (1.45% AH)   407 had no 


-- orders that don't contain SKUs meeting AH requirements
SELECT AHP.sTrackingNumber, 
    max(S.iLength) 'MaxLength',
    max(S.iWidth) 'MaxWidth',
    max(S.dWeight) 'MaxWeight',
    max(S.flgAdditionalHandling) 'AHflag'
--into #OrdersWithNo_AH_SKUs -- DROP TABLE #OrdersWithNo_AH_SKUs
from #AHPackages AHP
    left join tblOrder O on AHP.ixOrder = O.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
GROUP BY AHP.sTrackingNumber
HAVING max(S.iLength) < 47 -- using 1" less than the max so that it can FIT IN THE BOX
    AND max(S.iWidth) < 29 -- using 1" less than the max so that it can FIT IN THE BOX
    AND max(S.dWeight) < 70 
ORDER BY max(S.dWeight)         -- 83 out of the 748 AH orders (11%) do not contain a SKU with AH Length, Width, or Weight


    -- innactive boxes
    /*
BOX-110
BOX-115
BOX-122
BOX-148
BOX-158
BOX-160
BOX-183
BOX-187
BOX-198
BOX-199
*/
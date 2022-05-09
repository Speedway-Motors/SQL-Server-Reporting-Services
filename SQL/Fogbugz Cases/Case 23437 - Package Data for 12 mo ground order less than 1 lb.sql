-- Case 23437 - Package Data for 12 mo ground order less than 1 lb

/* OL.ixOrder,
   O.iShipMethod,
   OL.ixSKU,
   S.sDescription,
   OL.iQuantity,
    P.sTrackingNumber,
    P.dActualWeight,
    P.dBillingWeight    
ShipRevenue, 
ToT wt of OL
Delta (P.dActualWeight - ToT wt of OL)
iLength iWidth iHeight
CALC - round TOT SKU wt to Oz
CALC - round pkg Wt to Oz

-- conditions
O.dtShippedDate > = '07/23/2013' -- last 12 MO
O.sShipToCountry = 'US'
O.iShipMethod in (2,6,7,9,13,14,15,18)
only one package -- Sub-query SP
only one OL SKU (tangible & non-kit compenents ) -- Sub-query SS
wt of pkg < 1.1 lbs
wt of pkg > 0
ToT wt of OL > 0 
ToT wt of OL < 1.1 lbs    
*/

-- ORDER LINE LEVEL INFO
    -- DROP TABLE [SMITemp].dbo.PJC_23437_OL_level_data
SELECT O.ixOrder,              -- 20,973
    O.iShipMethod,
    OL.ixSKU,
    S.sDescription 'SKUDescription',
    S.iLength 'SKULength',
    S.iWidth 'SKUWidth',
    S.iHeight 'SKUHeight',
    S.dWeight as 'SKUdWeight',
    OL.iQuantity 'OL_Qty' ,    
    ((OL.iQuantity * S.dWeight)) as 'OLExtendedWeight',
    P.dActualWeight 'PKGdActualWeight',
   --(ABS(P.dActualWeight - (SUM((OL.iQuantity * S.dWeight))))) AS 'DeltaPkgWtVsOLExtWt',  -- <- HAS TO BE CALCULATED in a query from this result set
    P.sTrackingNumber,
    P.dBillingWeight,
    -- P.mShippingCost 'PKGmShippingCost',    <-- not populated yet
    O.mShipping 'OrdermShipping'  
into [SMITemp].dbo.PJC_23437_OL_level_data          
FROM tblOrder O
    left join tblOrderLine OL on OL.ixOrder = O.ixOrder
    left join tblPackage P on P.ixOrder = O.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
    join (-- Orders with 1 package 
          select ixOrder, COUNT(sTrackingNumber) PkgCount  -- 364,800
          from tblPackage
          where ixShipDate between 16643 and 17007
            and ixShipDate is NOT NULL           
            and (flgCanceled is NULL  OR flgCanceled = 0)
          group by ixOrder
          having COUNT(distinct sTrackingNumber) = 1  
          ) SP on SP.ixOrder = O.ixOrder
    join (-- orders with 1 tangible, non-kit component SKU      -- 145,092 
            select OL.ixOrder, COUNT(OL.ixSKU) SKUCount    
            from tblOrderLine OL
                left join tblSKU S on OL.ixSKU = S.ixSKU
            where OL.ixShippedDate between 16643 and 17007 
              and S.flgIntangible = 0                      
              and OL.flgKitComponent = 0                   
              and OL.ixSKU <> '999'                        
              and (OL.iQuantity * S.dWeight) > 0           
              and (OL.iQuantity * S.dWeight) <= 1.1
              and S.flgDeletedFromSOP = 0
            group by  OL.ixOrder   
            having COUNT(OL.ixSKU) = 1                    
        ) SS on SS.ixOrder = O.ixOrder         
WHERE O.dtShippedDate between '07/25/2013' and '07/24/2014'
    and O.iShipMethod in (2,6,7,9,13,14,15,18)
    and O.sShipToCountry = 'US'
    and S.flgIntangible = 0
    and S.flgDeletedFromSOP = 0
    --and OL.flgKitComponent = 0   -- include KIT component SKUs
    and S.flgIsKit = 0             -- exclude KIT SKUs
    and OL.ixShippedDate >= 16643
    and OL.ixSKU <> '999'    
    and P.dActualWeight <= 1.1
    and P.dActualWeight > 0
    and P.ixShipDate is NOT NULL
    and O.mMerchandise > 0
    and (OL.iQuantity * S.dWeight) > 0           
    and (OL.iQuantity * S.dWeight) <= 1.1
    and (flgCanceled is NULL OR flgCanceled = 0)              
ORDER BY ixOrder -- (ABS(P.dActualWeight - (OL.iQuantity * S.dWeight))) desc




select * from tblSKU where dWeight is null
and flgDeletedFromSOP = 0

--  ORDER LEVEL SUMMARY from above data set
-- TO POPULATE THE SPREADSHEET
select ixOrder, sTrackingNumber, SUM(OLExtendedWeight) TotExtOLSKUWeight, PKGdActualWeight, dBillingWeight, OrdermShipping -- 20,048
from  [SMITemp].dbo.PJC_23437_OL_level_data
group by ixOrder, sTrackingNumber, PKGdActualWeight, dBillingWeight, OrdermShipping
order by ixOrder



select COUNT(*)  from [SMITemp].dbo.PJC_23437_OL_level_data -- 20,985
select COUNT(distinct ixOrder) from [SMITemp].dbo.PJC_23437_OL_level_data -- 20,042

select * from [SMITemp].dbo.PJC_23437_OL_level_data    
    
-- orders with 1 tangible, non-kit component SKU    
select OL.ixOrder, COUNT(OL.ixSKU)    
from tblOrderLine OL
    left join tblSKU S on OL.ixSKU = S.ixSKU
where OL.ixShippedDate >= 16643 -- 477,251
  and S.flgIntangible = 0       -- 477,569
  and OL.flgKitComponent = 0    -- 472,569
group by  OL.ixOrder   
having COUNT(OL.ixSKU) = 1      -- 171,106

/*
select * from tblShipMethod
where ixShipMethod in (2,6,7,9,13,14,15,18)


select * from tblShipMethod where sTransportMethod like '%Ground%'
and ixShipMethod NOT in (2,6,7,9,13,14,15,18)



select top 10 * from tblPackage where dtDateLastSOPUpdate = '07/01/2014'

*/

/* NULL weights */

/*
select ixOrder, COUNT(sTrackingNumber) PkgCount
          from tblPackage
          where ixShipDate >= 16643         -- 575,585
          group by ixOrder, dActualWeight
          having COUNT(sTrackingNumber) = 1 
          and 
          
          
select *
          from tblPackage
          where ixShipDate between 16643 and 17007 -- 5364
            and dActualWeight is NULL    
order by dtDateLastSOPUpdate


select P.*, O.iShipMethod
          from tblPackage P
            join tblOrder O on P.ixOrder = O.ixOrder
          where ixShipDate between 16643 and 17007 -- 922
            and dActualWeight is NULL    
            and O.iShipMethod in (2,6,7,9,13,14,15,18)
order by O.iShipMethod, ixShipDate



select * from tblPackage where ixOrder = '5999736'



select distinct sOrderStatus from tblOrder

Cancelled



SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) like '%CANCEL%') --IXSKU' )
ORDER BY name


SELECT * FROM syscolumns WHERE upper(name) like '%CANCEL%'

*/


select * from tblPackage
where ixOrder = '5000166'
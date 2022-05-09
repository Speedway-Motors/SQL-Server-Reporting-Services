-- SMIHD-10095 - Percentage of Ground Orders that arrive in 3 days or less
 /*
We need to know what percent of Expedited UPS Ground shipments are delivered within three days or less.
Please review sales from 1/1/18 to the most current date.
Please exclude any order that contains a drop ship item.
Please exclude any order with a ship-to address that is outside of the Contiguous United States.

 */
SELECT * from tblShipMethod
where ixCarrier = 'UPS'
AND sTransportMethod LIKE '%Ground%'

2	UPS Ground
12	UPS Standard
18	UPS SurePost

19	Canada Post
32	UPS 2 Day Economy

select iShipMethod, count(*)
from tblOrder
where dtShippedDate >= '01/01/2017'
and sOrderStatus = 'Shipped'
and iShipMethod in (2,12,18,19,32)
group by iShipMethod


Select *
from tblOrder O
where dtShippedDate between '01/01/2018' and '01/31/2018' -- >= '01/04/2018'
    and O.sOrderStatus = 'Shipped' 
    and O.sShipToCountry = 'US'
    and O.sShipToState NOT IN ('HI','AK')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.iShipMethod <> 1 --= 2                -- 42,193
    and O.dtLastPackageDeliveryLocal is NULL    -- 38,666 



Select O.ixOrder, O.ixShippedDate, O.dtGuaranteedDelivery, O.flgDeliveryPromiseMet,
    MAX(P.ixPackageDeliveredLocal) 'MaxDelivered',
    (MAX(P.ixPackageDeliveredLocal)- O.ixShippedDate) 'DaysDelivered'
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
where dtShippedDate between '01/01/2018' and '02/15/2018' -- >= '01/04/2018'
    and O.sOrderStatus = 'Shipped' 
    and O.sShipToCountry = 'US'
    and O.sShipToState NOT IN ('HI','AK')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.iShipMethod = 2                               -- 18,909                   26,928
    and O.dtLastPackageDeliveryLocal is NULL  
    --and P.ixPackageDeliveredLocal is NULL         -- 2,517  <-- NULL 86.7% of the time!?!   68.8% NULLs for APR 2017      8,409
    --AND flgGuaranteedDeliveryPromised = 1 -- is NOT NULL
    --AND O.dtGuaranteedDelivery IS not NULL
GROUP BY O.ixOrder, O.ixShippedDate , O.dtGuaranteedDelivery, O.flgDeliveryPromiseMet  
ORDER BY (MAX(P.ixPackageDeliveredLocal)- O.ixShippedDate)                                                



Select distinct P.sTrackingNumber/*O.ixOrder, O.ixShippedDate,
    MAX(P.ixPackageDeliveredLocal) 'MaxDelivered',
    (MAX(P.ixPackageDeliveredLocal)- O.ixShippedDate) 'DaysDelivered'
    */
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
where dtShippedDate between '01/10/2018' and '01/11/2018' -- >= '01/04/2018'
    and O.sOrderStatus = 'Shipped' 
    and O.sShipToCountry = 'US'
    and O.sShipToState NOT IN ('HI','AK')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.iShipMethod = 2                               -- 18,909                   26,928
    --and O.dtLastPackageDeliveryLocal is NOT NULL  
    and P.ixPackageDeliveredLocal is NULL         -- 2,517  <-- NULL 86.7% of the time!?!   68.8% NULLs for APR 2017      8,409
GROUP BY O.ixOrder, O.ixShippedDate  
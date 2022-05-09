-- Worldship orders that contain a kit
select COUNT(*) OrderCount
from tblOrder O
where sShipToCountry is NOT NULL and sShipToCountry <> 'US'
and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered -- 5787 Orders YTD
    and O.iShipMethod = 8 -- 288
    and O.ixOrder in (Select distinct O.ixOrder
                      from tblOrder O
                        join tblOrderLine OL on O.ixOrder = OL.ixOrder
                        join tblKit K on K.ixKitSKU = OL.ixSKU
                        where sShipToCountry is NOT NULL and sShipToCountry <> 'US'
                        and O.sOrderStatus = 'Shipped'
                        and O.dtShippedDate between '01/01/2016' and '12/31/2016'
                        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                        and O.sOrderType <> 'Internal'   -- USUALLY filtered -- 5787 Orders YTD
                        and O.iShipMethod = 8                         
                       )
    select * from tblShipMethod
    


SELECT * FROM vwOrderLineWorldShip
where ixOrder = '6430391'



SELECT WS.* 
FROM vwOrderLineWorldShip WS
join tblKit K on WS.ixSKU = K.ixKitSKU


SELECT WS.* 
FROM vwOrderLineWorldShip WS
join tblKit K on WS.ixSKU = K.ixKitSKU

SELECT * FROM vwOrderLineWorldShip
where ixOrder = '6430391'

SELECT COUNT(*) FROM vwOrderLineWorldShip                   -- 18,342,043
SELECT COUNT(distinct ixOrder) FROM vwOrderLineWorldShip    --  4,635,224

select sShipToCountry, COUNT(*) OrderCount
from tblOrder O
where sShipToCountry is NOT NULL and sShipToCountry <> 'US'
and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
group by sShipToCountry    


-- Worldship orders that contain a kit
select COUNT(*) OrderCount
from tblOrder O
where sShipToCountry is NOT NULL and sShipToCountry <> 'US'
and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered -- 5787 Orders YTD
    and O.iShipMethod = 8 -- 288
    and O.ixOrder in (Select distinct O.ixOrder
                      from tblOrder O
                        join tblOrderLine OL on O.ixOrder = OL.ixOrder
                        join tblKit K on K.ixKitSKU = OL.ixSKU
                        where sShipToCountry is NOT NULL and sShipToCountry <> 'US'
                        and O.sOrderStatus = 'Shipped'
                        and O.dtShippedDate between '01/01/2016' and '12/31/2016'
                        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                        and O.sOrderType <> 'Internal'   -- USUALLY filtered -- 5787 Orders YTD
                        and O.iShipMethod = 8                         
                       )
    select * from tblShipMethod
-- SMIHD-8079 - Orders with paid shipping send on DEN trailer 7-10-17
select DISTINCT O.ixOrder 'Order', 
    O.ixCustomer 'Cust', 
    O.mMerchandise 'Sales', 
    O.mShipping 'Shipping',
    O.iShipMethod,
    CONVERT(VARCHAR,O.dtShippedDate, 1) AS 'ShippedDate',
    O.sShipToState,
    O.sShipToZip,
    (CASE WHEN O.flgGuaranteedDeliveryPromised = 1 then CONVERT(VARCHAR,O.dtGuaranteedDelivery, 1)
         ELSE ''
         END
         ) 'GuarenteedDelivery'
 
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
where O.dtShippedDate = '07/10/2017'
    and O.mShipping > 0
    and P.ixTrailer = 'DEN'
order by O.ixCustomer, O.ixOrder

/*
select * from tblTrailer
where ixCarrier = 'UPS'
*/

select ixOrder, sTrackingNumber 
from tblPackage 
where ixOrder in (select DISTINCT O.ixOrder 
                  from tblOrder O
                      join tblPackage P on O.ixOrder = P.ixOrder
                  where O.dtShippedDate = '07/10/2017'
                      and O.mShipping > 0
                      and P.ixTrailer = 'DEN'
                    )
order by ixOrder, sTrackingNumber                    



method of shipping, order #, ship date, 
delivery zip code, delivery state, and delivery promise date (if a G/S paid shipping order), this would be ideal
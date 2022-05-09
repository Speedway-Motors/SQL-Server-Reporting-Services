-- SMIHD-20619 - Timeframe for customer pickup orders

select (ixShippedDate-ixOrderDate) 'DaysOrderToPU', count(ixOrder) 'Orders'
from tblOrder
where iShipMethod = 1
    and mMerchandise > 0
    and dtShippedDate between '03/01/20' and '02/28/21' -- 29,319
group by (ixShippedDate-ixOrderDate)
order by (ixShippedDate-ixOrderDate) desc

-- almost half the orders are missing a verified date
select (ORT.ixVerifyDate-O.ixOrderDate) 'DaysOrderToPU', count(O.ixOrder) 'Orders'
from tblOrder O
    left join tblOrderRouting ORT on O.ixOrder = ORT.ixOrder
where iShipMethod = 1
    and mMerchandise > 0
    and dtShippedDate between '03/01/20' and '02/28/21' -- 29,319
group by (ORT.ixVerifyDate-O.ixOrderDate)
order by (ORT.ixVerifyDate-O.ixOrderDate) desc
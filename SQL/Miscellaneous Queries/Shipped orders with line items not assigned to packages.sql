-- Shipped orders with line items not assigned to packages
select o.sOrderTaker, count(distinct ol.ixOrder) 'OrderCount'
/*
    o.ixOrder,
    ol.iOrdinality,
    o.iShipMethod,
    ol.ixSKU,
    ol.sTrackingNumber,
     s.flgIsKit,
    ol.flgKitComponent,
    ol.dtDateLastSOPUpdate,
    o.sOrderTaker,
    o.mPublishedShipping,
    o.sOrderType,
    ol.flgLineStatus,
    ol.flgOverride,
    ol.mExtendedPrice, 
    ol.iQuantity  
  */ 
from
    tblOrderLine ol
    left join tblOrder o on ol.ixOrder=o.ixOrder
    left join tblSKU s on ol.ixSKU = s.ixSKU
where
    ol.dtOrderDate >= '12/28/2018' --'04/09/19'
    and o.sOrderStatus='Shipped'
    and ol.flgLineStatus='Shipped'
    and o.iShipMethod not in (1)
    and ol.sTrackingNumber is null
    and s.flgIntangible=0
    and s.flgIsKit=0
   -- and o.sOrderChannel <> 'INTERNAL'
    and o.sOrderType <> 'Internal'
  --  and ol.flgOverride = 0
--and o.ixOrder = '8101659'
   and ol.mExtendedPrice > 0
group by o.sOrderTaker
order by count(distinct ol.ixOrder) desc
 --   o.ixOrder, ol.iOrdinality -- 42 SKUs from 9 different orders out of 2,850 orders that shipped that day 
                             --               8 of those orders, the problem SKUs were all kit components
                                              Order# 8188550 NONE of the problem SKUs were kit components


select count(ixOrder) -- 2,850
from tblOrder
where dtShippedDate = '04/09/19'
 and iShipMethod <> 1
 and sOrderStatus = 'Shipped'

select count(ixOrder) -- 2,844
from tblOrder
where  dtShippedDate = '04/09/19'
 and sOrderStatus = 'Shipped'
 and iShipMethod <> 1
 and sOrderType <> 'Internal'


select * from tblPackage
where ixOrder in ('8101659','8104558','8118552','8129656','8155355','8155652','8162554','8170456','8188550')

select * from tblOrderLine
where ixOrder = '8129656'
order by iOrdinality

select distinct flgLineStatus
from tblOrderLine




select ol.ixOrder, ol.flgLineStatus, count(ol.ixOrder)
from
    tblOrderLine ol
    left join tblOrder o on ol.ixOrder=o.ixOrder
    left join tblSKU s on ol.ixSKU = s.ixSKU
where
    ol.dtOrderDate = '04/09/19'
    and o.sOrderStatus='Shipped'
    --and ol.flgLineStatus='Shipped'
    and o.iShipMethod not in (1)
    and ol.sTrackingNumber is null
    and s.flgIntangible=0
    and s.flgIsKit=0
   -- and o.sOrderChannel <> 'INTERNAL'
    and o.sOrderType <> 'Internal'
  --  and ol.flgOverride = 0
--and o.ixOrder = '8101659'
group by sOrderTaker --ol.ixOrder, ol.flgLineStatus
order by





-- Shipped orders with line items not assigned to packages
select -- o.sOrderTaker, count(distinct ol.ixOrder) 'OrderCount'
    o.ixOrder,
    o.ixCustomer,
    ol.iOrdinality,
    o.iShipMethod,
    ol.ixSKU,
    ol.sTrackingNumber,
     s.flgIsKit,
    ol.flgKitComponent,
    ol.dtDateLastSOPUpdate,
    o.sOrderTaker,
    o.mPublishedShipping,
    o.sOrderType,
    ol.flgLineStatus,
    ol.flgOverride,
    ol.mExtendedPrice, 
    ol.iQuantity  
from
    tblOrderLine ol
    left join tblOrder o on ol.ixOrder=o.ixOrder
    left join tblSKU s on ol.ixSKU = s.ixSKU
where
    ol.dtOrderDate >= '12/28/2018' --'04/09/19'
    and o.sOrderStatus='Shipped'
    and ol.flgLineStatus='Shipped'
    and o.iShipMethod not in (1)
    and ol.sTrackingNumber is null
    and s.flgIntangible=0
    and s.flgIsKit=0
   -- and o.sOrderChannel <> 'INTERNAL'
    and o.sOrderType <> 'Internal'
  --  and ol.flgOverride = 0
--and o.ixOrder = '8101659'
   and ol.mExtendedPrice > 0
group by o.sOrderTaker
order by count(distinct ol.ixOrder) desc




select -- o.sOrderTaker, count(distinct ol.ixOrder) 'OrderCount'
    o.ixOrder,
    o.ixCustomer,
    ol.iOrdinality,
    o.iShipMethod,
    ol.ixSKU,
    ol.sTrackingNumber,
     s.flgIsKit,
    ol.flgKitComponent,
    ol.dtDateLastSOPUpdate,
    o.sOrderTaker,
    o.mPublishedShipping,
    o.sOrderType,
    ol.flgLineStatus,
    ol.flgOverride,
    ol.mExtendedPrice, 
    ol.iQuantity  
from
    tblOrderLine ol
    left join tblOrder o on ol.ixOrder=o.ixOrder
    left join tblSKU s on ol.ixSKU = s.ixSKU
where
    ol.dtOrderDate >= '12/28/2018' --'04/09/19'
    and o.sOrderStatus='Shipped'
    and ol.flgLineStatus='Shipped'
    and o.iShipMethod = 8 --not in (1)
    and ol.sTrackingNumber is null
    and s.flgIntangible=0
    and s.flgIsKit=0
   -- and o.sOrderChannel <> 'INTERNAL'
    and o.sOrderType <> 'Internal'
  --  and ol.flgOverride = 0
and o.ixOrder = '8129656'
   and ol.mExtendedPrice > 0
group by o.sOrderTaker
order by count(distinct ol.ixOrder) desc


select * from tblOrder where ixOrder = '8129656'

select * from tblOrderLine  ol
where ixOrder = '8129656'
and ol.sTrackingNumber is null 


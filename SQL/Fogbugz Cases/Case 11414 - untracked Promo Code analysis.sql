-- start time 12:00

-- ALL shipped orders last 3 years
select count(ixOrder)   -- 1,079,063
from tblOrder O
where O.dtShippedDate >= '02/26/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 


-- ALL shipped orders last 3 years WITH a promo discount
select count(ixOrder)   -- 48101
from tblOrder O
where O.dtShippedDate >= '02/26/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0
    and O.mPromoDiscount > 0


-- ALL shipped orders last 3 years WITH a promo code in tblPromoCodeMaster
select count(ixOrder)   -- 52,055
from tblOrder O
where O.dtShippedDate >= '02/26/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.sPromoApplied IN (select distinct ixPromoCode from tblPromoCodeMaster)


-- ALL shipped orders last 3 years WITH a promo discount but WITHOUT a sPromoApplied value
select count(ixOrder)   -- 0 yayyy!
from tblOrder O
where O.dtShippedDate >= '02/26/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0
    and O.mPromoDiscount > 0
    and O.sPromoApplied is NULL


-- ALL shipped orders last 3 years with a promo code that is NOT IN tblPromoCodeMaster
select count(ixOrder)   -- 341
from tblOrder O
where O.dtShippedDate >= '02/26/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.sPromoApplied NOT IN (select distinct ixPromoCode from tblPromoCodeMaster)


-- COUNTS BY sPromoApplied for ALL shipped orders last 3 years WITHOUT a promo code in tblPromoCodeMaster
select sPromoApplied, count(ixOrder) OrdCount   
from tblOrder O
where O.dtShippedDate >= '02/26/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.sPromoApplied NOT IN (select distinct ixPromoCode from tblPromoCodeMaster)
GROUP BY sPromoApplied
ORDER BY sPromoApplied







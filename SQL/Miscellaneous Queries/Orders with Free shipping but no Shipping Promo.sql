-- YTD orders with Free shipping 
/* EXCLUDES:
    Orders with an shipping ixPromoID 
    PRS & MR customers
    Orders containing a free shipping SKU
    Backorders
    Counter Orders
    Orders containing a GIFT CARD
*/     

select sum(O.mMerchandise) Sales
    -- O.sOrderTaker, sum(O.mMerchandise) Sales, COUNT(O.ixOrder) OrderCnt 
    -- SUM(O.mMerchandise) 
    -- O.*
    --distinct O.ixOrder
from tblOrder O
    left join tblOrder OL on O.ixOrder = OL.ixOrder
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblShippingPromo SP on O.ixOrder = SP.ixOrder
where O.dtOrderDate >= '01/01/2013'
and O.sOrderStatus in ('Shipped','Dropshipped')
and O.mShipping = 0 
and O.iShipMethod <> 1 -- Counter orders
and (C.ixCustomerType NOT in ('30','40')  -- PRS & MR
     or C.ixCustomerType is NULL)
and SP.ixOrder is NULL -- no shipping ixPromoID tied to order
and O.ixOrder NOT in (-- Orders containing a SKU that qualifies for free shipping
                        select distinct O.ixOrder  
                        from tblOrder O
                           join tblOrderLine OL on O.ixOrder = OL.ixOrder
                           join tblPromotionalInventory PINV on PINV.ixSKU = OL.ixSKU
                        where O.dtOrderDate >= '01/01/2013')
and O.ixOrder NOT in (-- Orders containing a GIFT CARD
                        select distinct O.ixOrder  
                        from tblOrder O
                           join tblOrderLine OL on O.ixOrder = OL.ixOrder
                        where O.dtOrderDate >= '01/01/2013'
                        and O.sOrderStatus in ('Shipped','Dropshipped')
                        and (OL.ixSKU like 'GIFT%'
                             or OL.ixSKU = 'EGIFT') 
                      )                       
and O.ixOrder NOT like '%-%' -- excluding ALL backorders (most should have 0 shipping)
--and O.dtDateLastSOPUpdate < '07/29/2013'
group by O.sOrderTaker
order by Sales desc

    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    
    
    
-- exclude MR & PRS   and (C.ixCustomerType NOT in ('30','40') or C.ixCustomerType is NULL)
-- exclude orders that have a SHIPPING ixPromoCode
-- exclude Order that contain a SKU in tblPromotionalInventory


select COUNT(*) from tblOrder O
where O.dtOrderDate >= '01/01/2013'
and O.sOrderStatus in ('Shipped','Dropshipped')
and O.ixOrder like '%-%'
and O.mMerchandise > 0
and O.mShipping > 0


select distinct ixPromoId
from tblShippingPromo
where ixPromoId in ('109','155','157','176','212','247','250','254','260','293')









select COUNT(*) from tblOrder where dtOrderDate  >= '01/01/2013'
and sOrderStatus in ('Shipped','Dropshipped') 


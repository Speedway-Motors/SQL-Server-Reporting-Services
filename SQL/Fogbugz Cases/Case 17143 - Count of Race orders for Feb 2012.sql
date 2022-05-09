-- Case 17143 - Count of Race orders for Feb 2012

-- NEED INFO FROM AL
-- about how SOP currently designates an order as needing an insert
-- in order to modify the query to use similar logic

select COUNT(distinct O.ixOrder) -- i
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
WHERE     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '02/01/2012' and '02/29/2012'
    AND PGC.ixMarket in ('R')--,'B')
    
    


select PGC.ixMarket, COUNT(SKU.ixSKU) SKUQty
from tblPGC PGC
    join tblSKU SKU on PGC.ixPGC = SKU.ixPGC
where SKU.flgDeletedFromSOP = 0
and SKU.flgActive = 1
group by PGC.ixMarket



/*
    
select sOrderChannel, COUNT(*)
from tblOrder O
where dtOrderDate >= '01/01/2013'
and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by sOrderChannel


*/
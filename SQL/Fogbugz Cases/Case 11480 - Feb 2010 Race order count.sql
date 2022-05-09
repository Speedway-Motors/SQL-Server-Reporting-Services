-- 27,788 total orders in Feb 2010 
select O.ixOrder, SUM(OL.mExtendedPrice) -- 8,233
from tblOrder  O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where O.dtShippedDate between '02/01/2010' and '02/28/2010' -- 27,788  Korth confirmed avg is about 1.3 packages per order
    and PGC.ixMarket = 'R'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 50 
group by O.ixOrder
having SUM(OL.mExtendedPrice) > 50   


-- Feb 2011 
select O.ixOrder, SUM(OL.mExtendedPrice) -- 8,576
from tblOrder  O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where O.dtShippedDate between '02/01/2011' and '02/28/2011' -- 27,788  Korth confirmed avg is about 1.3 packages per order
    and PGC.ixMarket = 'R'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 50 
group by O.ixOrder
having SUM(OL.mExtendedPrice) > 50   

                Est.
2010    2011    2012
8233    8576    8933
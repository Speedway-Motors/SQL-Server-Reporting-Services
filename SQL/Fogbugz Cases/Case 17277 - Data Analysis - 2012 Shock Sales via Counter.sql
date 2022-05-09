--  
select SKU.ixSKU            as 'SKU', 
    SKU.sDescription        as 'SKU Description', 
    sum(OL.iQuantity)       as 'Qty Sold', 
    sum(OL.mExtendedPrice)  as 'Shock Sales',
    sum(O.mMerchandise)     as 'All Merch Sales'
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation = '99'
where SL.sPickingBin = 'SHOCK'
    --and O.sOrderChannel = 'COUNTER'
    and O.iShipMethod = '1' -- Counter
    and O.sOrderStatus = 'Shipped'
   -- and O.sOrderType <> 'Internal'
   -- and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2012' and '12/31/2012'
    --and SKU.flgDeletedFromSOP = 0
    --and SKU.flgIntangible = 0
group by SKU.ixSKU, 
    SKU.sDescription  
    
    
select    sOrderChannel, count(*)
from tblOrder
where dtShippedDate between '01/01/2012' and '12/31/2012'
group by sOrderChannel



select * from tblSKULocation where   sPickingBin = 'SHOCK'    
    
    


-- totals for all orders that contained contained at least that came from sPickingBin SHOCK



SHOCKRB-BIL	SHOCK REBUILD	21	 $10.00 	 $1,306.51  -- cust # 1217425   1923549





select SKU.ixSKU            as 'SKU', 
    SKU.sDescription        as 'SKU Description', 
    (OL.iQuantity)       as 'Qty Sold', 
    (OL.mExtendedPrice)  as 'Shock Sales',
    O.ixOrder,
    O.ixCustomer,
    O.dtShippedDate,
    (O.mMerchandise)     as 'All Merch Sales',
    O.sOrderChannel,
    O.iShipMethod
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation = '99'
where SL.sPickingBin = 'SHOCK'
    --and O.sOrderChannel = 'COUNTER'
    --and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2012' and '12/31/2012'
    and OL.ixSKU = 'SHOCKRB-BIL'
    and O.ixCustomer in ('1217425','1923549')
    
select * from tblShipMethod    



















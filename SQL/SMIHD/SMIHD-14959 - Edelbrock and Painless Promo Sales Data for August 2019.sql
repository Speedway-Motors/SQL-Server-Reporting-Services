-- SMIHD-14959 - Edelbrock and Painless Promo Sales Data for August 2019
/*
analysis on two promos we ran for the last couple weeks in August.

First, was Edelbrock V#0325 & 0326. For that promo I need the following info for each order taken from 8/14/19 to 9/3/19 :

Second, was Painless. I need the following info for each order taken from 8/19/19 to 9/2/19 :

NEEDED FIELDS:
Item Sold (SKU)
Qty
Selling Price
Date Sold
Order Number
*/

-- Edelbrock
SELECT DISTINCT OL.ixOrder 'Order', OL.ixSKU 'SKU', ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    OL.iQuantity, OL.mSystemUnitPrice 'UnitPrice', OL.mExtendedPrice 'ExtUnitPrice', O.dtOrderDate, 
   -- VS.iOrdinality 'VendorOrdinality', 
   O.sOrderStatus 'OrderStatus', OL.flgLineStatus 'OrderLineStatus', 
   (CASE WHEN OL.flgKitComponent = 1 THEN 'Y'
        ELSE 'N'
    END) 'KitComponent'
FROM tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblVendorSKU VS on OL.ixSKU = VS.ixSKU
    left join tblSKU S on S.ixSKU = OL.ixSKU
WHERE VS.ixVendor in ('0325', '0326')
    and O.dtOrderDate between '08/14/2019' and '09/03/2019'
    and OL.flgLineStatus in ('Backordered','Dropshipped','Open','Shipped')
    and O.sOrderStatus in ('Backordered','Open','Shipped')
order by OL.ixOrder, OL.ixSKU





-- PAINLESS PERFORMANCE PRODUCTS
SELECT DISTINCT OL.ixOrder 'Order', OL.ixSKU 'SKU', ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    OL.iQuantity, OL.mSystemUnitPrice 'UnitPrice', OL.mExtendedPrice 'ExtUnitPrice', O.dtOrderDate, 
   -- VS.iOrdinality 'VendorOrdinality', 
   O.sOrderStatus 'OrderStatus', OL.flgLineStatus 'OrderLineStatus', 
   (CASE WHEN OL.flgKitComponent = 1 THEN 'Y'
        ELSE 'N'
    END) 'KitComponent'
FROM tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblVendorSKU VS on OL.ixSKU = VS.ixSKU
    left join tblSKU S on S.ixSKU = OL.ixSKU
WHERE VS.ixVendor in ('2527')
    and O.dtOrderDate between '08/19/2019' and '09/02/2019'
    and OL.flgLineStatus in ('Backordered','Dropshipped','Open','Shipped')
    and O.sOrderStatus in ('Backordered','Open','Shipped')
order by OL.ixOrder, OL.ixSKU


select * from tblVendor where upper(sName) like '%EDELBROCK%'
select * from tblVendor where upper(sName) like '%PAINLESS%'




select * from tblOrderLine OL where ixOrder = '8018782' --	3259665'
 
select * from tblVendorSKU where ixSKU = '3259665'

select * from tblOrderLine where ixOrder = '8005483'

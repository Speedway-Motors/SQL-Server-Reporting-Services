-- SMIHD-5248 - SKUs sold as Kit components that have a 0 quantity in tblOrderline

/* comments from case SMIHD-5248

Connie While - I just thought of something that might thru a kink into this... They have a work-around where they zero out the qty of a kit component 
    and then add that item as an individual item with a $0.00 price. Am I going to have to check for the individual item with $0.00 price to get the actual qty? 
    Otherwise that item won't have a weighted price because I won't have a qty...

Pat Crews - That is definitely a problem. I don't quite understand their work-around. So the orderline qty field on kit components isn't always the actual 
    quantity used? If that's the case, what is the reason they do that and roughly what % of the time does that happen? There are multiple existing reports based 
    on the qty in tblOrderline to show how much annual qty of each SKU is consumed by kits. This would definitely be throwing all of those figures off.

Connie While - Glad I thought of it then. You would have to talk to the CLC to see how often this is used. They do this so that they don't have to backorder the entire kit. 
    If the customer wants everything but the backordered item to be shipped, they do this. It is their only alternative other than to split the whole kit up into 
    individual components and try to adjust the prices which would be much worse. They've been doing this for a long time as far as I know. This is also an automated w
    orkaround for AFCO items that must be dropships within the Order Integrator as there was no other way to handle that.

Kevin Larkins (SMI) - I would say in the big picture it's done a small percentage of the time

Pat Crews - Thanks for the headsup Connie While. I'll try to keep that in mind when I get the inevitable "The totals on report X don't match the totals on report Y" inqueries.
    I ran the actual numbers YTD and yes, fortunately it is pretty infrequent. 1,500 line items out of 267k (0.6%).  Hopefully there aren't many more special case 
    scenarios like this. Once we start taking estimates of estimates of estimates...etc. the final answer gets less and less reliable.
 */

SELECT OL.flgLineStatus, OL.ixSKU, OL.iQuantity
from tblOrderLine OL
join tblOrder O on O.ixOrder = OL.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate > '01/01/2016' -- between '01/01/2016' and '12/31/2016' 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and OL.flgKitComponent = 1
    and OL.flgLineStatus IN ('Dropshipped','Shipped')
    -- NOT in ('Backordered','Backordered FS','Cancelled','Cancelled Quote', 'Dropshipped','fail','Lost','Open','Quote','Shipped','unknown'
order by OL.iQuantity

-- 2,67K Total Orderlines   1,593 show ZERO qty  (0.6%)



SELECT count(OL.iKitOrdinality)
from tblOrderLine OL
join tblOrder O on OL.ixOrder = OL.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate > '08/27/2016' -- between '01/01/2016' and '12/31/2016' 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and OL.flgKitComponent = 0
    and OL.flgLineStatus IN ('Dropshipped','Shipped')
    and OL.iKitOrdinality = 1 
    -- NOT in ('Backordered','Backordered FS','Cancelled','Cancelled Quote', 'Dropshipped','fail','Lost','Open','Quote','Shipped','unknown'
order by OL.iQuantity


select distinct ixGuaranteeDelivery
from tblOrder

select flgDeliveryPromiseMet, COUNT(*)
from tblOrder
where flgDeliveryPromiseMet is NOT NULL
group by flgDeliveryPromiseMet
/*
0	637
1	15436
*/

select ixOrder, sOrderStatus, dtDateLastSOPUpdate
from tblOrder where flgDeliveryPromiseMet = 0
order by dtDateLastSOPUpdate
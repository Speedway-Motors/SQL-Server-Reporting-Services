-- SMIHD-12344 - Merchandising Inventory By Vendor Report Issues
/*
Hi Pat,

The 12 and 24 mo. Sales numbers on this report are not calculating correctly. 
I just ran it for vendor numbers 2602 & 2605 and am looking at our best selling SKU  2552254
We have qty sold of 1561, it's retail price is 64.99 which would tell me if we sold them all at retail 
our 12 mos Sales should be over $100K, the report is showing the qty correctly but sales of only $21,007.78. 
I know not all SKUs are sold at retail but this number is way off.

Can you please take a look at this for me?
*/


select * from tblSKU where ixSKU in ('2552254','25522544')
-- 2552254 is the correct SKU


-- SUMMARY
SELECT flgKitComponent,
    SUM(iQuantity) 'QtySold', 
    SUM(mExtendedPrice) 'TotSales' 
    --ixOrder, dtOrderDate, dtShippedDate, iQuantity, mUnitPrice, mExtendedPrice, flgLineStatus, flgKitComponent
from tblOrderLine
where ixSKU = '2552254'
    and dtOrderDate between '11/14/2017' and '11/13/2018'
    and flgLineStatus = 'Shipped'
GROUP BY flgKitComponent
/*
flgKit      Qty     Tot
Component	Sold	Sales
=========   =====   ========
0	        389	    21007.78
1	        1173	    0.00
*/




-- OL detail
SELECT ixOrder, dtOrderDate, dtShippedDate, iQuantity, mUnitPrice, mExtendedPrice, flgLineStatus, flgKitComponent
from tblOrderLine
where ixSKU = '2552254'
and dtOrderDate between '11/14/2017' and '11/13/2018'
and flgLineStatus = 'Shipped'
order by dtOrderDate desc





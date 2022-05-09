-- SMIHD-2652 - Avg Value for Gift Cards Purchased Nov & Dec 2014

SELECT OL.ixSKU, OL.mUnitPrice, SUM(OL.iQuantity) QtySold
FROM tblOrderLine OL
    left join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblCustomer C on C.ixCustomer = O.ixCustomer
where OL.ixSKU like '%GIFT%'
    and OL.ixSKU in (select ixSKU from vwGiftCardSKUs)
    and OL.ixOrderDate between 17107 and 17167 -- 11/1/14 and 12/31/14
    and OL.flgLineStatus = 'Shipped'
    and OL.ixCustomer NOT in ('1299264', '1299265','1299266', '707952')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and C.ixCustomerType <> '45' -- FOR SPEEDWAY INVENTORY TRACKING/PROMOS/ETC.
group by OL.ixSKU, OL.mUnitPrice
order by OL.ixSKU, OL.mUnitPrice
/*
ixSKU	    QTY
==========  ===
GIFT-RACE	914
EGIFT	    676
GIFT-SR	    583
GIFT-SMI	259
GIFT-SPRINT	116
*/



-- UNUSUAL PRICE POINTS
select OL.ixCustomer, OL.ixOrder, OL.ixSKU, OL.mUnitPrice-- , iQuantity
,O.sOrderType, C.sCustomerType, C.ixCustomerType, O.sOrderChannel, O.sOrderTaker
from tblOrderLine OL
left join tblOrder O on O.ixOrder = OL.ixOrder
left join tblCustomer C on C.ixCustomer = O.ixCustomer
where OL.ixSKU like '%GIFT%'
AND OL.ixSKU in (select ixSKU from vwGiftCardSKUs)
and OL.ixOrderDate between 17107 and 17167 -- 11/1/14 and 12/31/14
and OL.flgLineStatus = 'Shipped'
and OL.ixCustomer NOT in ('1299264', '1299265','1299266', '707952')
and OL.mUnitPrice NOT like '%.00' -- in (55.26, 155.99, 99.99, 229.96, 81.07, 81.99, 90.94, 99.98, 109.99, 125.98, 129.99, 168.90, 241.89, 249.96, 249.98, 459.94, 822.79, 1283.99, 2159.99, 
and O.mMerchandise > 0 -- > 1 if looking at non-US orders
and O.sOrderType <> 'Internal'   -- USUALLY filtered
and C.ixCustomerType <> '45' -- FOR SPEEDWAY INVENTORY TRACKING/PROMOS/ETC.

select * from tblCustomerType

--group by ixSKU, mUnitPrice
order by sOrderTaker -- OL.ixCustomer, OL.ixSKU, OL.mUnitPrice






select * from tblSKU
WHERE ixSKU = 'GIFT-SMI'





-- SMIHD-1768 Gift Card Sales past 24 months


select * from tblSKU
where ixSKU like '%GIFT%'
and flgDeletedFromSOP = 0


select OL.ixSKU, SKU.sDescription, SUM(OL.iQuantity) QtySoldLast12Mo
from tblOrderLine OL
join tblOrder O on OL.ixOrder = O.ixOrder
join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where O.dtOrderDate between '08/04/14' and '08/03/15'
and SKU.ixSKU LIKE 'GIFT%'
and OL.flgLineStatus = 'Shipped'
group by OL.ixSKU, SKU.sDescription
order by OL.ixSKU

select OL.ixSKU, SKU.sDescription, SUM(OL.iQuantity) QtySoldLast24Mo
from tblOrderLine OL
join tblOrder O on OL.ixOrder = O.ixOrder
join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where O.dtOrderDate between '08/04/13' and '08/03/14'
and SKU.ixSKU LIKE 'GIFT%'
and OL.flgLineStatus = 'Shipped'
group by OL.ixSKU, SKU.sDescription
order by OL.ixSKU


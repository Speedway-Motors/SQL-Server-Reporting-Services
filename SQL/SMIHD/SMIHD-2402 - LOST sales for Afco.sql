-- SMIHD-2402 - LOST sales for Afco
select OL.ixSKU, OL.flgLineStatus, SUM(OL.iQuantity) 'LostQTY'
from tblOrderLine OL
where dtOrderDate >= '01/01/2014'
and OL.flgLineStatus = 'Lost'
and OL.ixSKU = '762-91510'
group by OL.ixSKU, OL.flgLineStatus
order by flgLineStatus,  SUM(OL.iQuantity) desc
-- QTY doesn't match the screen Julie provided in SOP

select * from tblSKU where ixSKU = '762-91510'

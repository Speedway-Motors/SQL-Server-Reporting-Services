select
	count(1),
	D.iMonth,
	sum(O.mMerchandise),
	sum(OT.iBillingAddress+OT.iLineItems+OT.iMailingAddress+OT.iMethodOfPayment+OT.iMethodOfShipping+OT.iOrderSummary+OT.iShippingAddress) as 'Time'
from
	tblOrder O
	Left join tblDate D on O.ixOrderDate = D.ixDate
	left join tblOrderTiming OT on O.ixOrder = OT.ixOrder
where
	O.dtOrderDate >= '01/01/12'
	and O.sSourceCodeGiven in ('2190', 'WO', 'NET', '2191', '2192')
	and O.sOrderTaker <> 'WEB'
	and O.sOrderChannel <> 'WEB'
	and O.sOrderStatus = 'Shipped'
group by
	D.iMonth

select
	count(1),
	count(distinct OL.ixSKU),
	D.iMonth
from
	tblOrderLine OL
	left join tblDate D on OL.ixOrderDate = D.ixDate
where
	OL.dtOrderDate >= '01/01/12'
	and OL.flgLineStatus in ('Shipped', 'Dropshipped')
group by
	D.iMonth
having count(1) > 1
select
	O.ixOrder,
	O.dtOrderDate as 'Date',
	O.sOrderStatus as 'Order Status',
	O.ixCustomer as 'C#',
	O.iShipMethod as 'MOS'
from
	tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
where
	OL.ixSKU = '4081001'
	and
	O.dtOrderDate >= '03/01/11'
	and O.sOrderStatus <> 'Cancelled'
	and OL.flgLineStatus <> 'Cancelled'


select
	OL.ixOrder,
	convert(varchar, OL.dtOrderDate, 101) as 'OrderDate',
	OL.ixSKU as 'SKU',
	(OL.iQuantity) as 'Quantity',
	OL.mUnitPrice as 'Unit Price',
	OL.mExtendedPrice as 'Extended Price',
	OL.mExtendedCost as 'COGS',
	case when O.iShipMethod = '1' then 'Y' else 'N' end as 'Will-Call Order Y or N',
	O.sOrderType as 'Order Type'
from
	tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
where
	O.dtOrderDate >= '10/22/11'
	and O.sOrderStatus in ('Shipped', 'Open')
	and OL.flgLineStatus in ('Shipped', 'Open')
	and O.ixOrder in (select distinct OL1.ixOrder from tblOrderLine OL1 where OL1.ixSKU in (select CS.ixSKU from CCCSKUS CS))  --all orders containing SKUs from CCCSKUS
	and OL.flgKitComponent = 0
	and O.sOrderChannel <> 'INTERNAL'
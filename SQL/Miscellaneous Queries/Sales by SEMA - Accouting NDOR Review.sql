

select
	convert(varchar, O.dtOrderDate, 101) as 'Order Date',
	OL.ixSKU as 'SKU',
	isnull(SKU.sWebDescription,SKU.sDescription) as 'Description',
	OL.ixOrder as 'Order',
	sum(OL.iQuantity) as 'Quantity',
	O.ixCustomer as 'Customer#',
	C.ixCustomerType as 'Customer Flag',
	C.flgTaxable as 'Tax Code',
	sum(OL.mExtendedPrice) as 'Total MDSE',
	sum(OL.mExtendedCost) as 'Merchandise Cost',
	O.mShipping as 'Shipping',
	O.mTax as 'Tax',
	SM.sDescription as 'Shipping Method',
	O.sOrderChannel as 'Order Channel'
from
	tblOrderLine OL
	left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblCustomer C on OL.ixCustomer = C.ixCustomer
	left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where
	O.dtOrderDate >= '07/25/10'
	and SKU.sSEMAPart = 'Tires'
	and O.sShipToState = 'NE'
	and O.sOrderStatus = 'Shipped'

group by
	convert(varchar, O.dtOrderDate, 101), OL.ixSKU, isnull(SKU.sWebDescription, SKU.sDescription), OL.ixOrder, O.ixCustomer, C.ixCustomerType, C.flgTaxable, O.mShipping, O.mTax, SM.sDescription, O.sOrderChannel
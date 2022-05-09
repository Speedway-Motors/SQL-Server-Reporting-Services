-- Case 20953 - Annual Tire Sales by SEMA - Accouting NDOR Review

select
	convert(varchar, O.dtOrderDate, 101) as 'Order Date',
	OL.ixSKU as 'SKU',
	isnull(SKU.sWebDescription,SKU.sDescription) as 'Description',
	OL.ixOrder as 'Order',
	sum(OL.iQuantity) as 'Quantity',
	O.ixCustomer as 'Customer#',
	O.sShipToState as 'Ship To State',
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
	O.dtOrderDate between '01/01/2014' and '12/31/2014' -- full 2013 sales will be needed in Jan 2014
	and SKU.sSEMAPart = 'Tires'
	-- and O.sShipToState = 'NE'   <-- now for ALL states
	and O.sOrderStatus = 'Shipped'
group by
	convert(varchar, O.dtOrderDate, 101), OL.ixSKU, isnull(SKU.sWebDescription, SKU.sDescription), OL.ixOrder, O.ixCustomer, O.sShipToState, C.ixCustomerType, C.flgTaxable, O.mShipping, O.mTax, SM.sDescription, O.sOrderChannel
order by 'Order Date' desc	
	
	
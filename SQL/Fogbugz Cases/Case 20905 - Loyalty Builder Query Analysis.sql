/* Loyalty Builders - SKU/Customer Affinity Analysis */

/* view to build transaction file
once view is created, run the three selects to generate the three tab delimited files for LB upload */
alter view vwLBSampleTransactions
as
(select
	O.ixCustomer as 'custid',
	OL.ixSKU as 'itemid',
	convert(varchar,O.dtOrderDate,101) as 'txdate',
	OL.iQuantity as 'quantity',
	OL.mExtendedPrice as 'amount',
	O.sOrderChannel as 'order_channel'
from
	tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
	left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
	left join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation=99
where
/* try and exclude as many 'fake' SKUs (intangible, etc.) from result set
LB only care about real items */
	C.sCustomerType='Retail'
	and O.dtOrderDate between '01/01/07' and '07/01/13'
	and O.sOrderStatus = 'Shipped'
	and O.sOrderChannel <> 'INTERNAL'
	and OL.flgKitComponent = 0
	and O.ixOrder not like '%-%'
	and SKU.flgIntangible=0
	and O.iShipMethod in (2,9,13,14,8,1,3,4,32)
	and O.mMerchandise > 0
	and OL.mExtendedPrice > 0
	and O.sSourceCodeGiven <> 'CUST-SERV'
	and C.ixCustomerType='1'
	and O.sOrderType='Retail'
	and OL.ixSKU not like 'HELP%'
	and SL.sPickingBin not like 'INS%'
	and O.sShipToCountry='US'
	and SL.sPickingBin not like '%!%'
	)
--transaction file data


SELECT * from vwLBSampleTransactions

--products file
select
	SKU.ixSKU as 'itemid',
	SKU.sDescription as 'itemdesc',
	SKU.sSEMACategory as 'prodcat',
	SKU.sSEMASubCategory as 'prodclass',
	SKU.sSEMAPart as 'prodsubclass',
	SKU.sWebDescription as 'itemdesc_long',
	case
		when PGC.ixMarket = 'R' then 'Race'
		when PGC.ixMarket = 'SR' then 'Street Rod'
		when PGC.ixMarket = 'B' then 'Multi'
		when PGC.ixMarket = 'SM' then 'Open Wheel'
		when PGC.ixMarket = 'PC' then 'Pedal Car'
	  when PGC.ixMarket = '2B' then 'T Bucket'
	  when PGC.ixMarket = 'TE' then 'Tools'
	  when PGC.ixMarket = 'SC' then 'Sport Compact'
	end as 'primary_market'


from
	tblSKU SKU
	left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where
	SKU.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
--	and PGC.ixMarket <> 'SR' and PGC.ixMarket <> 'R' and PGC.ixMarket <> 'PC' and PGC.ixMarket <> 'SM' and PGC.ixMarket <> 'B' and PGC.ixMarket <> '2B' and PGC.ixMarket <> 'TE'
--customer file
select
	C.ixCustomer as 'custid',
	C.sMailToState as 'state'
from 
	tblCustomer C 
where
	C.ixCustomer in (select distinct LBST.custid from vwLBSampleTransactions LBST)
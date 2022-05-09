select
	OL.ixSKU as 'SKU',
	SKU.sDescription as 'Description',
	sum(OL.iQuantity) as 'Quantity Sold',
	SKU.flgShipAloneStatus as 'Ship Alone',
	SKU.iLength as 'Length',
	SKU.iWidth as 'Width',
	SKU.iHeight as 'Height',
	SKU.dWeight as 'Weight',
	BS.sPickingBin as 'Pick Location',
	SKU.iMaxQOS as 'Max QOS'
	
from
	tblOrderLine OL
	left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
	left join tblOrder O on O.ixOrder = OL.ixOrder
	left join tblBinSku BS on BS.ixSKU = OL.ixSKU
where
	OL.dtOrderDate >= '04/01/10' and OL.dtOrderDate <= '04/14/10'
	and OL.flgLineStatus = 'Shipped'
	and O.iShipMethod = '1'
	and SKU.flgIsKit = '0'
	and O.sOrderChannel = 'COUNTER'
	and SKU.dWeight <> '0.001'
	and sMatchbackSourceCode not in ('PRS', 'MRR', 'INTERNAL')
	and BS.sPickingBin not in ('9999', '999', '!!!!!', '~')
group by
	OL.ixSKU,
	SKU.sDescription,
	SKU.flgShipAloneStatus,
	SKU.iLength,
	SKU.iWidth,
	SKU.iHeight,
	SKU.dWeight,
	BS.sPickingBin,
	SKU.iMaxQOS

order by
	BS.sPickingBin
	
select
	dSKU.ixSKU,
	SKU.iLength,
	SKU.iHeight,
	SKU.dWeight,
	SKU.iMaxQOS
from
	tblSKU SKU
	left join tblBinSku BS on BS.ixSKU = SKU.ixSKU
where
	BS.sPickingBin like '5D%'
	or BS.sPickingBin like '5E%'
	or BS.sPickingBin like '5F%'
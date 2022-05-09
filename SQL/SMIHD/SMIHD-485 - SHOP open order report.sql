-- SMIHD-485 - SHOP open order report
SELECT
	O.ixOrder,
	O.iShipMethod,
	SM.sDescription,
	T.chTime as 'Time',
	convert(varchar, O.dtOrderDate, 101) as 'Date',
	OL.ixSKU as 'SKU',
	SKU.sDescription as 'Desc',
	OL.iQuantity as 'Qty',
	OL.flgLineStatus as 'Line Status',
	(case when O.flgPrinted=0 then 'No' else 'Yes' end) as 'Print Status'
FROM
	tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblSKULocation SL on OL.ixSKU=SL.ixSKU and SL.ixLocation=99
	left join tblSKU SKU on OL.ixSKU=SKU.ixSKU
	left join tblTime T on O.ixOrderTime=T.ixTime
	left join tblShipMethod SM ON SM.ixShipMethod = O.iShipMethod
WHERE O.sOrderStatus = 'Open'
	AND O.ixOrder in (select distinct (OL1.ixOrder) 
    	              from tblOrderLine OL1 
	                  left join tblSKULocation SL1 on SL1.ixSKU=OL.ixSKU and SL1.ixLocation=99
		    		  where SL1.sPickingBin like '%SHOP%' 
		    		    OR SL1.sPickingBin like '%BP/SH%')
ORDER BY OL.ixOrder,OL.iOrdinality

/*
SELECT distinct sPickingBin FROM tblSKULocation where sPickingBin like '%SHOP%'

SHOP
SHOP-F
SHOP-N
SHOP-R
SHOP-S
SHOP-W
*/

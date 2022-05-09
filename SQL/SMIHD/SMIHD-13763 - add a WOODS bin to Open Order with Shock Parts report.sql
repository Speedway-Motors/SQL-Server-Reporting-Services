-- SMIHD-13763 - add a WOODS bin to Open Order with Shock Parts report

-- Open Order with Shock Parts.rdl
-- ver 19.18.1

SELECT
	O.ixOrder,
	O.iShipMethod,
	SM.sDescription,
	T.chTime as 'Time',
	convert(varchar, O.dtOrderDate, 101) as 'Date',
	OL.ixSKU as 'SKU',
	ISNULL(SKU.sWebDescription, SKU.sDescription) 'SKUDescription',
	OL.iQuantity as 'Qty',
	OL.flgLineStatus as 'Line Status',
	(case when O.flgPrinted=0 then 'No' else 'Yes' end) as 'Print Status'
FROM tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblSKULocation SL on OL.ixSKU=SL.ixSKU and SL.ixLocation=99
	left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
	left join tblTime T on O.ixOrderTime=T.ixTime
	left join tblShipMethod SM ON SM.ixShipMethod = O.iShipMethod
WHERE  O.sOrderStatus = 'Open'
    and O.ixOrder in (select distinct (OL1.ixOrder) 
	                  from tblOrderLine OL1 
	                      left join tblSKULocation SL1 on SL1.ixSKU=OL1.ixSKU and SL1.ixLocation=99
		              where (SL1.sPickingBin like '%SHOCK%'
                             or 
                             SL1.sPickingBin = 'WOODS' -- added per SMIHD-13763
                            )
                      )
ORDER BY O.flgGuaranteedDeliveryPromised DESC
    , O.dtOrderDate, T.chTime, O.ixOrder, OL.iOrdinality
/*
SELECT distinct sPickingBin
FROM tblSKULocation SL1 
where SL1.sPickingBin like '%WOOD%'

SELECT distinct sPickingBin 
FROM tblSKULocation SL1 
where sBin = 'WOODS'

SELECT * from tblBin
where ixBin = 'WOODS'
*/


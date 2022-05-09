 -- SKUs & Quantities required for 11/18/10 to 12/02/10
select
	OL.ixSKU            ixSKU,
	SKU.sDescription    SKUDescription,
    SKU.iLength         Length,
    SKU.iWidth          Width, 
    SKU.iHeight         Height,
	SKU.dWeight         Weight,
  	SKU.flgShipAloneStatus ShipAlone,
    SubString(BS.sPickingBin,1,1)  BinType,
    PGC.ixMarket        Market,
	SKU.ixPGC           PGC,
    SKU.iMaxQOS	        MaxQOS,
    SKU.iCartonQuantity	CartonQTY,
    sum(OL.iQuantity)   QTYRequired
from
	tblOrderLine OL
	left join tblSKU SKU    on OL.ixSKU = SKU.ixSKU
	left join tblOrder O    on OL.ixOrder = O.ixOrder
    left join tblBinSKU BS  on BS.ixSKU = SKU.ixSKU
    left join tblPGC PGC    on PGC.ixPGC = SKU.ixPGC
    left join PJC_OptShipOrgXRef XR on XR.ixOrder = O.ixOrder
where
	 (O.sShipToCountry is Null
      OR O.sShipToCountry like 'US%')
	and XR.mOptimumShipOrigination = 'Booneville'
	and O.dtOrderDate >= '11/01/10' and O.dtOrderDate <= '11/21/10'
	--and O.dtOrderDate >= '11/18/09' and O.dtOrderDate <= '12/02/09'
group by
	OL.ixSKU,
	SKU.sDescription,
    SKU.iLength,
    SKU.iWidth, 
    SKU.iHeight,
	SKU.dWeight,
  	SKU.flgShipAloneStatus,
    SubString(BS.sPickingBin,1,1),
    PGC.ixMarket,
	SKU.ixPGC,
    SKU.iMaxQOS,
    SKU.iCartonQuantity




/*
select getdate() CurrentDateTimeStamp,count(*) Quant, flgShipAloneStatus
from tblSKU
group by flgShipAloneStatus
order by count(*)

CurrentDateTimeStamp	Quant	flgShipAloneStatus
2010-11-21 12:37:15.357	3935	1
2010-11-21 12:37:15.357	10238	NULL
2010-11-21 12:37:15.357	53824	0


select getdate() CurrentDateTimeStamp,count(*) Quant, iLength
from tblSKU
group by iLength
order by count(*) desc
*/

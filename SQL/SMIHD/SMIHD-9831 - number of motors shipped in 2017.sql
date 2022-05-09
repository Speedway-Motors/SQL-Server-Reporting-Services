-- SMIHD-9831 - number of motors shipped in 2017

SELECT SUM(OL.iQuantity) 'CrateEngines'
	,SM.sDescription 'ShipMethod'
	--OL.iQuantity, OL.mUnitPrice OL.mExtendedPrice
from tblOrder O
	join tblOrderLine OL on O.ixOrder = OL.ixOrder
	join tblSKU S on S.ixSKU = OL.ixSKU
	join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where O.dtShippedDate between '01/01/2017' and '12/31/2017'
	and S.sSEMAPart = 'Crate Engines'
	and O.sOrderStatus = 'Shipped'
   -- and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
GROUP BY SM.sDescription
order by O.iShipMethod
/*
SHIP		CRATE
METHOD		ENGINES
=========	=======
Best Way	665 +4 for internal orders
Counter		103 +5 for internal orders
UPS Ground    2	
*/

select * from tblShipMethod

SELECT S.ixSKU, S.sDescription,
S.iLength, S.iWidth, S.iHeight, S.dDimWeight, S.dWeight
FROM tblSKU S
where S.flgDeletedFromSOP = 0
	and sSEMAPart = 'Crate Engines'
order by S.dDimWeight


SELECT S.ixSKU, S.dtCreateDate, S.dtDiscontinuedDate, isnull(S.sWebDescription,S.sDescription) 'SKUDescription' 
FROM tblSKU S
where ixSKU in ('91532383.1','91532496.1','91599347','91599350','91599392','91057347','91619318604.GS','106QM550','106QM551','106QM552','106QM553','106QM554')


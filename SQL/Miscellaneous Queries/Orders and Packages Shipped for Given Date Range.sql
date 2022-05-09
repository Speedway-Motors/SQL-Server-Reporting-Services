select
	O.iShipMethod as 'Ship Method',
	count (distinct O.ixOrder) as 'Orders Shipped',
	count(1) as 'Packages Shipped'
from
	tblPackage P
	left join tblOrder O on P.ixOrder = O.ixOrder
	left join tblDate D on D.ixDate = P.ixShipDate
where
	D.dtDate >= '01/26/11'
	and D.dtDate <= '01/30/11'
group by
	O.iShipMethod
order by
	O.iShipMethod
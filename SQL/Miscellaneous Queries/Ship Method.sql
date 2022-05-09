select iShipMethod, COUNT(*) QTY
from tblOrder
where iShipMethod in ('13','14','15')
    --and dtShippedDate = '10-21-2011'
group by iShipMethod
/*
iShipMethod	QTY    RptShows
13	        12      10
14	        75      28
*/


select
	O.iShipMethod as 'Ship Method',
    SM.sDescription,
	count (distinct O.ixOrder) as 'Orders Shipped',
	count(1) as 'Packages Shipped'
from
	tblPackage P
	left join tblOrder O on P.ixOrder = O.ixOrder
	left join tblDate D on D.ixDate = P.ixShipDate
         join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
where D.dtDate = '10/19/2011'
   and SM.ixShipMethod in ('13','14')
group by O.iShipMethod,SM.sDescription
order by O.iShipMethod

/*
Ship Method	sDescription	Orders Shipped	Packages Shipped
13	FedEx Ground	                    12	20
14	FedEx Home Delivery	                74	82
*/	

 
 
 
 
 

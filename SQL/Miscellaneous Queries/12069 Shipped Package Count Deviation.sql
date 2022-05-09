SELECT
	O.iShipMethod as 'Ship Method',
                SM.sDescription,
	count (distinct O.ixOrder) as 'Orders Shipped',
	count(1) as 'Packages Shipped'
FROM tblOrder O
	left join tblPackage P on P.ixOrder = O.ixOrder
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
	left join tblDate D on D.ixDate = P.ixShipDate
WHERE
	D.dtDate = '1/24/2012'
GROUP BY 
	O.iShipMethod,SM.sDescription
ORDER BY
	O.iShipMethod



SELECT
	P.ixShipper as 'Shipper',
	count(1) as 'Packages Shipped'
FROM tblOrder O
	left join tblPackage P on P.ixOrder = O.ixOrder
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
	left join tblDate D on D.ixDate = P.ixShipDate
WHERE
	D.dtDate = '1/24/2012'
GROUP BY 
	P.ixShipper
ORDER BY
	count(1) desc
	
select top 10 * from tblPackage	


select * from tblErrorLogMaster
where ixErrorCode = 'LBP'

select * from tblErrorCode


select * from tblPackage 
where ixShipper = 'LBP'
and ixShipDate = 16095


select ixDate from tblDate where dtDate = '01/24/2012'


select sTrackingNumber
from tblPackage
where ixShipDate = 16095
and ixShipper = 'TFW'


select * from tblPackage
where sTrackingNumber = '1Z6353580316822174'

select * from tblDate where ixDat



select * from tblPackage
where ixShipDate = 16095



sTrackingNumber in (select * from PJC_OrdersShipped012412perSOP)
and ixShipDate is NULL



-- Orders have ship dates but packages don't
select count(distinct (sTrackingNumber))
from tblPackage P
    join tblOrder O on O.ixOrder = P.ixOrder
where P.ixShipDate is NULL
and O.ixShippedDate is NOT NULL
--and O.dtOrderDate >= '01/01/2011' -- before 1st feed 33167   after 33184
order by sTrackingNumber

select count(O.ixOrder) 
from tblOrder O
    Left join tblPackage P on O.ixOrder = P.ixOrder
where P.ixShipDate is NULL
and O.ixShippedDate is NOT NULL



select count(P.ixOrder) 
from tblPackage P
    join tblOrder O on O.ixOrder = P.ixOrder
where P.ixShipDate is NULL
and O.ixShippedDate is NOT NULL
select ixOrder, dtOrderDate, sOrderStatus, sShipToCountry, sShipToZip, sOptimalShipOrigination, ixTimeLastSOPUpdate, isnumeric(sShipToZip) 'isnumeric'
from tblOrder
where ixOrder in ('709268','709350','707565','709378','709156','709221') -- 04/26/2013
/*
707565	2013-04-10 00:00:00.000	Shipped	CANADA	611
709156	2013-04-24 00:00:00.000	Shipped	CANADA	000
709221	2013-04-25 00:00:00.000	Shipped	CANADA	434
709268	2013-04-25 00:00:00.000	Shipped	CANADA	659
709350	2013-04-26 00:00:00.000	Shipped	BRAZIL	81870150
709378	2013-04-26 00:00:00.000	Shipped	UNITED KINGDOM	146
*/


select count(*) from tblOrder where dtOrderDate =  '04/29/2013'

select count(*) from tblOrder 
where dtDateLastSOPUpdate = '04/29/2013' --
--and ixTimeLastSOPUpdate >= 32000
    and ixTimeLastSOPUpdate >= 62000


-- Shipped AFCO Foreign orders since 2010  -- 1,310
select ixOrder, dtOrderDate, sOrderStatus, sShipToCountry, sShipToZip, sOptimalShipOrigination, ixTimeLastSOPUpdate, isnumeric(sShipToZip)
from tblOrder
where sShipToCountry <> 'US'
    and isnumeric(sShipToZip) = 1
    and dtOrderDate >= '01/01/2010'
    and sOrderStatus = 'Shipped'
order by sOrderStatus, sShipToZip





select * from tblTime where ixTime = '32000'
select * from tblTime where ixTime > '61200'



select ixOrder, dtOrderDate, sOrderStatus, sShipToCountry, sShipToZip, ixAuthorizationTime, ixTimeLastSOPUpdate
from tblOrder where sShipToCountry <> 'US'
AND dtOrderDate >= '01/01/2013'
and ixOrder <> '709248'
and sOrderStatus = 'Shipped'
and len(sShipToZip) > 5
--and sShipToZip = 'F'
order by sOrderStatus



select ixOrder, dtOrderDate, sOrderStatus, sShipToCountry, sShipToZip, ixAuthorizationTime, ixTimeLastSOPUpdate
from tblOrder where sShipToCountry <> 'US'
    and dtOrderDate >= '04/29/2012'
    and ixOrder <> '709248'
    and sOrderStatus = 'Shipped'
    and len(sShipToZip) between  6 and 7
order by sOrderStatus


select isnum

select * from tb


select * from tblTime where ixTime = 4


trUpdatesOptimalShipOrignation

select a.[name] as trgname, b.[name] as [tbname] 
from sys.triggers a join sys.tables b on a.parent_id = b.object_id
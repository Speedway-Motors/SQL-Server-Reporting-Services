-- Tableau missing package ship location info for 07-21-20

select * from tblPackage
where ixShipDate = 19195

select ixPrimaryShipLocation, count(*) 'OrdCnt'
from tblOrder
where dtShippedDate = '07/21/20'
group by ixPrimaryShipLocation
/*
Primary
Ship
Location	OrdCnt
20	        32
47	        16
85	        338
99	        3132
*/

select ixPrimaryShipLocation, count(P.sTrackingNumber) 'PkgCnt'
from tblOrder O
    left join tblPackage P on O.ixOrder = P.ixOrder
where dtShippedDate = '07/21/20'
and P.flgCanceled = 0
and P.flgReplaced = 0
group by ixPrimaryShipLocation
/*
Primary
Ship
Location	PkgCnt
47	        16
85	        334
99	        3469
*/
-- 3,726 pkgs Tableau
-- 3,819 pkgs SMIReporting




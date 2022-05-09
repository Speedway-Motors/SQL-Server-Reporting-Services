-- Case 25903 - Package TNT analysis for CLC

select distinct ixZipCode from tblTrailerZipTNT -- 99... all are zips starting with 967,998,999
where iTNT > 6



select ixZipCode, MIN(iTNT) -- when placed on optimal trailers the above 99 zips all have a TNT of 4 days
from tblTrailerZipTNT
where ixZipCode in ('96703','96704','96705','96708','96710','96713','96714','96715','96716','96718','96719','96720','96721','96722','96725','96726','96727','96728','96729','96732','96733','96737','96738','96739','96740','96741','96742','96743','96745','96746','96747','96748','96749','96750','96751','96752','96753','96754','96755','96756','96757','96760','96761','96763','96764','96765','96766','96767','96768','96769','96770','96771','96772','96773','96774','96776','96777','96778','96779','96780','96781','96783','96784','96785','96788','96790','96793','96796','99801','99802','99803','99811','99812','99820','99821','99824','99825','99826','99827','99829','99830','99832','99835','99836','99840','99841','99850','99901','99903','99918','99919','99921','99922','99923','99925','99926','99927','99928','99950')
group by ixZipCode
order by MIN(iTNT)


/**** Package counts by TNT days   *****/

-- (Apr 2014 thru Mar 2015)
select P.ixShipTNT, count(P.sTrackingNumber) PkgCount --, P.ixShipDate, D.dtDate 'ShippedDate', P.ixShipTNT
FROM tblPackage P
    left join tblDate D on P.ixShipDate = D.ixDate
WHERE P.ixShipDate between 16893 and 17257 -- (Apr 2014 thru Mar 2015)
and P.ixOrder in (select ixOrder from tblOrder where sOrderStatus = 'Shipped')
GROUP BY P.ixShipTNT
order by P.ixShipTNT desc

-- March 2015
select P.ixShipTNT, count(P.sTrackingNumber) PkgCount --, P.ixShipDate, D.dtDate 'ShippedDate', P.ixShipTNT
FROM tblPackage P
    left join tblDate D on P.ixShipDate = D.ixDate
WHERE P.ixShipDate between 17227 and 17257 -- March 2014
and P.ixOrder in (select ixOrder from tblOrder where sOrderStatus = 'Shipped')
GROUP BY P.ixShipTNT
order by P.ixShipTNT desc

-- March 2014
select P.ixShipTNT, count(P.sTrackingNumber) PkgCount --, P.ixShipDate, D.dtDate 'ShippedDate', P.ixShipTNT
FROM tblPackage P
    left join tblDate D on P.ixShipDate = D.ixDate
WHERE P.ixShipDate between 16862 and 16892 -- March 2014
and P.ixOrder in (select ixOrder from tblOrder where sOrderStatus = 'Shipped')
GROUP BY P.ixShipTNT
order by P.ixShipTNT desc

select * from tblDate where dtDate in ('03/01/2015','03/31/2015')
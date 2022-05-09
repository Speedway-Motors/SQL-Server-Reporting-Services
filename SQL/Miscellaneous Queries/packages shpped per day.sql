-- packages shpped per day

select ixShipDate, COUNT(sTrackingNumber)
from tblPackage
where ixShipDate >= 17356
    and flgCanceled = 0
group by ixShipDate
having COUNT(sTrackingNumber) > 4000
order by ixShipDate
/* RESULTS from 7-7-2016
653,400 packages shipped previous year
  1,820 avg/day
  <0.1% cancelled (only 480 for prev year)
  
  
select * from tblDate where ixDate in (17592,17606,17634,17649,17719)

/* busiest ship dates

Pkgs    ixShipDate
4,183   17592	MONDAY	2016-02-29
4,125   17606	MONDAY	2016-03-14
4,342   17634	MONDAY	2016-04-11
4,163   17649	TUESDAY	2016-04-26
4,029   17719	TUESDAY	2016-07-05

*/

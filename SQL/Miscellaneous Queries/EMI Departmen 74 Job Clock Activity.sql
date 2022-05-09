-- EMI Departmen 74 Job Clock Activity

select SUM(O.mMerchandise) Sales,
    SUM(O.mMerchandiseCost) Cost,
  (SUM(O.mMerchandise) -  SUM(O.mMerchandiseCost)) GP
from tblOrder O
left join vwEagleOrder EO on EO.ixOrder = O.ixOrder
WHERE     O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2015' and '08/31/2015'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
    and EO.ixOrder is NOT NULL
/*
Sales	    Cost	        GP
76,267,076	43,148,417	33,118,659  -- Combined
75,426,747	42,609,608	32,817,138  -- non-EMI
   840,329	   538,808	   301,520  -- EMI
                 (1.1%)     (0.91%)
*/


select * from tblJobClock
where ixEmployee in ('MAL','MAL1','MAL2','AJB','KDL','JTM')
and dtDate >= '09/14/2015'

SELECT dtDate, ixEmployee, sJob, iStartTime, iStopTime, (iStopTime-iStartTime) 'TotSec'
from tblJobClock 
where ixEmployee in ('MAL','MAL1','MAL2','AJB','KDL','JTM')
and dtDate >= '09/14/2015'
order by ixEmployee, dtDate



SELECT JC.dtDate, JC.ixEmployee, JC.sJob, J.sDescription, JC.iStartTime, JC.iStopTime, (JC.iStopTime-JC.iStartTime) 'TotSec'
from tblJobClock JC
    LEFT JOIN tblJob J on JC.sJob = J.ixJob
where ixEmployee in ('MAL','MAL1','MAL2','AJB','KDL','JTM')
and dtDate >= '09/14/2015'
order by ixEmployee, dtDate


SELECT JC.ixEmployee, CONVERT(VARCHAR(10), JC.dtDate, 101) AS 'Date    ',
JC.sJob, J.sDescription, --(JC.iStopTime-JC.iStartTime) 'TotSec',
(JC.iStopTime-JC.iStartTime)*1.0/3600 'Hours'
from tblJobClock JC
    LEFT JOIN tblJob J on JC.sJob = J.ixJob
where ixEmployee in ('MAL','MAL1','MAL2','AJB','KDL','JTM')
and dtDate >= '09/14/2015'
and ((JC.iStopTime-JC.iStartTime)*1.0/3600) > 0
order by ixEmployee


SELECT JC.ixEmployee, CONVERT(VARCHAR(10), JC.dtDate, 101) AS 'Date    ',
JC.sJob, J.sDescription, --(JC.iStopTime-JC.iStartTime) 'TotSec',
(JC.iStopTime-JC.iStartTime)*1.0/3600 'Hours'
from tblJobClock JC
    LEFT JOIN tblJob J on JC.sJob = J.ixJob
where sJob like '74%'
and dtDate >= '09/17/2015'
and ((JC.iStopTime-JC.iStartTime)*1.0/3600) > 0
order by ixEmployee


SELECT JC.ixEmployee, SUM((JC.iStopTime-JC.iStartTime)*1.0/3600), -- CONVERT(VARCHAR(10), JC.dtDate, 101) AS 'Date    ',
JC.sJob, J.sDescription --(JC.iStopTime-JC.iStartTime) 'TotSec',
--(JC.iStopTime-JC.iStartTime)*1.0/3600 'Hours'
from tblJobClock JC
    LEFT JOIN tblJob J on JC.sJob = J.ixJob
where sJob like '74%'
and dtDate >= '09/14/2015'
and ((JC.iStopTime-JC.iStartTime)*1.0/3600) > 0
group by JC.ixEmployee, JC.sJob, J.sDescription
order by ixEmployee


select * from tblJob
where ixJob = 'BLT'


select * from tblJob
where ixJob like '74-%'
--in ('74-1','70-1','BLT')

select * from tblSKUTransaction 
where sUser in ('MAL','MAL1','MAL2','AJB','JTM') -- 'KDL',
and ixDate >= 17380 --'08/01/2015'
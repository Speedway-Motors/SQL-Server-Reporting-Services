-- SMIHD-15845 - Restock Dashboard
select * from tblJob
where ixJob like '41%'
order by sJobSort
/*
ixJob	sDescription
41-1	AZ Transfer
41-2	Truck Unloading
41-3	Transfer Breakdown
41-4	Carousel Putaway
41-5	Battleship Putaway
41-6	Deltap Putaway

41-11	Audit
41-12	Returns Putaway
41-13	Misc Non Production
41-14	Cleaning/Restock
41-15	Break
*/


select sJob, SUM(iStopTime-
from tblJobClock
where sJob  in ('41-3','41-4','41-5','41-6') --1,3-6 11,13-15
    and ixDate >= 19288	--10/21/2020
order by sJob, dtDate desc


SELECT DTJT.ixEmployee
    , dtDate
   -- , E.sFirstname + ' ' + E.sLastname AS Name
   --, DTJT.ixDepartment 
   --  , DTJT.sJobSort
     , DTJT.sJob 
     , DTJT.JobDescription
     , FORMAT(SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)),'###.##') AS Hours 
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee 
WHERE dtDate BETWEEN '11/05/2020' and '11/09/2020' --@StartDate AND @EndDate 
 -- AND DTJT.ixEmployee IN ('REZ','RRA','CQL','DGM','ABB1')
  AND DTJT.sJob in ('41-1','41-15',    '41-3','41-4','41-5','41-6')
GROUP BY DTJT.ixEmployee,
        dtDate
      -- , E.sFirstname + ' ' + E.sLastname 
      -- , DTJT.ixDepartment 
       , DTJT.sJob
       , DTJT.sJobSort
       , DTJT.JobDescription 
ORDER BY dtDate, DTJT.sJobSort -- , DTJT.ixEmployee
/*
Emp	dtDate	    Job		JobDescription	    Hours
CLQ	2020-11-04 41-3	3	Transfer Breakdown	3.6488888

REZ	2020-11-04 41-4	4	Carousel Putaway	5.5361111
RRA	2020-11-04 41-5	5	Battleship Putaway	2.0816666
RRA	2020-11-04 41-6	6	Deltap Putaway	    3.7011111
*/

select ixDate, sUser, ixJob, count(sCID)'CIDs'
from tblSKUTransaction
where ixDate = 19305--	11/06/2020
    and sUser in ('CLQ','REZ','RRA','RRA') 
    and sCID is NOT NULL 
group by  ixDate, sUser, ixJob



select ixDate,	sUser,	ixSKU,	iQty,	sBin,	sToBin,	sCID,	ixJob,	sTransactionInfo,	sTransactionType
from tblSKUTransaction
where ixDate >=  19303--	11/06/2020
    and sCID is NOT NULL 
    and ixJob in  ('41-4') --,'41-4','41-5','41-6')
order by sTransactionInfo

select ixDate,	sUser,	ixSKU,	iQty,	sBin,	sToBin,	sCID,	ixJob,	sTransactionInfo,	sTransactionType
from tblSKUTransaction
where ixDate =  19303--	11/06/2020
    and sCID is NOT NULL 
    and ixJob in  ('41-4') --,'41-4','41-5','41-6')
order by sTransactionInfo





-- (3) Transfer Breakdown
select sTransactionInfo, FORMAT(count(distinct sCID),'###,###') CIDs
from tblSKUTransaction
where ixDate = 19308     --between 19299 and 19307 --	11/01 to 11/09
    and sCID is NOT NULL 
    and ixJob in  ('41-3') 
group by sTransactionInfo

-- (4) Carousel Putaway
select sTransactionInfo, FORMAT(count(distinct sCID),'###,###') CIDs
from tblSKUTransaction
where ixDate = 19308     --between 19299 and 19307 --	11/01 to 11/09
    and sCID is NOT NULL 
    and ixJob in  ('41-4')
group by sTransactionInfo
order by sTransactionInfo


-- (5) Battleship Putaway
select sTransactionInfo, FORMAT(count(distinct sCID),'###,###') CIDs
from tblSKUTransaction
where ixDate = 19308     --between 19299 and 19307 --	11/01 to 11/09
    and sCID is NOT NULL 
    and ixJob in  ('41-5')
group by sTransactionInfo
order by sTransactionInfo

-- (6) Delta Putaway
select sTransactionInfo, FORMAT(count(distinct sCID),'###,###') CIDs
from tblSKUTransaction
where ixDate = 19308     --between 19299 and 19307 --	11/01 to 11/09
    and sCID is NOT NULL 
    and ixJob in  ('41-6')
group by sTransactionInfo
order by sTransactionInfo

-- all other 41% jobs
select ixJob, sTransactionInfo, FORMAT(count(distinct sCID),'###,###') CIDs
from tblSKUTransaction
where ixDate = 19308     --between 19299 and 19307 --	11/01 to 11/09
    and sCID is NOT NULL 
    and ixJob like  ('41-%') --,'41-4','41-5','41-6')
    and ixJob NOT IN ('41-3','41-4','41-5','41-6')
group by ixJob, sTransactionInfo
order by ixJob, sTransactionInfo



select *
from tblSKUTransaction
where ixDate = 19304--	11/06/2020
and ixJob in  ('41-3') --,'41-4','41-5','41-6')
and sUser in ('CLQ')
and sCID is NOT NULL
order by sUser



and sUser in ('CLQ') --('CLQ','REZ','RRA','RRA')




select *
from tblSKUTransaction
where ixDate = 19302--	11/04/2020
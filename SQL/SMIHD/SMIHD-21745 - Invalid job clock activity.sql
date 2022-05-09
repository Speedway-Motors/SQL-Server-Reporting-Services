-- SMIHD-21745 - Invalid job clock activity

-- select * from tblDepartment

-- recent blank or invalid jobs
SELECT sJob,  
     SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) 'Hours',
     JobDescription, sJobSort
     -- ,E.ixDepartment
FROM vwDailyTotJobTime DTJT
    LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
WHERE /* DTJT.ixEmployee =  'AAF2'
AND*/ DTJT.dtDate BETWEEN '04/21/2021' AND '04/26/2021' -- '01/01/2021' AND '12/31/2021'
 AND len(sJob) < 6
AND sJobSort is NULL
GROUP BY sJob, JobDescription, sJobSort--, E.ixDepartment
HAVING SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) > .16 -- 600 seconds
ORDER BY JobDescription
    --E.ixDepartment
-- 43 85 87


select D.ixDepartment, D.sDescription, COUNT(E.ixEmployee) 'EmpCnt'
from tblEmployee E
    left join tblDepartment D on D.ixDepartment = E.ixDepartment
where --E.flgCurrentEmployee = 1
   -- and 
   D.sDescription like 'U%'
group by D.ixDepartment, D.sDescription
order by D.ixDepartment, D.sDescription


-- most recent activity with weird chars
select * from tblJobClock
where len (sJob) = 0
and dtDate > '04/01/2022'
order by dtDate desc

select * from tblJobClock
where sJob like '90-%'
order by dtDate desc

select * from tblDepartment where sDescription like 'B%'
/*
ixDepartment	sDescription
8	            B&J Realtors
10	            B&J Administration
*/
select * from tblDepartment where sDescription like 'H%' -- 18	HR

select * from tblEmployee where flgCurrentEmployee = 1 and ixDepartment = 18




select D.ixDepartment 'Dept', D.sDescription 'DeptName', COUNT(E.ixEmployee) 'CurentEmployees'
from tblEmployee E
    left join tblDepartment D on D.ixDepartment = E.ixDepartment
where E.ixDepartment in (8,10,90)
    AND E.flgCurrentEmployee = 1
group by D.ixDepartment, D.sDescription
order by D.ixDepartment, D.sDescription
/*
Dept	DeptName	        CurentEmployees
8	    B&J Realtors	    2
10	    B&J Administration	9
90	    UNKNOWN	            1
*/

select * from tblJobClock
where ixEmployee in ('AAF1','DKN','EMB','GJS1','JMZ1','KJK1','MLZ','RJB')
order by dtDate desc


select E.ixEmployee, E.sFirstname, E.sLastname, D.ixDepartment 'Dept', D.sDescription 'DeptName'--, COUNT(E.ixEmployee) 'CurentEmployees'
from tblEmployee E
    left join tblDepartment D on D.ixDepartment = E.ixDepartment
where E.ixDepartment in (8,10,90)
    AND E.flgCurrentEmployee = 1
order by D.ixDepartment, sLastname





-- recent examples of "blank" job clock activity
SELECT DTJT.*
    /*sJob,  
     SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) 'Hours',
     JobDescription, sJobSort
     ,E.ixDepartment
     */
FROM vwDailyTotJobTime DTJT
    LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
WHERE /* DTJT.ixEmployee =  'AAF2'
AND*/ DTJT.dtDate BETWEEN '06/01/2021' AND '12/31/2021' -- '01/01/2021' AND '12/31/2021'
    AND len(sJob) < 4
    AND sJobSort is NULL 
    AND sJob <> 'BLT'
    ANd sJob ='' -- excluding "blank" jobs
   and E.ixEmployee = 'LAH1'
ORDER BY ixDate desc


SELECT DTJT.*,
    D.sDescription 'DeptDescription'
    /*sJob,  
     SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) 'Hours',
     JobDescription, sJobSort
     ,E.ixDepartment
     */
FROM vwDailyTotJobTime DTJT
    LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
    LEFT JOIN tblDepartment D on E.ixDepartment = D.ixDepartment
WHERE /* DTJT.ixEmployee =  'AAF2'
AND*/ DTJT.dtDate BETWEEN '06/22/2021' AND '12/31/2021' -- '01/01/2021' AND '12/31/2021'
    AND sJob = 'BLT'
ORDER BY ixEmployee





select * from tblJobClock
where dtDate = '06/13/2021'
and ixEmployee = 'LAH1'
order by iStartTime

select * from tblJob
where ixJob like '87-%'

ixJob	sDescription
87-1	Small Pack Morning Duties
87-2	SP Verify
87-3	SP Pack
87-4	SP Ship
87-5	Truck Loading
87-6	Break
87-7	Cleaning/Restock
87-8	Non Production Misc
87-9	Returns/Misc

select chTime from tblTime where ixTime in (42697,44862)

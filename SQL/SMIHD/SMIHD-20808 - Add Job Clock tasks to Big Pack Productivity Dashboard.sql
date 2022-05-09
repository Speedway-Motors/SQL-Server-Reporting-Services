-- SMIHD-20808 - Add Job Clock tasks to Big Pack Productivity Dashboard

SELECT sJob, count(*) 'RecCnt'
FROM tblJobClock
where ixDate >= 19653--	10/11/2021
    and sJob in ('85-13','85-14','85-15')
group by sJob
order by sJob
/*
sJob	RecCnt
85-13	22
85-14	21
85-15	26
*/


select * from tblJob
where ixJob like '85-%'
order by sJobSort
/*
ixJob	sDescription
85-13	Cart Unload
85-14	Singles Pulling
85-15	Team Lead Duties
*/

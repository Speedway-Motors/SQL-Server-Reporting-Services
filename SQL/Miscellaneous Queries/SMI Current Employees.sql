select * from tblEmployee where flgCurrentEmployee = 1
order by sFirstname, sLastname



select ixEmployee, sLastname, sFirstname, ixDepartment, sPayrollId, flgCurrentEmployee
from tblEmployee
where ixEmployee in ('SSU')
order by sFirstname, sLastname

select ixEmployee, count(*) QTY
from tblJobClock where ixEmployee in ('JKM','jcm',  'SSU','KPS','KTS','TEB','TEB1')
group by ixEmployee
order by ixEmployee

select ixEmployee, count(*) QTY
from tblTimeClock where ixEmployee in ('JKM','jcm','SSU','KPS','KTS','TEB','TEB1')
group by ixEmployee
order by ixEmployee



delete from tblEmployee where ixEmployee in ('JKM','KPS','TEB1')

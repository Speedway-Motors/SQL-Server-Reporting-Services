-- SMIHD-17505 - AFCO - Warehouse Productivity dashboards

select * from tblJob  -- AFCO has no Job table!?!

select top 50 *
from tblJobClock
where ixDate = 19191
order by newid()

select distinct *
from tblJob
where ixJob in (select sJob
                from tblJobClock
                where ixDate >= 19103 -- 04/19/2020    138 different job activities for 45 different departments
                and ixDepartment in (24,41,42,43,80,81,82,84,85,87,89)
                )
order by ixJob

select * from tblDepartment
where --sDescription <> 'UNKNOWN'
ixDepartment in (24,41,42,43,80,81,82,84,85,87,89)
/****   SMI   ****
24	Returns (main level)

41	AZ - Transfer
42	AZ - Picking
43	AZ - Outbound

80	Warehouse
81	Warehouse - Receiving
82	Warehouse - Restock
84	Warehouse - Carousel
85	Warehouse - Big Pack
87	Warehouse - Small Pack

89	Warehouse - Truck
*/

select * from tblDepartment
where sDescription <> 'UNKNOWN'
/****   AFCO   ****
24	Returns (main level)

41	AZ - Transfer
42	AZ - Picking
43	AZ - Outbound

80	Warehouse
81	Warehouse - Receiving
82	Warehouse - Restock
84	Warehouse - Carousel
85	Warehouse - Big Pack
87	Warehouse - Small Pack

89	Warehouse - Truck
*/


select distinct SUBSTRING(sJob,1,5), count(*)
from tblJobClock
where ixDate between 19162 and 19191 -- 06/17/2020 to 07/16/2020    
group by SUBSTRING(sJob,1,5)
having count(*) > 10
order by SUBSTRING(sJob,1,5)
-- 2,112 distinct sJob values!?!
-- using substring...aprox. 32 potential dept job clock activities?
/*
06-1
15-1
17-1
30-1
30-7
40-1
40-9
41-1
42-1
42-9
45-1
50-1
55-1
55-2
55-6
55-7
55-9
60-1
71-1
71-10
71-2
72-1
74-1
75-1
76-1
77-1
80-1
80-10
80-3
82-1
85-1
89-1
*/




select distinct SUBSTRING(sJob,1,5), count(*)
from tblJobClock
where ixDate between 19162 and 19191 -- 06/17/2020 to 07/16/2020    
group by SUBSTRING(sJob,1,5)
having count(*) > 10
order by SUBSTRING(sJob,1,5)
-- Terminations
select E.ixEmployee, E.sFirstname, E.sLastname  
    ,E.ixDepartment 
    ,D.sDescription
    ,E.dtTerminationDate
    ,E.dtHireDate, E.dtDateLastSOPUpdate
    ,E.flgCurrentEmployee , E.flgPartTime, E.flgExempt
from tblEmployee E
    left join tblDepartment D on E.ixDepartment = D.ixDepartment
where flgDeletedFromSOP = 0
    and dtTerminationDate >= '04/01/2020'
    and E.ixDepartment NOT IN (2,3,4,5,6,7,8,9,10,17,18,20,21,22,23,24,25,26,27,28,29,40,45,47,50,55,70,71,72,73,74,80,81,82,84,85,87,88,89)
order by E.dtTerminationDate desc, E.ixDepartment, E.ixEmployee


-- QTY of Terms by Dept
select E.ixDepartment, D.sDescription, COUNT(E.ixEmployee) QtyTerms
from tblEmployee E
    left join tblDepartment D on E.ixDepartment = D.ixDepartment
where flgDeletedFromSOP = 0
    and dtTerminationDate >= '01/01/2020'
    and E.ixDepartment NOT IN (2,3,4,5,6,7,8,9,10,17,18,20,21,22,23,24,25,26,27,28,29,40,45,47,50,55,70,71,72,73,74,80,81,82,84,85,87,88,89)
group by E.ixDepartment, D.sDescription    
order by E.ixDepartment, D.sDescription


-- Terms by Year
select DT.iYear, COUNT(E.ixEmployee) QtyTerms
    -- D.ixDepartment, D.sDescription, 
from tblEmployee E
    left join tblDepartment D on E.ixDepartment = D.ixDepartment
    left join tblDate DT on DT.ixDate = E.ixTerminationDate
where flgDeletedFromSOP = 0
    and dtTerminationDate >= '01/01/2011'
    and E.ixDepartment NOT IN (2,3,4,5,6,7,8,9,10,17,18,20,21,22,23,24,25,26,27,28,29,40,45,47,50,55,70,71,72,73,74,80,81,82,84,85,87,88,89)
group by DT.iYear   
order by DT.iYear desc
/*      Qty
iYear	Terms
=====   =====
2019    11
2018    9
2017	68      <-- 1/1/17-8/30/17 ... proj 102 by EOY
2016	105 \
2015	104  \
2014	86    \ avg 92/yr
2013	84    / 
2012	100  /
2011	72  /
*/

select DT.iYear, DT.iQuarter, COUNT(E.ixEmployee) QtyTerms
    -- D.ixDepartment, D.sDescription, 
from tblEmployee E
    left join tblDepartment D on E.ixDepartment = D.ixDepartment
    left join tblDate DT on DT.ixDate = E.ixTerminationDate
where flgDeletedFromSOP = 0
    and dtTerminationDate >= '01/01/2011'
    and E.ixDepartment NOT IN (2,3,4,5,6,7,8,9,10,17,18,20,21,22,23,24,25,26,27,28,29,40,45,47,50,55,70,71,72,73,74,80,81,82,84,85,87,88,89)
group by DT.iYear, DT.iQuarter    
order by DT.iYear, DT.iQuarter


select * from tblDepartment
where sDescription <> 'UNKNOWN'
/*
0	Catchall
1	Advertising
2	Accounting
3	Fiberglass
4	Ebay Customer Service
5	Discontinued
6	Engineering
7	Machine Shop
8	B&J Realtors
9	Speedway Properties
10	B&J Administration
11	Marketing/Ecomm
13	Creative/Adv
14	QC
15	IT
17	Shop
18	HR

20	Call Center - Sales
21	Counter Sales
22	Call Center - Customer Service
23	Call Center - International Sales
24	Returns (main level)
25	Call Center - CC Auth
26	Call Center - Supervisors
27	Call Center - Administration
28	Call Center - Blue Diamond
29	Call Center - QA/Training

40	Blue Diamond?
45	Mr Roadster
47	Afco Employee SOP accounts
50	Pro Racer
55	Museum
60	Misc
70	Garage Sale
71	Trackside Support
72	Shock Dept
73	Dyno Test
74	EAGLE

80	Warehouse
81	Warehouse - Receiving
82	Warehouse - Restock
83	Discontinued
84	Warehouse - Battleship
85	Warehouse - Big Pack
87	Warehouse - Small Pack

88	BOM

89	Warehouse - Truck
90	Speedway Properties
99	Discontinued
*/


select * from tblEmployee
where flgDeletedFromSOP = 0
and flgCurrentEmployee = 1
and ixDepartment = 12

SELECT * from tblEmployee where sPayrollId = '1126'




select * 
from tblEmployee
where dtTerminationDate >= '01/01/2018' -- 9
    and ixDepartment not in (2,3,4,5,6,7,8,9,10,17,18,20,21,22,23,24,25,26,27,28,29,40,45,47,50,55,70,71,72,73,74,80,81,82,84,85,87,88,89)


select * 
from tblEmployee
where dtTerminationDate between '01/01/2017' and '12/31/2017' -- 10
    and ixDepartment not in (2,3,4,5,6,7,8,9,10,17,18,20,21,22,23,24,25,26,27,28,29,40,45,47,50,55,70,71,72,73,74,80,81,82,84,85,87,88,89)


select * from tblDepartment
where ixDepartment not in (2,3,4,5,6,7,8,9,10,17,18,20,21,22,23,24,25,26,27,28,29,40,45,47,50,55,70,71,72,73,74,80,81,82,84,85,87,88,89)
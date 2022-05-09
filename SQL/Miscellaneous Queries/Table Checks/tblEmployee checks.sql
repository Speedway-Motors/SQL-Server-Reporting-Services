-- tblEmployee checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblEmployee%'
--  ixErrorCode	sDescription
--  1125	    Failure to update tblEmployee

-- ERROR COUNTS by Day
    SELECT --dtDate, 
        DB_NAME() AS 'DB          '
        ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1125'
      and dtDate >=  DATEADD(dd, -7, getdate())  -- past X months '05/06/2014'
    GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc
/*
DB          	Date    	ErrorQty
SMI Reporting	01/06/2016	5
SMI Reporting	10/19/2015	5
SMI Reporting	08/21/2015	5
SMI Reporting	08/04/2015	10
SMI Reporting	05/18/2015	10
SMI Reporting	01/19/2015	5
SMI Reporting	03/05/2014	5
SMI Reporting	03/04/2014	2
SMI Reporting	03/03/2014	4
SMI Reporting	02/24/2014	1
SMI Reporting	01/31/2014	3
SMI Reporting	01/17/2014	18
SMI Reporting	01/10/2014	2
**/

/************************************************************************/
-- TABLE GROWTH
exec spGetTableGrowth tblEmployee
/*
DB          	TABLE       	Rows   	Date
SMI Reporting	tblEmployee	1453	01-01-16
SMI Reporting	tblEmployee	1420	07-01-15
SMI Reporting	tblEmployee	1301	01-01-15
SMI Reporting	tblEmployee	1282	01-01-14
SMI Reporting	tblEmployee	1168	01-01-13
SMI Reporting	tblEmployee	1090	04-01-12
*/
                                 
select * from tblEmployee
where dtDateLastSOPUpdate < '08/03/2015'                                 

select flgCurrentEmployee, count(*) Qty 
from tblEmployee 
group by flgCurrentEmployee
/*
                flg     flg
DATE             0       1
==========      =====   ====
08-03-2015      1,008   419
05-07-2014        884   347
09-11-2013        917   344
08-05-2013        878   358
*/


select *
-- distinct sError 
from tblErrorLogMaster -- 15 errors YTD.. 5 unique
where dtDate >= '05/01/2016'
    and ixErrorCode = 1125    
order by    sError 
/*
sError
Employee CJN
Employee DSB
Employee JMM1
Employee JWM
Employee MGA
*/




select * from tblEmployee
where ixEmployee in ('DMB','DMG1')

-- PayrollId assigned to multiple ixEmployees
select sPayrollId, count(*) 'Qty'
from tblEmployee
where flgDeletedFromSOP = 0
group by sPayrollId
HAVING count(*) > 1
order by count(*) desc
/*
sPayroll
Id	    Qty
NULL	60
1265	3
1999	2
2777	2
2817	2
3473	2
9117	2
9999	2
*/

select * from tblEmployee where sPayrollId in ('2000','1265','9117','9999','1999','2555','3242','3259','2817','2575','1006','2713','2777')
order by sPayrollId, ixEmployee




select *
from tblEmployee 
where flgCurrentEmployee =1 -- 358    15 in properties
and (dtDateLastSOPUpdate < '08/05/2013'
     or dtDateLastSOPUpdate is NULL)


select * from tblEmployee 
where (dtDateLastSOPUpdate < '08/05/2013' -- 1,028
     or dtDateLastSOPUpdate is NULL)



-- Departments & Employee counts
select count(E.ixEmployee) 'Qty', 
    E.ixDepartment Dpt, 
    D.sDescription 'Description'
from tblEmployee E
    left join tblDepartment D on D.ixDepartment = E.ixDepartment
where E.flgCurrentEmployee = 1
group by E.ixDepartment, D.sDescription
order by count(E.ixEmployee) desc
/*
Qty	Dpt	sDescription
49	20	Call Center - Sales
28	1	Advertising
21	87	Warehouse - Pack Mez
21	84	Warehouse - Picking
20	15	IT
18	81	Warehouse - Receiving
15	9	Speedway Properties
14	7	Machine Shop
13	55	Museum
12	85	Warehouse - Big Pack
11	26	Call Center - Supervisors
11	0	Catchall
10	6	Engineering
9	80	Warehouse
8	82	Warehouse - Restock
8	3	Fiberglass
7	22	Call Center - Customer Service
7	90	Discontinued
6	2	Accounting
5	28	Call Center - Blue Diamond
5	70	Garage Sale
5	21	Counter Sales
5	14	QC
5	17	Museum
4	29	Call Center - QA/Training
4	25	Call Center - International Sales
3	24	Call Center - Mr Roadster
3	99	Speedway Properties
3	72	Shock Dept
2	50	Pro Racer
2	45	Mr Roadster
2	23	Call Center - Pro Racer
2	18	Discontinued
2	4	Discontinued
1	5	Discontinued
1	27	Call Center - Administration
1	60	Misc
1	89	Warehouse - Truck
*/



select ixEmployee 'Employee'
    ,sLastname 'Last Name'
    ,sFirstname 'First Name'
    --,sPhone, iExtension
    ,ixDepartment 'Dept'
    ,sPayrollId 'Payroll ID'
    ,flgCurrentEmployee 'Current Employee'
    --,dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    --,flgExempt 'Exempt'
from tblEmployee 
where flgCurrentEmployee = 1


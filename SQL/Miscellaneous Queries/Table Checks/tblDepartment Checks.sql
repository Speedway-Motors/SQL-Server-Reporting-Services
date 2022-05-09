-- tblDepartment Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblDepartment%'
--  N/A CURRENTLY THIS TABLE IS ONLY UPDATED MANUALLY
--  ixErrorCode	sDescription


-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1163'
  and dtDate >=  DATEADD(dd, -95, getdate())  -- past X days
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
    DB          	Date    	ErrorQty
*/


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblDepartment
/*
DB          	TABLE   Rows   	Date
SMI Reporting	tblDepartment	100	01-01-16
SMI Reporting	tblDepartment	100	01-01-15
SMI Reporting	tblDepartment	100	04-01-14
SMI Reporting	tblDepartment	44	01-01-14
SMI Reporting	tblDepartment	44	01-01-13
SMI Reporting	tblDepartment	43	03-01-12


AFCOReporting	tblDepartment	53,225	10-01-15

AFCOReporting	tblDepartment	52,522	07-01-15
AFCOReporting	tblDepartment	50,494	01-01-15
AFCOReporting	tblDepartment	49,070	07-01-14
AFCOReporting	tblDepartment	47,683	01-01-14
AFCOReporting	tblDepartment	46,340	10-01-13
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
    ,DaysOld 
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
FROM vwDataFreshness 
WHERE sTableName = 'tblDepartment'

/*
DB          	DateChecked	DaysOld	Records
=============   =========== ======= =======
SMI Reporting	01-07-2016	   <=1	100
*/
 
 



-- Departments & Employee counts
select CONVERT(varchar, GETDATE(), 110) AS 'DateChecked',
    count(E.ixEmployee) 'Qty', 
    E.ixDepartment Dpt, 
    D.sDescription 'Description'
from tblEmployee E
    left join tblDepartment D on D.ixDepartment = E.ixDepartment
where E.flgCurrentEmployee = 1
group by E.ixDepartment, D.sDescription
order by count(E.ixEmployee) desc
/*
DateChecked	Qty	Dpt	Description
01-07-2016	56	20	Call Center - Sales
01-07-2016	37	47	Afco Employee SOP accounts
01-07-2016	29	11	Marketing/Ecomm
01-07-2016	22	9	Speedway Properties
01-07-2016	20	84	Warehouse - Battleship
01-07-2016	19	7	Machine Shop
01-07-2016	17	87	Warehouse - Small Pack
01-07-2016	15	55	Museum
01-07-2016	14	74	EAGLE
01-07-2016	14	85	Warehouse - Big Pack
01-07-2016	13	81	Warehouse - Receiving
01-07-2016	13	6	Engineering
01-07-2016	11	26	Call Center - Supervisors
01-07-2016	10	15	IT
01-07-2016	9	17	Shop
01-07-2016	9	13	Creative/Adv
01-07-2016	9	29	Call Center - QA/Training
01-07-2016	9	82	Warehouse - Restock
01-07-2016	9	80	Warehouse
01-07-2016	8	0	Catchall
01-07-2016	8	1	Advertising
01-07-2016	7	3	Fiberglass
01-07-2016	6	22	Call Center - Customer Service
01-07-2016	6	21	Counter Sales
01-07-2016	5	73	Dyno Test
01-07-2016	5	2	Accounting
01-07-2016	4	28	Call Center - Blue Diamond
01-07-2016	4	25	Call Center - CC Auth
01-07-2016	4	14	QC
01-07-2016	3	72	Shock Dept
01-07-2016	3	70	Garage Sale
01-07-2016	3	18	HR
01-07-2016	2	24	Returns (main level)
01-07-2016	2	90	Discontinued
01-07-2016	1	23	Call Center - International Sales
01-07-2016	1	27	Call Center - Administration
01-07-2016	1	50	Pro Racer
01-07-2016	1	71	Trackside Support
01-07-2016	1	68	UNKNOWN
01-07-2016	1	45	Mr Roadster
01-07-2016	1	89	Warehouse - Truck
*/


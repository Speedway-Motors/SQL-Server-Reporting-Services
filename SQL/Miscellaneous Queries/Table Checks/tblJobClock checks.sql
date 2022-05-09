-- tblJobClock checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblJobClock%'
--  ixErrorCode	sDescription
--  1161	    Failure to update tblJobClock.

-- ERROR COUNTS by Day
SELECT dtDate, DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1161'
  and dtDate >=  DATEADD(month, -8, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
    DB          	Date    	ErrorQty
    SMI Reporting	04/03/2014	1
    SMI Reporting	04/02/2014	1
    SMI Reporting	03/28/2014	1
    SMI Reporting	03/27/2014	1
    SMI Reporting	03/22/2014	1
    SMI Reporting	03/20/2014	1
    SMI Reporting	03/19/2014	1
    SMI Reporting	03/05/2014	30
    SMI Reporting	03/04/2014	2
    SMI Reporting	02/28/2014	4
    SMI Reporting	02/27/2014	2
    SMI Reporting	02/26/2014	9
    SMI Reporting	02/25/2014	6
    SMI Reporting	02/21/2014	7
    SMI Reporting	02/20/2014	4
    SMI Reporting	02/19/2014	4
    SMI Reporting	01/29/2014	1
*/


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblJobClock
/*
DB          	TABLE       Rows   	Date
SMI Reporting	tblJobClock	659321	02-01-14
SMI Reporting	tblJobClock	641748	01-01-14
SMI Reporting	tblJobClock	591198	10-01-13
SMI Reporting	tblJobClock	536873	08-01-13
SMI Reporting	tblJobClock	457185	04-01-13
SMI Reporting	tblJobClock	399593	01-01-13
SMI Reporting	tblJobClock	346303	10-01-12    
SMI Reporting	tblJobClock	309419	08-01-12
SMI Reporting	tblJobClock	238605	04-01-12
*/


/***************** DATA FRESHNESS *************************************/
SELECT REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness WHERE sTableName = 'tblJobClock'
/*
    Records	DaysOld	DateChecked
    1,749	   <=1	02-21-2014
    3,457	   2-7	02-21-2014
    14,076	  8-30	02-21-2014
    118,529	 31-180	02-21-2014
    14,749	181 +	02-21-2014
    518,950	UK	    02-21-2014
 */
    
    
    
    
/************************************************************************/ 
select * -- distinct (sError)
FROM tblErrorLogMaster
WHERE ixErrorCode = '1161'
  AND dtDate >= '01/29/2014'

-- are the employees in the above query in tblEmployee?
-- FK on tblEmployee... IF AN EMPLOYEE IS NOT IN tblEmployee, THE JOBCLOCK RECORD INSERT WILL FAIL!
select * from tblEmployee 
where ixEmployee in ('AJA47','KCC47')

select * from [AFCOReporting].dbo.tblEmployee 
where ixEmployee in ('AJA','KCC')




select count(*) from tblJobClock -- 541,023 @8-07-2013
                                 -- 581,810 @9-13-2013

select count(*)  from tblJobClock where dtDateLastSOPUpdate is NULL -- 535,196  @8-8-2013

select count(*)  from tblJobClock where dtDateLastSOPUpdate is NOT NULL -- 5,829  @8-8-2013


select * from tblJobClock 
where 
--ixDate = 16851
--and 
ixEmployee = 'KCC47' --and ixTime = 12420

-- AFCO employees log job time on the SMI side when they are filling SMI orders
select ixEmployee, count(*) TimesLogged
from tblJobClock 
where ixEmployee like '%47'
and dtDate >= '05/08/2014'
group by ixEmployee
order by dtDate desc
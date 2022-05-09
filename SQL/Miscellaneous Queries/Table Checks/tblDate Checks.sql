-- tblDate Checks

-- UNVERIFIED FIELDS
    iPeriod, iISOWeek,  iPeriodYear, iYearMonth, sPeriod, iDayOfFiscalYear, iDayOfFiscalPeriod

select dtDate, iPeriod, iISOWeek,  iPeriodYear, iYearMonth, sPeriod, iDayOfFiscalYear, iDayOfFiscalPeriod
from tblDate where iYear = 2021
order by dtDate


select dtDate, iPeriod 
from tblDate
where iPeriodYear = 2021
order by iPeriod



/********** fields verified as correct  *************/
--ixDate & dtDate 
-- no missing rows and Al confirmed the final ixDate & dtDate values matched SOP @ 1/26/20
    select ixDate, dtDate
    from tblDate
    where ixDate > = 19001
    /*
    19001	2020-01-08 
    23016	2031-01-05 -- 4016 rows 
    */



--iDayOfWeek, sDayOfWeek, sDayOfWeek3Char
-- Days of Week   
select DISTINCT iDayOfWeek, sDayOfWeek, sDayOfWeek3Char -- v 1/26/20
from tblDate
order by iDayOfWeek -- SHOULD ONLY BE 7 unique combinations


-- iMonth & sMonth
    select DISTINCT iMonth, sMonth, iQuarter -- v 1/26/20
    from tblDate
    order by iMonth
    /*
    iMonth	sMonth
    1	JANUARY
    2	FEBRUARY
    3	MARCH
    3	March
    4	APRIL
    5	MAY
    6	JUNE
    7	JULY
    8	AUGUST
    9	SEPTEMBER
    10	OCTOBER
    11	NOVEMBER
    12	DECEMBER
    */

 -- iQuarter
    select DISTINCT iMonth, iQuarter -- v 1/26/20
    from tblDate
    order by iMonth
    /*
    iMonth	iQuarter
    1	    1
    2	    1
    3	    1

    4	    2
    5	    2
    6	    2

    7	    3
    8	    3
    9	    3

    10	    4
    11	    4
    12	    4
    */
     
     -- FIXES if iQuarter is off
     -- run for each quarter
     select *
     from tblDate where iMonth in (1,2,3) and iQuarter <> 1

     BEGIN TRAN
         UPDATE tblDate
         set iQuarter = 1
         where ixDate in (19084,19815,20545,22006)
     ROLLBACK TRAN

 -- iDayOfYear
     select iYear, min(iDayOfYear) 'MinDay', max(iDayOfYear)'MaxDay', count(distinct iDayOfYear) 'distinctRowCnt'
     from tblDate
     where iYear > 2019
     group by iYear
     order by iYear
     /*     
            Min Max distinct
    iYear	Day	Day	RowCnt
    2020	1	366	366
    2021	1	365	365
    2022	1	365	365
    2023	1	365	365
    2024	1	366	366
    2025	1	365	365
    2026	1	365	365
    2027	1	365	365
    2028	1	366	366
    2029	1	365	365
    2030	1	365	365
    2031	1	5	5
    */


select *
--into [SMITemp].dbo.PJC_2021CalendarFix
from tblDate
where dtDate between '12/25/2020' and '01/07/2022'

1/02/2021	1/29/2021
1/30/2021	3/5/2021
3/6/2021	4/2/2021
4/3/2021	4/30/2021
5/1/2021	6/4/2021
6/5/2021	7/2/2021
7/3/2021	7/30/2021
7/31/2021	9/3/2021
9/4/2021	10/1/2021
10/2/2021	10/29/2021
10/30/2021	12/3/2021
12/4/2021	12/31/2021

BEGIN TRAN

    UPDATE D
    set iDayOfFiscalPeriod = TF.iDayOfFiscalPeriod,
       iDayOfFiscalYear = TF.iDayOfFiscalYear
    from tblDate D
        join [SMITemp].dbo.PJC_2021CalendarFix TF on D.ixDate =TF.ixDate

ROLLBACK TRAN

select iPeriod, dtDate
from tblDate
where iPeriodYear = 2021
and iDayOfFiscalPeriod = 1
order by iPeriod



update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX



 
select distinct iPeriod, sPeriod
from tblDate
order by iPeriod



select * from tblDate
where dtDate 



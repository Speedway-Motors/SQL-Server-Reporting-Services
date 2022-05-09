-- SMIHD-19379 - Modify tblDate change 2021-2025 period dates

select *
into [SMIArchive].dbo.BU_tblDate_20201216 -- 17195
from tblDate


select * into [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods
from tblDate
where ixDate >= 19353 -- 1842
order by ixDate




select * from tblDate where ixDate between 19350 and 19360

iPeriod corrected through May 2022



select iPeriodYear, sMonth, iMonth,  count(distinct (iPeriod))
from [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods
group by iPeriodYear, sMonth, iMonth
-- having  count(distinct (iPeriod)) <> 1
order by iPeriodYear, iMonth

-- day of period udpated thru 12-31-2024

select iDayOfFiscalPeriod, count(*)
from [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods
group by iDayOfFiscalPeriod
order by iDayOfFiscalPeriod

select * from [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods where iDayOfFiscalPeriod NOT BETWEEN 1 and 31

select iMonth, iYear, count(distinct (iDayOfFiscalPeriod)), max(iDayOfFiscalPeriod)
from [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods
group by iMonth, iYear
order by iMonth, iYear

BEGIN TRAN
Update [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods -- 1835
set iDayOfFiscalYear = iDayOfYear
WHERE iYear >= 2021
ROLLBACK TRAN

SELECT TOP 30 * FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods

SELECT COUNT(1) FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods



BEGIN TRAN

    UPDATE D
    set D.dtDate = NC.dtDate,
       D.iQuarter = NC.iQuarter,
       D.iPeriod = NC.iPeriod,
       D.iISOWeek = NC.iISOWeek,
       D.iDayOfWeek = NC.iDayOfWeek,
       D.iDayOfYear = NC.iDayOfYear,
       D.iYear = NC.iYear,
       D.iPeriodYear = NC.iPeriodYear,
       D.iMonth = NC.iMonth,
       D.sMonth = NC.sMonth,
       D.iYearMonth = NC.iYearMonth,
       D.sDayOfWeek = NC.sDayOfWeek,
       D.sPeriod = NC.sPeriod,
       D.iDayOfFiscalYear = NC.iDayOfFiscalYear,
       D.iDayOfFiscalPeriod = NC.iDayOfFiscalPeriod,
       D.sDayOfWeek3Char = NC.sDayOfWeek3Char,
       D.dtLastYearMatchingDate = NC.dtLastYearMatchingDate
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods NC
        join tblDate D on NC.ixDate = D.ixDate 
    --where D.ixDate = 19389
ROLLBACK TRAN

select NC.*
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods NC
        join tblDate D on NC.ixDate = D.ixDate 												
where --NC.iPeriod <> D.iPeriod
--and 
D.ixDate = 19389

19389	2021-01-30 00:00:00.000	1	2	5	6	30	2021	2021	1	JANUARY	2021-01-15 00:00:00.000	SATURDAY	FEBRUARY            	29	1	SAT	2020-02-01 00:00:00.000
19389	2021-01-30 00:00:00.000	1	1	5	6	30	2021	2021	1	JANUARY	2021-01-15 00:00:00.000	SATURDAY	FEBRUARY            	30	29	SAT	2020-02-01 00:00:00.000
19389	2021-01-30 00:00:00.000	1	1	5	6	30	2021	2021	1	JANUARY	2021-01-15 00:00:00.000	SATURDAY	FEBRUARY            	30	29	SAT	2020-02-01 00:00:00.000


select top 1 * from [SMITemp].dbo.PJC_SMIHD19379_tblDate_NewCalendarPeriods

select * from tblDate
where ixDate >= 19354
order by ixDate



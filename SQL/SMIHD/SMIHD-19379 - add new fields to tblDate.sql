-- SMIHD-19379 - add 8 new fields to tblDate

/*
    iOperationalPeriod tinyint
    iOperationalYear    smallint
    dtRolling28DayStart datetaime
    dtRolling28DayEnd   datetaime
    dtRolling7DayStart  datetaime
    dtRolling7DayEnd    datetaime
    iDayOfOperationalPeriod smallint
dtLastYearMatchingOperationalDate datetaime

*/


select *
into [SMIArchive].dbo.BU_tblDate_20201216 -- 17195
from tblDate

select *
into [SMIArchive].dbo.BU_tblDate_20201223 -- 17195
from tblDate


select * into [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields -- DROP TABLE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
from tblDate
order by ixDate

SELECT * FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
ORDER BY ixDate

SELECT TOP 10 * FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields

/****** iOperationalYear *******/
    select count(distinct iYear) -- 49
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    -- 1978-2025

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalYear = (iYear-1)
        where iDayOfYear = 1
    ROLLBACK TRAN

    select ixDate, dtDate, iYear, iOperationalYear
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    where iDayOfYear = 1
    order by iYear

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalYear = iYear
        where iDayOfYear <> 1
    ROLLBACK TRAN

    select ixDate, dtDate, iYear, iOperationalYear
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    where iYear = 2021
    order by ixDate

    select iOperationalYear, count(*)
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    group by iOperationalYear
    order by iOperationalYear





/******* iOperationalPeriod ************/
    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 1
        where iDayOfYear BETWEEN 2 and 29
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 2
        where iDayOfYear BETWEEN 30 and 57
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 3
        where iDayOfYear BETWEEN 58 and 85
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 4
        where iDayOfYear BETWEEN 86 and 113
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 5
        where iDayOfYear BETWEEN 114 and 141
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 6
        where iDayOfYear BETWEEN 142 and 169
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 7
        where iDayOfYear BETWEEN 170 and 197
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 8
        where iDayOfYear BETWEEN 198 and 225
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 9
        where iDayOfYear BETWEEN 226 and 253
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 10
        where iDayOfYear BETWEEN 254 and 281
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 11
        where iDayOfYear BETWEEN 282 and 309
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 12
        where iDayOfYear BETWEEN 310 and 337
    ROLLBACK TRAN

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 13
        where iDayOfYear BETWEEN 338 and 366
    ROLLBACK TRAN

    -- Jan 1st is always last day of Op Period 13 of previous year
    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET iOperationalPeriod = 13
        where iDayOfYear = 1
    ROLLBACK TRAN

    select iOperationalYear, iOperationalPeriod, count(ixDate) 'Days'
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    where iOperationalPeriod = 13 --between 1 and 12  -- every Op Period has 28 days except Op Period 13 which has 29 or 30
    group by iOperationalYear, iOperationalPeriod
    order by iOperationalYear, iOperationalPeriod

    select * from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    where iOperationalPeriod is NULL



/*******    dtRolling28DayStart    ********/
-- dtRolling28DayStart = 28 days ago

    select dtDate,dtRolling28DayStart,
        DATEADD(dd,-28,DATEDIFF(dd,0,dtDate))
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    --where dtDate = '12/29/2020'
    where dtRolling28DayStart <> DATEADD(dd,-28,DATEDIFF(dd,0,dtDate))

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET dtRolling28DayStart = DATEADD(dd,-28,DATEDIFF(dd,0,dtDate))
    ROLLBACK TRAN


/*******    dtRolling28DayEnd    ********/
-- dtRolling28DayEnd = 1 day ago

    select dtDate,dtRolling28DayEnd,
        DATEADD(dd,-1,DATEDIFF(dd,0,dtDate))
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    --where dtDate = '12/08/2020'
    where dtRolling28DayEnd <> DATEADD(dd,-1,DATEDIFF(dd,0,dtDate))

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET dtRolling28DayEnd = DATEADD(dd,-1,DATEDIFF(dd,0,dtDate))
    ROLLBACK TRAN



 /*******    dtRolling7DayStart     ********/
-- dtRolling7DayStart = 7 days ago

    select dtDate,dtRolling7DayStart,
        DATEADD(dd,-7,DATEDIFF(dd,0,dtDate))
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    where dtDate = '12/28/2020'
    where dtRolling7DayStart <> DATEADD(dd,-7,DATEDIFF(dd,0,dtDate))

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET dtRolling7DayStart = DATEADD(dd,-7,DATEDIFF(dd,0,dtDate))
    ROLLBACK TRAN


/*******    dtRolling28DayEnd    ********/
-- dtRolling7DayEnd = 1 day ago

    select dtDate,dtRolling7DayEnd,
        DATEADD(dd,-1,DATEDIFF(dd,0,dtDate))
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    --where dtDate = '12/08/2020'
    where dtRolling7DayEnd <> DATEADD(dd,-1,DATEDIFF(dd,0,dtDate))

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        SET dtRolling7DayEnd  = dtRolling28DayEnd
    ROLLBACK TRAN



/*******    iDayOfOperationalPeriod     ********/
    select ixDate, dtDate, iOperationalPeriod, iDayOfOperationalPeriod
    into [SMITemp].dbo.PJC_SMIHD19379_DayOfOperationalPeriod
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    order by ixDate

    select * from [SMITemp].dbo.PJC_SMIHD19379_DayOfOperationalPeriod

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD19379_DayOfOpPeriod

    BEGIN TRAN

        UPDATE A 
        set iDayOfOperationalPeriod = B.iDayOfOperationalPeriod
        from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields A
            join [SMITemp].dbo.PJC_SMIHD19379_DayOfOpPeriod B on A.ixDate = B.ixDate

    ROLLBACK TRAN
    
    
    select ixDate, dtDate, sDayOfWeek, iDayOfOperationalPeriod
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    WHERE iOperationalPeriod = 1
    and iOperationalYear in (2019, 2020)
    order by iOperationalYear, iDayOfOperationalPeriod 



/*****  dtLastYearMatchingOperationalDate   *****/
    select ixDate, dtDate, sDayOfWeek, iDayOfOperationalPeriod, dtLastYearMatchingOperationalDate
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    WHERE iOperationalPeriod = 1
    and iOperationalYear in (2019, 2020)
    order by iOperationalYear, iDayOfOperationalPeriod 


    SELECT  dtDate, iOperationalPeriod, iDayOfOperationalPeriod,sDayOfWeek, dtLastYearMatchingOperationalDate
    FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
    WHERE iOperationalYear in (2019, 2020) and iOperationalPeriod = 13
    order by iOperationalYear, iDayOfOperationalPeriod 

    -- Set Jan 1st of each year to match Jan 1st of previous year
    select * from tblDate
    where iDayOfYear = 1
    order by dtDate -- 1979-2026 48 years

    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        set dtLastYearMatchingOperationalDate = DATEADD(yy, -1,dtDate) -- dtLastYearMatchingOperationalDate -1 year
        where iDayOfYear = 1
    ROLLBACK TRAN

        -- verify 
        SELECT dtDate, DATEADD(yy, -1,dtDate) 'PY_OPDateMatch', dtLastYearMatchingOperationalDate
        from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        where iDayOfYear = 1
            and DATEADD(yy, -1,dtDate) <> dtLastYearMatchingOperationalDate
        order by dtDate


    -- Set dtLastYearMatchingOperationalDate = matching occurance of day of week for each  1st of each year to match Jan 1st of previous year
    BEGIN TRAN
        UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
        set dtLastYearMatchingOperationalDate = DATEADD(yy, -1,dtDate) -- dtLastYearMatchingOperationalDate -1 year
        where iDayOfYear = 1
    ROLLBACK TRAN


SELECT dtDate, iOperationalYear, iOperationalPeriod, sDayOfWeek, dtLastYearMatchingOperationalDate
FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
where iDayOfYear <> 1 -- Jan 1st dates all already map to prev Jan 1st
    and iDayOfOperationalPeriod <= 28
    and iOperationalYear = 2020
    and iOperationalPeriod = 11



select iDayOfOperationalPeriod, count(*)
from tblDate
where [iOperationalYear] between 1979 and 2025 -- the only complete years   47*13 periods
group by iDayOfOperationalPeriod
order by iDayOfOperationalPeriod
-- 47*13 periods = 611 days for day of OPperiod 1-128  v
-- 47 years have a 29th day in period 13  v
-- 12 years have a 30th day in period 13 (leap year) 

order by  count(*) desc, iDayOfOperationalPeriod

select top 10 * from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields


select * from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
where [iOperationalYear] = 2026

select * from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields
where [iOperationalYear] = 1978



select O.dtOrderDate, FORMAT(sum(mMerchandise),'$###,###') Sales
from tblOrder O
    left join tblDate D on O.ixOrderDate = D.ixDate
WHERE sOrderStatus = 'Shipped'
and D.iDayOfYear = 1
and D.iYear between 2016 and 2020
GROUP BY O.dtOrderDate
order by O.dtOrderDate

select O.dtOrderDate, D.sDayOfWeek,  FORMAT(sum(mMerchandise),'$###,###') Sales
from tblOrder O
    left join tblDate D on O.ixOrderDate = D.ixDate
WHERE sOrderStatus = 'Shipped'
and D.dtDate in ('12/31/2019','12/31/2018','12/31/2017','12/31/2016','12/31/2015')
and D.iYear between 2016 and 2020
GROUP BY O.dtOrderDate,D.sDayOfWeek
order by O.dtOrderDate

select * from tblDate
where dtDate = '12/31/2016'









-- manual change for a value corrected in tblDate
      update [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields set iPeriodYear = 2021
      where ixDate = 19360










-- UPDATE tblDATE once temp table is completely populated
BEGIN TRAN

    UPDATE D
    set D.iOperationalPeriod = NF.iOperationalPeriod,
       D.iOperationalYear = NF.iOperationalYear,
       D.iDayOfOperationalPeriod = NF.iDayOfOperationalPeriod,
       D.dtLastYearMatchingOperationalDate = NF.dtLastYearMatchingOperationalDate,
       D.dtRolling28DayStart = NF.dtRolling28DayStart,
       D.dtRolling28DayEnd = NF.dtRolling28DayEnd,
       D.dtRolling7DayStart = NF.dtRolling7DayStart,
       D.dtRolling7DayEnd = NF.dtRolling7DayEnd
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields NF
        join tblDate D on NF.ixDate = D.ixDate 
    --where D.ixDate = 19389
ROLLBACK TRAN

select NF.*
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_New_Fields NF
        join tblDate D on NF.ixDate = D.ixDate 												
where D.ixDate = 19389

select top 10 * from tblDate
where iOperationalYear = 2020 and iOperationalPeriod = 13

-- VERIFY no data is missing
select * from tblDate 
where [ixDate] is NULL 
    OR [dtDate] is NULL 
    OR [iQuarter] is NULL 
    OR [iPeriod] is NULL 
    OR [iISOWeek] is NULL 
    OR [iDayOfWeek] is NULL 
    OR [iDayOfYear] is NULL 
    OR [iYear] is NULL 
    OR [iPeriodYear] is NULL 
    OR [iMonth] is NULL 
    OR [sMonth] is NULL
    OR [iYearMonth] is NULL 
    OR [sDayOfWeek] is NULL 
    OR [sPeriod] is NULL 
    OR [iDayOfFiscalYear] is NULL 
    OR [iDayOfFiscalPeriod] is NULL 
    OR [sDayOfWeek3Char] is NULL 
    -- OR [dtLastYearMatchingDate] is NULL the first 730 days in the table never populated this value
    OR [iOperationalPeriod] is NULL 
    OR [iOperationalYear] is NULL 
    OR [iDayOfOperationalPeriod] is NULL 
    --OR [dtLastYearMatchingOperationalDate] is NULL 
    OR [dtRolling28DayStart] is NULL 
    OR [dtRolling28DayEnd] is NULL 
    OR [dtRolling7DayStart] is NULL 
    OR [dtRolling7DayEnd] is NULL 


select * from [SMIArchive].dbo.BU_tblDate_20191231
where [dtLastYearMatchingDate] is NULL 


/***** POPULATE dtLastYearMatchingOperationalDate    *************/
select * into [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
FROM tblDate

UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
SET iDoWeekIteration = 1
WHERE iDayOfOperationalPeriod BETWEEN 1 AND 7
 
 UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
SET iDoWeekIteration = 2
WHERE iDayOfOperationalPeriod BETWEEN 8 AND 14

 UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
SET iDoWeekIteration = 3
WHERE iDayOfOperationalPeriod BETWEEN 15 AND 21

 UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
SET iDoWeekIteration = 4
WHERE iDayOfOperationalPeriod BETWEEN 22 AND 28

 UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
SET iDoWeekIteration = 5
WHERE iDayOfOperationalPeriod BETWEEN 29 AND 30

SELECT * FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
WHERE iDoWeekIteration is NULL

SELECT iDoWeekIteration, COUNT(*)
FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
GROUP BY iDoWeekIteration



BEGIN TRAN

    UPDATE TY
    set TY.dtLastYearMatchingOperationalDate = LY.dtDate
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField TY
        join [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField LY on TY.iOperationalPeriod = LY.iOperationalPeriod
                                                and TY.sDayOfWeek = LY.sDayOfWeek
                                                and TY.iDoWeekIteration = LY.iDoWeekIteration
                                                and LY.iOperationalYear = (TY.iOperationalYear-1)
    where TY.dtLastYearMatchingOperationalDate IS NULL

ROLLBACK TRAN

BEGIN TRAN

    UPDATE TY
    set TY.dtLastYearMatchingOperationalDate = LY.dtDate
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField TY
        join [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField LY on LY.iOperationalYear = (TY.iOperationalYear-1)
    where TY.dtLastYearMatchingOperationalDate IS NULL
        and TY.iDayOfYear = 1
        and LY.iDayOfYear = 1
ROLLBACK TRAN

select dtDate,iOperationalYear,iDoWeekIteration,  sDayOfWeek , iDayOfOperationalPeriod, dtLastYearMatchingOperationalDate
from [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
where dtLastYearMatchingOperationalDate is NULL
and iYear > 1979


select dtDate,iOperationalYear,iDoWeekIteration,  sDayOfWeek , iDayOfOperationalPeriod, dtLastYearMatchingOperationalDate
from [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
where iOperationalYear = 2020
    and iOperationalPeriod = 13
order by iDayOfOperationalPeriod


BEGIN TRAN

    UPDATE TY
    set TY.dtLastYearMatchingOperationalDate = LY.dtDate
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField TY
        join [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField LY on LY.iOperationalYear = (TY.iOperationalYear-1)
    where TY.dtLastYearMatchingOperationalDate IS NULL
        and TY.iDayOfYear = 1
        and LY.iDayOfYear = 1

ROLLBACK TRAN

-- Clear out field to use new instructions from CCC
BEGIN TRAN

UPDATE [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
SET dtLastYearMatchingOperationalDate = NULL
WHERE iDayOfYear <> 1

ROLLBACK TRAN


BEGIN TRAN

    UPDATE TY
    set TY.dtLastYearMatchingOperationalDate = LY.dtDate
    from [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField TY
        join [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField LY on TY.iOperationalPeriod = LY.iOperationalPeriod
                                                and TY.iDayOfOperationalPeriod = LY.iDayOfOperationalPeriod
                                                and LY.iOperationalYear = (TY.iOperationalYear-1)
    where TY.dtLastYearMatchingOperationalDate IS NULL

ROLLBACK TRAN

SELECT * FROM [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField
WHERE dtLastYearMatchingOperationalDate is NULL

select top 10 * from [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField 

BEGIN TRAN

UPDATE D
SET D.dtLastYearMatchingOperationalDate = LF.dtLastYearMatchingOperationalDate
FROM tblDate D
    left join [SMITemp].dbo.PJC_SMIHD19379_tblDate_LastField LF on D.ixDate = LF.ixDate

ROLLBACK TRAN


SELECT * FROM tblDate where dtLastYearMatchingOperationalDate is NULL

select * from tblDate D
where dtDate = '01/01/1988'

update A 
set COLUMN = B.COLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX

 select count(*) from tblDate where dtDate < '01/01/1988'

 BEGIN TRAN

 DELETE from tblDate where dtDate < '01/01/1988'

 ROLLBACK TRAN


 select dtDate,iOperationalYear,sDayOfWeek , iDayOfOperationalPeriod, dtLastYearMatchingOperationalDate
from tblDate
where iOperationalYear = 2020
    and iOperationalPeriod = 13
order by iDayOfOperationalPeriod
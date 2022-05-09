-- Case 21565 - Alter date logic in Daily Orders Taken report

/****           REMEMBER         

        iPeriodYear = iFiscalYear     

AND Calendar math =  #$@&!ing pain in the *#*$!

    
***/

select ixDate, dtDate, iPeriodYear, iDayOfFiscalYear
from tblDate where dtDate = '02/12/2014'
/*
ixDate	dtDate	    iPeriodYear	iDayOfFiscalYear
16845	2014-02-12  2014	    40
*/

select ixDate, dtDate, iPeriodYear, iDayOfFiscalYear
from tblDate where iPeriodYear = 2013 and iDayOfFiscalYear = 40
/*
ixDate	dtDate	    iPeriodYear	iDayOfFiscalYear
16474	2013-02-06 	2013	    40
*/


DECLARE
    @Date datetime
SELECT
    @Date = '02/12/2014'
    
-- CURRENT METHOD 
-- matches back to  2013-02-13 
select dateadd(wk, -52,@Date)

-- NEW METHOD 
-- should match back to 2013-02-06
select dateadd(wk, -52,@Date)



DECLARE
    @Date datetime
SELECT
    @Date = '02/12/2014'

-- @Date = latest day of THIS Fiscal Year
SELECT TFY.TFYDay1
    , @Date as 'TFYEndDay' --  @run day of THIS Fiscal Year
    , LFYStart.LFYDay1
    , LFYEnd.LFYMatchingEndDay
FROM  
    (-- First day of THIS Fiscal Year 
    select D.dtDate as 'TFYDay1', 1 as Joiner
    from tblDate D
    where D.iDayOfFiscalYear = 1
    and D.iPeriodYear = (select iPeriodYear from tblDate where dtDate = @Date)
    ) TFY
FULL OUTER JOIN 
    (-- First day of LAST Fiscal Year    
    select D.dtDate as 'LFYDay1', 1 as Joiner
    from tblDate D
    where D.iDayOfFiscalYear = 1
    and D.iPeriodYear = (select iPeriodYear-1 from tblDate where dtDate = @Date)
    ) LFYStart ON TFY.Joiner = LFYStart.Joiner
FULL OUTER JOIN 
    (-- Corisoponding day of LAST Fiscal Year
    select D.dtDate as 'LFYMatchingEndDay', 1 as Joiner
    from tblDate D
    where D.iPeriodYear = (select iPeriodYear-1 from tblDate where dtDate = @Date)
        AND D.iDayOfFiscalYear = (select iDayOfFiscalYear from tblDate where dtDate = @Date)
    ) LFYEnd ON TFY.Joiner = LFYEnd.Joiner
 
 
/*
TFY.TFYDay1
@Date as 'TFYEndDay' --  @run day of THIS Fiscal Year
LFYStart.LFYDay1
LFYEnd.LFYMatchingEndDay
*/ 

SELECT TY.OrdChan,
      TY.SortOrd,
       LFYMatchingEndDay LYCompareDate,
       TY.DailyNumOrds TYDailyNumOrds,
       TY.DailySales   TYDailySales,
       LY.DailyNumOrds LYDailyNumOrds,
      isnull(LY.DailySales,0)   LYDailySales
FROM
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        OrdChan,
        SortOrd
    from vwDailyOrdersTaken
    where dtDate between TFYDay1 and @Date
       and Division in (@Division)
    group by OrdChan,
             SortOrd) as TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        OrdChan
    from vwDailyOrdersTaken
    where dtDate between LFYDay1 and LFYMatchingEndDay
       and Division in (@Division)
    group by OrdChan) as LY on TY.OrdChan = LY.OrdChan
order by SortOrd





















-- Current day of This Fiscal Year
select D.dtDate 

select * from tblDate where iYear = 2011 order by dtDate


select * from tblDate where iPeriodYear = 2013
select * from tblDate where dtDate = '02/06/2013'

into tblDateTemp
from tblDate


select * from tblDate

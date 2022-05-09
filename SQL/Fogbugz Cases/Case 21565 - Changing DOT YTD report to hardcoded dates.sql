-- Case 21565 - Changing DOT YTD report to hardcoded dates

DECLARE
    @Date datetime,
  --  @TYiPeriodYear int,
  --  @LYiPeriodYear int,
    @Division varchar(20)

SELECT
    @Date = '02/13/14',
   -- @TYiPeriodYear
  --  @LYiPeriodYear = '10/29/13',
    @Division = 'Retail' --  'Wholesale' 
--SELECT DATEADD(week, -52,@Date) 

SELECT TY.OrdChan,
      TY.SortOrd,
       dateadd (wk, -52, @Date) LYCompareDate,
       TY.DailyNumOrds TYDailyNumOrds,
       TY.DailySales   TYDailySales,
       LY.DailyNumOrds LYDailyNumOrds,
      isnull(LY.DailySales,0)   LYDailySales
FROM
    (-- This Year
    select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        OrdChan,
        SortOrd
    from vwDailyOrdersTaken
    where dtDate between '01/02/2014' and @Date -- hardcoded per Carson.  Will re-evaluate yearly to determine new start date
        -- and iPeriodYear = @TYiPeriodYear
       and Division in (@Division)
    group by OrdChan,
             SortOrd) as TY
LEFT JOIN
    (-- Last Year
    select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        OrdChan
    from vwDailyOrdersTaken
    where dtDate between '01/03/2013' and DATEADD(week, -52,@Date)  -- hardcoded per Carson.
      --  and iPeriodYear = @LYiPeriodYear
       and Division in (@Division)
    group by OrdChan) as LY on TY.OrdChan = LY.OrdChan
order by SortOrd


/*


select * from tblDate where dtDate = '01/02/2014'

select * from tblDate where iPeriodYear = '2014'

select * from vwDailyOrdersTaken

01/07/2013 - 02/14/2013
01/02/2014 - 02/13/2014


select sum(DailySales)
from vwDailyOrdersTaken
where dtDate between '01/02/2014' and  '02/13/2014' --11040490.14
and Division = 'Retail'
order by dtDate, SortOrd





*/
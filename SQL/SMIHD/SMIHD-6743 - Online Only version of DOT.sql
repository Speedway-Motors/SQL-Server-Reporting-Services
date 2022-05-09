-- SMIHD-6743 - Online Only version of DOT
/* -- Online Only DOT
   -- Ver 17.8.1
DECLARE @Date AS datetime
SELECT @Date = '02/20/2017'
*/
SELECT TY.OrdChan,
      TY.SortOrd,
       dateadd (wk, -52, @Date) LYCompareDate,
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
    where dtDate = @Date
       and Division = 'Retail'
       and OrdChan in ('WEB','WEB-Mobile','Ebay/Auction','Amazon')
    group by OrdChan,
             SortOrd) as TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        OrdChan
    from vwDailyOrdersTaken
    where dtDate = dateadd (wk, -52, @Date)
       and Division = 'Retail'
       and OrdChan in ('WEB','WEB-Mobile','Ebay/Auction','Amazon')       
    group by OrdChan) as LY on TY.OrdChan = LY.OrdChan
ORDER BY SortOrd


--SELECT distinct Division from vwDailyOrdersTaken



/* -- DOT - Online Only sub1 Monthly
   -- Ver 17.8.1
DECLARE @Date AS datetime
SELECT @Date = '02/20/2017'
*/
SELECT TY.OrdChan,
      TY.SortOrd,
       dateadd (wk, -52, @Date) LYCompareDate,
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
    where dtDate <= @Date
         and iPeriodYear = @TYiPeriodYear
        and iPeriod = @iPeriod
       and Division = 'Retail'
       and OrdChan in ('WEB','WEB-Mobile','Ebay/Auction','Amazon')
    group by OrdChan,
             SortOrd) as TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        OrdChan
    from vwDailyOrdersTaken
    where iDayOfFiscalPeriod <= @iDayOfFiscalPeriod -- dtDate <= DATEADD(week, -52,@Date) 
        and iPeriodYear = @LYiPeriodYear
       and iPeriod = @iPeriod
       and Division = 'Retail'
       and OrdChan in ('WEB','WEB-Mobile','Ebay/Auction','Amazon')
    group by OrdChan) as LY on TY.OrdChan = LY.OrdChan
order by SortOrd




/* -- DOT - Online Only sub2 YTD
   -- Ver 17.8.1
DECLARE @Date AS datetime
SELECT @Date = '02/20/2017'
*/
SELECT TY.OrdChan,
      TY.SortOrd,
      -- dateadd (wk, -52, @Date) LYCompareDate,
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
    where iDayOfFiscalYear <= @DayOfFiscalYear
         and iPeriodYear = @TYiPeriodYear
       and Division = 'Retail'
       and OrdChan in ('WEB','WEB-Mobile','Ebay/Auction','Amazon')
    group by OrdChan,
             SortOrd) as TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        OrdChan
    from vwDailyOrdersTaken
    where iDayOfFiscalYear <= @DayOfFiscalYear
        and iPeriodYear = @LYiPeriodYear
       and Division = 'Retail'
       and OrdChan in ('WEB','WEB-Mobile','Ebay/Auction','Amazon')
    group by OrdChan) as LY on TY.OrdChan = LY.OrdChan
order by SortOrd
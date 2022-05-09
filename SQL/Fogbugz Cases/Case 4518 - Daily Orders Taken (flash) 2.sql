SELECT TY.*,
LY.*
FROM
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan
    from vwDailyOrdersTaken
    where dtDate = @Date
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan
    from vwDailyOrdersTaken
    where dtDate = @CompareToDate
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) LY on TY.OrdChan = LY.OrdChan




SELECT *
FROM
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan
    from vwDailyOrdersTaken
    where dtDate = @Date
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end)) as TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan
    from vwDailyOrdersTaken
    where dtDate = @CompareToDate
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end)) as LY on TY.OrdChan = LY.OrdChan



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
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan,
        SortOrd
    from vwDailyOrdersTaken
    where dtDate = @Date
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
             else OrdChan
             end),
             SortOrd) as TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan
    from vwDailyOrdersTaken
    where dtDate = @CompareToDate
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end)) as LY on TY.OrdChan = LY.OrdChan

select top 10 * from vwDailyOrdersTaken















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
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan,
        SortOrd
    from vwDailyOrdersTaken
    where dtDate = @Date
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
             else OrdChan
             end),
             SortOrd) as TY
LEFT JOIN
    (select sum(DailyNumOrds) DailyNumOrds,
        sum(DailySales) DailySales,
        (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end) OrdChan
    from vwDailyOrdersTaken
    where dtDate = @CompareToDate
    group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
         else OrdChan
         end)) as LY on TY.OrdChan = LY.OrdChan 


SELECT 
   (case when Division = 'All' then (-- query for every order chan
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
                                            (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
                                             else OrdChan
                                             end) OrdChan
                                        from vwDailyOrdersTaken
                                        where dtDate = @Date
                                        group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
                                             else OrdChan
                                             end)) as TY
                                    LEFT JOIN
                                        (select sum(DailyNumOrds) DailyNumOrds,
                                            sum(DailySales) DailySales,
                                            (case when OrdChan in ('MRR','PRS') and @Division <> 'Wholesale' then 'Wholesale'
                                             else OrdChan
                                             end) OrdChan
                                        from vwDailyOrdersTaken
                                        where dtDate = @CompareToDate
                                        group by (case when OrdChan in ('MRR','PRS') and  @Division <> 'Wholesale' then 'Wholesale'
                                             else OrdChan
                                             end)) as LY on TY.OrdChan = LY.OrdChan
)
         when Division = 'Retail' then then (-- query for retail order chan only
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
                                            OrdChan
                                        from vwDailyOrdersTaken
                                        where dtDate = @Date
                                            and OrdChan NOT in ('MRR','PRS') -- excludes wholesale
                                        group by OrdChan
                                        ) as TY
                                    LEFT JOIN
                                        (select sum(DailyNumOrds) DailyNumOrds,
                                            sum(DailySales) DailySales,
                                            OrdChan
                                        from vwDailyOrdersTaken
                                        where dtDate = @CompareToDate
                                            and OrdChan NOT in ('MRR','PRS') -- excludes wholesale
                                        group by OrdChan
                                        ) as LY on TY.OrdChan = LY.OrdChan
)
    end)



SELECT 
   (case when @Division = 'All' then (-- query for every order chan
                                        SELECT TY.OrdChan,
                                               TY.SortOrd,
                                               dateadd (wk, -52, '01/17/2011') LYCompareDate,
                                               TY.DailyNumOrds TYDailyNumOrds,
                                               TY.DailySales   TYDailySales,
                                               LY.DailyNumOrds LYDailyNumOrds,
                                              isnull(LY.DailySales,0)   LYDailySales
                                        FROM
                                            (select sum(DailyNumOrds) DailyNumOrds,
                                                sum(DailySales) DailySales,
                                                (case when OrdChan in ('MRR','PRS') then 'Wholesale'
                                                 else OrdChan
                                                 end) OrdChan,
                                                 SortOrd
                                            from vwDailyOrdersTaken
                                            where dtDate = '01/17/2011'
                                            group by (case when OrdChan in ('MRR','PRS') then 'Wholesale'
                                                 else OrdChan
                                                 end),
                                              SortOrd
                                                        ) as TY
                                        LEFT JOIN
                                            (select sum(isnull(DailyNumOrds,0)) DailyNumOrds,
                                                sum(DailySales) DailySales,
                                                (case when OrdChan in ('MRR','PRS') then 'Wholesale'
                                                 else OrdChan
                                                 end) OrdChan
                                            from vwDailyOrdersTaken
                                            where dtDate = '01/18/2010'
                                            group by (case when OrdChan in ('MRR','PRS') then 'Wholesale'
                                                 else OrdChan
                                                 end)) as LY on TY.OrdChan = LY.OrdChan
                                        )

        else                        (-- query for retail order chan only
                                    SELECT TY.OrdChan,
                                          TY.SortOrd,
                                           dateadd (wk, -52, '01/17/2011') LYCompareDate,
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
                                        where dtDate = '01/17/2011'
                                            and OrdChan NOT in ('MRR','PRS') -- excludes wholesale
                                        group by OrdChan,
                                           SortOrd
                                        ) as TY
                                    LEFT JOIN
                                        (select sum(DailyNumOrds) DailyNumOrds,
                                            sum(DailySales) DailySales,
                                            OrdChan
                                        from vwDailyOrdersTaken
                                        where dtDate = '01/18/2010'
                                            and OrdChan NOT in ('MRR','PRS') -- excludes wholesale
                                        group by OrdChan
                                        ) as LY on TY.OrdChan = LY.OrdChan
                                     )

    end)



select
  (case when @WTF = 'MIN' then (select min(dtDate) 
                                from tblDate)
        else (select max(dtDate) 
              from tblDate)
   end)



select distinct OrdChan from vwDailyOrdersTaken



PASS A STRING OF VALUES FOR EACH value OF @DIVISION
/*
Catalog
Counter
Ebay/Auction
MRR
PRS
Web

All = 'Catalog','Counter','Ebay/Auction','MRR','PRS','Web'
Retail = 'Catalog','Counter','Ebay/Auction','Web'
Wholesale = 'MRR','PRS'
*/
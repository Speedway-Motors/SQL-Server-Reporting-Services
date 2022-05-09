-- Case 19908 - Fill Rate discrepancy with Fill Rates reports SOP vs Report Server

--set rowcount 10

select distinct iISOWeek,
   datepart("yyyy",getdate())                                 as 'TY',
   datepart("yyyy",DATEADD(yy, -1, getdate()) )  as 'LY',
   datepart("yyyy",DATEADD(yy, -2, getdate()) )  as 'LY2',
    (select iISOWeek 
     from tblDate 
     where dtDate = convert(varchar, GETDATE(), 101))  CurrentPeriod,
    --TY
    ThisYear.FillableLines as 'TY Fillable Lines',
    ThisYear.BackorderedLines as 'TY Backordered Lines',
    
    ThisYear.FillableMerchandiseRevenue as 'TY Fillable Lines Revenue',
    ThisYear.BackorderedMerchandiseRevenue as 'TY Backordered Lines Revenue',
    
    ThisYear.FillableMerchandiseCost as 'TY Fillable Lines Cost',
    ThisYear.BackorderedMerchandiseCost as 'TY Backordered Lines Cost',

    --LY
    LastYear.FillableLines as 'LY Fillable Lines',
    LastYear.BackorderedLines as 'LY Backordered Lines',
    
    LastYear.FillableMerchandiseRevenue as 'LY Fillable Lines Revenue',
    LastYear.BackorderedMerchandiseRevenue as 'LY Backordered Lines Revenue',
    
    LastYear.FillableMerchandiseCost as 'LY Fillable Lines Cost',
    LastYear.BackorderedMerchandiseCost as 'LY Backordered Lines Cost',
    
    
    --LY2
    LastYear2.FillableLines as 'LY2 Fillable Lines',
    LastYear2.BackorderedLines as 'LY2 Backordered Lines',
    
    LastYear2.FillableMerchandiseRevenue as 'LY2 Fillable Lines Revenue',
    LastYear2.BackorderedMerchandiseRevenue as 'LY2 Backordered Lines Revenue',
    
    LastYear2.FillableMerchandiseCost as 'LY2 Fillable Lines Cost',
    LastYear2.BackorderedMerchandiseCost as 'LY2 Backordered Lines Cost'

from
    tblDate D
        left join (select
                        tblDate.iISOWeek as ThisYearPeriod,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end) as FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end) as FillableMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end) as FillableMerchandiseCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end) as BackorderedLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedPrice else 0 end) as BackorderedMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate on O.ixOrderDate = tblDate.ixDate
                    where
                        not(OL.ixOrder like '%-%')
                        and tblDate.iPeriodYear =  datepart("yyyy",getdate()) -- TY 
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        tblDate.iISOWeek
                    ) ThisYear on ThisYear.ThisYearPeriod = D.iISOWeek --ThisYear.ThisYeariISOWeek = D.iiISOWeek

        left join (select 
                        tblDate.iISOWeek as LastYearPeriod,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end) as FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end) as FillableMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end) as FillableMerchandiseCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end) as BackorderedLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedPrice else 0 end) as BackorderedMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate on O.ixOrderDate = tblDate.ixDate
                    where
                        not(OL.ixOrder like '%-%')
                        and tblDate.iPeriodYear = datepart("yyyy",DATEADD(yy, -1, getdate()) )  -- LY
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        tblDate.iISOWeek
                        --dbo.iISOWeek(OL.dtOrderDate)
                    ) LastYear on LastYear.LastYearPeriod = D.iISOWeek --LastYear.LastYeariISOWeek = D.iiISOWeek
        
        left join (select
                        --dbo.iISOWeek(OL.dtOrderDate) as LastYear2iISOWeek,
                        tblDate.iISOWeek as LastYear2Period,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end) as FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end) as FillableMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end) as FillableMerchandiseCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end) as BackorderedLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedPrice else 0 end) as BackorderedMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate on O.ixOrderDate = tblDate.ixDate
                    where
                        not(OL.ixOrder like '%-%')
                        and tblDate.iPeriodYear = datepart("yyyy",DATEADD(yy, -2, getdate()) ) -- LY2
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        tblDate.iISOWeek
                    ) LastYear2 on LastYear2.LastYear2Period = D.iISOWeek --LastYear2.LastYear2iISOWeek = D.iiISOWeek

order by
    D.iISOWeek --D.iiISOWeek desc
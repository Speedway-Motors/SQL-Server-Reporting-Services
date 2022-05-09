/* Description:  Fill Rates by period by year 
*/

select 
    --dbo.ISOweek(D.dtDate),
    distinct
    case when D.iPeriod = 1 then MM),
    --2010
    ThisYear.FillableLines as '2010 Fillable Lines',
    ThisYear.BackorderedLines as '2010 Backordered Lines',
    
    ThisYear.FillableMerchandiseRevenue as '2010 Fillable Lines Revenue',
    ThisYear.BackorderedMerchandiseRevenue as '2010 Backordered Lines Revenue',
    
    ThisYear.FillableMerchandiseCost as '2010 Fillable Lines Cost',
    ThisYear.BackorderedMerchandiseCost as '2010 Backordered Lines Cost',

    --2009
    LastYear.FillableLines as '2009 Fillable Lines',
    LastYear.BackorderedLines as '2009 Backordered Lines',
    
    LastYear.FillableMerchandiseRevenue as '2009 Fillable Lines Revenue',
    LastYear.BackorderedMerchandiseRevenue as '2009 Backordered Lines Revenue',
    
    LastYear.FillableMerchandiseCost as '2009 Fillable Lines Cost',
    LastYear.BackorderedMerchandiseCost as '2009 Backordered Lines Cost',
    
    
    --2008
    LastYear2.FillableLines as '2008 Fillable Lines',
    LastYear2.BackorderedLines as '2008 Backordered Lines',
    
    LastYear2.BackorderedLines as '2008 Backordered Lines',
    LastYear2.BackorderedMerchandiseRevenue as '2008 Backordered Lines Revenue',
    
    LastYear2.FillableMerchandiseCost as '2008 Fillable Lines Cost',
    LastYear2.BackorderedMerchandiseCost as '2008 Backordered Lines Cost'

from
    tblDate D
        left join (select 
                        --dbo.ISOweek(OL.dtOrderDate) as ThisYearISOweek,
                        tblDate.iPeriod as ThisYearPeriod,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end) as FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end) as FillableMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end) as FillableMerchandiseCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end) as BackorderedLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate on O.ixOrderDate = tblDate.ixDate
                    where
                        not(OL.ixOrder like '%-%')
                        --and OL.dtOrderDate >='01/01/10'
                        and tblDate.iPeriodYear = '2010'
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        tblDate.iPeriod
                    ) ThisYear on ThisYear.ThisYearPeriod = D.iPeriod --ThisYear.ThisYearISOweek = D.iISOWeek

        left join (select 
                        --dbo.ISOweek(OL.dtOrderDate) as LastYearISOweek,
                        tblDate.iPeriod as LastYearPeriod,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end) as FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end) as FillableMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end) as FillableMerchandiseCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end) as BackorderedLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate on O.ixOrderDate = tblDate.ixDate
                    where
                        not(OL.ixOrder like '%-%')
                        --and OL.dtOrderDate >='01/01/10'
                        and tblDate.iPeriodYear = '2009'
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        tblDate.iPeriod
                        --dbo.ISOweek(OL.dtOrderDate)
                    ) LastYear on LastYear.LastYearPeriod = D.iPeriod --LastYear.LastYearISOweek = D.iISOWeek
        
        left join (select 
                        --dbo.ISOweek(OL.dtOrderDate) as LastYear2ISOweek,
                        tblDate.iPeriod as LastYear2Period,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end) as FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end) as FillableMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end) as FillableMerchandiseCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end) as BackorderedLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseRevenue,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end) as BackorderedMerchandiseCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate on O.ixOrderDate = tblDate.ixDate
                    where
                        not(OL.ixOrder like '%-%')
                        --and OL.dtOrderDate >='01/01/10'
                        and tblDate.iPeriodYear = '2008'
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        tblDate.iPeriod
                        --dbo.ISOweek(OL.dtOrderDate)
                    ) LastYear2 on LastYear2.LastYear2Period = D.iPeriod --LastYear2.LastYear2ISOweek = D.iISOWeek

order by
    D.iPeriod --D.iISOWeek desc

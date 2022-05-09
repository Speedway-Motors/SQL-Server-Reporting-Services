/********** case 2727 New Fill Rate report *********
 ***************************************************/
SELECT 
    --This Year
    TY.iYear                TY,
    TY.iISOWeek             TY_iISOWeek,
    TY.FillableLines        TY_FillableLines,
    TY.BOLines              TY_BOLines,
    TY.FillableMerchRev     TY_FillableMerchRev,
    TY.BOMerchRev           TY_BOMerchRev,
    TY.FillableMerchCost    TY_FillableMerchCost,
    TY.BOMerchCost          TY_BOMerchCost,
    --Last Year
    LY.iYear                LY,
    LY.iISOWeek             LY_iISOWeek,
    LY.FillableLines        LY_FillableLines,
    LY.BOLines              LY_BOLines,
    LY.FillableMerchRev     LY_FillableMerchRev,
    LY.BOMerchRev           LY_BOMerchRev,
    LY.FillableMerchCost    LY_FillableMerchCost,
    LY.BOMerchCost          LY_BOMerchCost

FROM
       (select distinct iISOWeek
          from tblDate D
          where (D.dtDate <= CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101) -- previous isoweek
                    and D.dtDate >= CONVERT(VARCHAR(10), DATEADD(week, -4, getdate()) , 101))    -- 4 isoweeks ago)
              OR 
                (D.dtDate <= CONVERT(VARCHAR(10), DATEADD(yy, -1, DATEADD(week, -1, getdate())) , 101) -- previous ISOweek 1 year ago
                 and D.dtDate >= CONVERT(VARCHAR(10), DATEADD(yy, -1, DATEADD(week, -4, getdate())) , 101)) -- 4 ISOweeks ago minus 1 year
        ) Weeks   
        left join (select
                        D.iYear,
                        D.iISOWeek,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end)               FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end)  FillableMerchRev,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end)   FillableMerchCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end)                   BOLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedPrice else 0 end)      BOMerchRev,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end)       BOMerchCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate D on O.ixOrderDate = D.ixDate
                        join (select distinct iYear
                              from tblDate D
                              where D.dtDate = CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101)
                              ) years on years.iYear = D.iYear
                        join (select distinct iISOWEEK
                              from tblDate D
                              where D.dtDate <= CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101) -- previous isoweek
                                and D.dtDate > CONVERT(VARCHAR(10), DATEADD(week, -4, getdate()) , 101)    -- 4 isoweeks ago
                              ) weeks on weeks.iISOWeek = D.iISOWeek
                    where
                        not(OL.ixOrder like '%-%')
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        D.iYear,
                        D.iISOWeek
                    ) TY on TY.iISOWeek = Weeks.iISOWeek 
/*
iISOWeek    FillableLines   FillableMerchRev    FillableMerchCost   BOLines BOMerchRev  BOMerchCost
38          18018           1034322.523         563543.774          331     45823.48    28892.837
39          18528           999145.427          541988.043          297     30730.91    18785.90
37          18929           1091813.153         602341.515          259     24784.60    13695.672
40          17098           966423.521          526857.18           267     38072.33    19913.438
*/
        left join (select
                        D.iYear,
                        D.iISOWeek,
                    sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end)               FillableLines,
                    sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end)  FillableMerchRev,
                    sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end)   FillableMerchCost,
                    sum(case when flgLineStatus in ('Backordered') then 1 else 0 end)                   BOLines,
                    sum(case when flgLineStatus in ('Backordered') then mExtendedPrice else 0 end)      BOMerchRev,
                    sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end)       BOMerchCost
                   from
                    tblOrderLine OL
                    left join tblOrder O on OL.ixOrder = O.ixOrder
                    left join tblDate D on O.ixOrderDate = D.ixDate
                    
                    join (select distinct iYear
                          from tblDate D
                          where D.dtDate = CONVERT(VARCHAR(10), DATEADD(yy,-1,DATEADD(week, -1, getdate())) , 101)
                          )years on years.iYear = D.iYear
                    join (select distinct iISOWEEK
                          from tblDate D
                          where D.dtDate <= CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101) -- previous isoweek
                            and D.dtDate > CONVERT(VARCHAR(10), DATEADD(week, -4, getdate()) , 101)    -- 4 isoweeks ago
                          ) weeks on weeks.iISOWeek = D.iISOWeek
                    where
                        not(OL.ixOrder like '%-%')
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                    group by
                        D.iYear,
                        D.iISOWeek
                    ) LY on LY.iISOWeek = Weeks.iISOWeek 
/*
iISOWeek    FillableLines   FillableMerchRev    FillableMerchCost   BOLines BOMerchRev  BOMerchCost
38          17990           978350.066          533887.031          179     26859.89    14730.972
39          16815           934511.51           510224.281          188     27167.56    15491.735
37          18033           919413.60           503865.092          205     20614.86    11513.145
40          15485           870822.499          466243.716          156     19188.84    11275.412
*/

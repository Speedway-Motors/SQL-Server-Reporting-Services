-- Case 25994 - filter overridden SKUs from the Weekly Fill Rate Analysis reports
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
/* OVERRIDDEN SKU = 3870

IF CSR ORs the lineitem 
AND flgMadeToOrder = 0
THEN count as BO for this report

 If flgMadeToOrder = 1 ignore it for the the fill rate calculation - which is what happens right now).

*/
       (select distinct iISOWeek
          from tblDate D
          where (D.dtDate <= CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101) -- previous isoweek
                    and D.dtDate >= CONVERT(VARCHAR(10), DATEADD(week, -4, getdate()) , 101))    -- 4 isoweeks ago)
--              OR 
--                (D.dtDate <= CONVERT(VARCHAR(10), DATEADD(yy, -1, DATEADD(week, -1, getdate())) , 101) -- previous ISOweek 1 year ago
--                 and D.dtDate >= CONVERT(VARCHAR(10), DATEADD(yy, -1, DATEADD(week, -4, getdate())) , 101)) -- 4 ISOweeks ago minus 1 year
        ) Weeks   
       -- this year
        left join (select
                        D.iYear,
                        D.iISOWeek,
                        sum(case when flgLineStatus in ('Open', 'Shipped') 
                            and (OL.flgOverride = 0 
                                 OR (OL.flgOverride = 1 and SKU.flgMadeToOrder = 1)
                                 ) then 1 else 0  end
                            ) FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') 
                                AND (OL.flgOverride = 0 
                                     OR (OL.flgOverride = 1 and SKU.flgMadeToOrder = 1)
                                     ) then mExtendedPrice else 0 end
                            )  FillableMerchRev,
                        sum(case when flgLineStatus in ('Open', 'Shipped') 
                            and (OL.flgOverride = 0 
                                 OR
                                 (OL.flgOverride = 1 and SKU.flgMadeToOrder = 1)
                                 ) then mExtendedCost else 0 end
                            )  FillableMerchCost,                  
                        sum(case when (flgLineStatus in ('Backordered','Backordered FS')
                                       OR (OL.flgLineStatus in ('Open','Shipped') 
                                            and OL.flgOverride = 1
                                            and SKU.flgMadeToOrder = 0)
                                           ) then 1 else 0 end
                                        ) BOLines,
                        sum(case when (flgLineStatus in ('Backordered','Backordered FS')
                                       OR (OL.flgLineStatus in ('Open','Shipped') 
                                            and OL.flgOverride = 1
                                            and SKU.flgMadeToOrder = 0)) then mExtendedPrice else 0 end
                                        ) BOMerchRev,
                        sum(case when (flgLineStatus in ('Backordered','Backordered FS')
                                       OR (OL.flgLineStatus in ('Open','Shipped') 
                                            and OL.flgOverride = 1
                                            and SKU.flgMadeToOrder = 0)) then mExtendedCost else 0 end
                                        ) BOMerchCost
                    from
                        tblOrderLine OL
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate D on O.ixOrderDate = D.ixDate
                        join (select distinct iYear
                              from tblDate D
                              where D.dtDate = CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101)
                              ) years on years.iYear = D.iYear
                        join (select distinct iISOWeek
                              from tblDate D
                              where D.dtDate <= CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101) -- previous isoweek
                                and D.dtDate > CONVERT(VARCHAR(10), DATEADD(week, -4, getdate()) , 101)    -- 4 isoweeks ago
                              ) weeks on weeks.iISOWeek = D.iISOWeek
                        left join tblSKU SKU on SKU.ixSKU = OL.ixSKU                              
                    where
                        not(OL.ixOrder like '%-%')
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                         -- and O.ixCustomer NOT IN ('26101','26103') -- per AFCO, INCLUDE Inter Company Sales 
                        and SKU.flgIntangible = 0
/*                        
AND O.ixOrder in ('753864') -- TEST BATCH ONLY    ,'754699','754705','754683' 
-- AND SKU.ixSKU in ('1975-3','1993-5') -- TESTED
-- AND SKU.ixSKU in ('FAST') -- TESTED
AND SKU.ixSKU in ('HALFFRT','SHOCKTICKET','BOONVILLE','55000013780','55000014210','550000143','1975')
-- AND SKU.ixSKU in ('1973-6') -- TESTED
-- AND SKU.ixSKU in ('550000157')   -- TESTED   
*/
                    group by
                        D.iYear,
                        D.iISOWeek
                    ) TY on TY.iISOWeek = Weeks.iISOWeek 
       -- lasty year
        left join (select
                        D.iYear,
                        D.iISOWeek,
                        sum(case when flgLineStatus in ('Open', 'Shipped','Backordered FS') 
                            and (OL.flgOverride = 0 
                                 OR (OL.flgOverride = 1 and SKU.flgMadeToOrder = 1)
                                 ) then 1 else 0  end
                            ) FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped','Backordered FS')  
                                AND (OL.flgOverride = 0 
                                     OR (OL.flgOverride = 1 and SKU.flgMadeToOrder = 1)
                                     ) then mExtendedPrice else 0 end
                            )  FillableMerchRev,
                        sum(case when flgLineStatus in ('Open', 'Shipped','Backordered FS') 
                            and (OL.flgOverride = 0 
                                 OR
                                 (OL.flgOverride = 1 and SKU.flgMadeToOrder = 1)
                                 ) then mExtendedCost else 0 end
                            )  FillableMerchCost,                  
                        sum(case when (flgLineStatus in ('Backordered')
                                       OR (OL.flgLineStatus in ('Open','Shipped') 
                                            and OL.flgOverride = 1
                                            and SKU.flgMadeToOrder = 0)
                                           ) then 1 else 0 end
                                        ) BOLines,
                        sum(case when (flgLineStatus in ('Backordered')
                                       OR (OL.flgLineStatus in ('Open','Shipped') 
                                            and OL.flgOverride = 1
                                            and SKU.flgMadeToOrder = 0)) then mExtendedPrice else 0 end
                                        ) BOMerchRev,
                        sum(case when (flgLineStatus in ('Backordered')
                                       OR (OL.flgLineStatus in ('Open','Shipped') 
                                            and OL.flgOverride = 1
                                            and SKU.flgMadeToOrder = 0)) then mExtendedCost else 0 end
                                        ) BOMerchCost
  
                   from
                    tblOrderLine OL
                    left join tblOrder O on OL.ixOrder = O.ixOrder
                    left join tblDate D on O.ixOrderDate = D.ixDate
                    
                    join (select distinct iYear
                          from tblDate D
                          where D.dtDate = CONVERT(VARCHAR(10), DATEADD(yy,-1,DATEADD(week, -1, getdate())) , 101)
                          )years on years.iYear = D.iYear
                    join (select distinct iISOWeek
                          from tblDate D
                          where D.dtDate <= CONVERT(VARCHAR(10), DATEADD(week, -1, getdate()) , 101) -- previous isoweek
                            and D.dtDate > CONVERT(VARCHAR(10), DATEADD(week, -4, getdate()) , 101)    -- 4 isoweeks ago
                          ) weeks on weeks.iISOWeek = D.iISOWeek
                      left join tblSKU SKU on SKU.ixSKU = OL.ixSKU                           
                    where
                        not(OL.ixOrder like '%-%')
                        and O.sOrderStatus in ('Open', 'Shipped')
                        and OL.flgKitComponent = 0
                        and SKU.flgIntangible = 0
                        -- and O.ixCustomer NOT IN ('26101','26103') -- per AFCO, INCLUDE Inter Company Sales 
                        and SKU.flgIntangible = 0 
/*                        
AND O.ixOrder in ('753864') -- TEST BATCH ONLY    ,'754699','754705','754683' 
-- AND SKU.ixSKU in ('1975-3','1993-5') -- TESTED
-- AND SKU.ixSKU in ('FAST') -- TESTED
AND SKU.ixSKU in ('HALFFRT','SHOCKTICKET','BOONVILLE','55000013780','55000014210','550000143','1975')
-- AND SKU.ixSKU in ('1973-6') -- TESTED
-- AND SKU.ixSKU in ('550000157')   -- TESTED   
*/                                     
                    group by
                        D.iYear,
                        D.iISOWeek
                    ) LY on LY.iISOWeek = Weeks.iISOWeek 
ORDER BY
  TY.iISOWeek desc
  
/*

select flgIntangible, COUNT(*)
from tblSKU
group by   flgIntangible

select distinct sOrderStatus from tblOrder
  
  
  
*/


  
/**** FINDING TEST RECORDS  
select ixOrder, ixCustomer, 
    SKU.ixSKU, SKU.sDescription,
    flgOverride, flgLineStatus, SKU.flgMadeToOrder, SKU.flgIntangible 
from tblOrderLine OL
join tblSKU SKU on OL.ixSKU = SKU.ixSKU 
where 
ixOrder in ('753864') -- TEST BATCH ONLY    ,'754699','754705','754683'  
order by ixOrder, OL.ixSKU
*/








/*
select COUNT(*) Qty, flgLineStatus
from tblOrderLine
where ixOrderDate >= 16943
group by flgLineStatus
order by COUNT(*) desc

    /*  flgLineStatus last 12 months */
    -- 
    Qty     flgLineStatus
    1877468	Shipped
    112204	Cancelled Quote
    59116	unknown
    35891	Backordered
    25144	Cancelled
    7270	Lost
    6871	Dropshipped
    2655	Open
    1819	Backordered FS
    1412	Quote
*/


/*
select COUNT(*) Qty, sOrderStatus
from tblOrder
where ixOrderDate >= 16943
group by sOrderStatus
order by COUNT(*) desc
        /*
        Qty	sOrderStatus
        42518	Shipped
        1098	Cancelled Quote
        950	Cancelled
        278	Backordered
        194	Open
        11	Quote
        */
*/








/**** ORIG LOGIC 
                        sum(case when flgLineStatus in ('Open', 'Shipped') then 1 else 0 end)               FillableLines,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedPrice else 0 end)  FillableMerchRev,
                        sum(case when flgLineStatus in ('Open', 'Shipped') then mExtendedCost else 0 end)   FillableMerchCost,
                        sum(case when flgLineStatus in ('Backordered') then 1 else 0 end)                   BOLines,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedPrice else 0 end)      BOMerchRev,
                        sum(case when flgLineStatus in ('Backordered') then mExtendedCost else 0 end)       BOMerchCost
*****/


-- table PJC_CustomerOrderHistory MUST BE BUILT ON DOMINO due to the view that looks at archived order info

/* STEP 1 */ truncate table PJC_CustomerOrderHistory   -- Drop table PJC_CustomerOrderHistory

/* STEP 2 - POPULATE THE TABLE WITH EVERY CUSTOMER AND THEIR ORDER HISTORY BY 12 MONTH PERIODS
            about 14 mins runtime */
insert into PJC_CustomerOrderHistory    
select C.ixCustomer, FO.FirstOrder, -- 11,837,23
    isnull([145M+].[145M+Merch],0)  [145M+Merch],   isnull([145M+].[145M+OrdCount],0) [145M+OrdCount],
    isnull([144M].[144MMerch],0)    [144MMerch],    isnull([144M].[144MOrdCount],0) [144MOrdCount],
    isnull([132M].[132MMerch],0)    [132MMerch],    isnull([132M].[132MOrdCount],0) [132MOrdCount],
    isnull([120M].[120MMerch],0)    [120MMerch],    isnull([120M].[120MOrdCount],0) [120MOrdCount],
    isnull([108M].[108MMerch],0)    [108MMerch],    isnull([108M].[108MOrdCount],0) [108MOrdCount],
    isnull([96M].[96MMerch],0)      [96MMerch],     isnull([96M].[96MOrdCount],0)   [96MOrdCount],
    isnull([84M].[84MMerch],0)      [84MMerch],     isnull([84M].[84MOrdCount],0)   [84MOrdCount],
    isnull([72M].[72MMerch],0)      [72MMerch],     isnull([72M].[72MOrdCount],0)   [72MOrdCount],
    isnull([60M].[60MMerch],0)      [60MMerch],     isnull([60M].[60MOrdCount],0)   [60MOrdCount],
    isnull([48M].[48MMerch],0)      [48MMerch],     isnull([48M].[48MOrdCount],0)   [48MOrdCount],
    isnull([36M].[36MMerch],0)      [36MMerch],     isnull([36M].[36MOrdCount],0)   [36MOrdCount],
    isnull([24M].[24MMerch],0)      [24MMerch],     isnull([24M].[24MOrdCount],0)   [24MOrdCount],
    isnull([12M].[12MMerch],0)      [12MMerch],     isnull([12M].[12MOrdCount],0)   [12MOrdCount],
    (isnull([145M+].[145M+Merch],0)+isnull([144M].[144MMerch],0)+isnull([132M].[132MMerch],0)+isnull([120M].[120MMerch],0)+isnull([108M].[108MMerch],0)+ isnull([96M].[96MMerch],0)+isnull([84M].[84MMerch],0)+isnull([72M].[72MMerch],0)+isnull([60M].[60MMerch],0)+isnull([48M].[48MMerch],0)+isnull([36M].[36MMerch],0)+isnull([24M].[24MMerch],0)+isnull([12M].[12MMerch],0)) [TotMerch],
    (isnull([145M+].[145M+OrdCount],0)+isnull([144M].[144MOrdCount],0)+isnull([132M].[132MOrdCount],0)+isnull([120M].[120MOrdCount],0)+isnull([108M].[108MOrdCount],0)+isnull([96M].[96MOrdCount],0)+isnull([84M].[84MOrdCount],0)+isnull([72M].[72MOrdCount],0)+isnull([60M].[60MOrdCount],0)+isnull([48M].[48MOrdCount],0)+isnull([36M].[36MOrdCount],0)+ isnull([24M].[24MOrdCount],0)+isnull([12M].[12MOrdCount],0)) [TotOrdCount]    
into PJC_CustomerOrderHistory       
    FROM tblCustomer C
    left JOIN (select ixCustomer,
             --   min(datepart("yyyy",dtOrderDate)) [FirstOrder],
                (case when min(dtOrderDate) >  DATEADD(yy, -1, getdate()) 
                       and min(dtOrderDate) <= GETDATE()                   then '12M'
                when min(dtOrderDate) >  DATEADD(yy, -2, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -1, getdate())  then '24M'
                when min(dtOrderDate) >  DATEADD(yy, -3, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -2, getdate())  then '36M'
                when min(dtOrderDate) >  DATEADD(yy, -4, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -3, getdate())  then '48M'
                when min(dtOrderDate) >  DATEADD(yy, -5, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -4, getdate())  then '60M'
                when min(dtOrderDate) >  DATEADD(yy, -6, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -5, getdate())  then '72M'
                when min(dtOrderDate) >  DATEADD(yy, -7, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -6, getdate())  then '84M'
                when min(dtOrderDate) >  DATEADD(yy, -8, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -7, getdate())  then '96M'
                when min(dtOrderDate) >  DATEADD(yy, -9, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -8, getdate())  then '108M'
                when min(dtOrderDate) >  DATEADD(yy, -10, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -9, getdate())  then '120M'                                                                                                                                                                                        
                when min(dtOrderDate) >  DATEADD(yy, -11, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -10, getdate())  then '132M'   
                when min(dtOrderDate) >  DATEADD(yy, -12, getdate()) 
                       and min(dtOrderDate) <= DATEADD(yy, -11, getdate())  then '144M' 
                     else '145M+'               
                     end) [FirstOrder]
                 from vwOrderAllHistory
               where sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer) FO on FO.ixCustomer = C.ixCustomer
     -- 12 Month
    left join (select ixCustomer,
                sum(mMerchandise) [12MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [12MOrdCount]    
               from tblOrder
               where dtOrderDate >  DATEADD(yy, -1, getdate())  -- 1 year ago
                 and dtOrderDate <= GETDATE()                   -- today
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [12M] on [12M].ixCustomer = C.ixCustomer       
     -- 24 Month
    left join (select ixCustomer,
                sum(mMerchandise) [24MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [24MOrdCount]    
               from tblOrder
               where dtOrderDate >  DATEADD(yy, -2, getdate())  -- 2 years ago
                 and dtOrderDate <= DATEADD(yy, -1, getdate())  -- 1 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [24M] on [24M].ixCustomer = C.ixCustomer       
     -- 36 Month
    left join (select ixCustomer,
                sum(mMerchandise) [36MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [36MOrdCount]    
               from tblOrder
               where dtOrderDate >  DATEADD(yy, -3, getdate())  -- 3 years ago
                 and dtOrderDate <= DATEADD(yy, -2, getdate())  -- 2 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [36M] on [36M].ixCustomer = C.ixCustomer   
     -- 48 Month
    left join (select ixCustomer,
                sum(mMerchandise) [48MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [48MOrdCount]    
               from vwOrderAllHistory -- switching to view to get ARCHIVED orders
               where dtOrderDate >  DATEADD(yy, -4, getdate())  -- 4 years ago
                 and dtOrderDate <= DATEADD(yy, -3, getdate())  -- 3 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [48M] on [48M].ixCustomer = C.ixCustomer  
     -- 60 Month
    left join (select ixCustomer,
                sum(mMerchandise) [60MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [60MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -5, getdate())  -- 5 years ago
                 and dtOrderDate <= DATEADD(yy, -4, getdate())  -- 4 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [60M] on [60M].ixCustomer = C.ixCustomer  
     -- 72 Month
    left join (select ixCustomer,
                sum(mMerchandise) [72MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [72MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -6, getdate())  -- 6 years ago
                 and dtOrderDate <= DATEADD(yy, -5, getdate())  -- 5 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [72M] on [72M].ixCustomer = C.ixCustomer  
     -- 84 Month
    left join (select ixCustomer,
                sum(mMerchandise) [84MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [84MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -7, getdate())  -- 7 years ago
                 and dtOrderDate <= DATEADD(yy, -6, getdate())  -- 6 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [84M] on [84M].ixCustomer = C.ixCustomer  
     -- 96 Month
    left join (select ixCustomer,
                sum(mMerchandise) [96MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [96MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -8, getdate())  -- 8 years ago
                 and dtOrderDate <= DATEADD(yy, -7, getdate())  -- 7 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [96M] on [96M].ixCustomer = C.ixCustomer  
     -- 108 Month
    left join (select ixCustomer,
                sum(mMerchandise) [108MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [108MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -9, getdate())  -- 9 years ago
                 and dtOrderDate <= DATEADD(yy, -8, getdate())  -- 8 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [108M] on [108M].ixCustomer = C.ixCustomer  
     -- 120 Month
    left join (select ixCustomer,
                sum(mMerchandise) [120MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [120MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -10, getdate())  -- 10 years ago
                 and dtOrderDate <= DATEADD(yy, -9, getdate())  -- 9 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [120M] on [120M].ixCustomer = C.ixCustomer  
     -- 132 Month
    left join (select ixCustomer,
                sum(mMerchandise) [132MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [132MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -11, getdate())  -- 11 years ago
                 and dtOrderDate <= DATEADD(yy, -10, getdate())  -- 10 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [132M] on [132M].ixCustomer = C.ixCustomer  
     -- 144 Month
    left join (select ixCustomer,
                sum(mMerchandise) [144MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [144MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -12, getdate())  -- 12 years ago
                 and dtOrderDate <= DATEADD(yy, -11, getdate())  -- 11 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [144M] on [144M].ixCustomer = C.ixCustomer  
     -- 145+ Month
    left join (select ixCustomer,
                sum(mMerchandise) [145M+Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [145M+OrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(yy, -13, getdate())  -- 12 years ago
                 and dtOrderDate <= DATEADD(yy, -12, getdate())  -- 11 years ago                 
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [145M+] on [145M+].ixCustomer = C.ixCustomer                  
                                                                                                                                                                            
               
 
 
              

/* STEP 3 - Extract the results & populate spreadsheet */


/**** 12M NAME FLOW ****/
SELECT
    '12M NAME FLOW',
    --12 Month buyers 
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [24MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [24MOrdCount] > 0 
     and [12MOrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = '12M'
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [12MOrdCount] > 0 
    and [24MOrdCount] = 0 
    and ([36MOrdCount] > 0 
          or [48MOrdCount] > 0
          or [60MOrdCount] > 0
          or [72MOrdCount] > 0
          or [84MOrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers],
     
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [12MOrdCount] > 0 
    and [24MOrdCount] = 0 
    and [36MOrdCount] = 0 
    and [48MOrdCount] = 0
    and [60MOrdCount] = 0
    and [72MOrdCount] = 0
    and [84MOrdCount] = 0
    and ( [96MOrdCount] > 0
        or [108MOrdCount] > 0 
        or [120MOrdCount] > 0     
        or [132MOrdCount] > 0   
        or [144MOrdCount] > 0   
        or [145M+OrdCount] > 0                           
         )
     ) [Reactivation of 73 month+ buyers]
     

GO

/**** 24M NAME FLOW ****/
SELECT
    '24M NAME FLOW',
    --12 Month buyers 
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [36MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [36MOrdCount] > 0 
     and [24MOrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = '24M'
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [24MOrdCount] > 0 
    and [36MOrdCount] = 0 
    and ([48MOrdCount] > 0 
          or [60MOrdCount] > 0
          or [72MOrdCount] > 0
          or [84MOrdCount] > 0
          or [96MOrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers],     
     
         -- Reactivation of 73 month+ buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [24MOrdCount] > 0 
    and [36MOrdCount] = 0 
    and [48MOrdCount] = 0 
    and [60MOrdCount] = 0
    and [72MOrdCount] = 0
    and [84MOrdCount] = 0
    and [96MOrdCount] = 0
    and ([108MOrdCount] > 0
      or [120MOrdCount] > 0
      or [132MOrdCount] > 0
      or [144MOrdCount] > 0
      or [145M+OrdCount] > 0
          )
     ) [Reactivation of 73 month+ buyers]

GO

/**** 36M NAME FLOW ****/
SELECT
    '36M NAME FLOW',
    --12 Month buyers 
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [48MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [48MOrdCount] > 0 
     and [36MOrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = '36M'
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [36MOrdCount] > 0 
    and [48MOrdCount] = 0 
    and ([60MOrdCount] > 0 
          or [72MOrdCount] > 0
          or [84MOrdCount] > 0
          or [96MOrdCount] > 0
          or [108MOrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers],
     
    -- Reactivation of 73 month+ buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [36MOrdCount] > 0 
    and [48MOrdCount] = 0 
    and [60MOrdCount] = 0
    and [72MOrdCount] = 0
    and [84MOrdCount] = 0
    and [96MOrdCount] = 0
    and [108MOrdCount] = 0
    and ([120MOrdCount] > 0
      or [132MOrdCount] > 0
      or [144MOrdCount] > 0
      or [145M+OrdCount] > 0
          )
     ) [Reactivation of 73 month+ buyers]   
 
 GO    
     
/**** 48M NAME FLOW ****/
SELECT
    '48M NAME FLOW',
    --12 Month buyers 
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [60MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [60MOrdCount] > 0 
     and [48MOrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = '48M'
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [48MOrdCount] > 0 
    and [60MOrdCount] = 0 
    and ([72MOrdCount] > 0 
          or [84MOrdCount] > 0
          or [96MOrdCount] > 0
          or [108MOrdCount] > 0
          or [120MOrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers],

    -- Reactivation of 73 month+ buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [48MOrdCount] > 0 
    and [60MOrdCount] = 0
    and [72MOrdCount] = 0
    and [84MOrdCount] = 0
    and [96MOrdCount] = 0
    and [108MOrdCount] = 0
    and [120MOrdCount] = 0     
    and ([132MOrdCount] > 0
      or [144MOrdCount] > 0
      or [145M+OrdCount] > 0
          )
     ) [Reactivation of 73 month+ buyers]            
     
 GO
     
/**** 60M NAME FLOW ****/
SELECT
    '60M NAME FLOW',
    --12 Month buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [72MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [72MOrdCount] > 0 
     and [60MOrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = '60M'
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [60MOrdCount] > 0 
    and [72MOrdCount] = 0 
    and ([84MOrdCount] > 0 
          or [96MOrdCount] > 0
          or [108MOrdCount] > 0
          or [120MOrdCount] > 0
          or [132MOrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers],
     
    -- Reactivation of 73 month+ buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [60MOrdCount] > 0 
    and [72MOrdCount] = 0
    and [84MOrdCount] = 0
    and [96MOrdCount] = 0
    and [108MOrdCount] = 0
    and [120MOrdCount] = 0    
    and [132MOrdCount] = 0      
    and ([144MOrdCount] > 0
      or [145M+OrdCount] > 0
          )
     ) [Reactivation of 73 month+ buyers]                  
     
     
GO

/**** 72M NAME FLOW ****/
SELECT
    '72M NAME FLOW',
    --12 Month buyers 
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [84MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [84MOrdCount] > 0 
     and [72MOrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = '72M'
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [72MOrdCount] > 0 
    and [84MOrdCount] = 0 
    and ([96MOrdCount] > 0 
          or [108MOrdCount] > 0
          or [120MOrdCount] > 0
          or [132MOrdCount] > 0
          or [144MOrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers],

    -- Reactivation of 73 month+ buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [72MOrdCount] > 0 
    and [84MOrdCount] = 0
    and [96MOrdCount] = 0
    and [108MOrdCount] = 0
    and [120MOrdCount] = 0    
    and [132MOrdCount] = 0  
    and [144MOrdCount] = 0  
    and [145M+OrdCount] > 0
        
     ) [Reactivation of 73 month+ buyers]               
     


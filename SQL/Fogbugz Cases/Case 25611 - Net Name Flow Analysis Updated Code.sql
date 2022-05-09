
/********************************************************************************************
   STEP 1   truncate table [SMITemp].dbo.ASC_CustomerOrderHistory   -- Drop table [SMITemp].dbo.ASC_CustomerOrderHistory
********************************************************************************************/

-- Do a replace/find function and replace the previous date part with the current date part (i.e. find 07/31/ replace with 8/31/ 

/********************************************************************************************
   STEP 2 - POPULATE THE TABLE WITH EVERY CUSTOMER & THEIR ORDER HISTORY BY 12 MONTH PERIODS
                        approx 1:15 min runtime (USE LNK-DW1) 
********************************************************************************************/     

/*
       
insert into [SMITemp].dbo.ASC_CustomerOrderHistory    
select C.ixCustomer, FO.FirstOrder, -- 1,818,425
    -- the data is needed so far back because we need to be able to figure out 
    -- the 73M+ Buyer reactivation for the 72M NAME FLOW group (so > 72M + another 72M)
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
--into [SMITemp].dbo.ASC_CustomerOrderHistory       
    FROM tblCustomer C
    left JOIN (select ixCustomer,
             --   min(datepart("yyyy",dtOrderDate)) [FirstOrder],
                (case when min(dtOrderDate) >  DATEADD(MM, -12, '07/31/16') 
                       and min(dtOrderDate) <= '07/31/16'                   then '12M'
                when min(dtOrderDate) >  DATEADD(MM, -24, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -12, '07/31/16')  then '24M'
                when min(dtOrderDate) >  DATEADD(MM, -36, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -24, '07/31/16')  then '36M'
                when min(dtOrderDate) >  DATEADD(MM, -48, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -36, '07/31/16')  then '48M'
                when min(dtOrderDate) >  DATEADD(MM, -60, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -48, '07/31/16')  then '60M'
                when min(dtOrderDate) >  DATEADD(MM, -72, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -60, '07/31/16')  then '72M'
                when min(dtOrderDate) >  DATEADD(MM, -84, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -72, '07/31/16')  then '84M'
                when min(dtOrderDate) >  DATEADD(MM, -96, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -84, '07/31/16')  then '96M'
                when min(dtOrderDate) >  DATEADD(MM, -108, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -96, '07/31/16')  then '108M'
                when min(dtOrderDate) >  DATEADD(MM, -120, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -108, '07/31/16')  then '120M'                                                                                                                                                                                        
                when min(dtOrderDate) >  DATEADD(MM, -132, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -120, '07/31/16')  then '132M'   
                when min(dtOrderDate) >  DATEADD(MM, -144, '07/31/16') 
                       and min(dtOrderDate) <= DATEADD(MM, -132, '07/31/16')  then '144M' 
                     else '145M+'               
                     end) [FirstOrder]
                 from vwOrderAllHistory
               where sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer) FO on FO.ixCustomer = C.ixCustomer
     -- 12 Month
    left join (select ixCustomer,
                sum(mMerchandise) [12MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [12MOrdCount]    
               from tblOrder
               where dtOrderDate >  DATEADD(MM, -12, '07/31/16')  -- 1 year ago
                 and dtOrderDate <= '07/31/16'                   -- today
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [12M] on [12M].ixCustomer = C.ixCustomer       
     -- 24 Month
    left join (select ixCustomer,
                sum(mMerchandise) [24MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [24MOrdCount]    
               from tblOrder
               where dtOrderDate >  DATEADD(MM, -24, '07/31/16')  -- 2 years ago
                 and dtOrderDate <= DATEADD(MM, -12, '07/31/16')  -- 1 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [24M] on [24M].ixCustomer = C.ixCustomer       
     -- 36 Month
    left join (select ixCustomer,
                sum(mMerchandise) [36MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [36MOrdCount]    
               from tblOrder
               where dtOrderDate >  DATEADD(MM, -36, '07/31/16')  -- 3 years ago
                 and dtOrderDate <= DATEADD(MM, -24, '07/31/16')  -- 2 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [36M] on [36M].ixCustomer = C.ixCustomer   
     -- 48 Month
    left join (select ixCustomer,
                sum(mMerchandise) [48MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [48MOrdCount]    
               from vwOrderAllHistory -- switching to view to get ARCHIVED orders
               where dtOrderDate >  DATEADD(MM, -48, '07/31/16')  -- 4 years ago
                 and dtOrderDate <= DATEADD(MM, -36, '07/31/16')  -- 3 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [48M] on [48M].ixCustomer = C.ixCustomer  
     -- 60 Month
    left join (select ixCustomer,
                sum(mMerchandise) [60MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [60MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -60, '07/31/16')  -- 5 years ago
                 and dtOrderDate <= DATEADD(MM, -48, '07/31/16')  -- 4 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [60M] on [60M].ixCustomer = C.ixCustomer  
     -- 72 Month
    left join (select ixCustomer,
                sum(mMerchandise) [72MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [72MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -72, '07/31/16')  -- 6 years ago
                 and dtOrderDate <= DATEADD(MM, -60, '07/31/16')  -- 5 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [72M] on [72M].ixCustomer = C.ixCustomer  
     -- 84 Month
    left join (select ixCustomer,
                sum(mMerchandise) [84MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [84MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -84, '07/31/16')  -- 7 years ago
                 and dtOrderDate <= DATEADD(MM, -72, '07/31/16')  -- 6 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [84M] on [84M].ixCustomer = C.ixCustomer  
     -- 96 Month
    left join (select ixCustomer,
                sum(mMerchandise) [96MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [96MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -96, '07/31/16')  -- 8 years ago
                 and dtOrderDate <= DATEADD(MM, -84, '07/31/16')  -- 7 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [96M] on [96M].ixCustomer = C.ixCustomer  
     -- 108 Month
    left join (select ixCustomer,
                sum(mMerchandise) [108MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [108MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -108, '07/31/16')  -- 9 years ago
                 and dtOrderDate <= DATEADD(MM, -96, '07/31/16')  -- 8 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [108M] on [108M].ixCustomer = C.ixCustomer  
     -- 120 Month
    left join (select ixCustomer,
                sum(mMerchandise) [120MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [120MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -120, '07/31/16')  -- 10 years ago
                 and dtOrderDate <= DATEADD(MM, -108, '07/31/16')  -- 9 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [120M] on [120M].ixCustomer = C.ixCustomer  
     -- 132 Month
    left join (select ixCustomer,
                sum(mMerchandise) [132MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [132MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -132, '07/31/16')  -- 11 years ago
                 and dtOrderDate <= DATEADD(MM, -120, '07/31/16')  -- 10 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [132M] on [132M].ixCustomer = C.ixCustomer  
     -- 144 Month
    left join (select ixCustomer,
                sum(mMerchandise) [144MMerch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [144MOrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -144, '07/31/16')  -- 12 years ago
                 and dtOrderDate <= DATEADD(MM, -132, '07/31/16')  -- 11 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [144M] on [144M].ixCustomer = C.ixCustomer  
     -- 145+ Month
    left join (select ixCustomer,
                sum(mMerchandise) [145M+Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [145M+OrdCount]    
               from vwOrderAllHistory
               where dtOrderDate >  DATEADD(MM, -145, '07/31/16')  -- 12 years ago
                 and dtOrderDate <= DATEADD(MM, -144, '07/31/16')  -- 11 years ago                 
                 and sOrderStatus = 'Shipped' and sOrderType <> 'Internal' -- and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [145M+] on [145M+].ixCustomer = C.ixCustomer           

*/                                                                                                                                                                            
 
 --on the spreadsheet
 --retained 12Mo file = 12-month buyers + attrition
  
              
/*********************************************************************/
/* STEP 3 - Extract the results & populate top portion of spreadsheet */
/********************************************************************/


/* Start by running the select count (*) query on all with everything else (SUM(....)) commented out 
  (only one portion of the query can be run at a time) 
    Input all attrition numbers in the correct cells on the bottom portion of the spreadsheet (i.e. row 43...) 
   Then fill in the upper portion with the remaining data (i.e. C/D/G/J/M/P 7,16,25). 
   Comment out the count(*) and run for the next portion (i.e. SUM(TM.Sales)) and fill in the corresponding values
  */ 
 
 /* replace out these pieces after each one is run: 
       count(*)
       SUM(TM.Sales)
       SUM(LT.Sales)
       SUM(TM.OrderCnt)
       SUM(LT.OrderCnt)
       SUM(TM.GM)
       SUM(LT.GM) 
   */


/**** 12M NAME FLOW ****/
SELECT
    '12M NAME FLOW',
    --12 Month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer                
    where [24MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer       
    where [24MOrdCount] > 0 
     and [12MOrdCount] = 0   
     ) [Attrition],
    

    -- New First time buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 68,901
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer      
    where FirstOrder = '12M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH-- 22,382  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/16') AND '07/31/16'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer      
    where [12MOrdCount] > 0 
    and [24MOrdCount] = 0 
    and ([36MOrdCount] > 0 or [48MOrdCount] > 0 or [60MOrdCount] > 0 or [72MOrdCount] > 0 or [84MOrdCount] > 0)
     ) [Reactivation of 12-72M buyers]
     

GO


/**** 24M NAME FLOW ****/
SELECT
    '24M NAME FLOW',
    --12 Month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/15') AND '07/31/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/15') AND '07/31/15' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer        
    where [36MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/15') AND '07/31/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/15') AND '07/31/15' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where [36MOrdCount] > 0 
     and [24MOrdCount] = 0   
     ) [Attrition],
    

    -- New First time buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/15') AND '07/31/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/15') AND '07/31/15' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where FirstOrder = '24M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/15') AND '07/31/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/15') AND '07/31/15' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where [24MOrdCount] > 0 
    and [36MOrdCount] = 0 
    and ([48MOrdCount] > 0 or [60MOrdCount] > 0 or [72MOrdCount] > 0 or [84MOrdCount] > 0 or [96MOrdCount] > 0)
     ) [Reactivation of 12-72M buyers]

GO


/**** 36M NAME FLOW ****/
SELECT
    '36M NAME FLOW',
    --12 Month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/14') AND '07/31/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/14') AND '07/31/14' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer      
    where [48MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/14') AND '07/31/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/14') AND '07/31/14' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where [48MOrdCount] > 0 
     and [36MOrdCount] = 0   
     ) [Attrition],
    

    -- New First time buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/14') AND '07/31/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/14') AND '07/31/14' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where FirstOrder = '36M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/14') AND '07/31/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/14') AND '07/31/14' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where [36MOrdCount] > 0 
    and [48MOrdCount] = 0 
    and ([60MOrdCount] > 0 or [72MOrdCount] > 0 or [84MOrdCount] > 0 or [96MOrdCount] > 0 or [108MOrdCount] > 0)
     ) [Reactivation of 12-72M buyers]
 
 GO    
 
 
 
 /**** 48M NAME FLOW ****/
SELECT
    '48M NAME FLOW',
    --12 Month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [60MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [60MOrdCount] > 0 
     and [48MOrdCount] = 0   
     ) [Attrition],
    

    -- New First time buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where FirstOrder = '48M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/13') AND '07/31/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [48MOrdCount] > 0 
    and [60MOrdCount] = 0 
    and ([72MOrdCount] > 0 or [84MOrdCount] > 0 or [96MOrdCount] > 0 or [108MOrdCount] > 0 or [120MOrdCount] > 0)
     ) [Reactivation of 12-72M buyers]   
     
 GO
 
 
/**** 60M NAME FLOW ****/
SELECT
    '60M NAME FLOW',
    --12 Month buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where [72MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where [72MOrdCount] > 0 
     and [60MOrdCount] = 0   
     ) [Attrition],
    

    -- New First time buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where FirstOrder = '60M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/12') AND '07/31/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [60MOrdCount] > 0 
    and [72MOrdCount] = 0 
    and ([84MOrdCount] > 0 or [96MOrdCount] > 0 or [108MOrdCount] > 0 or [120MOrdCount] > 0 or [132MOrdCount] > 0)
     ) [Reactivation of 12-72M buyers]
     
GO  


/**** 72M NAME FLOW ****/
SELECT
    '72M NAME FLOW',
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [84MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [84MOrdCount] > 0 
     and [72MOrdCount] = 0   
     ) [Attrition],
    

    -- New First time buyers
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer  
    where FirstOrder = '72M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select SUM(LT.GM) 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -12, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                     
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/11') AND '07/31/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer  
    where [72MOrdCount] > 0 
    and [84MOrdCount] = 0 
    and ([96MOrdCount] > 0 or [108MOrdCount] > 0 or [120MOrdCount] > 0 or [132MOrdCount] > 0 or [144MOrdCount] > 0
         )
     ) [Reactivation of 12-72M buyers]             
     
GO




              
/*************************************************************************************/
/* STEP 4 - Extract the results & populate bottom portion (attrition) of spreadsheet */
/************************************************************************************/

/*

/**** 12M NAME FLOW ****/

    -- Attrition of 12-month buyers
    select count(*)
         , SUM(TM.Sales) AS TMSales
         , SUM(LT.Sales) AS LTSales
         , SUM(TM.OrderCnt) AS TMOrderCnt
         , SUM(LT.OrderCnt) AS LTOrderCnt 
         , SUM(TM.GM) AS TMGM
         , SUM(LT.GM) AS LTGM 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -24, '07/31/16') AND DATEADD(MM, -12, '07/31/16')
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
     left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/16') AND DATEADD(MM, -12, '07/31/16')
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
                ) LT ON LT.ixCustomer = COH.ixCustomer       
where [24MOrdCount] > 0 
  and [12MOrdCount] = 0   

/**** 24M NAME FLOW ****/

    -- Attrition of 12-month buyers
    select count(*)
         , SUM(TM.Sales) AS TMSales
         , SUM(LT.Sales) AS LTSales
         , SUM(TM.OrderCnt) AS TMOrderCnt
         , SUM(LT.OrderCnt) AS LTOrderCnt 
         , SUM(TM.GM) AS TMGM
         , SUM(LT.GM) AS LTGM          
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -24, '07/31/15' ) AND DATEADD(MM, -12, '07/31/15' )
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
     left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/15') AND DATEADD(MM, -12, '07/31/15')
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
                ) LT ON LT.ixCustomer = COH.ixCustomer       
    where [36MOrdCount] > 0 
     and [24MOrdCount] = 0  
     
/**** 36M NAME FLOW ****/

    -- Attrition of 12-month buyers
    select count(*)
         , SUM(TM.Sales) AS TMSales
         , SUM(LT.Sales) AS LTSales
         , SUM(TM.OrderCnt) AS TMOrderCnt
         , SUM(LT.OrderCnt) AS LTOrderCnt 
         , SUM(TM.GM) AS TMGM
         , SUM(LT.GM) AS LTGM          
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -24, '07/31/14' ) AND DATEADD(MM, -12, '07/31/14' )
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
     left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/14') AND DATEADD(MM, -12, '07/31/14')
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
                ) LT ON LT.ixCustomer = COH.ixCustomer       
    where [48MOrdCount] > 0 
     and [36MOrdCount] = 0      
     
/**** 48M NAME FLOW ****/

    -- Attrition of 12-month buyers
    select count(*)
         , SUM(TM.Sales) AS TMSales
         , SUM(LT.Sales) AS LTSales
         , SUM(TM.OrderCnt) AS TMOrderCnt
         , SUM(LT.OrderCnt) AS LTOrderCnt 
         , SUM(TM.GM) AS TMGM
         , SUM(LT.GM) AS LTGM          
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -24, '07/31/13' ) AND DATEADD(MM, -12, '07/31/13' )
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
     left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/13') AND DATEADD(MM, -12, '07/31/13')
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
                ) LT ON LT.ixCustomer = COH.ixCustomer       
    where [60MOrdCount] > 0 
     and [48MOrdCount] = 0         
     
/**** 60M NAME FLOW ****/

    -- Attrition of 12-month buyers
    select count(*)
         , SUM(TM.Sales) AS TMSales
         , SUM(LT.Sales) AS LTSales
         , SUM(TM.OrderCnt) AS TMOrderCnt
         , SUM(LT.OrderCnt) AS LTOrderCnt 
         , SUM(TM.GM) AS TMGM
         , SUM(LT.GM) AS LTGM          
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -24, '07/31/12' ) AND DATEADD(MM, -12, '07/31/12' )
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
     left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM                    
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '07/31/12') AND DATEADD(MM, -12, '07/31/12')
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
                ) LT ON LT.ixCustomer = COH.ixCustomer       
    where [72MOrdCount] > 0 
     and [60MOrdCount] = 0       

*/
     
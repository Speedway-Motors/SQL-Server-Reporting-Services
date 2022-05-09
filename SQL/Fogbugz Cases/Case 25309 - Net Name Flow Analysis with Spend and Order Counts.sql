/**** 12M NAME FLOW ****/
SELECT
    '12M NAME FLOW',
    --12 Month buyers 
    (select -- count(*)
         -- SUM(TM.Sales)
        -- SUM(LT.Sales)
       -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/26/15') AND '01/26/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/26/15') AND '01/26/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer                
    where [24MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select -- count(*)
         -- SUM(TM.Sales)
        -- SUM(LT.Sales)
       -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/26/15') AND '01/26/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/26/15') AND '01/26/15'
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
    (select -- count(*)
         -- SUM(TM.Sales)
        -- SUM(LT.Sales)
       -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 68,901
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/26/15') AND '01/26/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/26/15') AND '01/26/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer      
    where FirstOrder = '12M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select -- count(*)
         -- SUM(TM.Sales)
        -- SUM(LT.Sales)
       -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH-- 22,382  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/26/15') AND '01/26/15'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/26/15') AND '01/26/15'
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
    (select  -- count(*)
          -- SUM(TM.Sales)
         SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/25/14') AND '01/25/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/25/14') AND '01/25/14' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer        
    where [36MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select  -- count(*)
          -- SUM(TM.Sales)
         SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/25/14') AND '01/25/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/25/14') AND '01/25/14' 
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
    (select  -- count(*)
          -- SUM(TM.Sales)
         SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/25/14') AND '01/25/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/25/14') AND '01/25/14' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where FirstOrder = '24M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select  -- count(*)
          -- SUM(TM.Sales)
         SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/25/14') AND '01/25/14'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/25/14') AND '01/25/14' 
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
    (select -- count(*)
          -- SUM(TM.Sales)
       -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/24/13') AND '01/24/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/24/13') AND '01/24/13' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer      
    where [48MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select -- count(*)
          -- SUM(TM.Sales)
       -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/24/13') AND '01/24/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/24/13') AND '01/24/13' 
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
    (select -- count(*)
          -- SUM(TM.Sales)
       -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/24/13') AND '01/24/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/24/13') AND '01/24/13' 
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where FirstOrder = '36M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select -- count(*)
          -- SUM(TM.Sales)
       -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/24/13') AND '01/24/13'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/24/13') AND '01/24/13' 
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
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/23/12') AND '01/23/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/23/12') AND '01/23/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [60MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/23/12') AND '01/23/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/23/12') AND '01/23/12'
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
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/23/12') AND '01/23/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/23/12') AND '01/23/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where FirstOrder = '48M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/23/12') AND '01/23/12'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/23/12') AND '01/23/12'
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
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/22/11') AND '01/22/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/22/11') AND '01/22/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer     
    where [72MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/22/11') AND '01/22/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/22/11') AND '01/22/11'
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
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/22/11') AND '01/22/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/22/11') AND '01/22/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where FirstOrder = '60M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
        -- SUM(TM.OrderCnt)
         SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/22/11') AND '01/22/11'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/22/11') AND '01/22/11'
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
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/21/10') AND '01/21/10'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/21/10') AND '01/21/10'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer    
    where [84MOrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/21/10') AND '01/21/10'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/21/10') AND '01/21/10'
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
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/21/10') AND '01/21/10'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/21/10') AND '01/21/10'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) LT ON LT.ixCustomer = COH.ixCustomer  
    where FirstOrder = '72M'
    ) [1st Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select -- count(*)
        --   SUM(TM.Sales)
        -- SUM(LT.Sales)
         SUM(TM.OrderCnt)
       --  SUM(LT.OrderCnt)
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 149,428  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -1, '01/21/10') AND '01/21/10'
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
               ) TM ON TM.ixCustomer = COH.ixCustomer 
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from vwOrderAllHistory O  
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/21/10') AND '01/21/10'
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
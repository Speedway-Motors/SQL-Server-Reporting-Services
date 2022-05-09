/**** 12M NAME FLOW ****/

    -- Attrition of 12-month buyers
    select count(*)
         , SUM(TM.Sales) AS TMSales
         , SUM(LT.Sales) AS LTSales
         , SUM(TM.OrderCnt) AS TMOrderCnt
         ,  SUM(LT.OrderCnt) AS LTOrderCnt 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -2, '01/26/15') AND DATEADD(YY, -1, '01/26/15')
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
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/26/15') AND DATEADD(YY, -1, '01/26/15')
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
         ,  SUM(LT.OrderCnt) AS LTOrderCnt 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -2, '01/25/14' ) AND DATEADD(YY, -1, '01/25/14' )
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
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/25/14') AND DATEADD(YY, -1, '01/25/14')
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
         ,  SUM(LT.OrderCnt) AS LTOrderCnt 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -2, '01/24/13' ) AND DATEADD(YY, -1, '01/24/13' )
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
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/24/13') AND DATEADD(YY, -1, '01/24/13')
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
         ,  SUM(LT.OrderCnt) AS LTOrderCnt 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -2, '01/23/12' ) AND DATEADD(YY, -1, '01/23/12' )
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
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/23/12') AND DATEADD(YY, -1, '01/23/12')
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
         ,  SUM(LT.OrderCnt) AS LTOrderCnt 
    from [SMITemp].dbo.ASC_CustomerOrderHistory COH -- 75,132  
    left join (select ixCustomer
                    , SUM(O.mMerchandise) AS Sales 
                    , COUNT(DISTINCT O.ixOrder) AS OrderCnt  
               from tblOrder O  
               where O.dtOrderDate BETWEEN DATEADD(YY, -2, '01/22/11' ) AND DATEADD(YY, -1, '01/22/11' )
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
               where O.dtOrderDate BETWEEN DATEADD(MM, -72, '01/22/11') AND DATEADD(YY, -1, '01/22/11')
                 AND O.sOrderType <> 'Internal' 
                 AND O.sOrderStatus = 'Shipped' 
                 AND O.ixOrder NOT LIKE '%-%' 
                 AND O.mMerchandise > 1 
               group by O.ixCustomer 
                ) LT ON LT.ixCustomer = COH.ixCustomer       
    where [72MOrdCount] > 0 
     and [60MOrdCount] = 0        
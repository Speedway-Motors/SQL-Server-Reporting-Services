SELECT C.ixCustomer, 
    Y1.Purchases [0-12 Purch], (Case when Y1.OrdCnt > 1 then 'M' else 'S' end) as  [0-12 Ordrs],
    Y2.Purchases [13-24 Purch], (Case when Y2.OrdCnt > 1 then 'M' else 'S' end) as  [13-24 Ordrs]
    --Y3.Purchases [25-36 Purch], (Case when Y3.OrdCnt > 1 then 'M' else 'S' end) as  [25-36 Ordrs],
    --Y4.Purchases [37-48 Purch], (Case when Y4.OrdCnt > 1 then 'M' else 'S' end) as  [37-48 Ordrs],
    --Y5.Purchases [49-60 Purch], (Case when Y5.OrdCnt > 1 then 'M' else 'S' end) as  [49-60 Ordrs],
    --Y6.Purchases [61-72 Purch], (Case when Y6.OrdCnt > 1 then 'M' else 'S' end) as  [61-72 Ordrs]                    
FROM tblCustomer C-- 4729
    -- JOIN TO STARTING POOL
    -- 0-12 Month orders
    Left join (select ixCustomer, sum(mMerchandise) Purchases, count(ixOrder) OrdCnt 
               from tblOrder
               where dtShippedDate between DATEADD(yy, -1, getdate()) and  getdate()
                 and mMerchandise > 5
                 and sOrderStatus = 'Shipped'    -- mixed case?
                 and sOrderChannel <> 'Internal' -- mixed case?
               group by ixCustomer
              ) Y1 on Y1.ixCustomer = C.ixCustomer
    -- 13-24 Month orders
    Left join (select ixCustomer, sum(mMerchandise) Purchases, count(ixOrder) OrdCnt 
               from tblOrder
               where dtShippedDate >= DATEADD(yy, -2, getdate()) AND dtShippedDate < DATEADD(yy, -1, getdate())
                 and mMerchandise > 5
                 and sOrderStatus = 'Shipped'    -- mixed case?
                 and sOrderChannel <> 'Internal' -- mixed case?
               group by ixCustomer
              ) Y2 on Y2.ixCustomer = C.ixCustomer              
where 
--C.dtAccountCreateDate between '12/01/2005' and '12/31/2005'
C.dtAccountCreateDate > '12/01/2005'





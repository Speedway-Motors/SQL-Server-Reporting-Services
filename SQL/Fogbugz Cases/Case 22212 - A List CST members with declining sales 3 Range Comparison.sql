-- Philips Who Dropped out of the A list
/* 
NEW COMPARISON LOGIC:
            CUSTOMERS WITH 
                  25-36 Sales >= $1,000
             and  13-24 Sales >= $1,000
             and   0-12 Sales = 0
*/   
SELECT  
  RANGE3.ixCustomer,
  isNULL(RANGE3.OrderQty,0)   as 'OrderQty25-36Mo',
  isNULL(RANGE2.OrderQty,0)   as 'OrderQty13-24Mo',
  isNULL(RANGE3.Sales,0)      as 'Sales25-36Mo',
  isNULL(RANGE2.Sales,0)      as 'Sales13-24Mo',
  C.sCustomerFirstName, C.sCustomerLastName, C.sEmailAddress, C.sDayPhone, C.sNightPhone, C.sCellPhone
-- LT.OrderQty 'LifeTimeOrderQty',
--,  LT.Sales 'LifeTimeSales'
FROM vwCSTStartingPool CST
    JOIN 
       (-- "A" LIST customers RANGE 3       25-36 Months ago
        SELECT CST.ixCustomer       -- 14,511
            ,FR.OrderQty    
            ,MR.Sales 
        FROM vwCSTStartingPool CST  -- 543,415
        JOIN -- FREQUENCY
            (SELECT CST.ixCustomer, COUNT(O.ixOrder) OrderQty
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -36, GETDATE()) AND DATEADD(MM, -25, GETDATE()) -- 1-13 months ago
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1 
               and O.sOrderType = 'Retail'
            GROUP BY  CST.ixCustomer 
            HAVING COUNT(O.ixOrder) >= 1
            ) FR ON FR.ixCustomer = CST.ixCustomer
        JOIN -- MONETARY MUST HAVE $1,000+ Sales
            (SELECT CST.ixCustomer, SUM(O.mMerchandise) Sales
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -36, GETDATE()) AND DATEADD(MM, -25, GETDATE()) -- 1-13 months ago
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
               and O.sOrderType = 'Retail'               
             GROUP BY  CST.ixCustomer 
             HAVING SUM(O.mMerchandise) >= 1000
            ) MR on MR.ixCustomer = CST.ixCustomer
       ) RANGE3 ON CST.ixCustomer = RANGE3.ixCustomer
JOIN
       (-- "A" LIST customers RANGE 2       13-24 Months ago
        SELECT CST.ixCustomer       -- 16,054
            ,FR.OrderQty    
            ,MR.Sales Sales
        FROM vwCSTStartingPool CST  
        JOIN -- FREQUENCY
            (SELECT CST.ixCustomer, COUNT(O.ixOrder) OrderQty
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -24, GETDATE()) AND DATEADD(MM, -13, GETDATE())  -- 13-24 months ago
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1 
               and O.sOrderType = 'Retail'                  
             GROUP BY  CST.ixCustomer 
           -- HAVING COUNT(O.ixOrder) >= 6
            ) FR ON FR.ixCustomer = CST.ixCustomer
        JOIN -- MONETARY
            (SELECT CST.ixCustomer, SUM(O.mMerchandise) Sales
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -24, GETDATE()) AND DATEADD(MM, -13, GETDATE())   -- 0-12 months ago 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
               and O.sOrderType = 'Retail'               
             GROUP BY  CST.ixCustomer 
             HAVING SUM(O.mMerchandise) >= 1000
            ) MR on MR.ixCustomer = CST.ixCustomer
       ) RANGE2 on RANGE3.ixCustomer = RANGE2.ixCustomer 
LEFT JOIN
       (-- customers with Sales in the past 12 months
        SELECT distinct O.ixCustomer
             FROM tblOrder O --on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -12, GETDATE()) AND  GETDATE()  -- 0-12 months ago
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
               and O.sOrderType = 'Retail'               
          ) RANGE1 ON RANGE1.ixCustomer = RANGE2.ixCustomer
JOIN tblCustomer C on  C.ixCustomer = CST.ixCustomer   
WHERE RANGE1.ixCustomer is NULL
-- RANGE3 >= $1,000 and RANGE2 >=$1,000   -- 4,076 customers
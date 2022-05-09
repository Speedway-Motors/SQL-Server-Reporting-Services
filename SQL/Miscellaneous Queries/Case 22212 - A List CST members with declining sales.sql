-- Philips Who Dropped out of the A list
SELECT  
  OLDA.ixCustomer,
  OLDA.OrderQty             as 'PrevOrderQty',
  isNULL(NEWA.OrderQty,0)   as 'CurOrderQty',
  OLDA.Sales                as 'PrevSales',
  isNULL(NEWA.Sales,0)      as 'CurSales',
  (1-( OLDA.Sales - (isNULL(NEWA.Sales,0)))) 'SalesDecline',
  ((1-(isNULL(NEWA.Sales,0)/OLDA.Sales)) *100) 'SalesDeclinePercent',
  C.sCustomerFirstName, C.sCustomerLastName, C.sEmailAddress, C.sDayPhone, C.sNightPhone, C.sCellPhone
 -- LT.OrderQty 'LifeTimeOrderQty',
  --,  LT.Sales 'LifeTimeSales'
FROM vwCSTStartingPool CST
JOIN 
       (-- "A" LIST customers from 1-13 Months ago
        SELECT CST.ixCustomer   -- 8,802
            ,FR.OrderQty    
            ,MR.Sales 
        FROM vwCSTStartingPool CST  -- 543,415
        JOIN -- FREQUENCY - MUST HAVE 6+ order qty
            (SELECT CST.ixCustomer, COUNT(O.ixOrder) OrderQty
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -13, GETDATE()) AND DATEADD(MM, -1, GETDATE()) -- 1-13 months ago
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1 
               and O.sOrderType = 'Retail'
            GROUP BY  CST.ixCustomer 
            HAVING COUNT(O.ixOrder) >= 2
            ) FR ON FR.ixCustomer = CST.ixCustomer
        JOIN -- MONETARY MUST HAVE $1,000+ Sales
            (SELECT CST.ixCustomer, SUM(O.mMerchandise) Sales
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -13, GETDATE()) AND DATEADD(MM, -1, GETDATE()) -- 1-13 months ago
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
               and O.sOrderType = 'Retail'               
             GROUP BY  CST.ixCustomer 
             HAVING SUM(O.mMerchandise) >= 2000
            ) MR on MR.ixCustomer = CST.ixCustomer
       ) OLDA ON CST.ixCustomer = OLDA.ixCustomer
       
FULL OUTER JOIN

       (-- "A" LIST customers from 0-12 Months ago
        SELECT CST.ixCustomer
            ,FR.OrderQty    
            ,MR.Sales Sales
        FROM vwCSTStartingPool CST  
        JOIN -- FREQUENCY
            (SELECT CST.ixCustomer, COUNT(O.ixOrder) OrderQty
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -12, GETDATE()) AND GETDATE() -- 0-12 months ago
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
             WHERE  O.dtShippedDate  BETWEEN DATEADD(MM, -12, GETDATE()) AND GETDATE()  -- 0-12 months ago 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
               and O.sOrderType = 'Retail'               
             GROUP BY  CST.ixCustomer 
            -- HAVING SUM(O.mMerchandise) < 2000
            ) MR on MR.ixCustomer = CST.ixCustomer
       ) NEWA on OLDA.ixCustomer = NEWA.ixCustomer  
JOIN tblCustomer C on  C.ixCustomer = OLDA.ixCustomer      
/*
JOIN 
       (-- "A" LIST customers from 1-13 Months ago
        SELECT CST.ixCustomer   -- 8,802
            ,FR.OrderQty    
            ,MR.Sales 
        FROM vwCSTStartingPool CST  -- 543,415
        JOIN -- FREQUENCY - MUST HAVE 6+ order qty
            (SELECT CST.ixCustomer, COUNT(O.ixOrder) OrderQty
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate >= DATEADD(MM, -72, GETDATE()) -- last 72 Months
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1 
               and O.sOrderType = 'Retail'
            GROUP BY  CST.ixCustomer 
            HAVING COUNT(O.ixOrder) >= 2
            ) FR ON FR.ixCustomer = CST.ixCustomer
        JOIN -- MONETARY MUST HAVE $1,000+ Sales
            (SELECT CST.ixCustomer, SUM(O.mMerchandise) Sales
             FROM vwCSTStartingPool CST
                join tblOrder O on CST.ixCustomer = O.ixCustomer
             WHERE  O.dtShippedDate BETWEEN DATEADD(MM, -13, GETDATE()) AND DATEADD(MM, -1, GETDATE()) -- 1-13 months ago
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1    
               and O.sOrderType = 'Retail'               
             GROUP BY  CST.ixCustomer 
             HAVING SUM(O.mMerchandise) >= 2000
            ) MR on MR.ixCustomer = CST.ixCustomer
       ) LT ON LT.ixCustomer = OLDA.ixCustomer
*/                
WHERE OLDA.ixCustomer is NOT NULL
AND isNULL(NEWA.Sales,0) < OLDA.Sales 
ORDER BY OLDA.ixCustomer -- SalesDeclinePercent' desc
/*
-- didn't qualify in the current 0-12 month range
    AND (
            (NEWA.OrderQty IS NULL OR NEWA.OrderQty <6)
            OR
            (NEWA.Sales IS NULL OR NEWA.Sales  <1000)          
        )
    
    /*
*/    
/***** RAW 24 month data for Philip *********/
select ixOrder, O.ixCustomer, sShipToCity, sShipToState, sShipToZip, 
    sOrderChannel, iShipMethod, sSourceCodeGiven, sMatchbackSourceCode, sMethodOfPayment, 
    mMerchandise, mShipping, mTax, mCredits, 
    sOrderStatus, 
    mMerchandiseCost, 
    dtOrderDate, 
    dtShippedDate, 
    mPublishedShipping, 
    sWebOrderID, 
    flgDeviceType, 
    ixPrimaryShipLocation, 
from tblOrder O
    join vwCSTStartingPool SP on O.ixCustomer = SP.ixCustomer
where O.dtShippedDate >= '04/16/2012'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders    
*/

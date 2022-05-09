-- no case # Yet
-- Refused COD analysis`

      select dtOrderDate, 
        (Case when ixCustomerType in ('30','40')  then 'Wholesale'
         else 'Retail'
         end) as CustType,
         SUM(mMerchandise) Sales, 
         count(*) OrdCount
      from tblOrder O
        join tblCustomer C on O.ixCustomer = C.ixCustomer
        
      where dtOrderDate >= '01/01/2012'
        AND sMethodOfPayment = 'COD'
        AND sOrderStatus = 'Shipped'
        AND ixCustomerType in ('30','40')--WHOLESALE             <-- for RETAIL add NOT to the IN statement
      group by dtOrderDate,
      (Case when ixCustomerType in ('30','40')  then 'Wholesale'
         else 'Retail'
         end)
         --, sMethodOfPayment
      ORDER BY dtOrderDate
      

-- YTD COD Sales                  
select SUM(mMerchandise)
from tblOrder
where dtOrderDate >= '01/01/2012'
                    AND sMethodOfPayment <> 'COD'
                    AND sOrderStatus = 'Shipped'    -- 82,276,252                  
 
-- YTD COD orders that have a Credit Memo                    
select SUM(mMerchandise)
from tblCreditMemoMaster 
where ixOrder in (select ixOrder from tblOrder 
                    where dtOrderDate >= '01/01/2012' -- 3,973,550.48
                    AND sMethodOfPayment <> 'COD'
                    AND sOrderStatus = 'Shipped' 
                  )                    
-- SMIHD-8104 -- Verify the 22 sql server reports that pull from tng read replicastill work after collation changes

-- 1) WebSalableSKUs - WORKS

-- 2) UniqueSKUsSold12Mo - FAIL
Select * from openquery([TNGREADREPLICA], '
  select count(distinct s.ixSkuVariant) AS UniqueSkuSold, -- 30702 & 28508 @101-188 sec     94-115      26 sec SSRS
         count(distinct svb.ixSkuVariant) AS UniqueSkuSoldwithYMM 
  from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  LEFT JOIN vwSkuVariantWithChassisFitment svb ON s.ixSKUVariant = svb.ixSkuVariant
--  WHERE o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) 
  WHERE o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -1 DAY) -- TESTING ONLY!!!!!!!!!!!
    AND oli.ixOrderLineItemStatus = 2 
    AND o.ixSopWebOrderNumber is not NULL
    AND s.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND (s.iTotalQAV > 0 OR s.flgBackorderable = 1)
                              ')
                              
-- 3) RetailWebSalableSKUs - WORKS    

-- 4) GSWebSalableSKUs - WORKS

-- 5) Rolling12MoSalesAllSKUs - FAILS
Select * 
from openquery([TNGREADREPLICA], '
select 
CAST(SUM( 
        CAST(oli.mPostDiscountPrice as SIGNED) * CAST(oli.iQuantity AS SIGNED)
    )AS SIGNED) AS TotalSalesWeb,
SUM(oli.iQuantity) AS TotalQtySoldWeb
from userInfo.tblorder_lineitem oli -- 96.61%??@175 Sec
    INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
    INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
    INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
    INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
    INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
    LEFT JOIN vwSkuVariantWithChassisFitment svb ON s.ixSKUVariant = svb.ixSkuVariant
WHERE oli.ixOrderLineItemStatus = 2 
  --  AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) 
    AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -1 DAY) -- TESTING ONLY!!!!!!!!!!!    
    AND o.ixSopWebOrderNumber is not NULL
    AND s.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND(s.iTotalQAV > 0 
        OR s.flgBackorderable = 1)
                              ')
                              
-- 6) Rolling12MoSalesYMM
Select * 
from openquery([TNGREADREPLICA], '
select 
CAST(SUM( 
        CAST(oli.mPostDiscountPrice as SIGNED) * CAST(oli.iQuantity AS SIGNED)
    )AS SIGNED) AS TotalSalesWebYMM,
SUM(oli.iQuantity) AS TotalQtySoldWebYMM
from userInfo.tblorder_lineitem oli -- 96.61%??@175 Sec
    INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
    INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
    INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
    INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
    INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
    INNER JOIN vwSkuVariantWithChassisFitment svb ON s.ixSKUVariant = svb.ixSkuVariant
WHERE oli.ixOrderLineItemStatus = 2 
   -- AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) 
    AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -1 DAY) -- TESTING ONLY!!!!!!!!!!!        
    AND o.ixSopWebOrderNumber is not NULL
    AND s.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND(s.iTotalQAV > 0 
        OR s.flgBackorderable = 1)
                              ')                              
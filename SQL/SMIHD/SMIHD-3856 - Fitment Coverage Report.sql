-- SMIHD-3856 - Fitment Coverage Report

-- RUN in TNG then convert

-- Ron already has a query built for the first two modules (Total Web Salable & Unique SKUs Sold) 
-- Definitions:
-- Web Salable = Active in SOP Web Catalog, Not Discontinued, Active & Published in smiNET (basically, it shows up on the website and is for sale)
-- Chassis Fitment = SKU is assigned, either directly or indirectly via eng/trans/axle fitment, to a Year/Make/Model and/or a Race Type or is marked Universal Fit (YMM) with Market(s) applied
-- Retail = Non-Garage Sale SKUs

Select * from openquery([TNGREADREPLICA], 'SELECT ixSOPSKU as ''ixSKU'', 
                          M.sMarketName as ''ixMarket''
                        FROM tblmarket M 
                        where SV.ixSOPSKU <>'' ''
                              ')
                              
-- combining #1 Active SKu's (Rough count)
--       &   #2 Active SKu's (Rough count)  with YMM/Universal or RaceType
SELECT * 
from openquery([TNGREADREPLICA], '
                SELECT COUNT(DISTINCT t.ixSKUVariant) AS DistAllSKUs,  -- 102,215   88,405  @2-11 sec    4 sec SSRS
                  COUNT(DISTINCT ymm.ixSkuVariant) AS DistinctSkuWithFitment
                FROM tblskuvariant t
                  INNER JOIN tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                  LEFT JOIN vwSkuVariantWithChassisFitment ymm ON ymm.ixSkuVariant = t.ixSKUVariant
                WHERE t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
                 ')

-- combining #3 Unique SKU's sold last 12 months   
--      &    #4 Unique SKU's sold the last 12 months with fitment 
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
                                         
-- combining # 5 Active SKu's (Rough count)  Not garage sale
--    &       #6 Active SKu's (Rough count)  Not garage sale with YMM/Universal or RaceType
Select * from openquery([TNGREADREPLICA], '
SELECT COUNT(DISTINCT t.ixSKUVariant) AS DistinctSkuNotGS,  -- 92,700    83,429    @3-35 Sec     1
       COUNT(DISTINCT ymm.ixSKUVariant) AS DistinctSkuNotGSwFitment
FROM -- 83,397 @2 sec
tblskuvariant t
  INNER JOIN tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  LEFT JOIN vwSkuVariantWithChassisFitment ymm ON ymm.ixSkuVariant = t.ixSKUVariant
  LEFT JOIN vwSkuVariantGarageSale gs ON gs.ixSkuVariant = t.ixSKUVariant
WHERE t.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND (t.iTotalQAV > 0 
         OR t.flgBackorderable = 1)
    AND gs.ixSkuVariant IS NULL   
                              ')

-- combining #7 Active SKu's (Rough count)  garage sale
--    &      #8 Active SKu's (Rough count)  garage sale with YMM/Universal or RaceType
Select * 
from openquery([TNGREADREPLICA], '
    SELECT COUNT(DISTINCT t.ixSKUVariant) AS DistinctSkuGS,  -- 9,510   4,972    @33 Sec
           COUNT(DISTINCT ymm.ixSKUVariant) AS DistinctSkuGSwFitment
    FROM -- 83,397 @2 sec
    tblskuvariant t
      INNER JOIN tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
      INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
      INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
      LEFT JOIN vwSkuVariantWithChassisFitment ymm ON ymm.ixSkuVariant = t.ixSKUVariant
      INNER JOIN vwSkuVariantGarageSale gs ON gs.ixSkuVariant = t.ixSKUVariant
    WHERE t.flgPublish = 1
        AND t1.flgWebPublish = 1
        AND t3.flgActive = 1
        AND (t.iTotalQAV > 0 
             OR t.flgBackorderable = 1)
                                  ')


-- SELECT COUNT(*) AS DistinctYMM FROM tblskuvariant_vehicle_base tvb;

-- SELECT COUNT(distinct tvb.ixSkuVariant ) AS DistinctYMM FROM tblskuvariant_vehicle_base tvb;
;

-- ALL 12Mo Sales   #9 & #11   -- 44,984,901  1,241,346  @103-195 Sec
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
    AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) 
    AND o.ixSopWebOrderNumber is not NULL
    AND s.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND(s.iTotalQAV > 0 
        OR s.flgBackorderable = 1)
                              ')
                              
                              43,697,818 -- tng
                              43,697,818 --
                              
                              
/*
The OLE DB provider "MSDASQL" for linked server "TNGREADREPLICA" 
supplied invalid metadata for column "TotalSalesWebYMM". T
he precision exceeded the allowable maximum.
*/                              
                              
                              
-- 12 Mo Sales with YMM   #10 & #12
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
    AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) 
    AND o.ixSopWebOrderNumber is not NULL
    AND s.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND(s.iTotalQAV > 0 
        OR s.flgBackorderable = 1)
                              ')



select dtOrderDate, COUNT(*) 
from tblOrder
where dtDateLastSOPUpdate = '03/22/16'
group by dtOrderDate
order by dtOrderDate

select dtOrderDate, dtDateLastSOPUpdate
from tblOrder
where dtDateLastSOPUpdate = '03/22/16'
order by ixOrderDate

select ixOrder, dtOrderDate, dtShippedDate, dtDateLastSOPUpdate
from tblOrder
where dtDateLastSOPUpdate = '03/22/16'
order by dtShippedDate

select COUNT(*) 
from tblOrder
where dtDateLastSOPUpdate = '03/22/16' -- 9156

select ixOrder, dtOrderDate, dtShippedDate, dtDateLastSOPUpdate, T.chTime
from tblOrder O
    left join tblTime T on T.ixTime = O.ixTimeLastSOPUpdate
where dtDateLastSOPUpdate = '03/22/16'
order by dtDateLastSOPUpdate, T.chTime
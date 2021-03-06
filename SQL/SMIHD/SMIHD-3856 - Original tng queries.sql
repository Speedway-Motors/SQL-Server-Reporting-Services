-- SMIHD-3856 - Fitment Coverage Report

-- RUN in TNG then convert

-- Ron already has a query built for the first two modules (Total Web Salable & Unique SKUs Sold) 
-- Definitions:
-- Web Salable = Active in SOP Web Catalog, Not Discontinued, Active & Published in smiNET (basically, it shows up on the website and is for sale)
-- Chassis Fitment = SKU is assigned, either directly or indirectly via eng/trans/axle fitment, to a Year/Make/Model and/or a Race Type or is marked Universal Fit (YMM) with Market(s) applied
-- Retail = Non-Garage Sale SKUs


-- combining #1 Active SKu's (Rough count)
--       &   #2 Active SKu's (Rough count)  with YMM/Universal or RaceType
SELECT COUNT(DISTINCT t.ixSKUVariant) AS DistAllSKUs,  -- 102,215   88,405  @2-11 sec
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

;

-- combining #3 Unique SKU's sold last 12 months   
--      &    #4 Unique SKU's sold the last 12 months with fitment 
  select count(distinct s.ixSkuVariant) AS UniqueSkuSold, -- 30684 & 28494 @101-188 sec     94-115
         count(distinct svb.ixSkuVariant) AS UniqueSkuSoldwithYMM 
  from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  LEFT JOIN vwSkuVariantWithChassisFitment svb ON s.ixSKUVariant = svb.ixSkuVariant
  WHERE o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) 
    AND oli.ixOrderLineItemStatus = 2 
    AND o.ixSopWebOrderNumber is not NULL
    AND s.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND (s.iTotalQAV > 0 OR s.flgBackorderable = 1)

;           
           
-- combining # 5 Active SKu's (Rough count)  Not garage sale
--    &       #6 Active SKu's (Rough count)  Not garage sale with YMM/Universal or RaceType
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
;

-- combining #7 Active SKu's (Rough count)  garage sale
--    &      #8 Active SKu's (Rough count)  garage sale with YMM/Universal or RaceType
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



-- SELECT COUNT(*) AS DistinctYMM FROM tblskuvariant_vehicle_base tvb;

-- SELECT COUNT(distinct tvb.ixSkuVariant ) AS DistinctYMM FROM tblskuvariant_vehicle_base tvb;
;

-- ALL 12Mo Sales   #9 & #11
    select SUM(oli.mPostDiscountPrice * oli.iQuantity) AS TotalSalesWebYMM,  -- 44,984,901  1,241,346  @103-195 Sec      100   81   90
    SUM(oli.iQuantity) AS TotalQtySoldWebYMM
    from userInfo.tblorder_lineitem oli 
    INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
    INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
    INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
    INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
    INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
    WHERE 
           oli.ixOrderLineItemStatus = 2 
       AND o.ixSopWebOrderNumber is not NULL  
       AND s.flgPublish = 1
       AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) 
       AND t1.flgWebPublish = 1
       AND t3.flgActive = 1
       AND(s.iTotalQAV > 0 
           OR s.flgBackorderable = 1)

;
-- 12 Mo Sales with YMM   #10 & #12
  select SUM(oli.mPostDiscountPrice * oli.iQuantity) AS TotalSalesWebYMM,  -- 43,430,699   1,206,680 @84-103 Sec
  SUM(oli.iQuantity) AS TotalQtySoldWebYMM
  from userInfo.tblorder_lineitem oli -- 96.61%  @175 Sec
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

;

select 
SUM( 
CAST(oli.mPostDiscountPrice as SIGNED) * CAST(oli.iQuantity AS SIGNED)
) AS TotalSalesWebYMM,
SUM(oli.iQuantity) AS TotalQtySoldWebYMM
from userInfo.tblorder_lineitem oli -- 96.61%  @175 Sec
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




SELECT * from vwSkuVariantWithChassisFitment;
SELECT * from vwSkuVariantGarageSale;


SELECT COUNT(*) AS DistinctYMM FROM tblskuvariant_vehicle_base tvb;

SELECT COUNT(distinct tvb.ixSkuVariant ) AS DistinctYMM FROM tblskuvariant_vehicle_base tvb;



-- Active SKu's (Rough count)  Not garage sale
SELECT COUNT(DISTINCT ixSKUVariant) AS DistinctSkuNotGS FROM
tblskuvariant t
  INNER JOIN 
  tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
WHERE 
  t.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (t.iTotalQAV > 0 OR t.flgBackorderable = 1)
    and
  ixSkuVariant NOT IN
(
  SELECT DISTINCT ixSkuVariant FROM tblskuvariant_garagesale_xref tgx
  UNION
  SELECT DISTINCT ixskuvariant FROM tblskubasemarket t INNER JOIN tblskuvariant t1 ON t.ixSKUBase = t1.ixSKUBase WHERE t.ixMarket = 222
  UNION
  SELECT ixskuvariant FROM tblskuvariant t WHERE LOWER(t.sSKUVariantName) LIKE '%garage%'
)
;

-- Active SKu's (Rough count)
SELECT COUNT(DISTINCT ixSKUVariant) AS DistinctSkuNot FROM
tblskuvariant t
  INNER JOIN 
  tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
WHERE 
  t.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (t.iTotalQAV > 0 OR t.flgBackorderable = 1)
;


-- Active SKu's (Rough count)  Not garage sale with YMM/Universal or RaceType
SELECT COUNT(DISTINCT t.ixSKUVariant) AS DistinctSkuNotGS FROM
tblskuvariant t
  INNER JOIN 
  tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  INNER JOIN
  (
    SELECT distinct tvb.ixSkuVariant FROM tblskuvariant_vehicle_base tvb
    UNION
    SELECT DISTINCT tu.ixSKUvariant FROM tblskuvariant_universalfit tu
    UNION
    SELECT DISTINCT trx.ixSkuVariant FROM tblskuvariant_racetype_xref trx
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_engine_subfamily_xref xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_rearaxle_family xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_transmission_family_xref xref
    UNION
    SELECT DISTINCT sax.ixSKUVariant FROM tblskuvariant_application_xref sax INNER JOIN tblapplication a ON sax.ixApplication = a.ixApplication WHERE a.sApplicationGroup = 'Pedal Cars'
  ) ymm ON ymm.ixSkuVariant = t.ixSKUVariant
WHERE 
  t.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (t.iTotalQAV > 0 OR t.flgBackorderable = 1)
    and
  t.ixSkuVariant NOT IN
(
  SELECT ixSkuVariant FROM tblskuvariant_garagesale_xref tgx
  UNION
  SELECT ixskuvariant FROM tblskubasemarket t INNER JOIN tblskuvariant t1 ON t.ixSKUBase = t1.ixSKUBase WHERE t.ixMarket = 222
  UNION
  SELECT ixskuvariant FROM tblskuvariant t WHERE LOWER(t.sSKUVariantName) LIKE '%garage%'
)
;

-- Active SKu's (Rough count)  with YMM/Universal or RaceType
SELECT COUNT(DISTINCT t.ixSKUVariant) AS DistinctSkuNotGS FROM
tblskuvariant t
  INNER JOIN 
  tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  INNER JOIN
  (
    SELECT distinct tvb.ixSkuVariant FROM tblskuvariant_vehicle_base tvb
    UNION
    SELECT DISTINCT tu.ixSKUvariant FROM tblskuvariant_universalfit tu
    UNION
    SELECT DISTINCT trx.ixSkuVariant FROM tblskuvariant_racetype_xref trx
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_engine_subfamily_xref xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_rearaxle_family xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_transmission_family_xref xref
    UNION
    SELECT DISTINCT sax.ixSKUVariant FROM tblskuvariant_application_xref sax INNER JOIN tblapplication a ON sax.ixApplication = a.ixApplication WHERE a.sApplicationGroup = 'Pedal Cars'
  ) ymm ON ymm.ixSkuVariant = t.ixSKUVariant
WHERE 
  t.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (t.iTotalQAV > 0 OR t.flgBackorderable = 1)
;

-- Percentage having a YMM as part of sales
SELECT 
  (select SUM(oli.mPostDiscountPrice * oli.iQuantity) AS TotalSalesWebYMM from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  INNER JOIN 
  ( 
    SELECT DISTINCT ixSkuVariant FROM tblskuvariant_vehicle_base svb 
    UNION
    SELECT DISTINCT tu.ixSKUvariant FROM tblskuvariant_universalfit tu
    UNION
    SELECT DISTINCT trx.ixSkuVariant FROM tblskuvariant_racetype_xref trx
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_engine_subfamily_xref xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_rearaxle_family xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_transmission_family_xref xref
    UNION
    SELECT DISTINCT sax.ixSKUVariant FROM tblskuvariant_application_xref sax INNER JOIN tblapplication a ON sax.ixApplication = a.ixApplication WHERE a.sApplicationGroup = 'Pedal Cars'
  ) svb ON s.ixSKUVariant = svb.ixSkuVariant
  WHERE 
    oli.ixOrderLineItemStatus = 2 AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) AND o.ixSopWebOrderNumber is not NULL
      AND
  s.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (s.iTotalQAV > 0 OR s.flgBackorderable = 1)

)
  /
(
  select SUM(oli.mPostDiscountPrice * oli.iQuantity) AS TotalSalesWebYMM from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  WHERE 
    oli.ixOrderLineItemStatus = 2 AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) AND o.ixSopWebOrderNumber is not NULL
      AND
  s.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (s.iTotalQAV > 0 OR s.flgBackorderable = 1)

)  AS PercentYMMAsSales
;


-- Percentage SKU's having a YMM as part of sales
SELECT 
  (select count(distinct s.ixSkuVariant) AS UniqueSkuSoldwithYMM from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  INNER JOIN 
  ( 
    SELECT DISTINCT ixSkuVariant FROM tblskuvariant_vehicle_base svb 
    UNION
    SELECT DISTINCT tu.ixSKUvariant FROM tblskuvariant_universalfit tu
    UNION
    SELECT DISTINCT trx.ixSkuVariant FROM tblskuvariant_racetype_xref trx
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_engine_subfamily_xref xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_rearaxle_family xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_transmission_family_xref xref
    UNION
    SELECT DISTINCT sax.ixSKUVariant FROM tblskuvariant_application_xref sax INNER JOIN tblapplication a ON sax.ixApplication = a.ixApplication WHERE a.sApplicationGroup = 'Pedal Cars'
  ) svb ON s.ixSKUVariant = svb.ixSkuVariant
  WHERE 
    oli.ixOrderLineItemStatus = 2 AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) AND o.ixSopWebOrderNumber is not NULL
      AND
  s.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (s.iTotalQAV > 0 OR s.flgBackorderable = 1)

)
  /
(
  select count(distinct s.ixSkuVariant) UniqueSkuSold from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  WHERE 
    oli.ixOrderLineItemStatus = 2 AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) AND o.ixSopWebOrderNumber is not NULL
      AND
  s.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (s.iTotalQAV > 0 OR s.flgBackorderable = 1)

)  AS PercentYMMAsSales
;

-- Unique SKU's sold the last 12 months with fitment
  select count(distinct s.ixSkuVariant) AS UniqueSkuSoldwithYMM from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  INNER JOIN 
  ( 
    SELECT DISTINCT ixSkuVariant FROM tblskuvariant_vehicle_base svb 
    UNION
    SELECT DISTINCT tu.ixSKUvariant FROM tblskuvariant_universalfit tu
    UNION
    SELECT DISTINCT trx.ixSkuVariant FROM tblskuvariant_racetype_xref trx
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_engine_subfamily_xref xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_rearaxle_family xref
    UNION
    SELECT DISTINCT xref.ixSKUVariant FROM tblskuvariant_transmission_family_xref xref
    UNION
    SELECT DISTINCT sax.ixSKUVariant FROM tblskuvariant_application_xref sax INNER JOIN tblapplication a ON sax.ixApplication = a.ixApplication WHERE a.sApplicationGroup = 'Pedal Cars'
  ) svb ON s.ixSKUVariant = svb.ixSkuVariant
  WHERE 
    oli.ixOrderLineItemStatus = 2 AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) AND o.ixSopWebOrderNumber is not NULL
      AND
  s.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (s.iTotalQAV > 0 OR s.flgBackorderable = 1)
;

-- Unique SKU's sold last 12 months
  select count(distinct s.ixSkuVariant) UniqueSkuSold from userInfo.tblorder_lineitem oli 
  INNER JOIN userInfo.tblorder o ON oli.ixOrder = o.ixOrder 
  INNER JOIN tblskuvariant s ON s.ixSOPSKU = oli.ixSKU 
  INNER JOIN tblskubase t1 ON s.ixSKUBase = t1.ixSKUBase
  INNER JOIN tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
  INNER JOIN tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
  WHERE 
    oli.ixOrderLineItemStatus = 2 AND o.dtOrderDate > DATE_ADD(NOW(), INTERVAL -12 MONTH) AND o.ixSopWebOrderNumber is not NULL
      AND
  s.flgPublish = 1
    AND
  t1.flgWebPublish = 1
  AND
  t3.flgActive = 1
    AND
  (s.iTotalQAV > 0 OR s.flgBackorderable = 1)


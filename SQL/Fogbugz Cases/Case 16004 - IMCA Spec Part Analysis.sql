-- 2010 Figures 
  
SELECT S.ixSKU AS SMISKU
     , VS.sVendorSKU AS PVSKU 
     , S.flgUnitOfMeasure AS SELLUM
     , S.mPriceLevel1 AS RETAIL 
     , VS.mCost AS PVCOST
     , S.mAverageCost AS AVGCOST
     --, COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(OL.iQuantity) AS SKUQTY
     , SUM(mExtendedPrice) AS MERCH
    -- , SUM(mExtendedCost) AS COST 
     , SUM(mExtendedPrice) - SUM(mExtendedCost) AS GMDOLLAR
     , ((SUM(mExtendedPrice) - SUM(mExtendedCost)) / (SUM(mExtendedPrice))) * 100 AS GMPERCENT
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU 
WHERE S.ixSKU IN ('91034313-L', '91034313-R', '91034393-L', '91034393-R', '91034394-L', '91034394-R', 
                  '1353502G') 
  AND VS.iOrdinality = '1'
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/10' AND '12/31/10'
GROUP BY S.ixSKU 
     , VS.sVendorSKU 
     , S.flgUnitOfMeasure 
     , S.mPriceLevel1 
     , VS.mCost 
     , S.mAverageCost 
ORDER BY AVGCOST DESC   
     
-- 2011 Figures 
  
SELECT S.ixSKU AS SMISKU
     , VS.sVendorSKU AS PVSKU 
     , S.flgUnitOfMeasure AS SELLUM
     , S.mPriceLevel1 AS RETAIL 
     , VS.mCost AS PVCOST
     , S.mAverageCost AS AVGCOST
     --, COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(OL.iQuantity) AS SKUQTY     
     , SUM(mExtendedPrice) AS MERCH
    -- , SUM(mExtendedCost) AS COST 
     , SUM(mExtendedPrice) - SUM(mExtendedCost) AS GMDOLLAR
     , ((SUM(mExtendedPrice) - SUM(mExtendedCost)) / (SUM(mExtendedPrice))) * 100 AS GMPERCENT
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU 
WHERE S.ixSKU IN ('91034313-L', '91034313-R', '91034393-L', '91034393-R', '91034394-L', '91034394-R', 
                  '1353502G') 
  AND VS.iOrdinality = '1'
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/11' AND '12/31/11'
GROUP BY S.ixSKU 
     , VS.sVendorSKU 
     , S.flgUnitOfMeasure 
     , S.mPriceLevel1 
     , VS.mCost 
     , S.mAverageCost      
ORDER BY AVGCOST DESC   
     
-- YTD Figures 
  
SELECT S.ixSKU AS SMISKU
     , VS.sVendorSKU AS PVSKU 
     , S.flgUnitOfMeasure AS SELLUM
     , S.mPriceLevel1 AS RETAIL 
     , VS.mCost AS PVCOST
     , S.mAverageCost AS AVGCOST
     --, COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(OL.iQuantity) AS SKUQTY     
     , SUM(mExtendedPrice) AS MERCH
   --  , SUM(mExtendedCost) AS COST 
     , SUM(mExtendedPrice) - SUM(mExtendedCost) AS GMDOLLAR
     , ((SUM(mExtendedPrice) - SUM(mExtendedCost)) / (SUM(mExtendedPrice))) * 100 AS GMPERCENT
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU 
WHERE S.ixSKU IN ('91034313-L', '91034313-R', '91034393-L', '91034393-R', '91034394-L', '91034394-R', 
                  '1353502G') 
  AND VS.iOrdinality = '1'
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/12' AND GETDATE()
GROUP BY S.ixSKU 
     , VS.sVendorSKU 
     , S.flgUnitOfMeasure 
     , S.mPriceLevel1 
     , VS.mCost 
     , S.mAverageCost      
ORDER BY AVGCOST DESC   
     
-- 2010 Order Counts *Orders with at least 1 (or more) IMCA Spec SKU  
  
SELECT COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(mExtendedPrice) AS MERCH   
FROM tblOrderLine OL 
WHERE OL.ixSKU IN ('91034313-L', '91034313-R', '91034393-L', '91034393-R', '91034394-L', '91034394-R', 
                  '1353502G') 
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/10' AND '12/31/10' 

-- 2011 Order Counts *Orders with at least 1 (or more) IMCA Spec SKU  
  
SELECT COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(mExtendedPrice) AS MERCH   
FROM tblOrderLine OL 
WHERE OL.ixSKU IN ('91034313-L', '91034313-R', '91034393-L', '91034393-R', '91034394-L', '91034394-R', 
                  '1353502G') 
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/11' AND '12/31/11' 
  
-- YTD 2012 Order Counts *Orders with at least 1 (or more) IMCA Spec SKU  
  
SELECT COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(mExtendedPrice) AS MERCH   
FROM tblOrderLine OL 
WHERE OL.ixSKU IN ('91034313-L', '91034313-R', '91034393-L', '91034393-R', '91034394-L', '91034394-R', 
                  '1353502G') 
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/12' AND GETDATE()   
  
  
  

-- Redo using additional SKUs that are being considered for IMCA Spec Parts 



-- 2010 Figures 
  
SELECT S.ixSKU AS SMISKU
     , VS.sVendorSKU AS PVSKU 
     , S.flgUnitOfMeasure AS SELLUM
     , S.mPriceLevel1 AS RETAIL 
     , VS.mCost AS PVCOST
     , S.mAverageCost AS AVGCOST
     --, COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , ISNULL(SUM(OL.iQuantity),0) AS SKUQTY
     , SUM(mExtendedPrice) AS MERCH
    -- , SUM(mExtendedCost) AS COST 
     , SUM(mExtendedPrice) - SUM(mExtendedCost) AS GMDOLLAR
     , ((SUM(mExtendedPrice) - SUM(mExtendedCost)) / (SUM(mExtendedPrice))) * 100 AS GMPERCENT
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU 
WHERE S.ixSKU IN ('91076500', '48675050', '91035295-R-RND', '91035295-L-RND', '91034290-R', 
                  '91034290-L', '91034301-R', '91034301-L', '9300300') 
  AND VS.iOrdinality = '1'
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/10' AND '12/31/10'
GROUP BY S.ixSKU 
     , VS.sVendorSKU 
     , S.flgUnitOfMeasure 
     , S.mPriceLevel1 
     , VS.mCost 
     , S.mAverageCost 
ORDER BY SMISKU  
     
-- 2011 Figures 
  
SELECT S.ixSKU AS SMISKU
     , VS.sVendorSKU AS PVSKU 
     , S.flgUnitOfMeasure AS SELLUM
     , S.mPriceLevel1 AS RETAIL 
     , VS.mCost AS PVCOST
     , S.mAverageCost AS AVGCOST
     --, COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , ISNULL(SUM(OL.iQuantity),0) AS SKUQTY     
     , SUM(mExtendedPrice) AS MERCH
    -- , SUM(mExtendedCost) AS COST 
     , SUM(mExtendedPrice) - SUM(mExtendedCost) AS GMDOLLAR
     , ((SUM(mExtendedPrice) - SUM(mExtendedCost)) / (SUM(mExtendedPrice))) * 100 AS GMPERCENT
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU 
WHERE S.ixSKU IN ('91076500', '48675050', '91035295-R-RND', '91035295-L-RND', '91034290-R', 
                  '91034290-L', '91034301-R', '91034301-L', '9300300') 
  AND VS.iOrdinality = '1'
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/11' AND '12/31/11'
GROUP BY S.ixSKU 
     , VS.sVendorSKU 
     , S.flgUnitOfMeasure 
     , S.mPriceLevel1 
     , VS.mCost 
     , S.mAverageCost      
ORDER BY SMISKU   
     
-- YTD Figures 
  
SELECT S.ixSKU AS SMISKU
     , VS.sVendorSKU AS PVSKU 
     , S.flgUnitOfMeasure AS SELLUM
     , S.mPriceLevel1 AS RETAIL 
     , VS.mCost AS PVCOST
     , S.mAverageCost AS AVGCOST
     --, COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , ISNULL(SUM(OL.iQuantity),0) AS SKUQTY     
     , SUM(mExtendedPrice) AS MERCH
   --  , SUM(mExtendedCost) AS COST 
     , SUM(mExtendedPrice) - SUM(mExtendedCost) AS GMDOLLAR
     , ((SUM(mExtendedPrice) - SUM(mExtendedCost)) / (SUM(mExtendedPrice))) * 100 AS GMPERCENT
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU 
WHERE S.ixSKU IN ('91076500', '48675050', '91035295-R-RND', '91035295-L-RND', '91034290-R', 
                  '91034290-L', '91034301-R', '91034301-L', '9300300') 
  AND VS.iOrdinality = '1'
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/12' AND GETDATE()
GROUP BY S.ixSKU 
     , VS.sVendorSKU 
     , S.flgUnitOfMeasure 
     , S.mPriceLevel1 
     , VS.mCost 
     , S.mAverageCost      
ORDER BY SMISKU   
     
-- 2010 Order Counts *Orders with at least 1 (or more) IMCA Spec SKU  
  
SELECT COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(mExtendedPrice) AS MERCH   
FROM tblOrderLine OL 
WHERE OL.ixSKU IN ('91076500', '48675050', '91035295-R-RND', '91035295-L-RND', '91034290-R', 
                   '91034290-L', '91034301-R', '91034301-L', '9300300') 
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/10' AND '12/31/10' 

-- 2011 Order Counts *Orders with at least 1 (or more) IMCA Spec SKU  
  
SELECT COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(mExtendedPrice) AS MERCH   
FROM tblOrderLine OL 
WHERE OL.ixSKU IN ('91076500', '48675050', '91035295-R-RND', '91035295-L-RND', '91034290-R', 
                   '91034290-L', '91034301-R', '91034301-L', '9300300') 
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/11' AND '12/31/11' 
  
-- YTD 2012 Order Counts *Orders with at least 1 (or more) IMCA Spec SKU  
  
SELECT COUNT (CASE WHEN OL.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS ORDCNT
     , SUM(mExtendedPrice) AS MERCH   
FROM tblOrderLine OL 
WHERE OL.ixSKU IN ('91076500', '48675050', '91035295-R-RND', '91035295-L-RND', '91034290-R', 
                   '91034290-L', '91034301-R', '91034301-L', '9300300') 
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND OL.dtShippedDate BETWEEN '01/01/12' AND GETDATE()   
  
  
  

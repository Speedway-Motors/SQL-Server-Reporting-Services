SELECT dtOrderDate 
     , COUNT(DISTINCT O.ixOrder) AS OrdCnt 
     , (CASE WHEN mMerchandise < 100 THEN '<100' 
             WHEN mMerchandise BETWEEN 100 AND 124.99 THEN '100-124.99'
             WHEN mMerchandise BETWEEN 125 AND 149.99 THEN '125-149.99'
             WHEN mMerchandise BETWEEN 150 AND 174.99 THEN '150-174.99'
             WHEN mMerchandise BETWEEN 175 AND 199.99 THEN '175-199.99'
             WHEN mMerchandise BETWEEN 200 AND 249.99 THEN '200-249.99'
             WHEN mMerchandise > 250 THEN '>250' 
             ELSE 'Other'
        END) AS DollarAmt 
FROM tblOrder O 
WHERE dtOrderDate BETWEEN '11/19/12' AND '11/30/12' 
  AND sOrderStatus = 'Shipped' 
  AND sOrderType NOT IN ('PRS','MRR') 
  --AND sOrderChannel <> 'INTERNAL' 
  --AND sOrderType <> 'Internal' 
  --AND mMerchandise > 0 
GROUP BY dtOrderDate 
       , (CASE WHEN mMerchandise < 100 THEN '<100' 
               WHEN mMerchandise BETWEEN 100 AND 124.99 THEN '100-124.99'
               WHEN mMerchandise BETWEEN 125 AND 149.99 THEN '125-149.99'
               WHEN mMerchandise BETWEEN 150 AND 174.99 THEN '150-174.99'
               WHEN mMerchandise BETWEEN 175 AND 199.99 THEN '175-199.99'
               WHEN mMerchandise BETWEEN 200 AND 249.99 THEN '200-249.99'
               WHEN mMerchandise > 250 THEN '>250' 
               ELSE 'Other'
          END)    
ORDER BY dtOrderDate, DollarAmt             
 
 
SELECT SUM(mMerchandise) / COUNT(DISTINCT ixOrder) AS AOV 
FROM tblOrder O 
WHERE dtOrderDate BETWEEN '11/19/12' AND '11/30/12' 
  AND sOrderStatus = 'Shipped' 
  AND sOrderType NOT IN ('PRS','MRR') 
  AND sOrderChannel <> 'INTERNAL' 
  AND sOrderType <> 'Internal' 
  AND mMerchandise > 0   
GROUP BY dtOrderDate 
ORDER BY dtOrderDate         
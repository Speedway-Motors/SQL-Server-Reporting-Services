
SELECT SC.ixCatalog
     , SC.ixSourceCode
     , SC.sDescription
     , SC.iQuantityPrinted
     , SUM(CASE WHEN O.ixOrder NOT LIKE '%-%' THEN 1 ELSE 0 END) AS OrdCnt
     , SUM(O.mMerchandise) AS Sales
     , SUM(O.mMerchandiseCost) AS Cost 
     --, (COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 ELSE 1 END)) / SC.iQuantityPrinted AS RRPercent
     , (SUM(O.mMerchandise)) / (COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 ELSE 1 END)) AS AOV
     , (((SUM(O.mMerchandise))-(SUM(O.mMerchandiseCost))) / (SUM(O.mMerchandise))) * 1 AS GMPercent 
     , (SUM(O.mMerchandise)) * 0.0258 AS PromoCost --??
     -- (Sales*GM%) - ((Sales*.1)+(QtyPrinted*1.55)+PromoCost) -- AS CM$
     , ((SUM(O.mMerchandise))* ((((SUM(O.mMerchandise))-(SUM(O.mMerchandiseCost))) / (SUM(O.mMerchandise))) * 1))
           - ((SUM(O.mMerchandise)*.1) + (SC.iQuantityPrinted * 1.55) + ((SUM(O.mMerchandise)) * 0.0258)) AS CMDollar
FROM tblSourceCode SC
LEFT JOIN tblOrder O ON O.sMatchbackSourceCode = SC.ixSourceCode
   and sOrderType <> 'Internal' 
  and sOrderChannel <> 'INTERNAL' 
  and sOrderStatus IN ('Shipped', 'Dropshipped') 
  and mMerchandise > 0
WHERE SC.ixCatalog IN ('325', '301', '327', '303')
GROUP BY SC.ixCatalog 
     , SC.ixSourceCode
     , SC.sDescription
     , SC.iQuantityPrinted
ORDER BY ixCatalog, ixSourceCode
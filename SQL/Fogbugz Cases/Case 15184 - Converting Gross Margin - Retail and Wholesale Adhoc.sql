--Dataset 1

SELECT D.iYear
	 , D.iPeriod
	 , SUM(O.mMerchandise) as 'Rev'
	 , SUM(O.mMerchandise)-SUM(O.mMerchandiseCost) as 'GP'
	 , ((SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) / SUM(O.mMerchandise)) as 'GM%'
FROM tblOrder O
LEFT JOIN tblDate D on O.ixOrderDate=D.ixDate
WHERE O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus in ('Open', 'Shipped', 'Backordered')
--	and D.iPeriod in (3)
  AND O.dtOrderDate >= @StartDate -- '01/01/07'
  AND O.sOrderType IN ('Retail', 'MRR', 'PRS')
GROUP BY D.iYear
	   , D.iPeriod
ORDER BY D.iYear
	   , D.iPeriod
	
--Retail dataset

SELECT D.iYear
	 , D.iPeriod
	 , O.sOrderType as 'Order Type'
	 , SUM(O.mMerchandise) as 'Rev'
	 , SUM(O.mMerchandise)-SUM(O.mMerchandiseCost) as 'GP'
	 , ((SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) / SUM(O.mMerchandise)) as 'GM%'
FROM tblOrder O
LEFT JOIN tblDate D on O.ixOrderDate=D.ixDate
WHERE O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus in ('Open', 'Shipped', 'Backordered')
--	and D.iPeriod in (3)
  AND O.dtOrderDate >= @StartDate -- '01/01/07'
  AND O.sOrderType = 'Retail'
GROUP BY D.iYear
	   , D.iPeriod
	   , O.sOrderType
ORDER BY D.iYear
	   , D.iPeriod
	
--MRR dataset

SELECT D.iYear
	 , D.iPeriod
	 , O.sOrderType as 'Order Type'
	 , SUM(O.mMerchandise) as 'Rev'
	 , SUM(O.mMerchandise)-SUM(O.mMerchandiseCost) as 'GP'
	 , ((SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) / SUM(O.mMerchandise)) as 'GM%'
FROM tblOrder O
LEFT JOIN tblDate D on O.ixOrderDate=D.ixDate
WHERE O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus in ('Open', 'Shipped', 'Backordered')
--	and D.iPeriod in (3)
  AND O.dtOrderDate >= @StartDate -- '01/01/07'
  AND O.sOrderType = 'MRR'
GROUP BY D.iYear
	   , D.iPeriod
	   , O.sOrderType
ORDER BY D.iYear
	   , D.iPeriod


--PRS dataset

SELECT D.iYear
	 , D.iPeriod
	 , O.sOrderType as 'Order Type'
	 , SUM(O.mMerchandise) as 'Rev'
	 , SUM(O.mMerchandise)-SUM(O.mMerchandiseCost) as 'GP'
	 , ((SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) / SUM(O.mMerchandise)) as 'GM%'
FROM tblOrder O
LEFT JOIN tblDate D on O.ixOrderDate=D.ixDate
WHERE O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus in ('Open', 'Shipped', 'Backordered')
--	and D.iPeriod in (3)
  AND O.dtOrderDate >= @StartDate -- '01/01/07'
  AND O.sOrderType = 'PRS'
GROUP BY D.iYear
	   , D.iPeriod
	   , O.sOrderType
ORDER BY D.iYear
	   , D.iPeriod			
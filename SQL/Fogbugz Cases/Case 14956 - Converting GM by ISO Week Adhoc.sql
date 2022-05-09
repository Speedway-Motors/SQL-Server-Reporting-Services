SELECT D.iYear
--	 , D.iPeriod
	 , D.iISOWeek
	 , SUM(O.mMerchandise) AS Revenue
	 , SUM(O.mMerchandise)-SUM(O.mMerchandiseCost) AS GrossProfit
	 , ((SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) / SUM(O.mMerchandise)) AS 'GM%'
	 , O.sOrderType AS 'Type'
FROM tblOrder O
LEFT JOIN tblDate D ON D.ixDate = O.ixOrderDate
WHERE O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus in ('Open', 'Shipped', 'Backordered')
--	and D.iPeriod in (3)
  AND O.dtOrderDate >= @OrderDateAfter --'01/01/07'
  AND O.sOrderType IN (@OrderType) --('Retail', 'MRR', 'PRS')
GROUP BY D.iYear
	   , D.iISOWeek
	   , O.sOrderType
--	D.iPeriod
ORDER BY D.iYear
--	D.iPeriod
	   , D.iISOWeek
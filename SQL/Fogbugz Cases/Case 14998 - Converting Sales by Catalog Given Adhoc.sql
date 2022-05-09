--Query for dataset1

SELECT CONVERT(datetime, O.dtOrderDate, 101) AS OrderDate
	 , O.sShipToState AS State
	 , O.sOrderChannel AS OrderChannel
	 , SC.ixCatalog AS CatalogGiven
	 , SC1.ixCatalog AS Matchback
	 , SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0
	       ELSE 1 
	       END) AS '#Orders'
	 , SUM(O.mMerchandise) AS Revenue
	 , SUM(O.mMerchandiseCost) AS Cost
	 , (SUM(O.mMerchandise)-SUM(O.mMerchandiseCost)) AS 'GP'
--	(SUM(O.mMerchandise)-SUM(O.mMerchandiseCost))/nullif(SUM(O.mMerchandise),0) as 'GM%'
FROM tblOrder O
LEFT JOIN tblSourceCode SC ON SC.ixSourceCode = O.sSourceCodeGiven
LEFT JOIN tblSourceCode SC1 ON SC1.ixSourceCode = O.sMatchbackSourceCode
LEFT JOIN tblCatalogMaster CM ON CM.ixCatalog = SC.ixCatalog 
RIGHT JOIN tblStates STATES ON STATES.ixState = O.sShipToState
WHERE O.sOrderStatus IN ('Shipped', 'Open', 'Backordered')
  AND O.sOrderType = 'Retail'
  AND O.sOrderChannel <> 'INTERNAL'
  AND CONVERT(datetime, O.dtOrderDate, 101) BETWEEN @StartDate AND @EndDate 
  AND CM.ixCatalog IN (@CatalogGiven)
GROUP BY CONVERT(datetime, O.dtOrderDate, 101)
	   , O.sShipToState
	   , O.sOrderChannel
	   , SC.ixCatalog
	   , SC1.ixCatalog
	   
--Query for dataset2 "Catalogs" 

SELECT CM.ixCatalog AS Catalog
	 , (CM.ixCatalog + ' - ' + CM.sDescription) AS CatalogDescription
	 , CM.dtStartDate AS CatalogStartDate
	 , CM.dtEndDate AS CatalogEndDate
FROM tblCatalogMaster CM
WHERE CM.dtStartDate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, DATEADD(YEAR, -3, GETDATE())), 0) --1st of the year, three years prior = '01/01/09'
ORDER BY CM.dtStartDate DESC	


  
SELECT D.iYear as 'Year'
	 , DATEPART(ww, D.dtDate) as 'Week'
    -- ,D.iISOWeek as 'Week'
	 , SUBSTRING(SL.sPickingBin,1,1) as 'Bin Type'
	 , SUM(CASE WHEN ST.sTransactionType = 'FHC' THEN 1 
	            ELSE 0 
	       END) AS 'Fails'
	 , SUM(CASE WHEN ST.sTransactionType = 'OR' THEN 1 
	            ELSE 0 
	       END) AS 'Total Commits'
FROM tblSKUTransaction ST
LEFT JOIN tblSKULocation SL on ST.ixSKU = SL.ixSKU
LEFT JOIN tblDate D on ST.ixDate = D.ixDate
WHERE SUBSTRING(SL.sPickingBin,1,1) IN ('Z', 'X','Y', '3', '4', '5', 'B')
	  AND D.dtDate BETWEEN @StartDate AND @EndDate -->= '01/01/12'
GROUP BY D.iYear
	   , DATEPART(ww,D.dtDate)
	   , SUBSTRING(SL.sPickingBin,1,1)
ORDER BY D.iYear
	   , DATEPART(ww,D.dtDate) DESC
	   , SUBSTRING(SL.sPickingBin,1,1)

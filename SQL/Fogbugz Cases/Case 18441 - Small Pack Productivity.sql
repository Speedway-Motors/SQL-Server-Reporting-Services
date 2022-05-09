--Small Pack / Verification "87-2" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
     , ISNULL(Orders.OrdCnt,0) AS OrdCnt 
     , ISNULL(Orders.OrdCnt,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS OrdersPerHour
     , ISNULL(Orders.LineItems,0) AS LineItems
     , ISNULL(Orders.LineItems,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))  AS ItemsPerHour
     , (ISNULL(Orders.OrdCnt,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)))/120 AS BenchmarkPcnt
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
LEFT JOIN (SELECT COUNT(DISTINCT P.ixOrder) AS OrdCnt
				, ixVerifier
				, SUM(OL.iQuantity) AS LineItems
		   FROM tblPackage P 
		   LEFT JOIN tblDate D ON D.ixDate = P.ixShipDate
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = P.ixOrder
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU                           
		   WHERE D.dtDate  BETWEEN @StartDate AND @EndDate --'05/20/13' AND '05/20/13' 
			 AND S.flgIntangible = '0' 
			 --AND ixVerifier IN @Employee --('KWR', 'AMP', 'ELA', 'EMT1', 'KWR', 'TAB1', 'AKA', 'NJS1')
		   GROUP BY ixVerifier
          ) Orders ON Orders.ixVerifier = DTJT.ixEmployee
WHERE DTJT.sJob = '87-2'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate --'05/20/13' AND '05/20/13' 
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixEmployee
       , ISNULL(Orders.OrdCnt,0)
       , ISNULL(Orders.LineItems,0)      

--Small Pack / Packaging "87-3" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
     , ISNULL(Orders.LineItems,0) AS LineItems
     , ISNULL(Orders.LineItems,0)/(SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))) AS ItemsPerHour
     , ISNULL(Orders.Weight,0) AS Weight
     , ISNULL(Orders.Weight,0)/(SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)))  AS WeightPerHour
     , ISNULL(Orders.Cartons,0) AS Cartons
     , ISNULL(Orders.Cartons,0)/(SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))) AS CartonsPerHour     
     , (ISNULL(Orders.Cartons,0)/(SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))))/35 AS BenchmarkPcnt
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
LEFT JOIN (SELECT SUM(P.dActualWeight) AS Weight
				, ixPacker
				, SUM(OL.iQuantity) AS LineItems
				, COUNT(DISTINCT P.sTrackingNumber) AS Cartons
		   FROM tblPackage P 
		   LEFT JOIN tblDate D ON D.ixDate = P.ixShipDate
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = P.ixOrder
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU                           
		   WHERE D.dtDate BETWEEN @StartDate AND @EndDate   
			 AND S.flgIntangible = '0' 
			 --AND ixPacker IN @Employee -- ('KWR', 'AMP', 'EMT1', 'KWR', 'TAB1', 'NJS1', 'AGW', 'CLF', 'DMG', 'JAC3', 'NJC', 'TCD', 'TJF')
		   GROUP BY ixPacker
          ) Orders ON Orders.ixPacker = DTJT.ixEmployee
WHERE DTJT.sJob = '87-3'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate   
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixEmployee
       , ISNULL(Orders.LineItems,0) 
       , ISNULL(Orders.Weight,0) 
       , ISNULL(Orders.Cartons,0)    

--Small Pack / Shipping "87-4" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
     , ISNULL(Orders.Weight,0) AS Weight
     , ISNULL(Orders.Weight,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS WeightPerHour
     , ISNULL(Orders.Cartons,0) AS Cartons
     , ISNULL(Orders.Cartons,0)/(SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))) AS CartonsPerHour     
     , (ISNULL(Orders.Cartons,0)/(SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))))/200 AS BenchmarkPcnt
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
LEFT JOIN (SELECT SUM(P.dActualWeight) AS Weight
				, ixShipper
				, COUNT(DISTINCT P.sTrackingNumber) AS Cartons
		   FROM tblPackage P 
		   LEFT JOIN tblDate D ON D.ixDate = P.ixShipDate
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = P.ixOrder
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU                           
		   WHERE D.dtDate BETWEEN @StartDate AND @EndDate  
			 AND S.flgIntangible = '0' 
			 --AND ixShipper IN @Employee -- ('AMP', 'TAB1', 'JAC3', 'LBP')
		   GROUP BY ixShipper
          ) Orders ON Orders.ixShipper = DTJT.ixEmployee
WHERE DTJT.sJob = '87-4'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate  
  AND DTJT.ixEmployee IN (@Employee) 
GROUP BY E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixEmployee
       , ISNULL(Orders.Weight,0) 
       , ISNULL(Orders.Cartons,0)  

--Small Pack / Truck Loading "87-5" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
WHERE DTJT.sJob = '87-5'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate   
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
     , DTJT.ixEmployee   
  
  
--Small Pack / Non Production Hours "87-1", "87-7", "87-6", "87-8" 

SELECT ISNULL(MDH.Name,ISNULL(CH.Name,(ISNULL(BH.Name,NPH.Name)))) AS Name 
     , ISNULL(MDH.ixEmployee,ISNULL(CH.ixEmployee,(ISNULL(BH.ixEmployee,NPH.ixEmployee)))) AS ixEmployee 
     , ISNULL(MDH.MDHours,0.00) AS MDHours 
     , ISNULL(CH.CHours, 0.00) AS CHours
     , ISNULL(BH.BHours,0.00) AS BHours
     , ISNULL(NPH.NPHours,0.00) AS NPHours 
     , ISNULL(MDH.MDHours,0.00) + ISNULL(CH.CHours,0.00) + ISNULL(BH.BHours,0.00) + ISNULL(NPH.NPHours,0.00) AS TotHours
FROM (SELECT E.sFirstname + ' ' + E.sLastname AS Name
		   , DTJT.ixEmployee
		   , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS MDHours
	  FROM vwDailyTotJobTime DTJT
	  LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
	  WHERE DTJT.sJob = '87-1'
	    AND DTJT.dtDate BETWEEN @StartDate AND @EndDate 
	  GROUP BY E.sFirstname + ' ' + E.sLastname 
		     , DTJT.ixEmployee
	 ) MDH  
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
				, DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS CHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '87-7'
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13'  
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) CH ON CH.ixEmployee = MDH.ixEmployee 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS BHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '87-6'
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13'    
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			   
		  ) BH ON BH.ixEmployee = MDH.ixEmployee 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS NPHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '87-8'
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13' 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) NPH ON NPH.ixEmployee = MDH.ixEmployee 
WHERE ISNULL(MDH.ixEmployee,ISNULL(CH.ixEmployee,(ISNULL(BH.ixEmployee,NPH.ixEmployee))))  IN (@Employee)		  
		  
--Total Hours Production v. Non-production 

SELECT ISNULL(NPH.Name,PH.Name) AS Name 
     , ISNULL(NPH.ixEmployee,PH.ixEmployee) AS ixEmployee 
     , ISNULL(NPH.NPHours,0.00) AS NPHours
     , ISNULL(PH.PHours,0.00) AS PHours
     , ISNULL(NPH.NPHours,0.00) + ISNULL(PH.PHours,0.00) AS TotHours
FROM (SELECT E.sFirstname + ' ' + E.sLastname AS Name
		   , DTJT.ixEmployee
		   , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS NPHours
	  FROM vwDailyTotJobTime DTJT
	  LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
	  WHERE DTJT.sJob IN ('87-1', '87-7', '87-6', '87-8')
	    AND DTJT.dtDate BETWEEN @StartDate AND @EndDate
	  GROUP BY E.sFirstname + ' ' + E.sLastname 
		     , DTJT.ixEmployee   
	 ) NPH  
JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
				, DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))  AS PHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob IN ('87-2', '87-3', '87-4', '87-5')
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee 			   
		  ) PH ON PH.ixEmployee = NPH.ixEmployee 
WHERE ISNULL(NPH.ixEmployee,PH.ixEmployee) IN (@Employee)		  	  
	  
		  
-- To populate employee dropdown list

(
	SELECT ixEmployee 
	FROM tblEmployee 
	WHERE ixDepartment = '87'
	  AND flgCurrentEmployee = '1' 
  
	UNION 

	SELECT ixEmployee 
	FROM tblJobClock
	WHERE sJob LIKE '87%'
	  AND dtDate BETWEEN @StartDate AND @EndDate 
)  

ORDER BY ixEmployee		  


--To show where employees were clocked in throughout the day
SELECT DTJT.ixEmployee
     , E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixDepartment 
     , DTJT.sJob 
     , DTJT.JobDescription
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours 
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee 
WHERE dtDate BETWEEN @StartDate AND @EndDate 
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY DTJT.ixEmployee
       , E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixDepartment 
       , DTJT.sJob 
       , DTJT.JobDescription 
ORDER BY DTJT.ixEmployee
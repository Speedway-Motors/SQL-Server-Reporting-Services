-- Carousel "84-2" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
     , ISNULL(Orders.SKUsPicked,0) AS SKUsPicked
     , ISNULL(Orders.SKUsPicked,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS SKUsPickedPerHour
     , ISNULL(Orders.LinesPicked,0) AS Lines 
     , ISNULL(Orders.LinesPicked,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS LinesPerHour     
     , (ISNULL(Orders.LinesPicked,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)))/200 AS BenchmarkPcnt     
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
-- Carousel Pick (will need to add mispull data when available)  
LEFT JOIN (SELECT COUNT(DISTINCT OL.ixSKU) AS LinesPicked 
				, SUM(OL.iQuantity) AS SKUsPicked 
				, OL.ixPicker 
		   FROM tblOrderLine OL 
		   LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
		   LEFT JOIN tblBinSku BS ON BS.ixSKU = OL.ixSKU AND BS.ixLocation = 99  
		   LEFT JOIN tblBin B ON B.ixBin = BS.ixBin AND B.ixLocation = 99  
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE OL.dtOrderDate BETWEEN @StartDate AND @EndDate --'07/09/14' AND '07/09/14' 
			 AND sPickingBin LIKE '[0-9]%'       
			 AND flgLineStatus IN ('Shipped', 'Open') 
			 AND O.sOrderStatus IN ('Shipped', 'Open')   
			 AND S.flgIntangible = 0 
			 AND iShipMethod <> 1 -- exclude due to process; these orders were first created as pick tickets therefore don't have picker data at the order level
			 AND iQuantity > 0 -- cases where all items ready to ship except 'x' pieces in kit; qty gets entered as 0 (i.e. nobody picks) and entered as new line with line status = BO 
			 AND OL.ixSKU NOT LIKE 'TECHELP%' -- wasn't be excluded as intangible 
			 AND B.sBinType = 'P'
		   GROUP BY OL.ixPicker   
          ) Orders ON Orders.ixPicker = DTJT.ixEmployee
WHERE DTJT.sJob = '84-2'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate  --'07/09/14' AND '07/09/14' 
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixEmployee
       , ISNULL(Orders.SKUsPicked,0)          
       , ISNULL(Orders.LinesPicked,0)




-- Flow Rack "84-3" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
     , ISNULL(Orders.SKUsPicked,0) AS SKUsPicked
     , ISNULL(Orders.SKUsPicked,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS SKUsPickedPerHour
     , ISNULL(Orders.LinesPicked,0) AS Lines 
     , ISNULL(Orders.LinesPicked,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS LinesPerHour     
     , (ISNULL(Orders.LinesPicked,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)))/200 AS BenchmarkPcnt     
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
-- Flow Rack Pick (will need to add mispull data when available)    
LEFT JOIN (SELECT COUNT(DISTINCT OL.ixSKU) AS LinesPicked 
			    , SUM(OL.iQuantity) AS SKUsPicked 
			    , OL.ixPicker 
		   FROM tblOrderLine OL 
		   LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
		   LEFT JOIN tblBinSku BS ON BS.ixSKU = OL.ixSKU AND BS.ixLocation = 99  
		   LEFT JOIN tblBin B ON B.ixBin = BS.ixBin AND B.ixLocation = 99  
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE OL.dtOrderDate BETWEEN @StartDate AND @EndDate -- '07/09/14' AND '07/09/14' 
			 AND (sPickingBin LIKE 'X%'       
					OR sPickingBin LIKE 'Y%' 
					OR sPickingBin LIKE 'Z%' 
					OR sPickingBin LIKE 'AL%' 
					OR sPickingBin LIKE 'AM%'
					OR sPickingBin LIKE 'AK%'
				  ) 
		     AND flgLineStatus IN ('Shipped', 'Open') 
			 AND O.sOrderStatus IN ('Shipped', 'Open')   
			 AND S.flgIntangible = 0 
			 AND iShipMethod <> 1 -- exclude due to process; these orders were first created as pick tickets therefore don't have picker data at the order level
			 AND iQuantity > 0 -- cases where all items ready to ship except 'x' pieces in kit; qty gets entered as 0 (i.e. nobody picks) and entered as new line with line status = BO 
			 AND OL.ixSKU NOT LIKE 'TECHELP%' -- wasn't be excluded as intangible   
			 AND B.sBinType = 'P'
		   GROUP BY ixPicker  
          ) Orders ON Orders.ixPicker = DTJT.ixEmployee
WHERE DTJT.sJob = '84-3'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate  --'07/09/14' AND '07/09/14' 
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixEmployee
       , ISNULL(Orders.SKUsPicked,0)          
       , ISNULL(Orders.LinesPicked,0)





--Carousel / Non Production Hours "84-1", "84-11", "84-10", "84-12" 

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
	  WHERE DTJT.sJob = '84-1'
	    AND DTJT.dtDate BETWEEN @StartDate AND @EndDate 
	  GROUP BY E.sFirstname + ' ' + E.sLastname 
		     , DTJT.ixEmployee
	 ) MDH  -- Morning Duties Hours 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
				, DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS CHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '84-11'
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) CH ON CH.ixEmployee = MDH.ixEmployee -- Cleaning Hours 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS BHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '84-10'
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			   
		  ) BH ON BH.ixEmployee = MDH.ixEmployee -- Break Hours 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS NPHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '84-12'
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) NPH ON NPH.ixEmployee = MDH.ixEmployee -- Non Production (Misc.) Hours 	  
WHERE ISNULL(MDH.ixEmployee,ISNULL(CH.ixEmployee,(ISNULL(BH.ixEmployee,NPH.ixEmployee)))) IN (@Employee)		  





-- Flow Rack Restock "84-5" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
     , ISNULL(Restock.CIDs,0) AS CIDs
     , ISNULL(Restock.CIDs,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS CIDsPerHour
     , (ISNULL(Restock.CIDs,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)))/25 AS BenchmarkPcnt     
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
-- Restock Data for Flow Rack / Carousel  
LEFT JOIN (SELECT ST.sUser 
                , (COUNT(DISTINCT sCID)) + (SUM(CASE WHEN sCID IS NULL THEN 1
                                                     ELSE 0
                                                END)
                                             ) AS CIDs  -- some SKUs aren't "CIDed" according to Carol and therefore would be unaccounted for if only counting DISTINCT CIDs      
                , (CASE WHEN sToBin LIKE '[0-9]%' THEN 'Carousel'
                        WHEN (sToBin LIKE 'X%'       
					            OR sToBin LIKE 'Y%' 
								OR sToBin LIKE 'Z%' 
								OR sToBin LIKE 'AL%' 
								OR sToBin LIKE 'AM%'
								OR sToBin LIKE 'AK%') THEN 'Flow Rack' 
						ELSE 'Other' 
					END) AS Location 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE dtDate BETWEEN @StartDate AND @EndDate -- '07/09/14' AND '07/09/14' 
			 AND sTransactionType = 'T'
			 AND (ixJob LIKE '84%'
					OR (ixJob IS NULL AND sTransactionInfo IN ('Carousel CID Putaway', 'Carousel Return Putaway')) 
				  ) 
		   GROUP BY ST.sUser 
				  , (CASE WHEN sToBin LIKE '[0-9]%' THEN 'Carousel'
						  WHEN (sToBin LIKE 'X%'       
								   OR sToBin LIKE 'Y%' 
				  				   OR sToBin LIKE 'Z%' 
								   OR sToBin LIKE 'AL%' 
								   OR sToBin LIKE 'AM%'
								   OR sToBin LIKE 'AK%') THEN 'Flow Rack' 
						  ELSE 'Other' 
					 END) 
          ) Restock ON Restock.sUser = DTJT.ixEmployee
WHERE DTJT.sJob = '84-5'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- '07/09/14' AND '07/09/14' 
  AND DTJT.ixEmployee IN (@Employee)
  AND Location = 'Flow Rack' -- ?? Unable to test currently due to people not correctly logging time to the correct jobs 
GROUP BY E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixEmployee
       , ISNULL(Restock.CIDs,0)
		 




-- Carousel Restock "84-4" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
     , ISNULL(Restock.CIDs,0) AS CIDs
     , ISNULL(Restock.CIDs,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS CIDsPerHour
     , (ISNULL(Restock.CIDs,0)/SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)))/60 AS BenchmarkPcnt     
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
-- Restock Data for Flow Rack / Carousel  
LEFT JOIN (SELECT ST.sUser 
                , (COUNT(DISTINCT sCID)) + (SUM(CASE WHEN sCID IS NULL THEN 1
                                                     ELSE 0
                                                END)
                                             ) AS CIDs  -- some SKUs aren't "CIDed" according to Carol and therefore would be unaccounted for if only counting DISTINCT CIDs      
                , (CASE WHEN sToBin LIKE '[0-9]%' THEN 'Carousel'
                        WHEN (sToBin LIKE 'X%'       
					            OR sToBin LIKE 'Y%' 
								OR sToBin LIKE 'Z%' 
								OR sToBin LIKE 'AL%' 
								OR sToBin LIKE 'AM%'
								OR sToBin LIKE 'AK%') THEN 'Flow Rack' 
						ELSE 'Other' 
					END) AS Location 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE dtDate BETWEEN @StartDate AND @EndDate -- '07/09/14' AND '07/09/14' 
			 AND sTransactionType = 'T'
			 AND (ixJob LIKE '84%'
					OR (ixJob IS NULL AND sTransactionInfo IN ('Carousel CID Putaway', 'Carousel Return Putaway')) 
				  ) 
		   GROUP BY ST.sUser 
				  , (CASE WHEN sToBin LIKE '[0-9]%' THEN 'Carousel'
						  WHEN (sToBin LIKE 'X%'       
								   OR sToBin LIKE 'Y%' 
				  				   OR sToBin LIKE 'Z%' 
								   OR sToBin LIKE 'AL%' 
								   OR sToBin LIKE 'AM%'
								   OR sToBin LIKE 'AK%') THEN 'Flow Rack' 
						  ELSE 'Other' 
					 END) 
          ) Restock ON Restock.sUser = DTJT.ixEmployee
WHERE DTJT.sJob = '84-4'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- '07/09/14' AND '07/09/14' 
  AND DTJT.ixEmployee IN (@Employee)
  AND Location = 'Carousel' -- ?? Unable to test currently due to people not correctly logging time to the correct jobs 
GROUP BY E.sFirstname + ' ' + E.sLastname 
       , DTJT.ixEmployee
       , ISNULL(Restock.CIDs,0)
       
       
-- Carousel / Returns Putaway "84-6" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
WHERE DTJT.sJob = '84-6'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate   
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
     , DTJT.ixEmployee   
     
     
-- Carousel / Misc Putaway "84-7" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
WHERE DTJT.sJob = '84-7'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate   
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
     , DTJT.ixEmployee 
     
     

-- Carousel / Fail HC + Problems "84-8" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
WHERE DTJT.sJob = '84-8'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate   
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
     , DTJT.ixEmployee 
     
     
     
-- Carousel / Print/Tubs/Support "84-9" 
SELECT E.sFirstname + ' ' + E.sLastname AS Name
     , DTJT.ixEmployee
     , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS Hours
FROM vwDailyTotJobTime DTJT
LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
WHERE DTJT.sJob = '84-9'
  AND DTJT.dtDate BETWEEN @StartDate AND @EndDate   
  AND DTJT.ixEmployee IN (@Employee)
GROUP BY E.sFirstname + ' ' + E.sLastname 
     , DTJT.ixEmployee     
     
     
     
     
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
	  WHERE DTJT.sJob IN ('84-1', '84-11', '84-10', '84-12')
	    AND DTJT.dtDate BETWEEN @StartDate AND @EndDate
	  GROUP BY E.sFirstname + ' ' + E.sLastname 
		     , DTJT.ixEmployee   
	 ) NPH  
FULL JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
				, DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0))  AS PHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob IN ('84-2', '84-3', '84-4', '84-5', '84-6', '84-7', '84-8', '84-9')
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee 			   
		  ) PH ON PH.ixEmployee = NPH.ixEmployee 
WHERE ISNULL(NPH.ixEmployee,PH.ixEmployee) IN (@Employee)		 



                       
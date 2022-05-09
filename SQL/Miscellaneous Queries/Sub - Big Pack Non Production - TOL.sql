-- Sub - Big Pack Non Production - TOL.rdl
/*  ver 20.43.1
*/
DECLARE @StartDate datetime,    @EndDate datetime,      @Employee varchar(10)
SELECT @StartDate = '10/22/2020',   @EndDate = '10/22/2020',   @Employee= 'BJM2' --'SCN' 

/*
    43-12	Returns
    43-15	Break
    43-14	Cleaning/Restock
    43-13	Misc Non Production
    43-4	Big Pack Printing
    43-1	AZ Outbound
*/ 

SELECT ISNULL(AZO.Name,ISNULL(BPP.Name,ISNULL(CH.Name,(ISNULL(BH.Name,(ISNULL(NPH.Name,RTN.Name))))))) AS Name 
     , ISNULL(AZO.ixEmployee,
        ISNULL(BPP.ixEmployee,
            ISNULL(CH.ixEmployee,
                    ISNULL(BH.ixEmployee,
                            ISNULL(NPH.ixEmployee,RTN.ixEmployee))))) AS ixEmployee 
     , ISNULL(BPP.BPPHours,0.00) AS BPPHours 
     , ISNULL(CH.CHours, 0.00) AS CHours
     , ISNULL(BH.BHours,0.00) AS BHours
     , ISNULL(NPH.NPHours,0.00) AS NPHours 
     , ISNULL(RTN.RtnHours,0.00) AS RTNHours    
     , ISNULL(AZO.AZOHours,0.00) AS AZOHours    
     , ISNULL(BPP.BPPHours,0.00) + ISNULL(CH.CHours,0.00) + ISNULL(BH.BHours,0.00) + ISNULL(NPH.NPHours,0.00) + ISNULL(RTN.RtnHours,0.00) + ISNULL(AZO.AZOHours,0.00) AS TotHours
FROM (SELECT E.sFirstname + ' ' + E.sLastname AS Name
		   , DTJT.ixEmployee
		   , SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS BPPHours
	  FROM vwDailyTotJobTime DTJT
	  LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
	  WHERE DTJT.sJob = '43-4' --Big Pack Printing
	    AND DTJT.dtDate BETWEEN @StartDate AND @EndDate 
	  GROUP BY E.sFirstname + ' ' + E.sLastname 
		     , DTJT.ixEmployee
	 ) BPP  
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
				, DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS CHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '43-14' --Cleaning Hours 
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13'  
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) CH ON CH.ixEmployee = BPP.ixEmployee 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS BHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '43-15' --Break Hours
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13'    
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			   
		  ) BH ON BH.ixEmployee = BPP.ixEmployee 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS NPHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '43-13' --Non-Production Misc Hours 
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13' 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) NPH ON NPH.ixEmployee = BPP.ixEmployee 
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS RtnHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '43-12' --Returns Misc Hours  
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13' 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) RTN ON RTN.ixEmployee = BPP.ixEmployee 	  	
FULL OUTER JOIN (SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS AZOHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '43-1' --AZ outbound
			 AND DTJT.dtDate BETWEEN @StartDate AND @EndDate -- = '05/17/13' 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 
		  ) AZO ON AZO.ixEmployee = BPP.ixEmployee 	          	  
WHERE ISNULL(AZO.ixEmployee,
        ISNULL(BPP.ixEmployee,
            ISNULL(CH.ixEmployee,
                    ISNULL(BH.ixEmployee,
                            ISNULL(NPH.ixEmployee,RTN.ixEmployee))))) IN (@Employee) -- ('BJM2','SCN') --	  



/*
SELECT * FROM tblJobClock
WHERE sJob = '43-4'
order by dtDate desc

--SELECT * FROM tblEmployee where flgCurrentEmployee = 1 and ixEmployee like 'B%B%'

SELECT * FROM tblJobClock
WHERE dtDate = '10/22/2020'

SELECT E.sFirstname + ' ' + E.sLastname AS Name
			    , DTJT.ixEmployee
				, SUM(ISNULL((DTJT.iTotDailyJobTime/3600.00),0)) AS AZOHours
		   FROM vwDailyTotJobTime DTJT
		   LEFT JOIN tblEmployee E ON E.ixEmployee = DTJT.ixEmployee
		   WHERE DTJT.sJob = '43-1' --AZ outbound
			 AND DTJT.dtDate BETWEEN '10/22/2020' and '10/22/2020' --@StartDate AND @EndDate -- = '05/17/13' 
		   GROUP BY E.sFirstname + ' ' + E.sLastname 
		          , DTJT.ixEmployee			 

*/

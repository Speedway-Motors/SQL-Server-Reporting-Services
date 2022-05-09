/***********	DOOR SWIPES		************/

-- LATEST swipe
SELECT top 5 DATENAME(dw,dtEventTimeDate)'LastSwipe', dtEventTimeDate 'EventTimeDate', sAction 'Action', DATENAME(dw,getdate()) AS 'Today',  CONVERT(VARCHAR,GETDATE(), 1)      FROM tblDoorEvent       ORDER BY dtEventTimeDate desc   

-- Employee recent swipes
	DECLARE @Emp Varchar(10)	SELECT @Emp = ('CAK2') -- ('ASM','PJC')  -- CJS6 Chris Kelley

		SELECT CU.ixEmployee 'tblCardUser.ixEmployee', --CU.sExtraInfo 'tblCardUser.sExtraInfo', -- BOTH OF THESE FIELDS NEED TO HAVE THE ixEmployee data or the report can not pick them up!!!
			CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10) AS [MM/DD/YY],
			SUBSTRING(D.sDayOfWeek,1,3) 'Day',    
			SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) AS 'TIME',	DE.sAction
		FROM tblCardUser CU 
			left join tblCard C on C.ixCardUser = CU.ixCardUser
			left join tblDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
			left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)
		WHERE CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101) between DATEADD(dd,-237,DATEDIFF(dd,0,getdate())) AND getdate() -- past 13 days (assuming you run it on Fridays)
			AND (CU.sExtraInfo IN (@Emp)
				OR CU.ixEmployee IN (@Emp))
			-- AND DE.sAction = 'Entry' and (SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5)) < '11:00'
			-- AND D.sDayOfWeek = 'THURSDAY'   
		ORDER BY CU.ixEmployee, CU.sExtraInfo, DE.dtEventTimeDate
    
SELECT * FROM tblCardUser
WHERE --sFirstName like 'Chris%' -- 1785	CAK2
    sLastName = 'Kelley'
order by sLastName

/*
ixCardUser	ixEmployee	sFirstName	sLastName	sExtraInfo
1785	    CAK2	    Chris       Kelley      F/C 4                           


SELECT * from tblCard 
where ixCardUser = 1785

/ixCard	ixCardUser	ixCardScanNum	sPrintedCardNum	flgActive	iActivationDate	iDeactivationDate
1677	1785	907445179	    635644	1	1568151420	5000000000








SELECT * from tblEmployee
where ixEmployee like 'C%S%'
order by 'sFirstname'


SELECT * from tblEmployee
where ixEmployee like 'R%K%'
order by 'sFirstname'

-- LATEST swipe
SELECT top 5 * FROM tblDoorEvent ORDER BY dtEventTimeDate desc 
    
-- dataset query to populate employee dropdown for 
-- "Employee Entrance and Exit Door Swipes - Call Center.rdl"
Select distinct E.sPayrollId, CU.ixEmployee, C.ixCardUser, E.ixDepartment, E.sFirstname, E.sLastname
FROM tblEmployee  E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
   left join tblCard C on C.ixCardUser = CU.ixCardUser
WHERE --E.ixDepartment in ('20') -- in (@Dept)
  -- and E.flgCurrentEmployee = 1
  --C.ixCardUser = '3688'
  E.ixEmployee like 'D%K%'
	-- E.ixEmployee in ('EJB','EMI','JPM','LJH','MEW','NFI','RED','TMP','ZBL')
ORDER BY ixEmployee --E.sPayrollId
/*
    Payroll Card    First   Last
Emp	Id	    User	name    name    Dept
ARH 3804	1494    ANNA	HIEBERT 20
*/


SELECT ixEmployee,	sPayrollId,	ixDepartment 'Dept', sFirstname,	sLastname, flgCurrentEmployee, CONVERT(VARCHAR,dtHireDate, 1) AS 'HireDate', dtDateLastSOPUpdate
FROM tblEmployee
WHERE --ixEmployee LIKE 'TMS%' -- ('EJB','EMI','JPM','LJH','MEW','NFI','RED','TMP','ZBL')
    sLastname = 'KING'
	-- 'ADS1','DKK','JBD',
	-- 'BKH','JJM',
ORDER BY sPayrollId
/*		Payroll
ixEmp	Id		Dpt Firstname	Lastname
=====	=======	==== ========	==========
TMS		3747	29	TINA		SPRADLEY	
EJB		NULL	12	BETSY		GRINDLAY
JPM		2741	6	JOSEPH		MCCOLLOUGH
LJH		3536	81	LOGAN		HENRIKSEN
ZBL		3593	17	ZACH		LUEDTKE
MEW		3624	20	MARISA		WHITING

-- WORKS on Report but NOT on query
JJM		2231	2	JERRY		MALCOM
BKH		2628	81	BRIAN		HAYS

-- WORKING
ADS1	3114	82	ALEX		SCHNEIDER
DKK		3549	87	DEMITRIA	KECHELY
JSB		2814	85	JUSTIN		BEDEA
*/


select * from tblDepartment
where ixDepartment = 87


/***** tables used by DOOR System *******

SELECT COUNT(*) FROM tblCardUser -- 525,139
SELECT TOP 10 *  FROM tblCardUser CU ORDER BY ixCardUser desc

ixCardUser	ixEmployee	sFirstName	sLastName	sExtraInfo
525139	    RDA	        Ryan        Ardiana     RDA                             



-- SELECT TOP 10 * FROM tblCard C ORDER BY ixCard desc

ixCard	ixCardUser	ixCardScanNum	sPrintedCardNum	flgActive	iActivationDate	iDeactivationDate
518733	518434	    908001560	    634396	        1	        1492017360	    5000000000



-- SELECT TOP 10 *  FROM tblDoorEvent DE ORDER BY iEventTimeDate desc

ixEventId	ixCardScanNum	dtEventTimeDate	        sAction	iEventTimeDate
508374	    906363192	    2017-04-19 23:26:55.000	Exit	1492662415


SELECT * FROM tblEmployee WHERE ixEmployee = 'FWG'

-- vwDoorEvent is currently just the contents of tblDoorEvent
SELECT * FROM tblCardUser WHERE sLastName in ('Crews','Crook')

JOINS
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
    
Employee	sFirstname	sLastname	Dept	sPayrollId
ASM	        ALAINA	    CROOK	    15      2868
PJC	    	PATRICK	    CREWS	    15      1126
HJN	        HALEY	    NELSON
HJZ	        HALEY	    ZITEK
*/




/*
SELECT CU.sFirstName, SUBSTRING(D.sDayOfWeek,1,3) 'Day',  
    CONVERT(VARCHAR, dtEventTimeDate, 1) AS 'EventDate',
    CONVERT(VARCHAR, dtEventTimeDate, 8)   AS 'EventTime',    
-- dtEventTimeDate    
    sAction, iEventTimeDate 
FROM tblCard C
    join tblCardUser CU on C.ixCardUser = CU.ixCardUser
    join tblDoorEvent DE on C.ixCardScanNum = DE.ixCardScanNum
    left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)
WHERE sLastName = 'Crews' 
    and CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101) between DATEADD(dd,-14,DATEDIFF(dd,0,getdate())) AND getdate() -- past 13 days (assuming you run it on Fridays)
ORDER BY dtEventTimeDate desc
*/


-- AVG ENTRY & EXIT TIMES FOR DEPT 15
/*  NEED to: 
        compute AVG Entry & Exits for date range with two sub-queries
        count Entry scans and Exit scans
        exclude SAT & SUN
        exclude dates with and odd number of scans (definte mismach of #of Entries vs Exits */          
/*        
SELECT
    E.ixEmployee,
    SUBSTRING(D.sDayOfWeek,1,3) 'Day',
    CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10) AS [MM/DD/YY],
    SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) AS 'TIME',
    DE.sAction
FROM
    tblEmployee E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
    left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)       
WHERE --E.ixDepartment = '11'
E.ixEmployee = 'MEK'
    --  E.sPayrollId = 
    --  E.ixEmployee = 'PJC'
--    and DE.dtEventTimeDate >= dateadd(DD,-9,getdate())   -- LAST 30 DAYS
     and DE.dtEventTimeDate between '01/01/2016' and  '12/31/2016'
    
    -- ONLY RETURN Enteries before 10AM and exits after 3PM
     --   and (DE.sAction = 'Entry' and SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) < '10:00'
           --  OR 
             --DE.sAction = 'Exit' and SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) > '15:00'
ORDER BY ixEmployee, CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10)
*/


-- TO locate an Employees ixCardScanNum
/*
SELECT distinct ixCardScanNum
FROM 
    tblEmployee E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C      on C.ixCardUser = CU.ixCardUser
WHERE E.ixEmployee in ('EJB','EJG')
*/      

/*** how many users had activity on a given day *****/
/*
SELECT count(distinct DE.ixCardScanNum) 
FROM     tblCardUser CU 
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum -- 196
WHERE dtEventTimeDate between '05/14/2013' and '05/15/2013'


SELECT distinct sFirstName, sLastName 
FROM tblCardUser
WHERE --ixEmployee = 'NONE'
 sFirstName not like '%Pass%'
and sFirstName not like '%2007%'
and sFirstName not like '%Sunday%'
and sFirstName not like '%Card%'
and sFirstName not like '%Holiday%' 
and sFirstName not like '%Crew%'
and sFirstName not like '%Labor%' 
and sFirstName not like '%Main%' 
and sFirstName not like '%Night%' 
and sFirstName not like '%Security%' 
and sFirstName not like '%Card%' 
and sFirstName not like '%Program%' 
and sFirstName not like '%Guard%' 
and sLastName not like '%Cleaning%' 
ORDER BY sLastName


SELECT count(ixEmployee) - 10
FROM tblEmployee
WHERE flgCurrentEmployee = 1


SELECT * FROM vwDoorEvent
ORDER BY dtEventTimeDate desc




SELECT
   -- E.ixEmployee,
  --  SUBSTRING(D.sDayOfWeek,1,3) 'Day',
    CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10) AS [MM/DD/YY],
  --  SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) AS 'TIME',
    count(DE.sAction) 'Swipes'
FROM
    tblEmployee E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
    left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)       
WHERE --E.ixDepartment = '11'
E.ixEmployee = 'MEK'
    --  E.sPayrollId = 
    --  E.ixEmployee = 'PJC'
--    and DE.dtEventTimeDate >= dateadd(DD,-9,getdate())   -- LAST 30 DAYS
     and DE.dtEventTimeDate between '01/01/2016' and  '12/31/2016'
    
    -- ONLY RETURN Enteries before 10AM and exits after 3PM
     --   and (DE.sAction = 'Entry' and SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) < '10:00'
           --  OR 
             --DE.sAction = 'Exit' and SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) > '15:00'
GROUP BY CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10)
ORDER BY CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10)
             
ORDER BY ixEmployee, CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10)

SELECT * FROM tblEmployee WHERE ixEmployee = 'MEK'
SELECT * FROM tblEmployee WHERE ixEmployee = 'ASM' -- Hire Date 2009-06-03


/***	Summary of Changes to Daylight Saving Time ***
	    Prior to 2007	        2007 and After	
Start	1st SUN in April	    2nd SUN in March	
End	    Last SUN in October	    1st SUN in November	
				
				
------------ Start ------ End ----- Year
Door System	04/06/14	10/26/14	2014
Actual US	03/09/14	11/02/14	2014
			
Door System	04/05/15	10/25/15	2015
Actual US	03/08/15	11/01/15	2015
			
Door System	04/03/16	10/30/16	2016
Actual US	03/13/16	11/06/16	2016
			
Door System	04/02/17	10/29/17	2017
Actual US	03/12/17	11/05/16	2017
*/	
SELECT
    E.sFirstname,
    E.sLastname,
    E.ixEmployee, -- placeholder until Employee# is created
    E.sPayrollId,
    E.ixDepartment,
    CONVERT(VARCHAR(10), DE.dtEventTimeDate, 101) AS [MM/DD/YYYY],
   SUBSTRING(datename(dw,DE.dtEventTimeDate),1,3) 'Day',
    DE.sAction,
    DE.dtEventTimeDate
/* MODIFY THE CASE STATEMENT ACCORDING TO THE CHART AT THE TOP OF THE COMMENTS TO COMPENSATE FOR OUR JUNKY DOOR SYSTEM
    (Case when (DE.dtEventTimeDate > '11/02/10' and  DE.dtEventTimeDate < '11/07/10')
          then dateadd(HH,-1,DE.dtEventTimeDate) 
          else DE.dtEventTimeDate
     End) EventTimeDate
*/     
FROM
    tblEmployee E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
WHERE
   --     E.sPayrollId in ('EJB','EJG') -- (@Employee)
--and DE.dtEventTimeDate >= @StartDate
--and DE.dtEventTimeDate < (@EndDate+1)
-- and E.ixDepartment in (@Dept)
 C.ixCardScanNum IN ('404210057','740245546','840929562') -- BETSY
-- C.ixCardScanNum IN ('45299819','637928377','637981497','908513722')  -- LARKINS
--C.ixCardScanNum IN ('1050782635','9549514')  -- HELM
ORDER BY     E.sLastname,    DE.dtEventTimeDate



-- tblCardUser.ixEmployee
-- tblCardUser.sExtraInfo

SELECT ixEmployee, sFirstname, sLastname, ixDepartment, sPayrollId, flgCurrentEmployee
FROM tblEmployee
WHERE ixEmployee in ('EJB','EJG','KDL','KDL47','KRH')

ix       First
Employee name	Lastname	ixDepartment	sPayrollId	flgCurrentEmployee
EJB     BETSY	GRINDLAY	12	            NULL	1
EJG	    BETSY	GRINDLAY	12	            1104	1
KDL	    KEVIN	LARKINS	    70	            2575	1
KDL47	KEVIN	LARKINS	    47	            NULL	1
KRH	    KEVIN	HELM	    17	            1066	1

-- TO locate an Employees ixCardScanNum
/**/
SELECT distinct ixCardScanNum
FROM 
    tblEmployee E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C      on C.ixCardUser = CU.ixCardUser
WHERE E.ixEmployee in ('KRH') -- KDL','KDL47','KRH','EJB','EJG',
    
        
-- Count of Swipes by Day
SELECT FORMAT(dtEventTimeDate,'yyyy.MM.dd') 'Date',
count(*)
FROM tblDoorEvent
GROUP BY FORMAT(dtEventTimeDate,'yyyy.MM.dd')
ORDER BY FORMAT(dtEventTimeDate,'yyyy.MM.dd') DESC


    */
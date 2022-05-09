-- tblDoorEvent Checks

/***** tables used by DOOR System *******
select top 10 * from tblCardUser CU
select top 10 * from tblCard C
select top 10 * from tblDoorEvent DE
select * from tblCardUser where sLastName in ('Crews','Crook')

JOINS
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join tblDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
    
**************** ERROR CODES & ERROR LOG history ***********************/
select * from tblErrorCode where sDescription like '%tblDoorEvent%'
--  ixErrorCode	sDescription
--  THERE ARE NO ERROR CODES FOR THE 3 Door Tables
--  They can not write to tblError

-- ERROR COUNTS by Day
SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '####'
  and dtDate >=  DATEADD(month, -12, getdate())  -- past 3 months
GROUP BY CONVERT(VARCHAR(10), dtDate, 10)  
HAVING count(*) > 10
ORDER BY 'Date      ' Desc
/*
DataBaseName	Date      	ErrorQty
************************************************************************/

-- Distinct list of Orders with erros
select distinct sError
from tblErrorLogMaster
where ixErrorCode = '####'
  and dtDate >='11/17/2013'
order by sError  


SELECT COUNT(*) FROM tblDoorEvent -- 67,707 @11/18/2013  

SELECT COUNT(*) 'RecCnt'
    ,min(dtEventTimeDate)'OldestRecord           '
    ,max(dtEventTimeDate)'NewestRecord'
from tblDoorEvent
/*
RecCnt	OldestRecord           	NewestRecord
 67,707	2013-01-01 19:17:21.000	2013-05-07 12:49:46.000
180,252	2013-01-01 19:17:21.000	2013-11-19 10:20:38.000 
*/

select top 10 dtEventTimeDate
    ,CONVERT(VARCHAR(10), dtEventTimeDate, 101) 
from tblDoorEvent
    
/*    
Employee	sFirstname	sLastname	Dept	sPayrollId
ASM	        ALAINA	    CROOK	    15      2868
PJC	    	PATRICK	    CREWS	    15      1126
*/

SELECT CU.sExtraInfo, --CU.ixEmployee,
    SUBSTRING(D.sDayOfWeek,1,3) 'Day',
    CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10) AS [MM/DD/YY],
    SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) AS 'TIME',
    DE.sAction
   -- DE.dtEventTimeDate as EventTimeDate,
FROM tblCardUser CU 
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join tblDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
    left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)
WHERE 
    DE.dtEventTimeDate >= '05/01/2013' --dateadd(DD,-30,getdate())
   --DE.dtEventTimeDate between '05/01/2013' and '05/30/2013'
      AND CU.sExtraInfo = 'ASM'--  in ('ASM','PJC') 
   -- and DE.sAction = 'Entry' and (SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5)) < '11:00'
   -- and DE.sAction = 'Exit' and (SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5)) > '15:00'
ORDER BY CU.sExtraInfo, DE.dtEventTimeDate




SELECT COUNT(*) 'RecCnt'
    ,min(dtEventTimeDate)'OldestRecord           '
    ,max(dtEventTimeDate)'NewestRecord'
from tblDoorEvent


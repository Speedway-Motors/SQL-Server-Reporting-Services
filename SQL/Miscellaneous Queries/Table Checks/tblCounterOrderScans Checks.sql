-- tblCounterOrderScans Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblCounterOrderScans%'
--  ixErrorCode	sDescription                            ixErrorType
--  1214	    Failure to update tblCounterOrderScans	SQLDB


-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = 1214
 -- and dtDate >=  DATEADD(dd, -195, getdate())  -- past X days
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
    DB          	Date    	ErrorQty
NONE 
 
*/


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblCounterOrderScans
/*
DB          	TABLE   Rows   	Date
SMI Reporting	tblCounterOrderScans	141,680	02-01-16

SMI Reporting	tblCounterOrderScans	138,428	01-01-16
SMI Reporting	tblCounterOrderScans	113,270	07-01-15
SMI Reporting	tblCounterOrderScans	 81,242	01-01-15
SMI Reporting	tblCounterOrderScans	 58,476	07-01-14
SMI Reporting	tblCounterOrderScans	 30,147	01-01-14
SMI Reporting	tblCounterOrderScans	  4,624	06-01-13
*/


/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
    ,DaysOld 
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
FROM vwDataFreshness 
WHERE sTableName = 'tblCounterOrderScans'

/*
DB          	DateChecked	DaysOld	Records
=============   =========== ======= =======
SMI Reporting	02-22-2016	   <=1	    113
SMI Reporting	02-22-2016	  8-30	  2,744
SMI Reporting	02-22-2016	   2-7	  1,201
SMI Reporting	02-22-2016	 31-180	 16,949
SMI Reporting	02-22-2016	  181 +	123,815
*/
 
 
/*******   DONE   **********************/


SELECT OS.ixEmployee 'Emp', OS.ixOrder, 
    CONVERT(VARCHAR, OS.dtScanDate, 101)   'ScanDate',
    T.chTime 'ScanTime'
FROM tblCounterOrderScans OS
    left join tblTime T on OS.ixScanTime = T.ixTime
WHERE ixIP = '192.168.174.55'

SELECT * from tblCounterOrderScans
where ixIP NOT IN (select ixIP from tblIPAddress)


SELECT * from tblIPAddress
WHERE ixIP = '192.168.174.55'

SELECT * from tblIPAddress
where UPPER(sLocation) like '%JASON%'
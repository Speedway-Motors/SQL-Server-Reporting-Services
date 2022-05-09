-- tblBin checks
/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblBin%'
--  ixErrorCode	sDescription
--  1158	Failure to update tblBin

-- ERROR COUNTS by Day
SELECT dtDate, DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1158'
 -- and dtDate >=  DATEADD(month, -24, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/* 
    DB          	Date    	ErrorQty
SMI Reporting	    05/23/2014	410
*/

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblBin
/*
DB          	Rows   	Date
SMI Reporting	199,531	08-01-15
SMI Reporting	199,447	07-01-15
SMI Reporting	199,228	04-01-15
SMI Reporting	184,457	01-01-15
SMI Reporting	195,642	01-01-14
SMI Reporting	188,269	01-01-13
SMI Reporting	180,576	04-01-12

AFCOReporting	199,308	08-01-15
AFCOReporting	199,006	04-01-15
AFCOReporting	184,228	01-01-15
AFCOReporting	195,429	01-01-14
AFCOReporting	194,636	10-01-13
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblBin'
ORDER BY DaysOld
/*
DB          	Records	DaysOld	DateChecked
SMI Reporting	181,917	   <=1	08-07-2015
SMI Reporting	8,902	   2-7	08-07-2015
SMI Reporting	29	    8-30	08-07-2015
SMI Reporting	671	    31-180	08-07-2015
SMI Reporting	5,436	181 +	08-07-2015

SMI Reporting	166,414	   <=1	05-23-2014



DB          	Records	DaysOld	DateChecked
AFCOReporting	769	   <=1	    08-07-2015
AFCOReporting	1,629	   2-7	08-07-2015
AFCOReporting	3,408	  8-30	08-07-2015
AFCOReporting	66,622	 31-180	08-07-2015
AFCOReporting	125,457	181 +	08-07-2015
*/
 
/**********************************
*****   UPDATE DELETED BINS  ******
***********************************/ 
update tblBin 
set flgDeletedFromSOP = 1
where ixBin in (select ixBin from [SMITemp].dbo.PJC_Deleted_Bins)



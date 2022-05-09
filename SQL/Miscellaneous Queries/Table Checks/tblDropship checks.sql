-- tblDropship checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblDropship%'

--  ixErrorCode	sDescription
--  1172	    Failure to update tblDropship.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1172'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
dtDate	    ErrorQty
2014-08-06  6
2014-07-29 	14
2013-08-28 	2
*/

select * from  tblErrorLogMaster
WHERE ixErrorCode = '1172'
and dtDate >= '08-06-14'
/************************************************************************/
select * from tblDropship
where ixDropship in (1086,3175,8476,13195,5273)

-- tblDropship is populated by spUpdateDropship

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblDropship
/*
DB          	TABLE       Rows   	Date
SMI Reporting	tblDropship	17829	08-01-14
SMI Reporting	tblDropship	17542	07-01-14
SMI Reporting	tblDropship	16737	04-01-14
SMI Reporting	tblDropship	16118	01-01-14

SMI Reporting	tblDropship	15498	08-01-13
SMI Reporting	tblDropship	14519	04-01-13
SMI Reporting	tblDropship	13786	01-01-13

SMI Reporting	tblDropship	13397	10-01-12
SMI Reporting	tblDropship	11592	06-01-12
SMI Reporting	tblDropship	8257	03-01-12




AFCOReporting	tblDropship	1501	07-01-14
AFCOReporting	tblDropship	1501	06-01-14
AFCOReporting	tblDropship	1501	01-01-14
AFCOReporting	tblDropship	1501	10-01-13
*/


/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblDropship'

/*

DB          	Records	DaysOld	DateChecked
SMI Reporting	17,876	   <=1	08-06-2014

AFCOReporting	1,501	UK	    07-29-2014
*/
 
select * 
from [ErrorLogging].dbo.ProcedureLog
where ProcedureName like '%spUpdateDropship%'
    and LogDate >= '08/06/14'
    
    
select * from tblOrder where ixOrder in ('5664507','4927153','4024020','4062902')
select * from tblOrderLine where ixOrder in ('5664507','4927153','4024020','4062902')

/***********************************
*****   REFEED FAILED RECORDS ******
************************************/ 
-- 1) COUNT ERRORS
    select count(*)  -- 20 total errors          
    from tblErrorLogMaster
    where dtDate >=  '02/28/2014' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1172   



    

/*******   DONE   **********************/



5664507
4927153
4062902
4024020

DELETE from [ErrorLogging].dbo.ProcedureLog where Field1 = 'ixSpecialOrder' and Value1 = '1086'



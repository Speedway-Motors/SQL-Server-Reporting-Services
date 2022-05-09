-- tblBrand checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblBrand%'
--  ixErrorCode	sDescription
--  1171	    Failure to update tblBrand.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1171'
  and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate
--HAVING count(*) > 10
ORDER BY dtDate Desc

/************************************************************************/

-- tblBrand is populated by spUpdateBrand

select count(*) from tblBrand -- 439 @8-7-2013

select * from tblBrand where dtDateLastSOPUpdate is NULL

select * from tblBrand where dtDateLastSOPUpdate is NOT NULL

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblBrand
/*
DB          	Rows   	Date
SMI Reporting	480	02-01-15
SMI Reporting	471	12-01-14
SMI Reporting	463	07-01-14
SMI Reporting	455	01-01-14
SMI Reporting	438	08-01-13
SMI Reporting	367	01-01-13
SMI Reporting	311	03-01-12


*/




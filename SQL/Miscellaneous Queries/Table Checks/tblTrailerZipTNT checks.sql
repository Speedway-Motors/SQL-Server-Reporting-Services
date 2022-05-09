-- tblTrailerZipTNT checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblTrailerZipTNT%'

--  ixErrorCode	sDescription
--  NO ERROR CODE exists

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '####'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
dtDate	    ErrorQty

*/

/************************************************************************/

-- tblTrailerZipTNT is populated by sp..

select count(*) from tblTrailerZipTNT                    -- 210,927 @8-7-2013

select count(*) 'NULL update'  from tblTrailerZipTNT 
where dtDateLastSOPUpdate is NULL                       -- 210,927 @8-7-2013

select count(*) 'With updates' from tblTrailerZipTNT 
where dtDateLastSOPUpdate is NOT NULL                   -- 0 @8-7-2013








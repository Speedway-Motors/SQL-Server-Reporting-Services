-- tblOrderTiming checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblOrderTiming%'

--  ixErrorCode	sDescription
--  1152	    Failure to update tblOrderTiming.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1152'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
dtDate	    ErrorQty
2013-02-01  	5
2013-01-31  	1154
2012-09-07  	104
*/

/************************************************************************/

-- tblOrderTiming is populated by sp..

select count(*) from tblOrderTiming                    -- 791,044 @8-7-2013

select count(*) 'NULL update'  from tblOrderTiming 
where dtDateLastSOPUpdate is NULL                       -- 785,682 @8-7-2013

select count(*) 'With updates' from tblOrderTiming 
where dtDateLastSOPUpdate is NOT NULL                   -- 5,362 @8-7-2013








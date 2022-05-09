-- tblVendor checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblVendor%'
--  ixErrorCode	sDescription
--  1124	    Failure to update tblVendor.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1124'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc

/************************************************************************/

-- tblVendor is populated by spUpdateBOMTransferMaster

select count(*) from tblVendor -- 1,759 @8-7-2013

select count(*) from tblVendor where dtDateLastSOPUpdate is NULL -- 0 @8-7-2013

select count(*) from tblVendor where dtDateLastSOPUpdate is NOT NULL -- 1,759 @8-7-2013




-- tblEvent checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblEvent%'
--  ixErrorCode	sDescription
--  1144	    Failure to update tblEvent.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1144'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc

/************************************************************************/

-- tblEvent is populated by spUpdateBOMTransferMaster

select count(*) from tblEvent -- 10 @8-7-2013

select * from tblEvent where dtDateLastSOPUpdate is NULL -- 1 @8-7-2013

select * from tblEvent where dtDateLastSOPUpdate is NOT NULL




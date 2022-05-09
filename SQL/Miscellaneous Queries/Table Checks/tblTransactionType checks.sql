-- tblTransactionType checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblTransactionType%'
--  ixErrorCode	sDescription
--  1181	    Failure to update tblTransactionType.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1181'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc

/************************************************************************/

-- tblTransactionType is populated by spUpdateBOMTransferMaster

select count(*) from tblTransactionType -- 110 @8-7-2013

select * from tblTransactionType where dtDateLastSOPUpdate is NULL -- 1,501 @8-7-2013

select * from tblTransactionType where dtDateLastSOPUpdate is NOT NULL




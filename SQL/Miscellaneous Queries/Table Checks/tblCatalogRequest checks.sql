-- tblCatalogRequest checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblCatalogRequest%'

--  ixErrorCode	sDescription
--  1182	    Failure to update tblCatalogRequest.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1182'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc

/************************************************************************/

-- tblCatalogRequest is populated by sp..

select count(*) from tblCatalogRequest -- 412,682 @8-7-2013

select count(*)  from tblCatalogRequest where dtDateLastSOPUpdate is NULL -- 407,955 @8-7-2013

select count(*)  from tblCatalogRequest where dtDateLastSOPUpdate is NOT NULL -- 4,727 @8-7-2013








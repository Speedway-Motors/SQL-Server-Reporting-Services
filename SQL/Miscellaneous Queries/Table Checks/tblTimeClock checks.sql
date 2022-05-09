-- tblTimeClock checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblTimeClock%'
--  ixErrorCode	sDescription
--  1165	Failure to update tblTimeClock

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1165'
 -- and dtDate >=  DATEADD(month, -3, getdate()) -- past 3 months
GROUP BY dtDate
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
Date	    ErrorQty
2012-01-22 	65
2012-01-21 	210
2012-01-20 	659
*/


/************************************************************************/
select count(*) from tblTimeClock -- 187,979 @9-12-2013


select * from tblErrorLogMaster
where ixErrorCode = '1165'
--and dtDate >= '07/26/2013'
-- dtDateLastSOPUpdate = '07/19/2013'



/************** last updates    *************************/
select * from tblTimeClock 
where dtDateLastSOPUpdate = '08/26/2013'

  
select count(*)
from tblTimeClock -- 173997

select count(*) NULLcnt
from tblTimeClock
where sComment is NULL

select count(*) NotNULLcnt -- 21993 EXPECTED
from tblTimeClock
where sComment is NOT NULL



select *
from tblTimeClock
where sComment is NOT NULL
and len(sComment) > 254
order by len(sComment) desc
-- as of 9-12-13 it looks like only 10 comments got cut off after 255 chars

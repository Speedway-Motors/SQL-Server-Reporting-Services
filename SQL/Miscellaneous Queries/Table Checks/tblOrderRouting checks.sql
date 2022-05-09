-- tblOrderRouting checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblOrderRouting%'

--  ixErrorCode	sDescription
--  1150	    Failure to update tblOrderRouting.

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1150'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
dtDate	    ErrorQty
2014-01-08    	7
2013-02-01  	5
2013-01-31  	1154
2012-09-07  	104
2011-10-18  	1
*/

/************************************************************************/

-- tblOrderRouting is populated by sp..

select count(*) from tblOrderRouting                    -- 1,09,2047 @8-7-2013

select count(*) 'NULL update'  from tblOrderRouting 
where dtDateLastSOPUpdate is NULL                       -- 1,081,664 @8-7-2013



/********** REFEED "STALE" Order records ***********/

    -- TRUNCATE table [SMITemp].dbo.PJC_Orders_toRefeed
    insert into [SMITemp].dbo.PJC_Orders_toRefeed 
    select ixOrder -- count(*)   -- 11,961
    --into [SMITemp].dbo.PJC_Orders_toRefeed 
    from tblOrderRouting 
    where dtDateLastSOPUpdate < '01/29/2013'
       and ixTimeLastSOPUpdate < = 25000  
        --and flgDeletedFromSOP = 0

select * from [SMITemp].dbo.PJC_Orders_toRefeed

select RF.ixOrder, ORT.dtDateLastSOPUpdate, ORT.ixTimeLastSOPUpdate
from [SMITemp].dbo.PJC_Orders_toRefeed RF
    left join tblOrderRouting ORT on RF.ixOrder = ORT.ixOrder
order by ORT.dtDateLastSOPUpdate, ORT.ixTimeLastSOPUpdate
/*
DB  DateRefed   ixStart ixEnd   RECqty  Sec     rec/sec
SMI 03-04-14    45399   45652    1,597  132      12.1 
SMI 03-04-14    46190   49484   11,186  3284  103.7


*/




select * from vwDataFreshness where sTableName = 'tblOrderRouting'
order by DaysOld
/*
tblOrderRouting	    2,611	   <=1
tblOrderRouting	    9,552	   2-7
tblOrderRouting	   51,368	  8-30
tblOrderRouting	  143,857	 31-180
tblOrderRouting	   82,619	181 +
tblOrderRouting	1,081,549	UK
*/


select ixOrder from tblOrderRouting
where ixCommitmentDate >= 16836 -- 17,031 kicked off at 5:10 PM        UPDATING ABOUT 24K/Hour
    and dtDateLastSOPUpdate < '04/10/14'
    
    
16850	02/17/2014	MONDAY
16843	02/10/2014	MONDAY
16836	02/03/2014	MONDAY
16829	01/27/2014	MONDAY
16822	01/20/2014	MONDAY
16815	01/13/2014	MONDAY
16808	01/06/2014	MONDAY
-- kicked off at 36937


select getdate() -- 2014-04-10 10:16:07.467

select ixTime from tblTime where chTime = '10:15:37'    

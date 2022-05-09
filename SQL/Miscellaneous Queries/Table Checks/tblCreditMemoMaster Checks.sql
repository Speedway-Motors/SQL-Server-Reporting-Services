-- tblCreditMemoMaster Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblCreditMemoMaster%'
--  1147 = Failure to update tblCreditMemoMaster


-- ERROR COUNTS by Day
SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1147'
  and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 10
ORDER BY dtDate desc 
/*
DataBaseName	Date      	ErrorQty
SMI Reporting	10-21-19	1
SMI Reporting	04-12-19	161
SMI Reporting	04-11-19	240

AFCOReporting	04-12-19	6
AFCOReporting	04-11-19	7

************************************************************************/

-- Distinct list of Orders with erros
-- may want to append a list of the Order #'s from the OrderLine error code also (EC 1142)
select  *, -- sError,
   SUBSTRING(sError,13,8) 'ixCreditMemo'
  --  REPLACE(SUBSTRING(sError,7,10),' fa','') 'ixOrder-fixed'  -- VERIFY THERE ARE NO TRAILINGS SPACES 
from tblErrorLogMaster
where ixErrorCode = '1147'
  and dtDate >='11/16/2021'
order by sError  
/*
ixCredit    Last        TimeLast
Memo	    SOPUpdate	SOPUpdate
========    ==========  ==========
C-835468	2021-11-18 	52496
C-835469	2021-11-18 	52496
C-835470	2021-11-18 	52496
C-835471	2021-11-18 	52496
C-835473	2021-11-18 	52496
C-835474	2021-11-18 	52496
C-835475	2021-11-18 	52496
F-835472	2021-11-18 	52496
*/

SELECT ixCreditMemo, dtDateLastSOPUpdate, ixTimeLastSOPUpdate --'666351'
from tblCreditMemoMaster 
where ixCreditMemo in (-- could be hardcode list instead of subselect
                                select distinct 
                                    --sError,
                                   SUBSTRING(sError,13,8) 'ixCreditMemo'
                                from tblErrorLogMaster
                                where ixErrorCode = '1147'
                                  and dtDate >='11/18/2021'
                                ) 
order by  dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc 
            
SELECT * FROM tblTime where ixTime = 53398            

/********** REFEED "STALE" Order records ***********/


select * from vwDataFreshness where sTableName = 'tblCreditMemoMaster'
order by DaysOld
/*
sTableName	      Records	DaysOld
tblCreditMemoMaster	       55,678	   <=1
tblCreditMemoMaster	        7,098	   2-7
tblCreditMemoMaster	       38,021	  8-30
tblCreditMemoMaster	      330,044	 31-180
tblCreditMemoMaster	    5,858,788	181 +
tblCreditMemoMaster	            1	UK
*/


    -- TRUNCATE table [SMITemp].dbo.PJC_Orders_toRefeed
    insert into [SMITemp].dbo.PJC_Orders_toRefeed 
    select ixOrder -- count(*)   -- 11,961
    --into [SMITemp].dbo.PJC_Orders_toRefeed 
    from tblCreditMemoMaster 
    where dtDateLastSOPUpdate < '04/10/14'
       and ixCommitmentDate >= 16836
        --and flgDeletedFromSOP = 0

select * from [SMITemp].dbo.PJC_Orders_toRefeed

select RF.ixOrder, O.dtDateLastSOPUpdate, O.ixTimeLastSOPUpdate
from [SMITemp].dbo.PJC_Orders_toRefeed RF
    left join tblCreditMemoMaster O on RF.ixOrder = O.ixOrder
order by O.dtDateLastSOPUpdate, O.ixTimeLastSOPUpdate
/*
DB  DateRefed   ixStart ixEnd   RECqty  Sec     rec/sec
SMI 03-04-14    45399   45652    1,597  132      12.1 
SMI 03-04-14    46190   49484   11,186  3284  103.7


*/



select ixOrder from tblCreditMemoMasterRouting
where ixCommitmentDate >= 16836 -- 17,031 kicked off at 5:10 PM
    and dtDateLastSOPUpdate < '04/10/14'


select sShipToEmailAddress, COUNT(*)
from tblCreditMemoMaster
group by sShipToEmailAddress


select ixOrderDate, COUNT(*) 
from [AFCOReporting].dbo.tblCreditMemoMaster -- 292,983
where ixOrderDate >= 17670
group by ixOrderDate
order by ixOrderDate

select COUNT(*) from tblCreditMemoMaster where ixOrderDate > 17339 --17533  20547

select COUNT(*) from tblCreditMemoMaster where dtDateLastSOPUpdate = '06/20/2016' and ixTimeLastSOPUpdate > 37800 -- 10:30AM   411


select COUNT(*) from tblCreditMemoMasterLine where dtDateLastSOPUpdate = '06/20/2016' and ixTimeLastSOPUpdate > 37800 -- 10:30AM   2624

select * from tblTime where chTime like '10:30:00%'


select dtDateLastSOPUpdate, COUNT(*) OrdersRefed
from tblCreditMemoMaster
group by dtDateLastSOPUpdate
order by dtDateLastSOPUpdate desc

select COUNT(*) from tblCreditMemoMaster 
where sOrderStatus = 'Shipped' 
and dtShippedDate > '06/15/2012' -- 279,36-   155+ 


select O.ixCustomer, COUNT(*)
from tblCreditMemoMaster O
--join tblDate D on O.ixShippedDate = D.ixDate
where dtDateLastSOPUpdate >= '01/01/2020'
group by O.ixCustomer
order by  COUNT(*) DESC








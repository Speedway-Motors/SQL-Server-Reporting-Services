-- tblOrder Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblOrder%'
--  ixErrorCode	1141 = Failure to update tblOrder


-- ERROR COUNTS by Day
SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1141'
  and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 10
ORDER BY dtDate desc 
/*
DataBaseName	Date      	ErrorQty
SMI Reporting	01-28-20	3       -- connie fixed

SMI Reporting	05-20-19	1
SMI Reporting	05-16-19	2
SMI Reporting	04-03-19	1
SMI Reporting	04-02-19	1
SMI Reporting	02-27-19	2
SMI Reporting	02-26-19	709


AFCOReporting	04-19-19	456
AFCOReporting	04-12-19	1543
AFCOReporting	04-11-19	1744
AFCOReporting	04-02-19	1

AFCOReporting	08-06-18	1
AFCOReporting	08-05-18	1
AFCOReporting	08-04-18	1
AFCOReporting	08-03-18	26
AFCOReporting	08-02-18	27
AFCOReporting	08-01-18	30
AFCOReporting	07-31-18	22
AFCOReporting	07-30-18	2
AFCOReporting	04-25-18	6


************************************************************************/

-- Distinct list of Orders with erros
-- may want to append a list of the Order #'s from the OrderLine error code also (EC 1142)
select distinct 
    sError,
    SUBSTRING(sError,7,9) 'ixOrder',
    REPLACE(SUBSTRING(sError,7,10),' fa','') 'ixOrder-fixed'  -- VERIFY THERE ARE NO TRAILINGS SPACES 
from tblErrorLogMaster
where ixErrorCode = '1141'
  and dtDate >='01/01/2020'
order by sError  

SELECT ixOrder, sOrderStatus, dtShippedDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate --'666351'
from tblOrder where ixOrder in (-- could be hardcode list instead of subselect
                                select distinct 
                                    --sError,
                                   REPLACE(SUBSTRING(sError,7,10),' fa','') collate SQL_Latin1_General_CP1_CS_AS as 'ixOrder'
                                from tblErrorLogMaster
                                where ixErrorCode = '1141'
                                  and dtDate >='01/01/2016'
                                ) 
order by  dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc 
            
            
/********** REFEED "STALE" Order records ***********/


select * from vwDataFreshness where sTableName = 'tblOrder'
order by DaysOld
/*
sTableName	      Records	DaysOld
tblOrder	       55,678	   <=1
tblOrder	        7,098	   2-7
tblOrder	       38,021	  8-30
tblOrder	      330,044	 31-180
tblOrder	    5,858,788	181 +
tblOrder	            1	UK
*/


    -- TRUNCATE table [SMITemp].dbo.PJC_Orders_toRefeed
    insert into [SMITemp].dbo.PJC_Orders_toRefeed 
    select ixOrder -- count(*)   -- 11,961
    --into [SMITemp].dbo.PJC_Orders_toRefeed 
    from tblOrder 
    where dtDateLastSOPUpdate < '04/10/14'
       and ixCommitmentDate >= 16836
        --and flgDeletedFromSOP = 0

select * from [SMITemp].dbo.PJC_Orders_toRefeed

select RF.ixOrder, O.dtDateLastSOPUpdate, O.ixTimeLastSOPUpdate
from [SMITemp].dbo.PJC_Orders_toRefeed RF
    left join tblOrder O on RF.ixOrder = O.ixOrder
order by O.dtDateLastSOPUpdate, O.ixTimeLastSOPUpdate
/*
DB  DateRefed   ixStart ixEnd   RECqty  Sec     rec/sec
SMI 03-04-14    45399   45652    1,597  132      12.1 
SMI 03-04-14    46190   49484   11,186  3284  103.7


*/



select ixOrder from tblOrderRouting
where ixCommitmentDate >= 16836 -- 17,031 kicked off at 5:10 PM
    and dtDateLastSOPUpdate < '04/10/14'


select sShipToEmailAddress, COUNT(*)
from tblOrder
group by sShipToEmailAddress


select ixOrderDate, COUNT(*) 
from [AFCOReporting].dbo.tblOrder -- 292,983
where ixOrderDate >= 17670
group by ixOrderDate
order by ixOrderDate

select COUNT(*) from tblOrder where ixOrderDate > 17339 --17533  20547

select COUNT(*) from tblOrder where dtDateLastSOPUpdate = '06/20/2016' and ixTimeLastSOPUpdate > 37800 -- 10:30AM   411


select COUNT(*) from tblOrderLine where dtDateLastSOPUpdate = '06/20/2016' and ixTimeLastSOPUpdate > 37800 -- 10:30AM   2624

select * from tblTime where chTime like '10:30:00%'


select dtDateLastSOPUpdate, COUNT(*) OrdersRefed
from tblOrder
group by dtDateLastSOPUpdate
order by dtDateLastSOPUpdate desc

select COUNT(*) from tblOrder 
where sOrderStatus = 'Shipped' 
and dtShippedDate > '06/15/2012' -- 279,36-   155+ 


select O.ixCustomer, COUNT(*)
from tblOrder O
--join tblDate D on O.ixShippedDate = D.ixDate
where dtDateLastSOPUpdate >= '06/19/2016'
group by O.ixCustomer
order by  COUNT(*) DESC



SELECT top 50 mMerchandise, ixOrder, dtOrderDate
from tblOrder
where mMerchandise > 84000 --dtOrderDate >= '01/01/2018'
order by dtOrderDate  desc --mMerchandise desc



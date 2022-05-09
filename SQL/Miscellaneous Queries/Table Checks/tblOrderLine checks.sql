-- tblOrderLine Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblOrderLine%'
--  ixErrorCode	sDescription
--  1142	    Failure to update tblOrderLine

-- ERROR COUNTS by Day
SELECT dtDate
    ,DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1142'
  and dtDate >=  DATEADD(dd, -40, getdate())  -- past X days
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 3
ORDER BY dtDate Desc
/*
DataBaseName	Date      	ErrorQty
SMI Reporting	04-09-18	1
SMI Reporting	04-08-18	1
SMI Reporting	04-07-18	1
SMI Reporting	04-06-18	2
SMI Reporting	05-27-15	2610
SMI Reporting	05-26-15	5
SMI Reporting	12-11-14	95      <-- ALL OF THE ERRORS from 10/25/14 to 12/11/14 are from orders with dtOrderDate FEB 2014 OR OLDER.  Whatever the issue is appears to be resolved.
SMI Reporting	12-10-14	43
SMI Reporting	12-09-14	38
SMI Reporting	12-05-14	12
SMI Reporting	12-01-14	18
SMI Reporting	11-26-14	19          
SMI Reporting	11-24-14	145
SMI Reporting	11-21-14	14
SMI Reporting	11-20-14	24      
SMI Reporting	11-13-14	27
SMI Reporting	11-11-14	4
SMI Reporting	11-10-14	4
SMI Reporting	11-07-14	10
SMI Reporting	11-05-14	5
SMI Reporting	11-03-14	8
SMI Reporting	10-31-14	16
SMI Reporting	10-29-14	12
SMI Reporting	10-28-14	10
SMI Reporting	10-27-14	12
SMI Reporting	02-09-14	5
SMI Reporting	02-08-14	8
SMI Reporting	02-06-14	11
SMI Reporting	01-31-14	4
SMI Reporting	01-20-14	4
SMI Reporting	01-18-14	4
SMI Reporting	01-15-14	8

AFCOReporting	05-27-15	510
AFCOReporting	04-08-15	10
AFCOReporting	05-07-15	1


************************************************************************/
exec spGetTableGrowth tblOrderLine
/*
SMI Reporting	tblOrderLine	26,362,572	11-01-19

SMI Reporting	tblOrderLine	24,334,817	01-01-19
SMI Reporting	tblOrderLine	21,795,216	01-01-18
SMI Reporting	tblOrderLine	19,436,038	01-01-17
SMI Reporting	tblOrderLine	17,100,526	01-01-16
SMI Reporting	tblOrderLine	14,880,358	01-01-15
SMI Reporting	tblOrderLine	12,732,382	01-01-14
SMI Reporting	tblOrderLine	10,859,796	01-01-13
SMI Reporting	tblOrderLine	 8,976,441	03-01-12


AFCOReporting	tblOrderLine	1,709,448	11-01-19

AFCOReporting	tblOrderLine	1,575,954	01-01-19
AFCOReporting	tblOrderLine	1,360,821	01-01-18
AFCOReporting	tblOrderLine	1,141,956	01-01-17
AFCOReporting	tblOrderLine	   914,638	01-01-16
AFCOReporting	tblOrderLine	   835,273	01-01-15
AFCOReporting	tblOrderLine	   684,058	01-01-14
AFCOReporting	tblOrderLine	   660,329	10-01-13
*/

select * from tblTableSizeLog
where sTableName = 'tblOrder'
order by dtDate Desc

SELECT *
FROM tblErrorLogMaster
WHERE ixErrorCode = '1142'
  and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
  
  
-- Distinct list of Orders with erros
select  --sError,
    DISTINCT REPLACE (SUBSTRING(sError,7,9),',','') 'ixOrder'
from tblErrorLogMaster
where ixErrorCode = '1142'
  and dtDate >=  DATEADD(day, -35, getdate())  -- past X months          dtDate >='01/18/14'
order by REPLACE (SUBSTRING(sError,7,9),',','')  

/*
Order 3792148, SKU:465621513, 3	3792148, SKU:46
Order 3792148, SKU:91017093-1, 2	3792148, SKU:91
*/

select * from tblOrderLine where ixOrder = '4605937'

select ixOrder, count(*) OLCount from tblOrderLine where ixOrder in (select  --sError,
                                                                DISTINCT REPLACE (SUBSTRING(sError,7,9),',','') 'ixOrder'
                                                            from tblErrorLogMaster
                                                            where ixErrorCode = '1142'
                                                              and dtDate >=  DATEADD(month, -1, getdate())  -- past X months          dtDate >='01/18/14'
                                                            --order by REPLACE (SUBSTRING(sError,7,9),',','')  
                                                            )
group by ixOrder                                                            

SELECT ixOrder, flgLineStatus, iOrdinality, dtOrderDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblOrderLine where ixOrder in (-- could be hardcode list instead of subselect
                                select  --sError,
                                    DISTINCT REPLACE (SUBSTRING(sError,7,9),',','') 'ixOrder'
                                from tblErrorLogMaster
                                where ixErrorCode = '1142'
                                  and dtDate >=  DATEADD(month, -11, getdate())  -- past X months          dtDate >='01/18/14'
                               )
order by dtOrderDate
    -- dtDateLastSOPUpdate, ixTimeLastSOPUpdate desc 
            
-- SEE WHAT iOrdinality numbers are missing (if any) in each order            
SELECT ixOrder, iOrdinality--, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblOrderLine where ixOrder in (-- could be hardcode list instead of subselect
                                    select  REPLACE (SUBSTRING(sError,7,9),',','') 'ixOrder'
                                    from tblErrorLogMaster
                                    where ixErrorCode = '1142'
                                      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months          dtDate >='01/18/14'
                                   -- order by REPLACE (SUBSTRING(sError,7,9),',','')  
                                )
order by  ixOrder, iOrdinality       
/*
ixOrder	iOrdinality
2546428	1
2546428	2
2546428	3
2546428	6
*/
                        

-- 468 rows b4 refeed
      
-- count of Line Items <> max Ordinality
/*  
    THIS APPEARS TO BE A NON-ISSUE.
    Talked with CCC on 7-26-13 and it has something to do with Kit SKUs. Apparently the ordinality counts 
    the kit components but not for the kits themselves (or some situation simlar too that).  
    This not causing any problems that we know of.
*/    
select ixOrder, dtOrderDate,  
    count(*) CountRows,
    max(iOrdinality) MaxOrd,
    abs(count(*) - max(iOrdinality)) Delta
from tblOrderLine
where dtOrderDate >= '01/01/2012'
group by ixOrder, dtOrderDate
having count(*) <> max(iOrdinality)
order by 
    Delta desc
    --dtOrderDate desc




select * from tblOrderLine where ixOrder = '4851171'
    
  
  
select ixOrder, flgLineStatus, dtShippedDate, iOrdinality
from tblOrderLine
where ixOrder in ('4895185','4053887')
order by ixOrder, iOrdinality
/*
ixOrder	flgLineStatus	dtShippedDate	iOrdinality
4053887	Shipped	2012-07-27 00:00:00.000	1
4053887	Shipped	2012-07-27 00:00:00.000	2
4053887	Shipped	2012-07-27 00:00:00.000	3
4053887	Shipped	2012-07-27 00:00:00.000	4
4053887	Shipped	2012-07-27 00:00:00.000	5
4053887	Shipped	2012-07-27 00:00:00.000	6
4053887	Shipped	2012-07-27 00:00:00.000	11
4895185	Shipped	2012-09-27 00:00:00.000	1
4895185	Shipped	2012-09-27 00:00:00.000	5
4895185	Shipped	2012-09-27 00:00:00.000	9
4895185	Shipped	2012-09-27 00:00:00.000	10
4895185	Shipped	2012-09-27 00:00:00.000	11
*/


-- MANUALLY CALL UPADATE PROC
EXEC spUpdateOrderLine 
    (
	   '',         --@ixOrder varchar(10),
	   '',         --@ixCustomer varchar(10),
	   '',         --@ixSKU varchar(30),
	   ,         --@ixShippedDate smallint,
	   ,         --@ixOrderDate smallint,
	   ,         --@iQuantity smallint,
	   ,         --@mUnitPrice money,
	   ,         --@mExtendedPrice money,
	   '',         --@flgLineStatus varchar(12),
	            --@dtOrderDate datetime,
	            --@dtShippedDate datetime,
	   ,         --@mCost money,
	   ,         --@mExtendedCost money,
	   ,         --@flgKitComponent tinyint,
	   ,         --@iOrdinality smallint,
	   ,         --@iKitOrdinality smallint,
	   ,         --@ixPrintedDate int,
	   ,         --@ixPrintedTime int,
	   ,         --@mSystemUnitPrice money,
	   ,         --@mExtendedSystemPrice money,
	   '',         --@ixPriceDevianceReasonCode varchar(10),
	   '',         --@sPriceDevianceReason varchar(100),
	   '',         --@ixPicker varchar(10) 
	   )

select distinct sError from tblErrorLogMaster
where ixErrorCode = 1142
and ixDate >= 18895	-- 2019-09-24 
order by sError

select ixSKU, 
dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU
where ixSKU in ('1012442901','582ASB401','7022850C','7214673','72556155PCZ','91015338','91032104','91034307','9103834-57','91510302F','91602831','91631948-1','91633-999 ','91634052','91636-999','91645129')

Order 6452386-1, SKU:72556155PCZ, 1 [U2][SQL Client]An illegal SQL data type was supplied
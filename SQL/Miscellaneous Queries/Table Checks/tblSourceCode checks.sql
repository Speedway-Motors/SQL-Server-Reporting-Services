-- tblSourceCode checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblSource%'
--ixErrorCode	sDescription	                    ixErrorType
--1180	        Failure to update tblSourceCode.	SQLDB

-- ERROR COUNTS by Day
SELECT  DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
    ,dtDate
FROM tblErrorLogMaster
WHERE ixErrorCode = '1180'
  and dtDate >=  DATEADD(month, -24, getdate())  -- past 3 months
GROUP BY CONVERT(VARCHAR(10), dtDate, 101), dtDate  
--HAVING count(*) > 10
ORDER BY dtDate  Desc
/*
SMI Reporting	04/05/2016	12	
SMI Reporting	04/01/2016	1	
SMI Reporting	10/19/2015	4
SMI Reporting	09/09/2015	4
SMI Reporting	05/13/2015	9	
SMI Reporting	03/02/2015	1


DB          	Date    	ErrorQty
AFCOReporting	04/26/2016	1
AFCOReporting	04/25/2016	40

*/

SELECT * 
FROM tblErrorLogMaster
WHERE ixErrorCode = '1180'
ORDER BY dtDate desc
/************************************************************************/
SELECT  count(sError) Errors, count (distinct(sError)) DtnctError             -- 2279 errors for 17 unique source codes
FROM tblErrorLogMaster
WHERE ixErrorCode = '1180'
  and dtDate >= '05/08/2015'
--order by ixDate desc, ixTime desc  
/*
Errors	DtnctError
3486	21
*/
  
  
-- Distinct list of Source Codes with erros
-- may want to append a list of the Order #'s from the BOMTransferDetail error code also (EC 1159)

-- DROP TABLE [SMITemp].dbo.PJC_SourceCodes_toRefeed  
-- TRUNCATE table [SMITemp].dbo.PJC_SourceCodes_toRefeed   
INSERT INTO [SMITemp].dbo.PJC_SourceCodes_toRefeed 
select count(*) ErrorCnt, 
    (replace(substring(sError,13,99),' failed to update','')) as 'ixSourceCode'
    , sError
--INTO [SMITemp].dbo.PJC_SourceCodes_toRefeed     
from tblErrorLogMaster
where ixErrorCode = '1180'
  and dtDate >= '04/01/2016'
group by   sError, 
    (replace(substring(sError,13,99),' failed to update','')) 
order by count(*) desc 
/*    ix
Error Source
Cnt	  Code	sError
==== ====== ==========================================
1572 AFAB15	Source code AFAB15 failed to update
560	PRO15	Source code PRO15 failed to update
43	AFAB	Source code AFAB failed to update
20	TN1415	Source code TN1415 failed to update
12	AFAB14	Source code AFAB14 failed to update
6	34897	Source code 34897 failed to update
6	TURN14	Source code TURN14 failed to update
6	UK	    Source code UK failed to update
6	PRO513	Source code PRO513 failed to update
6	PROSMI	Source code PROSMI failed to update
6	SMI11	Source code SMI11 failed to update
6	AFAB11	Source code AFAB11 failed to update
6	AFAB12	Source code AFAB12 failed to update
6	AFAB13	Source code AFAB13 failed to update
6	LANETEMP Source code LANETEMP failed to update
6	PRO13	Source code PRO13 failed to update
6	PRO14	Source code PRO14 failed to update

*/

        (CASE when sError like '%*47 failed to update' then replace(substring(sError,5,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,5,200),'*99 failed to update','')
              else replace(substring(sError,5,200),' failed to update','')
              end
              )'ixSKU'

select * from [SMITemp].dbo.PJC_SourceCodes_toRefeed

-- latest updates of problem records
SELECT SC.* --SCRF.ixTransferNumber, ixCreateDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate-- '666351'
from [SMITemp].dbo.PJC_SourceCodes_toRefeed SCRF
    join tblSourceCode SC on SCRF.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS = SC.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS
order by  dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc 

DELETE FROM [SMITemp].dbo.PJC_SourceCodes_toRefeed
WHERE ixTransferNumber in ('39640-1','40199-1','40328-1','40335-1','41486-1',
'41488-1','41489-1','41491-1','41674-1','41682-1',
'39206-1','39466-1','39593-1')


-- tblSourceCode is populated by spUpdateBOMTransferMaster

select count(*) from tblSourceCode -- 74 @ 8-24-2015  AFCO


select * from tblSourceCode 
where dtDateLastSOPUpdate < '08/24/2015' -- 
order by ixSourceCode

select * from tblSourceCode 
where ixTransferNumber = '147941-1'

select * from tblTime where ixTime = 36084

select * from tblSourceCode where dtDateLastSOPUpdate is NOT NULL --41,717 @8-9-2013

select top 10 * from tblSourceCode



select * from tblSourceCode where ixTransferNumber = '143106-1'

select * FROM tblErrorLogMaster
WHERE ixErrorCode = '1180' 
order by dtDate desc


select top 3 *-- ixTransferNumber, count(*)
from tblSourceCode
--where iQuantity > 14000
order by iQuantity desc



change datatype of 4 fields in tblSourceCode from smallint to 


iQuantity
iCompletedQuantity
iOpenQuantity
iReleasedQuantity



xSourceCode AFAB16
ixStartDate 17473
ixEndDate 17898
ixCatalog AFAB16
sDescription AFAB 2016 CUSTOMERS
sCatalogMarket M
dtStartDate 11/02/15
dtEndDate 12/31/16
iQuantityPrinted 1
ixMostSimilarSourceCode AFAB15
iExpectedNumberOfOrders 5000
dExpectedAverageOrderSize 1000.00
dExpectedAverageMargin 40.00
sSourceCodeType CAT-H

ixSourceCode PRO16
ixStartDate 17473
ixEndDate 17898
ixCatalog PRO16
sDescription PRO-FORMANCE SHOCKS 2016 CUSTOMERS
sCatalogMarket M
dtStartDate 11/02/15
dtEndDate 12/31/16
iQuantityPrinted 1
ixMostSimilarSourceCode PRO15
iExpectedNumberOfOrders 5000
dExpectedAverageOrderSize 1000.00
dExpectedAverageMargin 40.00
sSourceCodeType CAT-H

ixSourceCode MS2016
ixStartDate 17473
ixEndDate 17898
ixCatalog MS2016
sDescription MOTOR STATE 2016
sCatalogMarket M
dtStartDate 11/02/15
dtEndDate 12/31/16
iQuantityPrinted 1
ixMostSimilarSourceCode AFAB16
iExpectedNumberOfOrders 10000
dExpectedAverageOrderSize 1000.00
dExpectedAverageMargin 40.00
sSourceCodeType CAT-H

ixSourceCode CSI2016
ixStartDate 17473
ixEndDate 17898
ixCatalog CSI2016
sDescription CSI PRICING 2014
sCatalogMarket M
dtStartDate 11/02/15
dtEndDate 12/31/16
iQuantityPrinted 1
ixMostSimilarSourceCode REB16
iExpectedNumberOfOrders 500
dExpectedAverageOrderSize 1000.00
dExpectedAverageMargin 40.00
sSourceCodeType CAT-H

ixSourceCode AFAB
ixStartDate 15282
ixEndDate 15706
ixCatalog AFAB10
sDescription AFAB CUSTOMER
sCatalogMarket R
dtStartDate 11/02/09
dtEndDate 12/31/10
iQuantityPrinted 1
ixMostSimilarSourceCode
iExpectedNumberOfOrders 5000
dExpectedAverageOrderSize 1000.00
dExpectedAverageMargin 40.00
sSourceCodeType CAT-H

select *-- ixTransferNumber, count(*)
from tblSourceCode
where ixSourceCode in ('AFAB','CSI2016','PRO16','MS2016','AFAB16')







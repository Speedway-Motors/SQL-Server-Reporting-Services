-- tblKit checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblKit%'
--ixErrorCode	sDescription	                    ixErrorType
--1175	        Failure to update tblKit.	SQLDB

-- ERROR COUNTS by Day
SELECT  DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
    ,dtDate
FROM tblErrorLogMaster
WHERE ixErrorCode = '1175'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY CONVERT(VARCHAR(10), dtDate, 101), dtDate  
--HAVING count(*) > 10
ORDER BY dtDate  Desc
/*
DB          	Date    	ErrorQty
AFCOReporting	05/12/2015	50
AFCOReporting	05/11/2015	33
AFCOReporting	05/08/2015	21

SMI Reporting	03/02/2015	1

*/


/************************************************************************/
SELECT  *               
FROM tblErrorLogMaster
WHERE ixErrorCode = '1175'
  and dtDate >= '05/08/2015'
order by ixDate desc, ixTime desc  
  

-- Kit SKU has been deleted
SELECT distinct ixKitSKU
from tblKit 
where ixKitSKU in (select ixSKU from tblSKU where flgDeletedFromSOP = 1)

-- in tblKit but SKU is not flagged as a Kit
select ixSKU, flgIsKit
from tblSKU
where ixSKU in (select ixKitSKU from tblKit)
order by flgIsKit

-- flagged as a kit in tblSKU but doesn't exist in tblKit
select distinct ixKitSKU 
from tblKit
where ixKitSKU in (select ixSKU from tblSKU where flgIsKit = 0)

-- REFEED ALL KITS (approx 30 mins for SMI)
SELECT * from tblKit 
--where ixKitSKU not in ('91048309.GS','91048309.GS1','91606084','9103145')
order by dtDateLastSOPUpdate


select *
into [SMIArchive].dbo.BU_tblKit_20201007
from tblKit

-- DELETE 
FROM tblKit
where ixKitSKU in ('1660SPB','3700-1','FE107R','TEST','52-72537','52-72852','52-72675','52-72965')


-- DROP TABLE [SMITemp].dbo.PJC_SourceCodes_toRefeed  
-- TRUNCATE table [SMITemp].dbo.PJC_SourceCodes_toRefeed   
INSERT INTO [SMITemp].dbo.PJC_SourceCodes_toRefeed 
select count(*) ErrorCnt, 
    --sError,
    (replace(substring(sError,13,99),' failed to update','')) as 'ixSourceCode'
from tblErrorLogMaster
where ixErrorCode = '1175'
  and dtDate >= '05/08/2015'
group by   sError, 
    (replace(substring(sError,13,99),' failed to update','')) 
--order by sError  

        (CASE when sError like '%*47 failed to update' then replace(substring(sError,5,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,5,200),'*99 failed to update','')
              else replace(substring(sError,5,200),' failed to update','')
              end
              )'ixSKU'

select * from [SMITemp].dbo.PJC_SourceCodes_toRefeed

-- latest updates of problem records
SELECT BOMRF.ixTransferNumber, ixCreateDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate-- '666351'
from [SMITemp].dbo.PJC_SourceCodes_toRefeed BOMRF
    left join tblKit BTM on BOMRF.ixTransferNumber = BTM.ixTransferNumber
order by  dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc 

DELETE FROM [SMITemp].dbo.PJC_SourceCodes_toRefeed
WHERE ixTransferNumber in ('39640-1','40199-1','40328-1','40335-1','41486-1',
'41488-1','41489-1','41491-1','41674-1','41682-1',
'39206-1','39466-1','39593-1')


-- tblKit is populated by spUpdateBOMTransferMaster

select count(*) from tblKit -- 41,717 @8-9-2013


select * from tblKit where dtDateLastSOPUpdate is NULL -- 0 @8-9-2013

select * from tblKit 
where ixTransferNumber = '147941-1'

select * from tblTime where ixTime = 36084

select * from tblKit where dtDateLastSOPUpdate is NOT NULL --41,717 @8-9-2013

select top 10 * from tblKit



select * from tblKit where ixTransferNumber = '143106-1'

select * FROM tblErrorLogMaster
WHERE ixErrorCode = '1175' 
order by dtDate desc


select top 3 *-- ixTransferNumber, count(*)
from tblKit
--where iQuantity > 14000
order by iQuantity desc


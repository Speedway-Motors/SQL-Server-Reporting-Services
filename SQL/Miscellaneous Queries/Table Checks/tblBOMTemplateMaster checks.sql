-- tblBOMTemplateMaster Checks

/**************** ERROR CODES & ERROR LOG history ***********************/
select * from tblErrorCode where sDescription like '%tblBOMTemplate%'
--  ixErrorCode	sDescription
--  1170	    Failure to update tblBOMTemplateMaster.	
--  1169	    Failure to update tblBOMTemplateDetail.	

-- ERROR COUNTS by Day
    SELECT dtDate, DB_NAME() AS 'DB          '
        ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1170'
      and dtDate >=  DATEADD(month, -24, getdate())  -- past X months
    GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc
/*
DB          	Date    	ErrorQty
SMI Reporting	04/03/2018	21          -- refed all without issue
SMI Reporting	04/29/2016	104
SMI Reporting	04/13/2016	1419
SMI Reporting	07/11/2014	56
SMI Reporting	07/09/2014	14
SMI Reporting	07/07/2014	2
SMI Reporting	06/27/2014	2
SMI Reporting	06/26/2014	30
SMI Reporting	06/23/2014	18
SMI Reporting	06/17/2014	39
SMI Reporting	06/13/2014	25
SMI Reporting	06/09/2014	10

2016-04-13 00:00:00.000	AFCOReporting	04/13/2016	6
*/
-- REFED EVERY BOM THAT FAILED BETWEEN 6-2-13 AND 1-28-14... ALL updated successfully

/**************** DATA FRESHNESS ******************************/
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), getdate(), 101) AS 'Date    '
    ,sTableName AS 'TableName           '
    ,Records
    ,DaysOld
FROM vwDataFreshness where sTableName = 'tblBOMTemplateMaster'
ORDER BY DaysOld

/*
DB          	Date    	TableName           	Records	DaysOld
AFCOReporting	10/26/2015	tblBOMTemplateDetail	337	    <=1
AFCOReporting	10/26/2015	tblBOMTemplateDetail	299	    2-7
AFCOReporting	10/26/2015	tblBOMTemplateDetail	2425	8-30
AFCOReporting	10/26/2015	tblBOMTemplateDetail	23660	31-180
AFCOReporting	10/26/2015	tblBOMTemplateDetail	265921	181 +

DB          	Date    	TableName           	Records	DaysOld
SMI Reporting	04/16/2018	tblBOMTemplateMaster	33	   <=1
SMI Reporting	04/16/2018	tblBOMTemplateMaster	55	   2-7
SMI Reporting	04/16/2018	tblBOMTemplateMaster	11,415	  8-30
*/


/**************** PROCEDURE LOG history ***********************/
    select -- *
        LogDate, ProcedureName, ErrorLine, ErrorMessage, Field1, Value1, Field2, Value2, Field3, Value3, Field4, Value4, Field5, Value5
    from [ErrorLogging].dbo.ProcedureLog
    where ProcedureName like '%BOMTemplate%'
     and LogDate >=DATEADD(dd,-10,DATEDIFF(dd,0,getdate())) -- begginng of Today
    order by 
    LogDate desc

/************************************************************************/

-- TABLE GROWTH
exec spGetTableGrowth tblBOMTemplateDetail
/*
DB          	TABLE       	        Rows   	Date
=============   
AFCOReporting	tblBOMTemplateDetail	293,242	10-01-15
AFCOReporting	tblBOMTemplateDetail	289,786	07-01-15
AFCOReporting	tblBOMTemplateDetail	282,933	04-01-15
AFCOReporting	tblBOMTemplateDetail	276,016	01-01-15
AFCOReporting	tblBOMTemplateDetail	268,863	07-01-14
AFCOReporting	tblBOMTemplateDetail	251,900	01-01-14
AFCOReporting	tblBOMTemplateDetail	246,148	10-01-13

DB          	TABLE                   Rows   	Date
SMI Reporting	tblBOMTemplateDetail	27,422	10-01-15
SMI Reporting	tblBOMTemplateDetail	26,058	07-01-15
SMI Reporting	tblBOMTemplateDetail	22,828	01-01-15
SMI Reporting	tblBOMTemplateDetail	18,534	01-01-14
SMI Reporting	tblBOMTemplateDetail	14,151	01-01-13
SMI Reporting	tblBOMTemplateDetail	12,941	03-01-12
*/


/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select count(*)  -- X total errors          
    from tblErrorLogMaster
    where ixErrorCode = 1170   
        and dtDate >=  DATEADD(month, -1, getdate()) -- past X months


-- 2) EXTRACT SKUS from the sError field                                    
    -- 68 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_SKUs_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_SKUs_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*47 failed to update' then replace(substring(sError,21,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,21,200),'*99 failed to update','')
              else replace(substring(sError,21,200),' failed to update','')
              end
              )'ixSKU'
    from tblErrorLogMaster
    where  dtDate >= '01/27/2014'
        --dtDate >=  DATEADD(month, -1, getdate()) -- past X months
        and 
        ixErrorCode = 1169    
    order by 'ixSKU' 
 
    
    -- HOW MANY EXIST IN tblSKU ?
    select * from tblSKU SKU -- 35 out of 35
    join [SMITemp].dbo.PJC_SKUs_toRefeed RF on SKU.ixSKU = RF.ixSKU
    
    
    -- BEFORE Reefeeding
     SELECT RF.ixSKU, 
        (CASE when TM.ixFinishedSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblBOMTemplateMaster',
         CONVERT(VARCHAR, TM.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         TM.ixTimeLastSOPUpdate,  TM.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblBOMTemplateMaster TM on RF.ixSKU = TM.ixFinishedSKU
    ORDER BY 'In_tblBOMTemplateMaster',TM.dtDateLastSOPUpdate,TM.ixTimeLastSOPUpdate  
       
      
    /*
    ixSKU	In_tblBOMTemplateMaster	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
    634-1334	NO	NULL	NULL	NULL
    634-1721	NO	NULL	NULL	NULL
    634-41733	NO	NULL	NULL	NULL
    634-41773	NO	NULL	NULL	NULL
    634-41783	NO	NULL	NULL	NULL
    634-63506	NO	NULL	NULL	NULL
    ... etc. 
 
    */

    
-- 3) REFEED these SKUs from SOP
    select distinct ixSKU from [SMITemp].dbo.PJC_SKUs_toRefeed    

    select ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
     SELECT RF.ixSKU, 
        (CASE when TM.ixFinishedSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblBOMTemplateMaster',
         CONVERT(VARCHAR, TM.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         TM.ixTimeLastSOPUpdate,  TM.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblBOMTemplateMaster TM on RF.ixSKU = TM.ixFinishedSKU
    ORDER BY 'In_tblBOMTemplateMaster',TM.dtDateLastSOPUpdate,TM.ixTimeLastSOPUpdate  


/*******   DONE   **********************/


select ixSKU, dtCreateDate, ixCreator
from tblSKU where ixSKU in ('1353298.1','1353298.2','1353298.L','7154290.1','7154290.1.1','7154290.2','7154290.2.1','91035700.1-RH','91035700.1.1.1','91035700.1.1.2',
                            '91035700.1.1.3','91035700.1.2-LH','91035700.1.3-LH','91035700.1.4-LH','91035700.10','91035700.2','91035700.2.1','91035700.2.2','91035700.2.3',
                            '91035700.2.4','91035700.2.5','91035700.3.1','91035700.3.2','91035700.3.3','91035700.4-LH','91035700.4-RH','91035700.4.1-LH','91035700.4.1-RH','91035700.4.2',
                            '91035700.5','91035700.6','91035700.7','91035700.8-LH','91035700.8-RH','91035700.9')
select * 
from tblBOMTemplateMaster where ixFinishedSKU in ('1353298.1','1353298.2','1353298.L','7154290.1','7154290.1.1','7154290.2','7154290.2.1','91035700.1-RH','91035700.1.1.1','91035700.1.1.2',
                            '91035700.1.1.3','91035700.1.2-LH','91035700.1.3-LH','91035700.1.4-LH','91035700.10','91035700.2','91035700.2.1','91035700.2.2','91035700.2.3',
                            '91035700.2.4','91035700.2.5','91035700.3.1','91035700.3.2','91035700.3.3','91035700.4-LH','91035700.4-RH','91035700.4.1-LH','91035700.4.1-RH','91035700.4.2',
                            '91035700.5','91035700.6','91035700.7','91035700.8-LH','91035700.8-RH','91035700.9')
select * 
from tblBOMTemplateDetail where ixFinishedSKU in ('1353298.1','1353298.2','1353298.L','7154290.1','7154290.1.1','7154290.2','7154290.2.1','91035700.1-RH','91035700.1.1.1','91035700.1.1.2',
                            '91035700.1.1.3','91035700.1.2-LH','91035700.1.3-LH','91035700.1.4-LH','91035700.10','91035700.2','91035700.2.1','91035700.2.2','91035700.2.3',
                            '91035700.2.4','91035700.2.5','91035700.3.1','91035700.3.2','91035700.3.3','91035700.4-LH','91035700.4-RH','91035700.4.1-LH','91035700.4.1-RH','91035700.4.2',
                            '91035700.5','91035700.6','91035700.7','91035700.8-LH','91035700.8-RH','91035700.9')
                            


SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) LIKE '%SKU' )
ORDER BY name




DECLARE @SKU varchar(50)
SELECT  @SKU = '1014503101'


select ixSKU,'tblSKU', ixTimeLastSOPUpdate, dtDateLastSOPUpdate
from tblSKU
where ixSKU = @SKU

select ixSKU, 'tblSKULocation', ixTimeLastSOPUpdate,dtDateLastSOPUpdate,ixLocation
from tblSKULocation
where ixSKU = @SKU

select ixSKU,'tblVendorSKU', ixTimeLastSOPUpdate, dtDateLastSOPUpdate
from tblVendorSKU
where ixSKU = @SKU

select  ixSKU,'tblBinSku', ixTimeLastSOPUpdate, dtDateLastSOPUpdate,ixBin
from tblBinSku
where ixSKU = @SKU --'8352300542'



select ixTime, chTime from tblTime where ixTime = '39579'


select * from tblSKU where dtCreateDate = '01/29/2014'
order by ixTimeLastSOPUpdate desc




select 'tblSKU',ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblBOMTemplateDetail
where ixSKU = '8352300542'

select 'tblSKU',ixFinishedSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblBOMTemplateMaster
where ixFinishedSKU = '8352300542'





tblVelocity60
select ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblVelocity60
where ixSKU = '8352300542'

SELECT ixSKU, count(ixOrder), sum(iQuantity)
FROM tblOrderLine
where ixShippedDate >= 16803
and flgLineStatus = 'Shipped'
and iQuantity > 100
group by ixSKU
order by sum(iQuantity) desc


select ixFinishedSKU, flgDeletedFromSOP
from tblBOMTemplateMaster
where dtDateLastSOPUpdate < '01/28/2014' -- 4,965 220

select flgDeletedFromSOP, count(*)
from tblBOMTemplateMaster
group by flgDeletedFromSOP

-- flag DELETED BOMs
update tblBOMTemplateDetail
set flgDeletedFromSOP = 1
where ixFinishedSKU in ('xxxxxx')

select ixFinishedSKU
from tblBOMTemplateMaster
where  flgDeletedFromSOP = 1



select * --ixFinishedSKU, flgDeletedFromSOP
from tblBOMTemplateMaster
where dtDateLastSOPUpdate = '01/28/2014' -- 4,965 220


select count(*) from tblBOMTemplateMaster -- 5418  5246
select count(*) from tblBOMTemplateMaster where flgDeletedFromSOP = 0 -- 5418  5246
 
/* refed all BOM's
added 150 missing BOMs
flagged 45 as deleted
*/

select ixFinishedSKU from tblBOMTemplateMaster
where ixFinishedSKU like 'UPGS%'

select distinct ixSKU from tblSKU
where ixSKU like 'UPGS%'

select * from tblTableSizeLog
where sTableName = 'tblBOMTemplateMaster'
order by dtDate desc



select * from tblOrderLine
where ixSKU not in (select ixSKU from tblSKU)
and ixShippedDate > 16803


select * from tblErrorLogMaster
order by ixDate desc, ixTime desc

select * from tblTime where ixTime = 50700



select * from tblJobClock where dtDate = '03/02/2014'
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate desc

select count(*) from tblJobClock where dtDate between '03/01/2014' and '03/02/2014'
and dtDateLastSOPUpdate = '03/05/2014'


order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate desc


select 


-- flag BOM Templates as being deleted from SOP when refeed menu can not find the finished SKUS
BEGIN TRAN
UPDATE tblBOMTemplateMaster
set flgDeletedFromSOP = 1
where ixFinishedSKU in (
                            select ixFinishedSKU from tblBOMTemplateMaster
                            where dtDateLastSOPUpdate < '01/28/2016'
                            and flgDeletedFromSOP = 0)
ROLLBACK TRAN                            


BEGIN TRAN
UPDATE tblBOMTemplateDetail
set flgDeletedFromSOP = 1
where ixFinishedSKU in (
                            select distinct ixFinishedSKU 
                            from tblBOMTemplateDetail  
                           where dtDateLastSOPUpdate < '01/28/2016'
                            and flgDeletedFromSOP = 0)
ROLLBACK TRAN       
                            
select * from vwDataFreshness
where sTableName like 'tblBOMTemplate%'                            

SELECT * from tblBOMTemplateMaster
where flgDeletedFromSOP = 0
AND
(mEMITotalLaborCost is NULL OR
mEMITotalMaterialCost is NULL OR
mSMITotalLaborCost is NULL OR
mSMITotalMaterialCost is NULL
)

SELECT * from tblBOMTemplateMaster
where mEMITotalLaborCost <> 0 OR
mEMITotalMaterialCost <> 0 OR
mSMITotalLaborCost <> 0 OR
mSMITotalMaterialCost <> 0

SELECT SUM(mEMITotalLaborCost) FROM tblBOMTemplateMaster
SELECT SUM(mEMITotalMaterialCost) FROM tblBOMTemplateMaster
SELECT SUM(mSMITotalLaborCost) FROM tblBOMTemplateMaster
SELECT SUM(mSMITotalMaterialCost) FROM tblBOMTemplateMaster

SELECT * from tblBOMTemplateMaster
where mEMITotalLaborCost = 0 AND
mEMITotalMaterialCost = 0 AND
mSMITotalLaborCost = 0 AND
mSMITotalMaterialCost = 0 

SELECT * FROM tblTime where ixTime = 39190

select * from tblBOMTemplateMaster
where ixFinishedSKU = '91637020'
order by dtDateLastSOPUpdate

/* RESET COST VALUES so they can be refed and tested again */
    BEGIN TRAN
        Update tblBOMTemplateMaster
        SET mEMITotalLaborCost = NULL
        WHERE mEMITotalLaborCost is NOT NULL
    ROLLBACK TRAN

    BEGIN TRAN
        Update tblBOMTemplateMaster
        SET mEMITotalMaterialCost = NULL
        WHERE mEMITotalMaterialCost is NOT NULL
    ROLLBACK TRAN

    BEGIN TRAN
        Update tblBOMTemplateMaster
        SET mSMITotalLaborCost = NULL
        WHERE mSMITotalLaborCost is NOT NULL
    ROLLBACK TRAN

    BEGIN TRAN
        Update tblBOMTemplateMaster
        SET mSMITotalMaterialCost = NULL
        WHERE mSMITotalMaterialCost is NOT NULL
    ROLLBACK TRAN



/*
-- Speedway's Error Code WIKI http://it.speedwaymotors.com/FogBugz/default.asp?W17

tblErrorCode
    ixErrorCode, sDescription
tblErrorLogMaster   
    ixErrorID, ixDate, dtDate, ixTime, IPAddress, sUser, sPort, ixErrorCode, sError
*/

-- summary
SELECT count(*) QTY,
        ELM.ixErrorCode, EC.sDescription
    -- dtDate, 
FROM tblErrorLogMaster ELM
    left join tblErrorCode EC on EC.ixErrorCode = ELM.ixErrorCode
WHERE ELM.dtDate > '01/31/2014'
    and EC.ixErrorType = 'SQLDB'
GROUP BY ELM.ixErrorCode, EC.sDescription
--HAVING count(*) > 50
order by QTY Desc





select * 
from tblErrorLogMaster ELM
    left join tblErrorCode EC on EC.ixErrorCode = ELM.ixErrorCode
where ELM.ixErrorCode in ('1160','1169','1159')
    and ELM.dtDate > '02/01/2014'
    and EC.ixErrorType = 'SQLDB'




-- all Production tables
Select *
from sys.tables
where name like 'tbl%'






/**************************************************************************************/
/***********    Error Count Past X Days - (INCLUDES days with 0 occurences    *********/
/**************************************************************************************/
select D.dtDate, isnull(ELM.ErrorCnt ,0) ErrorCnt
from tblDate D
               -- specifying error code
    left join (select dtDate, count(*) ErrorCnt
                from tblErrorLogMaster
                where ixErrorCode = 1148
                group by dtDate) ELM on D.dtDate = ELM.dtDate
--where D.dtDate between '01/13/2012' and '04/25/2012'
order by D.dtDate desc



/**************************************************************************************/
/***********    Errors Count PAST X DAYS (shows ONLY days that had errors)    *********/
/**************************************************************************************/
SELECT count(*) QTY
	,CONVERT(VARCHAR(10), ELM.dtDate, 101) AS 'Date' 
	,ELM.ixErrorCode, EC.sDescription 
FROM tblErrorLogMaster ELM
	left join tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
WHERE 
    ELM.dtDate >  DATEADD(dd, /* #ofDays--> */-30,DATEDIFF(dd,0,getdate()))
	 --ELM.ixErrorCode = 1161
group by ELM.dtDate
    ,ELM.ixErrorCode, EC.sDescription
HAVING count(*) > 0
ORDER BY
	ELM.dtDate desc, 
    QTY desc,
    EC.sDescription
    
    
    
    
select sError, count(*) QTY
from tblErrorLogMaster
where ixErrorCode = '1165'
    and dtDate = '11/26/2011'
    group by sError
order by sError

-- ALL errors occuring 10 or more times
SELECT count(*) QTY
	,ELM.ixErrorCode, EC.sDescription 
FROM tblErrorLogMaster ELM
	left join tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
where EC.sDescription is NULL
group by ELM.ixErrorCode, EC.sDescription
having count(*) <= 10
ORDER BY ELM.ixErrorCode,EC.sDescription

    


-- TABLES that are not manual and do not have error codes set up for them
CREATE TABLE #temp (
   table_name sysname ,
   row_count INT,
   reserved_size VARCHAR(50),
   data_size VARCHAR(50),
   index_size VARCHAR(50),
   unused_size VARCHAR(50))
SET NOCOUNT ON
INSERT #temp
EXEC sp_MSforeachtable 'sp_spaceused ''?'''
SELECT a.table_name,a.row_count,
Cast(replace(a.data_size,' KB','') as INT) KBint,
(Cast(replace(a.data_size,' KB','') as DEC (7,0))/1024) MB --   1MB = 1024KB
FROM #temp a
   INNER JOIN INFORMATION_SCHEMA.COLUMNS b ON a.table_name collate database_default = b.table_name collate database_default
WHERE   a.table_name like 'tbl%' 
    and a.table_name NOT IN 
	    ('tblPOMaster','tblOrderLine','tblOrder','tblCustomer','tblPODetail','tblCreditMemoDetail','tblCreditMemoMaster','tblSKULocation',
	     'tblCard','tblCardUser','tblDoorEvent', --   CREATE A TICKET FOR RYAN TO UPDATE THESE
	    'spUpdatePromoCodeDetail','tblEvent','tblCustomerOffer','tblPackage','tblOrderRouting','tblSKUTransaction','tblCatalogDetail','tblCatalogMaster','tblOrderTiming','tblVendor',
	    'tblSnapAdjustedMonthlySKUSales','tblSnapshotSKU','tblBinSku','tblInventoryReceipt','tblDoorEvent','tblBin','tblBOMTransferDetail','tblBOMTransferMaster',
	    'tblJobClock','tblReceiver','tblSKU','tblSKUIndex','tblTimeClock','tblVendorSKU','tblErrorLogMaster','tblTrailer',
	    'tblEmployee','tblBOMSequence','tblBOMTemplateDetail','tblBOMTemplateMaster','tblBrand','tblDropship','tblInsert','tblInventoryForecast',
	    'tblKit','tblPGC','tblPromoCodeMaster','tblPromotionalInventory','tblReceivingWorksheet','tblSourceCode','tblTransactionType',
	    'tblTrailerZipTNT','tblKitList','tblZipCode','tblBoonvilleTotalSKUQuantCost','tblSOPFeedLog','tblTableSizeLog','tblReportDropDowns',
	    'tblPriceChangeReasonCode','tblPromoCodeDetail',
	    
	    
	    /***** the tables below are all Manually Maintained and do not have feeds **/
	    'tblDate','tblDeliveryAreaSurcharge','tblDepartment',
	    'tblErrorCode','tblHandlingCode','tblJob',
	    'tblLatestFeed','tblLocation','tblMarket',
	    'tblShipMethod','tblSourceCodeType','tblStates','tblTime','tblTrailer'
   	    /************/
) 
GROUP BY a.table_name, a.row_count, a.data_size
ORDER BY  a.row_count DESC -- a.table_name
DROP TABLE #temp


tblDate
tblDeliveryAreaSurcharge 
tblDepartment
tblErrorCode
tblHandlingCode
tblJob
tblLatestFeed
tblLocation
tblMarket
tblShipMethod
tblSourceCodeType
tblStates
tblTime
tblTrailer


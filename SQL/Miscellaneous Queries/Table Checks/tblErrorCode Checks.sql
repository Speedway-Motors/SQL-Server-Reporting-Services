-- tblErrorCode Checks

/**************** ERROR CODES & ERROR LOG history ***********************/
-- N/A since this is a manually populated table
/************************************************************************/

select * from tblErrorCode

-- TABLE GROWTH
exec spGetTableGrowth tblErrorCode
/*
DB          	TABLE       	Rows   	Date
SMI Reporting	tblErrorCode	197	01-01-18
SMI Reporting	tblErrorCode	196	01-01-17
SMI Reporting	tblErrorCode	192	01-01-16
SMI Reporting	tblErrorCode	191	01-01-15
SMI Reporting	tblErrorCode	147	01-01-14
SMI Reporting	tblErrorCode	134	01-01-13
SMI Reporting	tblErrorCode	121	03-01-12
*/

-- ADD NEW ERROR CODES
-- !! DON'T FORGET TO ADD SAME CODES TO AFCOReporting !!
--insert into [AFCOReporting].dbo.tblErrorCode
select 1078, 'Error in Product Suggestion Subroutine', 'SOP' -- 'SQLDB' 'SOP' or NULL 

select * from tblErrorCode
order by ixErrorCode desc


-- Change Error Description
--update table [AFCOReporting].dbo.tblErrorCode
set sDescription = 'Error in Product Suggestion Subroutine'
where ixErrorCode = 1078

select * from tblErrorCode
where ixErrorCode = 1223
/*
ixErrorCode	sDescription	ixErrorType
1223	Failure to update tblErrorCodeMaster	SQLDB
*/

-- Frequency of specific error
select ixDate, ixErrorCode, count(*) Qty
from tblErrorLogMaster
where ixErrorCode = 1223
group by ixDate, ixErrorCode
order by ixDate desc
/*      ixError
ixDate	Code	Qty
17991	1223	3
17989	1223	1
17988	1223	2
17987	1223	1
17986	1223	8
17980	1223	17
17979	1223	3
17978	1223	2
17977	1223	4
17975	1223	1
17974	1223	1
17973	1223	3
17970	1223	2
17968	1223	1
17966	1223	1
17959	1223	1
17957	1223	1
17956	1223	1
17953	1223	1
17952	1223	3
17951	1223	1
17950	1223	2
17949	1223	1
17943	1223	22
17942	1223	3
17938	1223	3
17936	1223	1
17935	1223	5
17929	1223	7
17928	1223	2
17924	1223	1
17921	1223	5
17920	1223	2
17915	1223	68
17911	1223	1
17909	1223	2
17904	1223	1
17900	1223	2
17898	1223	2
17896	1223	5
17894	1223	1
17891	1223	380
17889	1223	2
17887	1223	2
17886	1223	1
17879	1223	2
17868	1223	2
17865	1223	2
17864	1223	2
17863	1223	2
17861	1223	2
17854	1223	2
17851	1223	4
17840	1223	1
17835	1223	1
17830	1223	3

*/
select * from tblErrorLogMaster
where ixErrorCode = 1223
and ixDate = 17991
2017-04-03 00:00:00.000	80051
2017-04-03 00:00:00.000	80051
2017-04-03 00:00:00.000	80555


select * from tblErrorLogMaster
where ixErrorID in (5971032, 5971035, 5971041)
2017-04-03 00:00:00.000	74943
2017-04-03 00:00:00.000	75406
2017-04-03 00:00:00.000	80051


2017-04-04 00:00:00.000	31643
2017-04-04 00:00:00.000	31643




-- counts by Error Type
select ixErrorType, count(*) Qty
from tblErrorCode
group by ixErrorType
order by ixErrorType
/*
ixErrorType	Qty
SOP	        102
SQLDB	     49
*/

select * from tblErrorLogMaster where ixErrorCode = 1223
order by ixDate desc

select * from tblErrorCode
where sDescription like 'Failure to update%'
order by sDescription

select * from tblErrorCode where ixErrorType = 'SQLDB'
order by sDescription


-- WHAT TABLES DON'T HAVE ERROR CODES YET?
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
--Cast(replace(a.data_size,' KB','') as INT) KBint,
(Cast(replace(a.data_size,' KB','') as DEC (7,0))/1024) MB --   1MB = 1024KB
FROM #temp a
   INNER JOIN INFORMATION_SCHEMA.COLUMNS b ON a.table_name collate database_default = b.table_name collate database_default
WHERE   a.table_name like 'tbl%' 
    and a.table_name NOT IN 
        /******* These tables have Error Codes */
	    ('tblBin',                      -- ixErrorCode =
        'tblBinSku',                    -- ixErrorCode =
        'tblBOMSequence',               -- ixErrorCode =
        'tblBOMTemplateDetail',         -- ixErrorCode =
        'tblBOMTemplateMaster',         -- ixErrorCode =
        'tblBOMTransferDetail',         -- ixErrorCode =
        'tblBOMTransferMaster',         -- ixErrorCode =
        'tblBoonvilleTotalSKUQuantCost',-- ixErrorCode =
        'tblBrand',                     -- ixErrorCode =
        'tblCatalogDetail',             -- ixErrorCode =
        'tblCatalogMaster',             -- ixErrorCode =
        'tblCatalogRequest',            -- ixErrorCode = 1182   
        'tblCounterOrderScans',         -- ixErrorCode = 1214             
        'tblCreditMemoDetail',          -- ixErrorCode =
        'tblCreditMemoMaster',          -- ixErrorCode =
        'tblCreditMemoReasonCode',      -- ixErrorCode = 1212        
        'tblCustomer',                  -- ixErrorCode =
        'tblCustomerOffer',             -- ixErrorCode =
        'tblDoorEvent',                 -- ixErrorCode =
        'tblDropship',                  -- ixErrorCode =
        'tblEmployee',                  -- ixErrorCode =
        'tblErrorLogMaster',            -- ixErrorCode =
        'tblEvent',                     -- ixErrorCode =
        'tblInsert',                    -- ixErrorCode =
        'tblInventoryForecast',         -- ixErrorCode =
        'tblInventoryReceipt',          -- ixErrorCode =
        'tblJobClock',                  -- ixErrorCode =
        'tblKit',                       -- ixErrorCode =
        'tblKitList',                   -- ixErrorCode =
        'tblMailingOptIn',              -- ixErrorCode = 1183        
        'tblOrder',                     -- ixErrorCode =
        'tblOrderLine',                 -- ixErrorCode =
        'tblOrderPromoCodeXref',        -- ixErrorCode = 1218          
        'tblOrderRouting',              -- ixErrorCode =
        'tblOrderTiming',               -- ixErrorCode =
        'tblPackage',                   -- ixErrorCode =
        'tblPGC',                       -- ixErrorCode =
        'tblPODetail',                  -- ixErrorCode =
        'tblPOMaster',                  -- ixErrorCode =
        'tblPriceChangeReasonCode',     -- ixErrorCode =
        'tblProductLine',               -- ixErrorCode = 1171        
        'tblPromoCodeDetail',           -- ixErrorCode =
        'tblPromoCodeMaster',           -- ixErrorCode =
        'tblPromotionalInventory',      -- ixErrorCode =
        'tblReceiver',                  -- ixErrorCode =
        'tblReceivingWorksheet',        -- ixErrorCode =
        'tblReportDropDowns',           -- ixErrorCode =
        'tblSKU',                       -- ixErrorCode =
        'tblSKUIndex',                  -- ixErrorCode =
        'tblSKULocation',               -- ixErrorCode =
        'tblSKUTransaction',            -- ixErrorCode =
        'tblSnapAdjustedMonthlySKUSales', -- ixErrorCode =
        'tblSnapAdjustedMonthlySKUSalesNEW',-- ixErrorCode =
        'tblSnapshotSKU',               -- ixErrorCode =
        'tblSOPFeedLog',                -- ixErrorCode =
        'tblSourceCode',                -- ixErrorCode =
        'tblTableSizeLog',              -- ixErrorCode =
        'tblTimeClock',                 -- ixErrorCode =
        'tblTimeClockDetail',           -- ixErrorCode = 1217           
        'tblTrailer',                   -- ixErrorCode =
        'tblTrailerZipTNT',             -- ixErrorCode =
        'tblTransactionType',           -- ixErrorCode =
        'tblVendor',                    -- ixErrorCode =
        'tblVendorSKU',                 -- ixErrorCode =
        'tblZipCode',                   -- ixErrorCode =
	    
	    /******* These tables are used by the Door System.  If possible we may associate Error Codes at a later date. */
	    'tblCard','tblCardUser','tblDoorEvent', 'tblDoorEventArchive',
	    
	    /******* These tables are all Manually Maintained and do not have feeds **/
	    'tblCanadianProvince','tblDate','tblDeliveryAreaSurcharge','tblDepartment',
	    'tblIPAddress',
	    'tblErrorCode','tblHandlingCode','tblJob',
	    'tblLatestFeed','tblLocation','tblMarket',
	    'tblMethodOfPayment',
	    'tblShipMethod','tblSourceCodeType','tblStates','tblTime','tblTrailer',
	    
	    /******* These tables are populated by the SSA job "SMI Bulk Upload".
                 On job failure, email notifications are sent out.  
                 Additional details can be retreived from SSA job history.
                 NO ixErrorCodes are needed. */   
         'tblFIFODetail','tblGiftCardDetail','tblGiftCardMaster','tblShippingPromo','tblSKUPromo',
         
        /******* These tables are manually maintained by CCC. Currently used by SSAS. 
                 Eventually they will be handled entirely on Tableau side and can be deleted at that time. 
                 NO ixErrorCodes are needed. */ 
        'tblGeography','tblOrderChannel','tblOrderType','tblDimDate','tblOrderTNT'
) 
GROUP BY a.table_name, a.row_count, a.data_size
ORDER BY  a.row_count DESC -- a.table_name
DROP TABLE #temp


-- HAVE SOME ERROR CODES NEVER TRIPPED?  IF SO, CAN WE VERIFY THEY ACTUALLY TRIGGER WHEN THEY ARE SUPPOSED TO?
select EC.ixErrorCode, EC.sDescription, count(ELM.ixErrorCode)
from tblErrorCode EC
left join tblErrorLogMaster ELM on EC.ixErrorCode = ELM.ixErrorCode
WHERE ixErrorType = 'SQLDB'
GROUP BY EC.ixErrorCode, EC.sDescription
HAVING count(ELM.ixErrorCode) = 0
ORDER BY EC.sDescription


select min(ixDate) from tblErrorLogMaster

select * from tblDate where ixDate = 16590 -- 2013-06-02 ccc deleted all of the history prior to this date.




select top 100 * from tblDimDate order by newid()
select top 100 * from tblFIFODetail  order by newid()
select top 100 * from tblGeography order by newid()

select top 100 * from tblGiftCardDetail order by newid()
select top 100 * from tblGiftCardMaster order by newid()

select top 100 * from tblOrderChannel order by newid()
select top 100 * from tblOrderTNT order by newid()
select top 100 * from tblOrderType order by newid()
select top 100 * from tblShippingPromo order by newid()
select top 100 * from tblSKUPromo order by newid()
select top 100 * from tblVelocity60 order by newid()

select max(dtLastSOPUpdateDate) from tblDimDate
select max(dtLastSOPUpdateDate) from tblFIFODetail
select max(dtLastSOPUpdateDate) from tblGeography
select max(dtLastSOPUpdateDate) from tblGiftCardDetail
select max(dtLastSOPUpdateDate) from tblGiftCardMaster
select max(dtLastSOPUpdateDate) from tblOrderChannel
select max(dtLastSOPUpdateDate) from tblOrderTNT
select max(dtLastSOPUpdateDate) from tblOrderType
select max(dtLastSOPUpdateDate) from tblShippingPromo
select max(dtLastSOPUpdateDate) from tblSKUPromo
select max(dtLastSOPUpdateDate) from tblVelocity60



select * from tblOrderType
select * from tblOrderChannel

select * from tblGeography
select * from tblOrderType

select * from [SMITemp].dbo.[Dataset1$]


select *
from sysobjects so join sysusers su 
on so.uid = su.uid  
WHERE so.name LIKE 'CAHTC%'
order by so.crdate


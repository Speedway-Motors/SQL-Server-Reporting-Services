-- Tables that may need dtDateLastSOPUpdate field added
SELECT t.name AS 'TableName'
FROM sys.tables  t  
WHERE t.name like 'tbl%'
    and t.name NOT IN ( -- tables that have dtDateLastSOPUpdate field
                        SELECT t.name AS 'TableName'
                        FROM        sys.columns c
                        JOIN        sys.tables  t   ON c.object_id = t.object_id
                        WHERE       c.name LIKE '%dtDateLastSOPUpdate%'
                        )
    and t.name NOT like 'tblAws%' 
    /*
    and t.name NOT IN (-- tables scheduled to be deleted soon
                        'tblDoorEventArchive','tblDoorEventArchive010114to041414','tblDoorEventArchive041514to123114',
                        'tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans',
                        'tblOrderFreeShippingEligible','tblOrderTNT','tblPromotionalInventory','tblSKUIndex') 
    and t.name NOT IN (-- Ron's tables - primarily data from tng?
                        'tblengine_family','tblengine_subfamily','tblracetype','tblskuvariant_engine_subfamily_xref','tblskuvariant_racetype_xref',
                        'tblskuvariant_transmission_family_xref','tblskuvariant_vehicle_base','tbltransmission_family',
                        'tblvehicle_base','tblvehicle_make','tblvehicle_model','tblvehicle_model_type','tblvehicle_year','tblVelocity60') 
    and t.name NOT IN (-- Ron's Call Center tables
                        'tblCallCenterHoursWorked','tblCallCenterKpi','tblCallCenterMetrics','tblCallCenterSection','tblCallCenterUser')
    and t.name NOT IN (-- MANUALLY populated tables
                        'tblCanadianProvince','tblCustomerType','tblDate','tblDeliveryAreaSurcharge','tblDepartment',
                        'tblGoodHTC','tblHandlingCode','tblIPAddress','tblLocation','tblMarket',
                        'tblMethodOfPayment','tblNCOACode','tblOrderChannel','tblOrderType','tblPriceChangeReasonCode',
                        'tblShipMethod','tblSourceCodeType','tblStates','tblTime','tblTrailer')
    and t.name NOT IN (-- door system tables
                        'tblCard','tblCardUser','tblDoorEvent') 
    and t.name NOT IN ( -- tables populated by SSA jobs
                        'tblCSTCustSummary_Rollup','tblCustomerTwoMostRecentOrders_Rollup','tblKitList','tblSnapAdjustedMonthlySKUSales','tblSnapAdjustedMonthlySKUSalesNEW',
                        'tblSnapshotWEBPriceLevel1','tblSOPFeedLog','tblStockOut','tblTableSizeLog')
    */
ORDER BY TableName


select * from tblCustomerProject
select * from tblDimDate
select * from tblGeography
select * from tblLatestFeed
select * from

SELECT *
into [SMIArchive].dbo.BU_tblLatestFeed_20180418
from tblLatestFeed

select count(*) from [SMIArchive].dbo.BU_tblLatestFeed_20180418
select count(*) from tblLatestFeed

set rowcount 10000
delete from tblLatestFeed
set rowcount 0 



tblCatalogDetail
tblCatalogDetailWork
tblCatalogMaster
tblCatalogMasterWork
tblCatalogSKULog
tblCustomerProject
tblDatabaseSchemaLog
tblDimDate
tblDropshipEstimatedShippingRate
tblDropshipSKUPerformance
tblErrorCode
tblFIFODetail
tblGeography
tblLatestFeed
tblPODetail
tblReceivingWorksheet
tblShippingPromo
tblSKUPromo


select sTableName, flgActive from tblAwsQueueTypeReference
where sTableName in ('tblDoorEventArchive','tblDoorEventArchive010114to041414','tblDoorEventArchive041514to123114','tblLatestFeed','tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans','tblOrderFreeShippingEligible','tblOrderTNT','tblPromotionalInventory','tblSKUIndex')

BEGIN TRAN

    UPDATE tblAwsQueueTypeReference
    set flgActive = 0
    where sTableName in ('tblDoorEventArchive','tblDoorEventArchive010114to041414','tblDoorEventArchive041514to123114','tblLatestFeed','tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans','tblOrderFreeShippingEligible','tblOrderTNT','tblPromotionalInventory','tblSKUIndex')

ROLLBACK TRAN

select * from tblLatestFeed WHER

SELECT * FROM tblDoorEventArchive
SELECT * FROM tblDoorEventArchive010114to041414
SELECT * FROM tblDoorEventArchive041514to123114
SELECT * FROM tblLatestFeed
SELECT * FROM tblLoanTicketDetail

SELECT * FROM tblLoanTicketMaster
SELECT * FROM tblLoanTicketScans
SELECT * FROM tblOrderFreeShippingEligible
SELECT * FROM tblOrderTNT
SELECT * FROM tblPromotionalInventory
SELECT * FROM tblSKUIndex
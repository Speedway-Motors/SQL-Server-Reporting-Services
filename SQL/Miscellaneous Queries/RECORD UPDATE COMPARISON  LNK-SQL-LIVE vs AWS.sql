-- RECORD UPDATE COMPARISON  LNK-SQL-LIVE vs AWS
SELECT 'tblBin' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBin
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblBinSku' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBinSku
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblBOMTemplateDetail' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBOMTemplateDetail
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblBOMTransferDetail' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBOMTransferDetail
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblCustomer' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCustomer
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblCustomerOffer' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCustomerOffer
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblEmployee' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblEmployee
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblKit' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblKit
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblPackage' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblPackage
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblPGC' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblPGC
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
-- tables 11-21
SELECT 'tblPOMaster' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblPOMaster
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblSourceCode' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblSourceCode
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblTimeClock' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblTimeClock
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblTimeClockDetail' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblTimeClockDetail
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblVendorSKU' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblVendorSKU
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL







/********************************
-- 100% match on 1-24-18
 ********************************/
SELECT 'tblBOMSequence' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBOMSequence
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblBOMTemplateMaster' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBOMTemplateMaster
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblBOMTransferMaster' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBOMTransferMaster
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblBrand' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblBrand
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblCatalogRequest' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCatalogRequest
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblCounterOrderScans' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCounterOrderScans
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
-- tables 11-20
SELECT 'tblCreditMemoDetail' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCreditMemoDetail
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblCreditMemoMaster' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCreditMemoMaster
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblCreditMemoReasonCode' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCreditMemoReasonCode
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblDropship' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblDropship
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblGiftCardDetail' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblGiftCardDetail
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblGiftCardMaster' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblGiftCardMaster
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblInventoryForecast' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblInventoryForecast
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblInventoryReceipt' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblInventoryReceipt
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblJob' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblJob
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblJobClock' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblJobClock
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblLocalTaxCode' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblLocalTaxCode
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblMailingOptIn' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblMailingOptIn
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblMergedCustomers' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblMergedCustomers
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblOrder' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblOrder
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblOrderPromoCodeXref' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblOrderPromoCodeXref
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblOrderRouting' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblOrderRouting
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblOrderTiming' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblOrderTiming
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblProductLine' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblProductLine
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblPromoCodeMaster' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblPromoCodeMaster
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblReceiver' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblReceiver
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblSKU' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblSKU
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblSKULocation' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblSKULocation
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblTrailerZipTNT' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblTrailerZipTNT
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblTransactionType' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblTransactionType
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
UNION
SELECT 'tblVendor' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblVendor
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL


/*UNION
SELECT 'tblCustomerType' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblCustomerType
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL

UNION
SELECT 'tblDeliveryAreaSurcharge' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblDeliveryAreaSurcharge
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL

UNION
SELECT 'tblDepartment' as 'sTableName',	count(*) 'UpdateBeforeToday' 
FROM tblDepartment
WHERE dtDateLastSOPUpdate < convert(varchar(10), getdate(), 120) or dtDateLastSOPUpdate is NULL
*/

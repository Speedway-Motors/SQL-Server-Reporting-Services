-- SMIHD-18325 tables are in sync - SMI Reporting vs AWS

SELECT 'tblBin' as 'sTableName',	count(*) 'RecCount' FROM tblBin

UNION
SELECT 'tblBinSku' as 'sTableName',	count(*) 'RecCount' FROM tblBinSku

UNION
SELECT 'tblBOMSequence' as 'sTableName',	count(*) 'RecCount' FROM tblBOMSequence

UNION
SELECT 'tblBOMTemplateDetail' as 'sTableName',	count(*) 'RecCount' FROM tblBOMTemplateDetail

UNION
SELECT 'tblBOMTemplateMaster' as 'sTableName',	count(*) 'RecCount' FROM tblBOMTemplateMaster

UNION
SELECT 'tblBOMTransferDetail' as 'sTableName',	count(*) 'RecCount' FROM tblBOMTransferDetail

UNION
SELECT 'tblBOMTransferMaster' as 'sTableName',	count(*) 'RecCount' FROM tblBOMTransferMaster

UNION
SELECT 'tblBrand' as 'sTableName',	count(*) 'RecCount' FROM tblBrand

UNION
SELECT 'tblBusinessUnit' as 'sTableName',	count(*) 'RecCount' FROM tblBusinessUnit

UNION
SELECT 'tblCatalogDetail' as 'sTableName',	count(*) 'RecCount' FROM tblCatalogDetail

UNION
SELECT 'tblCatalogMaster' as 'sTableName',	count(*) 'RecCount' FROM tblCatalogMaster

UNION
SELECT 'tblCatalogRequest' as 'sTableName',	count(*) 'RecCount' FROM tblCatalogRequest

UNION
SELECT 'tblCounterOrderScans' as 'sTableName',	count(*) 'RecCount' FROM tblCounterOrderScans

UNION
SELECT 'tblCreditMemoDetail' as 'sTableName',	count(*) 'RecCount' FROM tblCreditMemoDetail

UNION
SELECT 'tblCreditMemoMaster' as 'sTableName',	count(*) 'RecCount' FROM tblCreditMemoMaster

UNION
SELECT 'tblCreditMemoReasonCode' as 'sTableName',	count(*) 'RecCount' FROM tblCreditMemoReasonCode

UNION
SELECT 'tblCustomer' as 'sTableName',	count(*) 'RecCount' FROM tblCustomer

UNION
SELECT 'tblCustomerOffer' as 'sTableName',	count(*) 'RecCount' FROM tblCustomerOffer

UNION
SELECT 'tblDate' as 'sTableName',	count(*) 'RecCount' FROM tblDate

UNION
SELECT 'tblDropship' as 'sTableName',	count(*) 'RecCount' FROM tblDropship

UNION
SELECT 'tblEmployee' as 'sTableName',	count(*) 'RecCount' FROM tblEmployee

UNION
SELECT 'tblFIFODetail' as 'sTableName',	count(*) 'RecCount' FROM tblFIFODetail

UNION
SELECT 'tblGiftCardDetail' as 'sTableName',	count(*) 'RecCount' FROM tblGiftCardDetail

UNION
SELECT 'tblGiftCardMaster' as 'sTableName',	count(*) 'RecCount' FROM tblGiftCardMaster

UNION
SELECT 'tblInventoryForecast' as 'sTableName',	count(*) 'RecCount' FROM tblInventoryForecast

UNION
SELECT 'tblInventoryReceipt' as 'sTableName',	count(*) 'RecCount' FROM tblInventoryReceipt

UNION
SELECT 'tblJob' as 'sTableName',	count(*) 'RecCount' FROM tblJob

UNION
SELECT 'tblJobClock' as 'sTableName',	count(*) 'RecCount' FROM tblJobClock

UNION
SELECT 'tblKit' as 'sTableName',	count(*) 'RecCount' FROM tblKit

UNION
SELECT 'tblLocation' as 'sTableName',	count(*) 'RecCount' FROM tblLocation

UNION
SELECT 'tblLocalTaxCode' as 'sTableName',	count(*) 'RecCount' FROM tblLocalTaxCode

UNION
SELECT 'tblMailingOptIn' as 'sTableName',	count(*) 'RecCount' FROM tblMailingOptIn

UNION
SELECT 'tblMergedCustomers' as 'sTableName',	count(*) 'RecCount' FROM tblMergedCustomers

UNION
SELECT 'tblOrder' as 'sTableName',	count(*) 'RecCount' FROM tblOrder

UNION
SELECT 'tblOrderLine' as 'sTableName',	count(*) 'RecCount' FROM tblOrderLine

UNION
SELECT 'tblOrderPromoCodeXref' as 'sTableName',	count(*) 'RecCount' FROM tblOrderPromoCodeXref

UNION
SELECT 'tblOrderRouting' as 'sTableName',	count(*) 'RecCount' FROM tblOrderRouting

UNION
SELECT 'tblOrderTiming' as 'sTableName',	count(*) 'RecCount' FROM tblOrderTiming

UNION
SELECT 'tblPackage' as 'sTableName',	count(*) 'RecCount' FROM tblPackage

UNION
SELECT 'tblPGC' as 'sTableName',	count(*) 'RecCount' FROM tblPGC

UNION
SELECT 'tblPOMaster' as 'sTableName',	count(*) 'RecCount' FROM tblPOMaster

UNION
SELECT 'tblProductLine' as 'sTableName',	count(*) 'RecCount' FROM tblProductLine

UNION
SELECT 'tblPromoCodeMaster' as 'sTableName',	count(*) 'RecCount' FROM tblPromoCodeMaster

UNION
SELECT 'tblReceiver' as 'sTableName',	count(*) 'RecCount' FROM tblReceiver

UNION
SELECT 'tblSKU' as 'sTableName',	count(*) 'RecCount' FROM tblSKU

UNION
SELECT 'tblSKULocation' as 'sTableName',	count(*) 'RecCount' FROM tblSKULocation

UNION
SELECT 'tblSourceCode' as 'sTableName',	count(*) 'RecCount' FROM tblSourceCode

UNION
SELECT 'tblTimeClock' as 'sTableName',	count(*) 'RecCount' FROM tblTimeClock

UNION
SELECT 'tblTimeClockDetail' as 'sTableName',	count(*) 'RecCount' FROM tblTimeClockDetail

UNION
SELECT 'tblTrailer' as 'sTableName',	count(*) 'RecCount' FROM tblTrailer

UNION
SELECT 'tblTrailerZipTNT' as 'sTableName',	count(*) 'RecCount' FROM tblTrailerZipTNT

UNION
SELECT 'tblTransactionType' as 'sTableName',	count(*) 'RecCount' FROM tblTransactionType

UNION
SELECT 'tblVendor' as 'sTableName',	count(*) 'RecCount' FROM tblVendor

UNION
SELECT 'tblVendorSKU' as 'sTableName',	count(*) 'RecCount' FROM tblVendorSKU






/*
select max(dtDateLastSOPUpdate)  from tblJobClock
select max(ixTimeLastSOPUpdate)  from tblJobClock where dtDateLastSOPUpdate = '08/07/2020'
2020-08-07 00:00:00.000
44875  45266


select max(dtDateLastSOPUpdate)  from tblVendorSKU
select max(ixTimeLastSOPUpdate)  from tblVendorSKU where dtDateLastSOPUpdate = '08/07/2020'
44835


SELECT 'tblVendorSKU' as 'sTableName',	count(*) 'RecCount' 
FROM tblVendorSKU
-- 777,795

SELECT * FROM tblTrailer
order by ixTrailer

*/
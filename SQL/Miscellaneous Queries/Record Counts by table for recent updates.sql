-- Record Counts by table for recent updates
/*
SELECT * from tblTime
where chTime = '11:55:00' -- 42900

select sTableName, SUM(Records) RecUpdates
from vwDataFreshness
where DaysOld in ('   <=1','   2-7')
-- and Records > 1000
GROUP BY sTableName
--HAVING SUM(Records) > 3000
ORDER BY sTableName



*/
DECLARE @ixTime as INT,
    @dtDateLastSOPUpdate as datetime

SELECT @ixTime = 43200,
       @dtDateLastSOPUpdate = '06/17/2016'

select COUNT(*) 'RecordUpdates', 'tblBin' AS 'TABLE' from tblBin where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates', 'tblBinSku' AS 'TABLE' from tblBinSku where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates', 'tblBOMSequence' AS 'TABLE' from tblBOMSequence where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates', 'tblBOMTemplateDetail' AS 'TABLE' from tblBOMTemplateDetail where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates', 'tblBOMTemplateMaster' AS 'TABLE' from tblBOMTemplateMaster where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates', 'tblBOMTransferDetail' AS 'TABLE' from tblBOMTransferDetail where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates', 'tblBOMTransferMaster' AS 'TABLE' from tblBOMTransferMaster where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 


UNION ALL
select COUNT(*) 'RecordUpdates', 'tblBrand' AS 'TABLE' from tblBrand where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates', 'tblCreditMemoDetail' AS 'TABLE' from tblCreditMemoDetail where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblCreditMemoMaster' AS 'TABLE' from tblCreditMemoMaster where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblCreditMemoReasonCode' AS 'TABLE' from tblCreditMemoReasonCode where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblCustomer' AS 'TABLE' from tblCustomer where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblCustomerOffer' AS 'TABLE' from tblCustomerOffer where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblDropship' AS 'TABLE' from tblDropship where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblEmployee' AS 'TABLE' from tblEmployee where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblErrorLogMaster' AS 'TABLE' from tblErrorLogMaster where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblInventoryForecast' AS 'TABLE' from tblInventoryForecast where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblInventoryReceipt' AS 'TABLE' from tblInventoryReceipt where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblJobClock' AS 'TABLE' from tblJobClock where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblKit' AS 'TABLE' from tblKit where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblMailingOptIn' AS 'TABLE' from tblMailingOptIn where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblOrder' AS 'TABLE' from tblOrder where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblOrderLine' AS 'TABLE' from tblOrderLine where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblOrderPromoCodeXref' AS 'TABLE' from tblOrderPromoCodeXref where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblOrderRouting' AS 'TABLE' from tblOrderRouting where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblPackage' AS 'TABLE' from tblPackage where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblPGC' AS 'TABLE' from tblPGC where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblProductLine' AS 'TABLE' from tblProductLine where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblReceiver' AS 'TABLE' from tblReceiver where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblSKU' AS 'TABLE' from tblSKU where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblSKULocation' AS 'TABLE' from tblSKULocation where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblSKUTransaction' AS 'TABLE' from tblSKUTransaction where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblSourceCode' AS 'TABLE' from tblSourceCode where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblTimeClockDetail' AS 'TABLE' from tblTimeClockDetail where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblTransactionType' AS 'TABLE' from tblTransactionType where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblVendor' AS 'TABLE' from tblVendor where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
UNION ALL
select COUNT(*) 'RecordUpdates' , 'tblVendorSKU' AS 'TABLE' from tblVendorSKU where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 


-- select COUNT(*) 'RecordUpdates' , 'XXXXX' AS 'TABLE' from tblTrailer where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
-- select COUNT(*) 'RecordUpdates' , 'tblMergedCustomers' AS 'TABLE' from tblMergedCustomers where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 
-- select COUNT(*) 'RecordUpdates', 'tblBinSkuOLD' AS 'TABLE' from tblBinSkuOLD where dtDateLastSOPUpdate =  @dtDateLastSOPUpdate and ixTimeLastSOPUpdate > @ixTime -- '12:01:00' 




/*
442	tblBin
19529	tblBOMTemplateDetail
1634	tblBOMTemplateMaster
3421	tblBOMTransferDetail
272	tblBOMTransferMaster


390	tblBin
19496	tblBOMTemplateDetail
1632	tblBOMTemplateMaster
3311	tblBOMTransferDetail
252	tblBOMTransferMaster

371	tblBin
19496	tblBOMTemplateDetail
1632	tblBOMTemplateMaster
3307	tblBOMTransferDetail
250	tblBOMTransferMaster

11:23-11:33
19496	tblBOMTemplateDetail
1632	tblBOMTemplateMaster
3288	tblBOMTransferDetail
247	tblBOMTransferMaster

SELECT * FROM tblBOMTemplateDetail --   19,537 so far today at 11:35
WHERE dtDateLastSOPUpdate = '05/02/2016'
and ixTimeLastSOPUpdate >= 41580 -- 19,496

select * from tblBinSku where dtDateLastSOPUpdate = '05/02/2016'

SELECT dtDateLastSOPUpdate, count(*)
from tblSKU
where flgDeletedFromSOP = 0
AND dtDateLastSOPUpdate > = '4/27/2016'
GROUP BY dtDateLastSOPUpdate
ORDER BY dtDateLastSOPUpdate DESC

*/
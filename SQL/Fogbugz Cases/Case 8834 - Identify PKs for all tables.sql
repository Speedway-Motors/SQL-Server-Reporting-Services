select count(*) from tblBin -- 157007
select distinct ixBin, ixLocation
from tblBin
group by ixBin, ixLocation
having count(*) > 1

delete from tblBin
where ixBin is NULL



/**************************************/
select count(*) from tblBinSku -- 202051

select distinct ixBin, sCID, ixSKU, ixLocation -- 202051
from tblBinSku

select ixBin, sCID, ixSKU, ixLocation, count(*) 
from tblBinSku 
group by ixBin, sCID, ixSKU, ixLocation
having count(*) > 1
order by count(*) desc

select * from tblBinSku where ixBin = '~'

select * from tblBinSku
where ixBin = 'RCV'
and ixSKU = '9193381'
and ixLocation = '99'

/**************************************/
select count(*) from tblBOMSequence -- 561 

select distinct ixFinishedSKU, iSequenceNumber -- 561
from tblBOMSequence

select distinct COLUMNNAMES, count(*)
from tblBOMSequence
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblOrder     -- 3,996,748

select distinct ixOrder       -- ###
from tblOrder

select distinct COLUMNNAMES, count(*)
from tblOrder
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblBOMTemplateDetail     -- 12532

select distinct ixFinishedSKU,ixSKU       -- 12532
from tblBOMTemplateDetail

select distinct COLUMNNAMES, count(*)
from tblBOMTemplateDetail
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblBOMTemplateMaster     -- 3019

select distinct ixFinishedSKU       -- 3019
from tblBOMTemplateMaster

select distinct COLUMNNAMES, count(*)
from tblBOMTemplateMaster
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblBOMTransferDetail     -- 126090

select distinct ixTransferNumber, ixSKU       -- 126090
from tblBOMTransferDetail

select distinct COLUMNNAMES, count(*)
from tblBOMTransferDetail
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblBOMTransferMaster     -- 31540

select distinct ixTransferNumber       -- 31540
from tblBOMTransferMaster

select distinct COLUMNNAMES, count(*)
from tblBOMTransferMaster
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblBoonvilleTotalSKUQuantCost     -- 2261

select distinct ixSKU       -- 2261
from tblBoonvilleTotalSKUQuantCost

select distinct COLUMNNAMES, count(*)
from tblBoonvilleTotalSKUQuantCost
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblBrand     -- 267

select distinct ixBrand       -- 267
from tblBrand

select distinct COLUMNNAMES, count(*)
from tblBrand
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblCatalogDetail     -- 1,119,050

select distinct ixCatalog, ixSKU       -- 1,119,050
from tblCatalogDetail

select distinct ixCatalog, ixSKU, count(*)
from tblCatalogDetail
group by ixCatalog, ixSKU
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblCatalogMaster     -- 234

select distinct ixCatalog       -- 234
from tblCatalogMaster

select distinct COLUMNNAMES, count(*)
from tblCatalogMaster
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblCreditMemoDetail     -- 364,036

select distinct ixCreditMemo,ixCreditMemoLine       -- 364,036
from tblCreditMemoDetail

select distinct COLUMNNAMES, count(*)
from tblCreditMemoDetail
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblCreditMemoMaster     -- 271,146

select distinct ixCreditMemo       -- 271,146
from tblCreditMemoMaster

select distinct COLUMNNAMES, count(*)
from tblCreditMemoMaster
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblCustomer     -- 1,130,297

select distinct ixCustomer       -- 1,130,297
from tblCustomer

select distinct COLUMNNAMES, count(*)
from tblCustomer
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblCustomerOffer     -- 10,647,323

select distinct ixCustomerOffer, ixCustomer       -- 10,647,323
from tblCustomerOffer
/**************************************/
select count(*) from tblCustomerType     -- ###

select distinct ixCustomerType       -- ###
from tblCustomerType
/**************************************/
select count(*) from tblDate     -- 15360

select distinct ixDate       -- 15360
from tblDate
/**************************************/
select count(*) from tblDropship     -- 5621

select distinct ixDropship       -- 5621
from tblDropship
/**************************************/
select count(*) from tblEmployee     -- 1001

select distinct ixEmployee       -- 1001
from tblEmployee
/**************************************/
select count(*) from tblInsert     -- ###

select distinct COLUMNNAME       -- ###
from tblInsert
/**************************************/
select count(*) from tblInventoryForecast     -- 18842

select distinct ixSKU       -- 18842
from tblInventoryForecast
/**************************************/
select count(*) from tblInventoryReceipt     -- 147004

select distinct ixInventoryReceipt       -- 147004
from tblInventoryReceipt
/**************************************/
select count(*) from tblJob     -- 327

select distinct ixJob       -- 327
from tblJob
/**************************************/
select count(*) from tblJobClock     -- 125290

select distinct sJob,ixEmployee,ixDate,iStartTime       -- ixSKU
from tblJobClock

select tblJobClockS, count(*)
from tblNAME
group by tblJobClockS
having count(*) > 1
order by count(*) desc
/**************************************/
select count(*) from tblKit     -- 12336

select distinct ixKitSKU, ixSKU       -- 12336
from tblKit
/**************************************/
select count(*) from tblKitList     -- 2615

select distinct ixKitSKU       -- 2615
from tblKitList

SELECT max(dtLastUpdate) from tblKitList -- 2011-07-04 07:06:00.887
/**************************************/
select count(*) from tblMarket     -- 19

select distinct ixMarket       -- 19
from tblMarket
/**************************************/
select count(*) from tblMMDeliveryAreaSurcharge     -- 23715

select distinct ixZipCode       -- 23715
from tblMMDeliveryAreaSurcharge 
/**************************************/
select count(*) from tblOrder     -- 3,996,769

select distinct ixOrder       -- 3,996,769
from tblOrder
/**************************************/
select count(*) from tblOrderLine     -- 15,790,262

select distinct ixOrder, iOrdinality       -- ###
from tblOrderLine
/**************************************/
select count(*) from tblOrderOptimalShipTrailer     -- 11280

select distinct ixOrder       -- 11280
from tblOrderOptimalShipTrailer

select max(dtShippedDate)
from tblOrder
   join tblOrderOptimalShipTrailer OST on OST.ixOrder = tblOrder.ixOrder
/**************************************/
select count(*) from tblOrderRouting     -- ###

select distinct ixOrder       -- ###
from tblOrderRouting
/**************************************/
select count(*) from tblOrderTiming     -- 423052

select distinct ixOrder       -- 423052
from tblOrderTiming
/**************************************/
select count(*) from tblPackage     -- 698235

select distinct sTrackingNumber--, ixOrder       -- ###
from tblPackage

select * from tblPackage
where sTrackingNumber in (
                           select sTrackingNumber
                           from tblPackage
                           group by sTrackingNumber
                           having count(*) > 1
                           )
order by sTrackingNumber

select top 10 * from tblPackage

/**************************************/
select count(*) from tblPGC     -- ###

select distinct ixPGC       -- ###
from tblPGC
/**************************************/
select count(*) from tblPODetail     -- 557548

select distinct ixPO, iOrdinality       -- ###
from tblPODetail

select top 10 * from tblPODetail
/**************************************/
select count(*) from tblPOMaster     -- ###

select distinct ixPO       -- ###
from tblPOMaster
/**************************************/
select count(*) from tblPromoCode     -- ###

select distinct ixPromoCode       -- ###
from tblPromoCode
/**************************************/
select count(*) from tblPromotionalInventory     -- 3302

select distinct ixSKU       -- ###
from tblPromotionalInventory
/**************************************/
select count(*) from tblReceiver     -- 55538

select distinct ixReceiver       -- 55538
from tblReceiver
/**************************************/
select count(*) from tblReceivingWorksheet     -- 17188

select distinct ixReceivingWorksheet       -- 17188
from tblReceivingWorksheet
/**************************************/
select count(*) from tblShipMethod     -- 12

select distinct ixReceivingWorksheet       -- ###
from tblShipMethod
/**************************************/
select count(*) from tblSKU     -- 77393

select distinct ixSKU       -- 77393
from tblSKU
/**************************************/
select count(*) from tblSKUIndex     -- 24073

select distinct ixSKU       -- 24002
from tblSKUIndex

select * from tblSKUIndex
where ixSKU in (
               select ixSKU
               from tblSKUIndex
               group by ixSKU
               having count(*) > 1
               )
order by ixSKU

select * from tblSKUIndex
where ixSKU = '9151467H-1-040'
/**************************************/
select count(*) from tblSKUTransaction     -- 17,666,241

select distinct ixSKU, sTransactionType,iSeq,ixDate,ixTime       -- 
from tblSKUTransaction
/**************************************/
select count(*) from tblSnapAdjustedMonthlySKUSales     -- 702846

select distinct ixSKU,  iYearMonth     -- 702846
from tblSnapAdjustedMonthlySKUSales
/**************************************/
select count(*) from tblSnapshotSKU     -- 23360535

select distinct ixSKU, ixDate       -- ###
from tblSnapshotSKU
/**************************************/
select count(*) from tblSourceCode     -- 5238

select distinct ixSourceCode       -- ###
from tblSourceCode
/**************************************/
select count(*) from tblStates     -- ###

select distinct ixStateid       -- ###
from tblStates
select count(*) from tblStates     -- ###

/**************************************/
select count(*) from tblTime     -- ###

select distinct ixTime       -- ###
from tblTime
/**************************************/
select count(*) from tblTimeClock     -- ###

select distinct ixEmployee, ixDate, ixTime       -- ###
from tblTimeClock
/**************************************/
select count(*) from tblTrailer     -- ###

select distinct ixTrailer       -- ###
from tblTrailer
/**************************************/
select count(*) from tblTrailerZipTNT     -- 210297

select distinct ixZipCode, ixTrailer       -- ###
from tblTrailerZipTNT

select top 10 * from tblTrailerZipTNT
/**************************************/
select count(*) from tblTransactionType     -- ###

select distinct ixTransactionType       -- ###
from tblTransactionType
/**************************************/
select count(*) from tblVendor     -- ###

select distinct ixVendor       -- ###
from tblVendor
/**************************************/
select count(*) from tblVendorSKU     -- ###

select distinct ixSKU, iOrdinality      -- ###
from tblVendorSKU
/**************************************/
select count(*) from tblZipCode     -- ###

select distinct ixZipCode       -- ###
from tblZipCode
/**************************************/
/**************************************/
select count(*) from tblNAME     -- ###

select distinct COLUMNNAME       -- ###
from tblNAME

select COLUMNNAMES, count(*)
from tblNAME
group by COLUMNNAMES
having count(*) > 1
order by count(*) desc

/**************************************/




select * from tblOrder 
where dtOrderDate < '01/01/1995'
and sOrderStatus <> 'Cancelled'
order by dtOrderDate


delete from tblCatalogDetail
where ixCatalog = 'PRS' and ixSKU = '91673059-44'
and mPriceLevel1 = '319.99'


select * from tblSKU where ixSKU = '91673059-44'

select ixCreditMemo,ixCreditMemoLine, count(*)
from tblCreditMemoDetail
group by ixCreditMemo,ixCreditMemoLine
having count(*) > 1

set rowcount 0
DELETE from tblCreditMemoDetail
where ixCreditMemo in ('C-203284') --,'C-203284')
and ixCreditMemoLine = 1
and mExtendedPrice is NULL
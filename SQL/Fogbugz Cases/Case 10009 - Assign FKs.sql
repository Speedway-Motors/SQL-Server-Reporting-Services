 -- ixLocation
/*  data type needs to be changed tinyint for all except tblLocation */
ALTER TABLE tblSKULocation
ADD CONSTRAINT FK_ixLocation_tblSKULocation
FOREIGN KEY (ixLocation)
REFERENCES tblLocation (ixLocation)

ALTER TABLE tblBin
ADD CONSTRAINT FK_ixLocation_tblBin
FOREIGN KEY (ixLocation)
REFERENCES tblLocation (ixLocation)

ALTER TABLE tblBinSku
ADD CONSTRAINT FK_ixLocation_tblBinSku
FOREIGN KEY (ixLocation)
REFERENCES tblLocation (ixLocation)

ALTER TABLE tblInventoryReceipt
ADD CONSTRAINT FK_ixLocation_tblInventoryReceipt
FOREIGN KEY (ixLocation)
REFERENCES tblLocation (ixLocation)






select distinct ixCustomer from tblVendor
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select distinct ixCustomer from tblCreditMemoMaster
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select distinct ixCustomer from tblCustomerOffer
where ixCustomer not in (select ixCustomer from tblCustomer)


select distinct ixOrder from tblOrder
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select distinct ixOrder from tblOrderLine
where ixCustomer not in (select ixCustomer from tblCustomer)    -- 4211 ## are older than 2008
Union
select distinct ixOrder from tblOrderLineArchive
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select distinct ixOrder from tblOrderArchive
where ixCustomer not in (select ixCustomer from tblCustomer) 
-- 6786 -- 6719

select count(*) from tblVendor
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select count(*) from tblCreditMemoMaster
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select count(*) from tblCustomerOffer
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select count(*) from tblOrder
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select count(*) from tblOrderArchive
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select count(*) from tblOrderLine
where ixCustomer not in (select ixCustomer from tblCustomer)
Union
select count(*) from tblOrderLineArchive
where ixCustomer not in (select ixCustomer from tblCustomer)



select count(*) from tblOrder where sOrderStatus = 'Cancelled' -- 1309711 / 53992




select * from tblKit

select ixKitSKU, ixSKU from tblKit where ixSKU not in (select ixSKU from tblSKU)




select ixLocation, count(*)
from tblBin
group by ixLocation

 
/*********************************
-- field
ALTER TABLE tablename
ADD CONSTRAINT FK_field
FOREIGN KEY (field)
REFERENCES mastertable (field)

 ********************************/




ALTER TABLE tblCreditMemoDetail
ADD CONSTRAINT FK_ixSKU_tblCreditMemoDetail -- ixSKU is Varchar(50) in CMD table... Varchar(30) everywhere else
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)



select distinct ixSKU
from tblSKUIndex
where ixSKU not in (select ixSKU from tblSKU)


select distinct ixOrder from tblOrderLineArchive
where ixCustomer not in (select ixCustomer from tblCustomer)
Union

select datepart(yyyy, dtOrderDate) Yr, count(*) from tblOrderArchive
where ixCustomer not in (select ixCustomer from tblCustomer) 
group by datepart(yyyy, dtOrderDate)

select datepart(yyyy, dtOrderDate) Yr, count(*) from tblOrderArchive
where ixCustomer not in (select ixCustomer from tblCustomer) 
group by datepart(yyyy, dtOrderDate)


/******  FUBAR'd ***********/

-- ixSourceCode
ALTER TABLE tblCustomer
ADD CONSTRAINT FK_ixSourceCodeCust
FOREIGN KEY (ixSourceCode)
REFERENCES tblSourceCode (ixSourceCode)

select distinct ixSourceCode -- 52K Customers
from tblCustomer
where ixSourceCode not in (select ixSourceCode from tblSourceCode)
order by SourceCode


select ixSourceCode, count(*) QTY -- 4554
from tblCustomer
group by ixSourceCode
order by ixSourceCode

select * from tblSourceCode -- 5341


select distinct ixSourceCode
from tblCustomerOffer
where ixSourceCode not in (select ixSourceCode from tblSourceCode)

select ixBrand from tblSKU where ixBrand not in (select ixBrand from tblBrand)


/******** BUILT ************
-- ixBin
ALTER TABLE tblBinSku
ADD CONSTRAINT FK_ixBin_tblBinSku
FOREIGN KEY (ixBin)
REFERENCES tblBin (ixBin)

-- ixBin,ixLocation
ALTER TABLE tblBinSku
ADD CONSTRAINT FK_ixBin_ixLocation_tblBinSku
FOREIGN KEY (ixBin,ixLocation)
REFERENCES tblBin (ixBin,ixLocation)

-- ixBrand
-- expanded tblSKU.ixBrand to varchar(10)
ALTER TABLE tblSKU
ADD CONSTRAINT FK_ixSourceCode
FOREIGN KEY (ixBrand)
REFERENCES tblBrand (ixBrand)

-- ixCardUser
ALTER TABLE tblCard
ADD CONSTRAINT FK_ixCardUser
FOREIGN KEY (ixCardUser)
REFERENCES tblCardUser (ixCardUser)

-- ixCatalog
ALTER TABLE tblCatalogDetail
ADD CONSTRAINT FK_ixCatalog_tblCatalogDetail
FOREIGN KEY (ixCatalog)
REFERENCES tblCatalogMaster (ixCatalog)

-- ixCreditMemo
ALTER TABLE tblCreditMemoDetail
ADD CONSTRAINT FK_ixCreditMemo
FOREIGN KEY (ixCreditMemo)
REFERENCES tblCreditMemoMaster (ixCreditMemo)

-- ixDepartment
ALTER TABLE tblEmployee
ADD CONSTRAINT FK_ixDepartment_tblEmployee
FOREIGN KEY (ixDepartment)
REFERENCES tblDepartment (ixDepartment)

ALTER TABLE tblJob
ADD CONSTRAINT FK_ixDepartment_tblJob
FOREIGN KEY (ixDepartment)
REFERENCES tblDepartment (ixDepartment)

-- ixEmployee
ALTER TABLE tblTimeClock
ADD CONSTRAINT FK_ixEmployee_tblTimeClock
FOREIGN KEY (ixEmployee)
REFERENCES tblEmployee (ixEmployee)

ALTER TABLE tblPromotionalInventory
ADD CONSTRAINT FK_ixEmployee_tblPromotionalInventory
FOREIGN KEY (ixEmployee)
REFERENCES tblEmployee (ixEmployee)

ALTER TABLE tblJobClock
ADD CONSTRAINT FK_ixEmployee_tblJobClock
FOREIGN KEY (ixEmployee)
REFERENCES tblEmployee (ixEmployee)

ALTER TABLE tblCardUser
ADD CONSTRAINT FK_ixEmployee_tblCardUser
FOREIGN KEY (ixEmployee)
REFERENCES tblEmployee (ixEmployee)

-- ixKitSKU
ALTER TABLE tblKit
ADD CONSTRAINT FK_ixKitSKU
FOREIGN KEY (ixKitSKU)
REFERENCES tblKitList (ixKitSKU)

-- ixMarket
ALTER TABLE tblInsert
ADD CONSTRAINT FK_ixMarket_tblInsert
FOREIGN KEY (ixMarket)
REFERENCES tblMarket (ixMarket)

ALTER TABLE tblPGC
ADD CONSTRAINT FK_ixMarket_tblPGC
FOREIGN KEY (ixMarket)
REFERENCES tblMarket (ixMarket)

-- ixOrder
ALTER TABLE tblOrderLine
ADD CONSTRAINT FK_ixOrder_tblOrderLine
FOREIGN KEY (ixOrder)
REFERENCES tblOrder (ixOrder)

-- ixPGC
ALTER TABLE tblSKU
ADD CONSTRAINT FK_ixFIELD
FOREIGN KEY (ixPGC)
REFERENCES tblPGC (ixPGC)

-- ixPO
ALTER TABLE tblPODetail
ADD CONSTRAINT FK_ixPO_tblPODetail
FOREIGN KEY (ixPO)
REFERENCES tblPOMaster (ixPO)

ALTER TABLE tblReceiver
ADD CONSTRAINT FK_ixPO_tblReceiver
FOREIGN KEY (ixPO)
REFERENCES tblPOMaster (ixPO)

-- ixPromoCode
ALTER TABLE tblPromoCodeDetail
ADD CONSTRAINT FK_ixPromoCode
FOREIGN KEY (ixPromoCode)
REFERENCES tblPromoCodeMaster (ixPromoCode)

ALTER TABLE tblEventDetail
ADD CONSTRAINT FK_ixPromoCode_tblEventDetail
FOREIGN KEY (ixPromoCode)
REFERENCES tblPromoCodeMaster (ixPromoCode)

-- ixReceiver
ALTER TABLE tblSKUTransactionArchive
ADD CONSTRAINT FK_ixReceiver_STArchive
FOREIGN KEY (ixReceiver)
REFERENCES tblReceiver (ixReceiver)

ALTER TABLE tblSKUTransaction
ADD CONSTRAINT FK_ixReceiver_ST
FOREIGN KEY (ixReceiver)
REFERENCES tblReceiver (ixReceiver)

ALTER TABLE tblReceivingWorksheet
ADD CONSTRAINT FK_ixReceiver_RW
FOREIGN KEY (ixReceiver)
REFERENCES tblReceiver (ixReceiver)

ALTER TABLE tblInventoryReceipt
ADD CONSTRAINT FK_ixReceiver_IR
FOREIGN KEY (ixReceiver)
REFERENCES tblReceiver (ixReceiver)

-- ixSKU
ALTER TABLE tblBinSku
ADD CONSTRAINT FK_ixSKU_tblBinSku
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblBoonvilleTotalSKUQuantCost
ADD CONSTRAINT FK_ixSKU_tblBoonvilleTotalSKUQuantCost
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblDropship
ADD CONSTRAINT FK_ixSKU_tblDropship
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblInventoryForecast
ADD CONSTRAINT FK_ixSKU_tblInventoryForecast
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblInventoryReceipt
ADD CONSTRAINT FK_ixSKU_tblInventoryReceipt
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblPromotionalInventory
ADD CONSTRAINT FK_ixSKU_tblPromotionalInventory
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblSKULocation
ADD CONSTRAINT FK_ixSKU_tblSKULocation
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblSKUTransaction
ADD CONSTRAINT FK_ixSKU_tblSKUTransaction
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblKit
ADD CONSTRAINT FK_ixSKU_tblKit
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblCatalogDetail
ADD CONSTRAINT FK_ixSKU_tblCatalogDetail
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblVendorSKU
ADD CONSTRAINT FK_ixSKU_tblVendorSKU
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

ALTER TABLE tblSnapAdjustedMonthlySKUSales
ADD CONSTRAINT FK_ixSKU_tblSnapAdjustedMonthlySKUSales
FOREIGN KEY (ixSKU)
REFERENCES tblSKU (ixSKU)

-- ixSourceCode
ALTER TABLE tblEventDetail
ADD CONSTRAINT FK_ixSourceCode_tblEventDetail
FOREIGN KEY (ixSourceCode)
REFERENCES tblSourceCode (ixSourceCode)


-- ixTrailer
ALTER TABLE tblPackage
ADD CONSTRAINT FK_ixTrailer
FOREIGN KEY (ixTrailer)
REFERENCES tblTrailer (ixTrailer)

ALTER TABLE tblTrailerZipTNT
ADD CONSTRAINT FK_ixTrailer_tblTrailerZipTNT
FOREIGN KEY (ixTrailer)
REFERENCES tblTrailer (ixTrailer)

-- ixTransferNumber
ALTER TABLE tblBOMTransferDetail
ADD CONSTRAINT FK_ixTransferNumber_tblBOMTransferDetail
FOREIGN KEY (ixTransferNumber)
REFERENCES tblBOMTransferMaster (ixTransferNumber)

ALTER TABLE tblJobClock
ADD CONSTRAINT FK_ixTransferNumber_tblJobClock
FOREIGN KEY (ixTransferNumber)
REFERENCES tblBOMTransferMaster (ixTransferNumber)

-- ixVendor
ALTER TABLE tblVendorSKU
ADD CONSTRAINT FK_ixVendor_tblVendorSKU
FOREIGN KEY (ixVendor)
REFERENCES tblVendor (ixVendor)

ALTER TABLE tblPOMaster
ADD CONSTRAINT FK_ixVendor_tblPOMaster
FOREIGN KEY (ixVendor)
REFERENCES tblVendor (ixVendor)



************/
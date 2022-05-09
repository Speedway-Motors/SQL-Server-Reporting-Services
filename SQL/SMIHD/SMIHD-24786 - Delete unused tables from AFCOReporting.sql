-- SMIHD-24786 - Delete unused tables from AFCOReporting
SELECT *
from tblTableSizeLog
where sTableName = 'tblSKUIndex'
	--and sRowCount > 0
order by dtDate desc

SELECT sTableName, sRowCount
from tblTableSizeLog
where dtDate > '04/26/2022'
and sTableName in ('tblBinSkuOLD ','tblCreditMemoReasonCode','tblInventoryForecastNewSKUs','tblMailingOptIn','tblOrderPromoCodeXref','tblProductLine','tblPromotionalInventory','tblSKUIndex')


-- DROP table tblBinSkuOLD
-- DROP table tblCreditMemoReasonCode
-- DROP table tblInventoryForecastNewSKUs
-- DROP table tblMailingOptIn
-- DROP table tblOrderPromoCodeXref
-- DROP table tblProductLine
-- DROP table tblPromotionalInventory
-- DROP table tblSKUIndex
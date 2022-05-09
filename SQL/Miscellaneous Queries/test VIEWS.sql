select top 10 * from NewCusts1
select top 10 * from vw_OneTimeBuyer
select top 10 * from vwAdjustedDailySKUSales
select top 10 * from vwAdjustedMonthlySKUSales
select top 10 * from vwAllNewCusts
select top 10 * from vwBudCusts
select top 10 * from vwCat302_PostcardTest
select top 10 * from vwCatalogSalesSummary
select top 10 * from vwCost2
select top 10 * from vwCounterCustomer2010
----------------------
select top 10 * from vwCustomerSKUSummary
select top 10 * from vwDailyCreditMemoCounts
select top 10 * from vwDailyCreditMemoSummary
select top 10 * from vwDailyGrossRevByChannel
select top 10 * from vwDailyOrdersTaken
select top 10 * from vwDailySKUReturns
select top 10 * from vwDailyTotJobTime
select top 10 * from vwFeb2009
select top 10 * from vwFeb2010
select top 10 * from vwHatPromo
----------------------
select top 10 * from vwLTVReportNEW
select top 10 * from vwNewCustOrder
select top 10 * from vwNewCusts
select top 10 * from vwNewEbayCust
select top 10 * from vwNullFlagCheck
select top 10 * from vwOrphanedSKUs
select top 10 * from vwRecentOrder
select top 10 * from vwRefunds
select top 10 * from vwSKULocalLocation
select top 10 * from vwSKUMultiLocation
----------------------
select top 10 * from vwSKUQuantityOutstanding
select top 10 * from vwSKUSalesPrev12Months
select top 10 * from vwSourceCodePerformance
select top 10 * from vwTest
select top 10 * from vwWarehouseReceivingProductivity


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
SELECT a.table_name,
   a.row_count,
   COUNT(*) AS col_count,
   a.data_size
FROM #temp a
   INNER JOIN INFORMATION_SCHEMA.COLUMNS b ON a.table_name collate database_default = b.table_name collate database_default
GROUP BY a.table_name, a.row_count, a.data_size
ORDER BY CAST(REPLACE(a.data_size, ' KB', '') AS integer) DESC
DROP TABLE #temp
dbcc showcontig (tblSKU) -- 13% BEFORE running rebuilds below, 99.83% AFTER
/*
DBCC SHOWCONTIG scanning 'tblSKU' table...
Table: 'tblSKU' (741577680); index ID: 1, database ID: 8
TABLE level scan performed.
- Pages Scanned................................: 30667
- Extents Scanned..............................: 3852
- Extent Switches..............................: 23403
- Avg. Pages per Extent........................: 8.0
- Scan Density [Best Count:Actual Count].......: 16.38% [3834:23404]
- Logical Scan Fragmentation ..................: 72.67%
- Extent Scan Fragmentation ...................: 28.45%
- Avg. Bytes Free per Page.....................: 2882.3
- Avg. Page Density (full).....................: 64.39%
DBCC execution completed. If DBCC printed error messages, contact your system administrator
*/

dbcc showcontig (tblSKU,IX_tblSKU_flgActive_flgDeletedFromSOP_Include) -- 13%
dbcc showcontig (tblSKU,IX_tblSKU_flgDeletedFromSOP) -- 16%
dbcc showcontig (tblSKU,IX_tblSKU_flgDeletedFromSOP_ixSKU_dtCreateDate) -- 17%
dbcc showcontig (tblSKU,IX_tblSKU_flgIntangible_ixSKU) -- 16%
dbcc showcontig (tblSKU,IX_tblSKU_ixPGC_flgIntangible_ixSKU) -- 16%
dbcc showcontig (tblSKU,IX_tblSKU_ixSKU) -- 13%
dbcc showcontig (tblSKU,IX_tblSKU_IXSKU_flgDeletedFromSOP_sOriginalSource_sDescription_mPriceLevel1_mLatestCost_Include) -- 15%
dbcc showcontig (tblSKU,PK_tblSKU) -- 16%

dbcc showcontig (tblFIFODetail) -- 15%
dbcc showcontig (tblPackage) -- 24%
dbcc showcontig (tblOrder) -- 17%
dbcc showcontig (tblOrderLine) -- 41%
dbcc showcontig (tblSKUTransaction) -- 93%
dbcc showcontig (tblSnapshotSKU) -- 13%
    dbcc showcontig (tblPOMaster) -- 56%
    dbcc showcontig (tblPODetail) -- 13%
    dbcc showcontig (tblBin) -- 34%
    dbcc showcontig (tblBinSku) -- 20%
    dbcc showcontig (tblCreditMemoMaster) -- 63%
    dbcc showcontig (tblCreditMemoDetail) -- 49%
    dbcc showcontig (tblCustomer) -- 20%
    dbcc showcontig (tblVendor) -- 17%
    dbcc showcontig (tblVendorSKU) -- 13%


USE [SMI Reporting]
GO
ALTER INDEX PK_tblSKU ON [dbo].[tblSKU] REBUILD  WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
GO



dbcc showcontig (tblKit,PK_tblKit) -- 31.31% [93:297]

USE [SMI Reporting]
GO
ALTER INDEX [PK_tblKit] ON [dbo].[tblKit] REBUILD  WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
GO

select COUNT(*) from tblKit


dbcc showcontig (tblSnapshotSKU) 

dbo.tblSnapshotSKU


sp_who2
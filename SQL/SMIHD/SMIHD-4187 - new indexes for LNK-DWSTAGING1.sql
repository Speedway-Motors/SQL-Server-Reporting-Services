-- SMIHD-4187 - new indexes for LNK-DWSTAGING1


/*  These need to be applies OUTSIDE of standard business hours!

TABLES:
tblBinSku
tblCounterOrderScans
tblCreditMemoDetail
tblCreditMemoMaster
tblCustomer
tblDate
tblOrder
tblOrderLine
tblOrderLine
tblSKU
tblSKULocation
tblSnapshotSKU
*/

-- 80% improvement
CREATE NONCLUSTERED INDEX [IX_tblCreditMemoDetail_ixSKU_ixCreditMemo_Include] ON [dbo].[tblCreditMemoDetail]
(
        [ixSKU] ASC,
        [ixCreditMemo] ASC
)
INCLUDE (      [iQuantityCredited]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

SET ANSI_PADDING ON



CREATE NONCLUSTERED INDEX [IX_tblCreditMemoMaster_flgCancelled_dtCreateDate_ixCreditMemo] ON [dbo].[tblCreditMemoMaster]
(
        [flgCanceled] ASC,
        [dtCreateDate] ASC,
        [ixCreditMemo] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

SET ANSI_PADDING ON



CREATE NONCLUSTERED INDEX [IX_tblOrder_ixOrder_sOrderChannel_dtOrderDate] ON [dbo].[tblOrder]
(
        [ixOrder] ASC,
        [sOrderChannel] ASC,
        [dtOrderDate] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

SET ANSI_PADDING ON



CREATE NONCLUSTERED INDEX [IX_tblOrderLine_ixOrder_flgLineStatus_dtOrderDate_ixSKU_Include] ON [dbo].[tblOrderLine]
(
        [ixOrder] ASC,
        [flgLineStatus] ASC,
        [dtOrderDate] ASC,
        [ixSKU] ASC
)
INCLUDE (      [iQuantity]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]





CREATE NONCLUSTERED INDEX [IX_tblSKU_flgDeletedFromSOP] ON [dbo].[tblSKU]
(
        [flgDeletedFromSOP] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

SET ANSI_PADDING ON




CREATE NONCLUSTERED INDEX [IX_tblSKU_flgActive_flgDeletedFromSOP_Include] ON [dbo].[tblSKU]
(
        [flgActive] ASC,
        [flgDeletedFromSOP] ASC
)
INCLUDE (      [ixSKU],
        [mAverageCost],
        [sDescription]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]





DROP INDEX [IX_tblSKULocation_ixLocation_Include] ON [dbo].[tblSKULocation]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_tblSKULocation_ixLocation_Include] ON [dbo].[tblSKULocation]
(
        [ixLocation] ASC
)
INCLUDE (      [ixSKU],
        [iQOS]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO




--89% improvement
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tblOrderLine_flgKitComponent_dtOrderDate_ixCustomer_flgLineStatus_dtShippedDate_ixOrder_ixSKU_Include] ON [dbo].[tblOrderLine]
(
         [flgKitComponent] ASC,
         [dtOrderDate] ASC,
         [ixCustomer] ASC,
         [flgLineStatus] ASC,
         [dtShippedDate] ASC,
         [ixOrder] ASC,
         [ixSKU] ASC
)
INCLUDE (        [iQuantity],
         [mExtendedPrice],
         [mExtendedCost]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]



-- 85% improvement
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tblSnapshotSKU_ixDate_ixSKU] ON [dbo].[tblSnapshotSKU]
(
         [ixDate] ASC,
         [ixSKU] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]




SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tblSKU_flgDeletedFromSOP_ixSKU_dtCreateDate] ON [dbo].[tblSKU]
(
         [flgDeletedFromSOP] ASC,
         [ixSKU] ASC,
         [dtCreateDate] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]




SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixSKu_Include] ON [dbo].[tblOrderLine]
(
         [ixSKU] ASC
)
INCLUDE (        [mExtendedPrice]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]




-- 97% improvement
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tblCustomer_ixCustomer_Include] ON [dbo].[tblCustomer]
(
         [ixCustomer] ASC
)
INCLUDE (        [sCustomerType]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_tblDate_dtDate_ixDate_iDayOfFiscalPeriod_iPeriodYear_iPeriod_iDayOfFiscalYear] ON [dbo].[tblDate]
(
         [dtDate] ASC,
         [ixDate] ASC,
         [iDayOfFiscalPeriod] ASC,
         [iPeriodYear] ASC,
         [iPeriod] ASC,
         [iDayOfFiscalYear] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]



-- 87% improvement
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tblSKU_flgIntangible_ixSKU] ON [dbo].[tblSKU]
(
        [flgIntangible] ASC,
        [ixSKU] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]




SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tblOrderLine_ixOrder_flgLineStatus_dtShippedDate_ixSKU_dtOrderDate] ON [dbo].[tblOrderLine]
(
        [ixOrder] ASC,
        [flgLineStatus] ASC,
        [dtShippedDate] ASC,
        [ixSKU] ASC,
        [dtOrderDate] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

SET ANSI_PADDING ON




CREATE NONCLUSTERED INDEX [IX_tblOrder_sOrderStatus_dtOrderDate_iShipMethod_ixOrderDate_ixOrder_ixOrderTime_Include] ON [dbo].[tblOrder]
(
        [sOrderStatus] ASC,
        [dtOrderDate] ASC,
        [iShipMethod] ASC,
        [ixOrderDate] ASC,
        [ixOrder] ASC,
        [ixOrderTime] ASC
)
INCLUDE (      [ixCustomer]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]




SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tblCounterOrderScans_ixOrder_ixIP_Include] ON [dbo].[tblCounterOrderScans]
(
        [ixOrder] ASC,
        [ixIP] ASC
)
INCLUDE (      [dtScanDate],
        [ixScanTime]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

SET ANSI_PADDING ON




CREATE NONCLUSTERED INDEX [IX_tblBinSku_ixSKU_sPickingBin_ixLocation] ON [dbo].[tblBinSku]
(
        [ixSKU] ASC,
        [sPickingBin] ASC,
        [ixLocation] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]



Statement:



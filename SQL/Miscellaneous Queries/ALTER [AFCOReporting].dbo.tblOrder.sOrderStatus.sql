-- ALTER [AFCOReporting].dbo.tblOrder.sOrderStatus

USE [AFCOReporting];
SET XACT_ABORT on
BEGIN tran

--DROP INDEXES 
DROP INDEX [_dta_index_tblOrder_7_1989582126__K21_K25_K1_K3_K2_K13_K7_17_23] ON [dbo].[tblOrder] WITH ( ONLINE = OFF )
DROP INDEX [_dta_index_tblOrder_7_1989582126__K21_K3] ON [dbo].[tblOrder] WITH ( ONLINE = OFF )
DROP INDEX [_dta_index_tblOrder_7_1989582126__K24_K1_K21_K7_17] ON [dbo].[tblOrder] WITH ( ONLINE = OFF )
DROP INDEX [_dta_index_tblOrder_7_1989582126__K3_K1_K21_K8_K2_17_22] ON [dbo].[tblOrder] WITH ( ONLINE = OFF )
DROP INDEX [_dta_index_tblOrder_c_7_1989582126__K1_K3] ON [dbo].[tblOrder] WITH ( ONLINE = OFF )
DROP INDEX [IX_tblOrder_sOptimalShipOrigination_dtShippedDate] ON [dbo].[tblOrder] WITH ( ONLINE = OFF )
ALTER TABLE [dbo].[tblOrder] DROP CONSTRAINT [PK_tblOrder]

--ALTER FIELD
ALTER TABLE dbo.tblOrder
ALTER COLUMN sOrderStatus VARCHAR(15)

--RECREATE INDEXES
CREATE NONCLUSTERED INDEX [_dta_index_tblOrder_7_1989582126__K21_K25_K1_K3_K2_K13_K7_17_23] ON [dbo].[tblOrder] 
(
	[sOrderStatus] ASC,
	[dtShippedDate] ASC,
	[ixOrder] ASC,
	[ixOrderDate] ASC,
	[ixCustomer] ASC,
	[sMatchbackSourceCode] ASC,
	[sOrderType] ASC
)
INCLUDE ( [mMerchandise],
[mMerchandiseCost]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [_dta_index_tblOrder_7_1989582126__K21_K3] ON [dbo].[tblOrder] 
(
	[sOrderStatus] ASC,
	[ixOrderDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [_dta_index_tblOrder_7_1989582126__K24_K1_K21_K7_17] ON [dbo].[tblOrder] 
(
	[dtOrderDate] ASC,
	[ixOrder] ASC,
	[sOrderStatus] ASC,
	[sOrderType] ASC
)
INCLUDE ( [mMerchandise]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [_dta_index_tblOrder_7_1989582126__K3_K1_K21_K8_K2_17_22] ON [dbo].[tblOrder] 
(
	[ixOrderDate] ASC,
	[ixOrder] ASC,
	[sOrderStatus] ASC,
	[sOrderChannel] ASC,
	[ixCustomer] ASC
)
INCLUDE ( [mMerchandise],
[flgIsBackorder]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]


CREATE CLUSTERED INDEX [_dta_index_tblOrder_c_7_1989582126__K1_K3] ON [dbo].[tblOrder] 
(
	[ixOrder] ASC,
	[ixOrderDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [IX_tblOrder_sOptimalShipOrigination_dtShippedDate] ON [dbo].[tblOrder] 
(
	[sOptimalShipOrigination] ASC,
	[dtShippedDate] ASC
)
INCLUDE ( [ixOrder],
[ixOrderDate],
[sShipToZip]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]


ALTER TABLE [dbo].[tblOrder] ADD  CONSTRAINT [PK_tblOrder] PRIMARY KEY NONCLUSTERED 
(
	[ixOrder] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]




COMMIT TRAN


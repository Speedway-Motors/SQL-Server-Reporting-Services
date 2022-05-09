-- TABLE PJC_tblSKUSnapshotPopBySQLDB
/****** Object:  Table [dbo].[PJC_tblSKUSnapshotPopBySQLDB]    Script Date: 03/02/2017 09:48:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- DROP TABLE [dbo].[PJC_tblSKUSnapshotPopBySQLDB]
CREATE TABLE [dbo].[PJC_tblSKUSnapshotPopBySQLDB](
	[ixSKU] [varchar](30) NOT NULL,
	[iFIFOQuantity] [int] NULL,
	[mFIFOExtendedCost] [money] NULL,
	[mAverageCost] [money] NULL,
	[ixDate] [smallint] NOT NULL,
	[mLastCost] [money] NULL,
	[ixPGC] [varchar](5) NULL,
	[ixPrimaryVendor] [varchar](10) NULL,
	[dtDateLastUpdate] [datetime] NULL,
	[ixTimeLastUpdate] [int] NULL,
 CONSTRAINT [PK_PJC_tblSKUSnapshotPopBySQLDB] PRIMARY KEY NONCLUSTERED 
(
	[ixSKU] ASC,
	[ixDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/*EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the total QOS of ALL locations.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PJC_tblSKUSnapshotPopBySQLDB', @level2type=N'COLUMN',@level2name=N'iFIFOQuantity'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'added 2-23-12 so that we can track when a SKU is temorarily a Garage Sale item.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PJC_tblSKUSnapshotPopBySQLDB', @level2type=N'COLUMN',@level2name=N'ixPGC'
GO
*/


/****** Object:  Index [IX_PJC_tblSKUSnapshotPopBySQLDB_ixDate_ixSKU]    Script Date: 03/02/2017 09:49:32 ******/
CREATE NONCLUSTERED INDEX [IX_PJC_tblSKUSnapshotPopBySQLDB_ixDate_ixSKU] ON [dbo].[PJC_tblSKUSnapshotPopBySQLDB] 
(
	[ixDate] ASC,
	[ixSKU] ASC
)
INCLUDE ( [ixPGC]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



/****** Object:  Index [IX_PJC_tblSKUSnapshotPopBySQLDB_ixSKU_ixDate]    Script Date: 03/02/2017 09:49:38 ******/
CREATE CLUSTERED INDEX [IX_PJC_tblSKUSnapshotPopBySQLDB_ixSKU_ixDate] ON [dbo].[PJC_tblSKUSnapshotPopBySQLDB] 
(
	[ixSKU] ASC,
	[ixDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


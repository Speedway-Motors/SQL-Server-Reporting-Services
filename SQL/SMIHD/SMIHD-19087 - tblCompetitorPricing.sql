USE [SMI Reporting]
GO

/****** Object:  Table [dbo].[tblCompetitorPricing]    Script Date: 11/4/2020 12:51:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- DROP TABLE [dbo].[tblCompetitorPricing]
CREATE TABLE [dbo].[tblCompetitorPricing](
	[ixSKU] [varchar](30) NOT NULL,
    [iSequence] [tinyint] NOT NULL,
    [sCompetitor] [varchar](15) NULL,
    [ixVenodr] [varchar](10) NULL,
    [sVendor] [varchar](30)NULL,-- change to sVendorName?
    [sVendorSKU] [varchar](30) NULL,
    [mVendorPrice] [money] NULL,
    [dtCreated] [datetime] NULL,
    [ixCreator] [varchar] (10) NULL,
    [dtChecked] [datetime] NULL,
    [ixCheckedUser] [varchar] (10) NULL,
    [sApplication] [varchar] (10) NULL,
    [sQuality] [varchar] (10) NULL,
    [sNote][varchar] (100) NULL,
    [sCompetitorURL]  [varchar](MAX) NULL,
	[dtDateLastSOPUpdate] [datetime] NULL,
	[ixTimeLastSOPUpdate] [int] NULL,
 CONSTRAINT [PK_tblCompetitorPricing] PRIMARY KEY NONCLUSTERED 
(
	[ixSKU] ASC,
	[iSequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblCompetitorPricing]  WITH CHECK ADD  CONSTRAINT [FK_ixSKU_tblCompetitorPricing] FOREIGN KEY([ixSKU])
REFERENCES [dbo].[tblSKU] ([ixSKU])
GO

ALTER TABLE [dbo].[tblCompetitorPricing] CHECK CONSTRAINT [FK_ixSKU_tblCompetitorPricing]
GO




-- case 17803 build tblCounterOrderTiming
USE [SMI Reporting]
GO

/****** Object:  Table [dbo].[tblCounterOrderTiming]    Script Date: 05/14/2013 18:06:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCounterOrderTiming](
	[ixGUID] [varchar](38) NOT NULL, -- the GUID is stored in SOP and can be used to help troubleshoot
	[ixIP] [varchar](10) NOT NULL, 
	[ixOrder] [varchar](10) NOT NULL,
	[ixEmployee] [varchar](10) NULL, -- the person who scanned
	[ixScanDate] [smallint] NULL,
    [dtScanDate] [datetime] NULL,
	[ixScanTime]  [varchar](10) NULL,
	[dtDateLastSOPUpdate] [datetime] NULL,
	[ixTimeLastSOPUpdate] [int] NULL,
 CONSTRAINT [PK_tblCounterOrderTiming] PRIMARY KEY NONCLUSTERED 
(
	[ixGUID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



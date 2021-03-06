USE [SMI Reporting]
GO
/****** Object:  Table [dbo].[tblCustomerType]    Script Date: 08/02/2011 08:37:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerType](
	[ixCustomerType] [varchar](10) NOT NULL,
	[sCustomerTypeDescription] [varchar](50) NULL,
	[sCustomerClass] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ixCustomerType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF